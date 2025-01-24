"""
Module to provide classes and functions to create an agent for a Markov decision process
"""

import math
from typing import Any
import scipy
import numpy as np
import scipy.stats
from tqdm import tqdm
from .environment import AirlineModel


class Agent:

    def __init__(self, discount: float, theta: float, model: AirlineModel, customersParams: dict[str, Any]):
        self.discount = discount
        self.theta = theta
        self.model = model
        self.lambd = float(customersParams["lambd"])
        self.alpha = int(customersParams["alpha"])
        self.beta = int(customersParams["beta"])
        # entry V[s, b, h] = value in having s tickets to sell at price b with h days before the flight
        self.V = np.zeros((model.tot_tickets + 1, model.nbins_price, model.horizon + 1))
        # entry R[s, b] = expected reward of trying to selling s trickets at price b
        self.R = np.zeros((model.tot_tickets + 1, model.nbins_price))
        # entry T[b, s2, s1] = probability of having s1 tickets apply price b and ending with s2 tickets
        self.T = np.zeros((model.nbins_price, model.tot_tickets + 1, model.tot_tickets + 1))
        self._init_tables()

    def _init_tables(self):

        ncustomers = math.ceil(self.lambd)

        for price_bin in range(self.model.nbins_price):
            p = scipy.stats.beta.sf(self.model.price_levels_scaled[price_bin], self.alpha, self.beta)
            for s in range(self.model.tot_tickets + 1):
                prob_to_sell_k_tickets = np.zeros((self.model.tot_tickets + 1))
                for k in range(0, min(s + 1, ncustomers + 1)):
                    prob = scipy.special.binom(ncustomers, k) * (p**k) * ((1 - p) ** (ncustomers - k))
                    prob_to_sell_k_tickets[k] = prob
                norm_coef: float = 1 / prob_to_sell_k_tickets.sum()
                prob_to_sell_k_tickets *= norm_coef
                self.T[price_bin, : s + 1, s] = np.flip(prob_to_sell_k_tickets[: s + 1])
                self.R[s, price_bin] = sum(
                    [self.model.price_levels[price_bin] * k * prob_to_sell_k_tickets[k] for k in range(s + 1)]
                )

        for s in range(self.model.tot_tickets + 1):
            self.V[s, :, 0] = self.model.seat_fixed_cost * s

    def solve(self):
        for days_left in tqdm(range(1, self.model.horizon + 1)):
            for t in range(self.model.tot_tickets + 1):
                for b in range(self.model.nbins_price):
                    current_reward = self.R[t, :]
                    potential_reward = self.discount * (self.T[:, :, t] @ self.V[:, :, days_left - 1])[b, :]
                    tot_rewards = current_reward + potential_reward
                    self.V[t, b, days_left] = tot_rewards.max()

    def get_policy(self) -> dict[tuple[int, int, int], int]:
        # ticket left, price bin, day left => next price bin
        policy: dict[tuple[int, int, int], int] = {}
        # 3 for loops to cicle on all the states
        for day in range(self.model.horizon, 0, -1):
            for price_bin in range(self.model.nbins_price):
                for ticket_left in range(self.model.tot_tickets + 1):
                    current_reward = self.R[ticket_left, :]
                    potential_reward = (
                        self.discount * (self.V[:, :, day - 1].T @ self.T[:, :, ticket_left].T)[price_bin, :]
                    )
                    tot_rewards = current_reward + potential_reward
                    best_bin = tot_rewards.argmax()
                    policy[(ticket_left, price_bin, day)] = best_bin  # type: ignore

        return policy
