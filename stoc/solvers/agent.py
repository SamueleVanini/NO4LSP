"""
Module to provide classes and functions to create an agent for a Markov decision process
"""

from typing import Optional
import numpy as np
import numpy.typing as npt
from .environment import AirlineModel
from simulator.clients_traces import Customer


class FiniteHorizonValueIteration:

    def __init__(
        self,
        model: AirlineModel,
        vTable: Optional[npt.NDArray[np.float64]] = None,
        qTable: Optional[npt.NDArray[np.float64]] = None,
    ) -> None:
        assert (vTable is None and qTable is None) or (
            vTable is not None and qTable is not None
        ), "Error: you must provide both vTable and qTable or neither"
        self.model = model
        if vTable and qTable:
            self.vTable = vTable.copy()
            self.qTable = qTable.copy()
        else:
            self.vTable, self.qTable = self._init_tables()

    def _init_tables(self) -> tuple[npt.NDArray[np.float64], npt.NDArray[np.float64]]:
        V = np.zeros((self.model.nmax_tickets, self.model.nmax_days), dtype=np.float64)
        Q = np.zeros(
            (self.model.nmax_tickets, self.model.nbins_price, self.model.nmax_days),
            dtype=np.float64,
        )
        for tickets_left in range(self.model.nmax_tickets):
            for demand_index, price_level in enumerate(self.model.price_levels):
                # TODO: done is not used check if we can reduce the number of computation using it
                reward, ticket_sold, _ = self.model.step((tickets_left, price_level, 0))
                Q[tickets_left, demand_index, 0] = reward
            best_revenue_per_level = Q[tickets_left, :, 0].max(axis=0)
            # TODO: check if the mean if correct for the expected reward since the probability in the price levels is Beta distributed
            V[tickets_left, 0] = best_revenue_per_level.mean()

        return V.copy(), Q.copy()

    def solve(self):
        for days_left in range(1, self.model.nmax_days):
            for tickets_left in range(self.model.nmax_tickets):
                for demand_index, price_level in enumerate(self.model.price_levels):
                    reward, tickets_sold, _ = self.model.step((tickets_left, price_level, days_left))
                    self.qTable[tickets_left, demand_index, days_left] = (
                        reward + self.vTable[tickets_left - tickets_sold, days_left - 1]
                    )
                expected_reward_at_levels = self.qTable[tickets_left, :, days_left].max(axis=0)
                # TODO: check if the mean if correct for the expected reward since the probability in the price levels is Beta distributed
                self.vTable[tickets_left, days_left] = expected_reward_at_levels.mean()

    def score_greedy_policy(self, trace: list[Customer]):  # type: ignore
        ticket_left = self.model.nmax_tickets - 1

        revenue, ticket_sold = self._step_greedy(ticket_left, self.model.nmax_days - 1, trace)
        return revenue, ticket_sold

    def _step_greedy(self, ticket_left, days_left, trace, ticket_sold=0):
        if days_left == -1 or ticket_left == -1:
            return 0, 0
        relevant_Q_vals = self.qTable[ticket_left, :, days_left]
        price_bin_idx = relevant_Q_vals.argmax()
        price = self.model.price_levels[price_bin_idx]
        ticket_sold = self._get_ticket_sold(
            ticket_left, price, [customer for customer in trace if customer.arrival_day == days_left]
        )
        reward = price * ticket_sold
        ticket_left -= ticket_sold
        new_step_reward, new_ticket_sold = self._step_greedy(ticket_left, days_left - 1, trace, ticket_sold)
        return (reward + new_step_reward), (ticket_sold + new_ticket_sold)

    def _get_ticket_sold(self, max_ticket, price, trace):
        ticket_sold = 0
        value_scaled = (price - self.model.min_price) / (self.model.max_price - self.model.min_price)
        if max_ticket == 0:
            return 0
        for customer in trace:
            if max_ticket == 0:
                break
            if value_scaled <= customer.percived_value:
                ticket_sold += 1
                max_ticket -= 1
        return ticket_sold
