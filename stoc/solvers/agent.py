"""
Module to provide classes and functions to create an agent for a Markov decision process
"""

import math
from typing import Any
import scipy
import numpy as np
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
        self.V = np.zeros((model.tot_tickets + 1, model.nbins_price, model.horizon + 1))
        self.R = np.zeros((model.tot_tickets + 1, model.nbins_price))
        self.T = np.zeros((model.nbins_price, model.tot_tickets + 1, model.tot_tickets + 1))
        self._init_tables()

    def _init_tables(self):

        ncustomers = math.ceil(1 / self.lambd)

        for price_bin in range(self.model.nbins_price):
            # remove the 0.0001 and properly fix it
            p = scipy.stats.beta.sf(self.model.price_levels_scaled[price_bin], self.alpha, self.beta)
            for s in range(self.model.tot_tickets + 1):
                # prob_to_sell_k_tickets = [scipy.special.binom(ncustomers, k) * (p ^ k) * ((1 - p) ^ k) for k in range(0, s)]
                prob_to_sell_k_tickets = np.zeros((self.model.tot_tickets + 1))
                for k in range(0, s + 1):
                    prob = scipy.special.binom(ncustomers, k) * (p**k) * ((1 - p) ** (ncustomers - k))
                    prob_to_sell_k_tickets[k] = prob
                exp = np.exp(prob_to_sell_k_tickets[: s + 1])
                self.T[price_bin, : s + 1, s] = exp / sum(exp)
                # check if ncustomers can be greater than s
                self.R[s, price_bin] = sum(
                    [self.model.price_levels[price_bin] * k * prob_to_sell_k_tickets[k] for k in range(s + 1)]
                )

        for s in range(self.model.tot_tickets + 1):
            self.V[s, :, 0] = self.model.seat_fixed_cost * s

    def solve(self, max_iter: int = 1000, theta: float = 0.01):
        # delta = 0

        # v = self.V.copy()
        for days_left in tqdm(range(1, self.model.horizon + 1)):
            for t in range(self.model.tot_tickets + 1):
                for b in range(self.model.nbins_price):
                    current_reward = self.R[t, :]
                    potential_reward = self.discount * (self.V[:, b, days_left - 1] @ self.T[:, :, t].T)
                    tot_rewards = current_reward + potential_reward
                    self.V[t, b, days_left] = tot_rewards.max()
        # a = self.V - v
        # intermediate_norm = np.linalg.norm(a, ord=np.inf, axis=(0, 1))
        # delta = np.linalg.norm(intermediate_norm[1:], ord=np.inf)

        # if delta < theta:
        # break

    def get_policy(self) -> dict[tuple[int, int, int], int]:
        # ticket left, price bin, day left => next price bin
        policy: dict[tuple[int, int, int], int] = {}
        # 3 for loops to cicly on all the states
        for day in range(self.model.horizon, 0, -1):
            for price_bin in range(self.model.nbins_price):
                for ticket_left in range(self.model.tot_tickets + 1):
                    current_reward = self.R[ticket_left, :]
                    potential_reward = self.discount * (self.V[:, price_bin, day - 1] @ self.T[:, :, ticket_left].T)
                    tot_rewards = current_reward + potential_reward
                    best_bin = tot_rewards.argmax()
                    # policy[(ticket_left, price_bin, day)] = self.model.price_levels[best_bin]
                    policy[(ticket_left, price_bin, day)] = best_bin  # type: ignore

        return policy
