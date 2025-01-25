"""
Module to provide classes and functions to generate customers traces based.
"""

import random

from pathlib import Path
from typing import NamedTuple, Optional, Self
from math import floor


class Customer(NamedTuple):
    arrival_day: int
    percived_value: float


class CustomersSimulator:

    def __init__(
        self,
        final_time: int,
        distribution_params: dict[str, float],
        seed: int | None = None,
        customers: Optional[list[Customer]] = None,
    ):
        self.distribution_params = distribution_params
        self.final_time = final_time
        self._price_default_distribution = random.betavariate
        self._arrival_distribution = random.expovariate
        self.customers = customers
        self.seed = seed
        random.seed(seed)

    def generate_trace(self) -> list[Customer]:

        time = 1
        customers: list[Customer] = []
        lambd = self.distribution_params.get("lambd", 0.5)
        a = self.distribution_params.get("alpha", 0.5)
        b = self.distribution_params.get("beta", 1.5)

        while time < self.final_time + 1:
            arrival_time = time + self._arrival_distribution(lambd)
            if arrival_time > self.final_time + 1:
                break
            arrival_day = floor(arrival_time)
            percived_value = self._price_default_distribution(a, b)
            customers.append(Customer(arrival_day=arrival_day, percived_value=percived_value))
            time = arrival_time

        self.customers = customers
        return customers

    def save_trace(self, path: Path):
        assert self.customers is not None, "No customers have been generated"
        with open(path, "w") as f:
            lambd = self.distribution_params.get("lambd", 0.5)
            a = self.distribution_params.get("alpha", 0.5)
            b = self.distribution_params.get("beta", 1.5)
            f.write(f"final_time={self.final_time},lambd={lambd},alpha={a},beta={b},seed={self.seed}\n")
            for customer in self.customers:
                f.write(f"{customer}\n")

    @classmethod
    def load_trace(cls, path: Path) -> Self:
        customers: list[Customer] = []
        with open(path, "r") as f:
            line = f.readline()
            comma_splits = line.split(",")
            final_time = int(comma_splits[0].split("=")[1])
            lambd = float(comma_splits[1].split("=")[1])
            alpha = float(comma_splits[2].split("=")[1])
            beta = float(comma_splits[3].split("=")[1])
            seed = int(comma_splits[4].split("=")[1])
            line = f.readline()
            while line:
                comma_splits = line.split(",")
                arrival_day = comma_splits[0].split("=")[1]
                percived_value = comma_splits[1].removesuffix(")\n").split("=")[1]
                customers.append(Customer(int(arrival_day), float(percived_value)))
                line = f.readline()
        if not customers:
            raise Exception("No customers trace found in the provided file")
        return cls(final_time, {"lambd": lambd, "alpha": alpha, "beta": beta}, seed, customers)
