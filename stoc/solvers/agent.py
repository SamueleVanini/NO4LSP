"""
Module to provide classes and functions to create an agent for a Markov decision process
"""

from typing import Optional
import numpy as np
import numpy.typing as npt
from .environment import AirlineModel


class FiniteHorizonValueIteration:

    def __init__(
        self,
        model: AirlineModel,
        vTable: Optional[npt.NDArray[np.float64]] = None,
        qTable: Optional[npt.NDArray[np.float64]] = None,
    ) -> None:
        assert (vTable is None and qTable is None) or (
            vTable is not None and qTable is not None
        ), "Error you must provide both vTable and qTable or neither"
        self.model = model
        if vTable and qTable:
            self.vTable = vTable.copy()
            self.qTable = qTable.copy()
        else:
            self.vTable, self.qTable = self._init_tables()

    def _init_tables(self) -> tuple[npt.NDArray[np.float64], npt.NDArray[np.float64]]:
        V = np.zeros((self.model.nmax_tickets, self.model.nmax_days), dtype=np.float64)
        Q = np.zeros(
            (self.model.nmax_tickets, self.model.nmax_tickets, self.model.nbins_price, self.model.nmax_days),
            dtype=np.float64,
        )
        for tickets_left in range(self.model.nmax_tickets):
            for ticket_sold in range(tickets_left + 1):
                for demand_index, price_level in enumerate(self.model.price_levels):
                    # TODO: done is not used check if we can reduce the number of computation using it
                    reward, _ = self.model.step((ticket_sold, price_level, 0))
                    Q[ticket_sold, tickets_left, demand_index, 0] = reward
            best_revenue_per_level = Q[:, tickets_left, :, 0].max(axis=0)
            # TODO: check if the mean if correct for the expected reward since the probability in the price levels is Beta distributed
            V[tickets_left, 0] = best_revenue_per_level.mean()

        return V.copy(), Q.copy()

    def solve(self):
        for days_left in range(1, self.model.nmax_days):
            for tickets_left in range(self.model.nmax_tickets):
                for tickets_sold in range(tickets_left):
                    for demand_index, price_level in enumerate(self.model.price_levels):
                        reward, _ = self.model.step((tickets_sold, price_level, days_left))
                        self.qTable[tickets_sold, tickets_left, demand_index, days_left] = (
                            reward + self.vTable[tickets_left - tickets_sold, days_left - 1]
                        )
                expected_reward_at_levels = self.qTable[:, tickets_left, :, days_left].max(axis=0)
                # TODO: check if the mean if correct for the expected reward since the probability in the price levels is Beta distributed
                self.vTable[tickets_left, days_left] = expected_reward_at_levels.mean()

    def get_policy(self):  # type: ignore
        raise NotImplementedError()
