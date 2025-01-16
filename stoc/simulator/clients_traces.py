"""
Module to provide classes and functions to generate customers traces based.
"""

import random

from pathlib import Path
from typing import Any, NamedTuple
from math import floor


class Customer(NamedTuple):
    arrival_day: int
    percived_value: float


class CustomersSimulator:

    def __init__(self, final_time: int, distribution_params: dict[str, Any], seed: int | None = None):
        self.distribution_params = distribution_params
        self.final_time = final_time
        self._price_default_distribution = random.betavariate
        self._arrival_distribution = random.expovariate
        random.seed(seed)

    def generate_trace(self) -> list[Customer]:

        time = 0
        customers: list[Customer] = []
        lambd = self.distribution_params.pop("lambd", 0.5)
        a = self.distribution_params.pop("a", 0.5)
        b = self.distribution_params.pop("b", 1.5)

        while time < self.final_time + 1:
            arrival_time = time + self._arrival_distribution(lambd)
            if arrival_time > self.final_time + 1:
                break
            arrival_day = floor(arrival_time)
            percived_value = self._price_default_distribution(a, b)
            customers.append(Customer(arrival_day=arrival_day, percived_value=percived_value))
            time = arrival_time

        return customers

    @staticmethod
    def save_trace(trace: list[Customer], path: Path):
        with open(path, "w") as f:
            for customer in trace:
                f.write(f"{customer}\n")

    @staticmethod
    def load_trace(path: Path) -> list[Customer]:
        customers: list[Customer] = []
        with open(path, "r") as f:
            line = f.readline()
            comma_splits = line.split(",")
            arrival_day = comma_splits[0].split("=")[1]
            percived_value = comma_splits[1].removesuffix(")\n").split("=")[1]
            customers.append(Customer(int(arrival_day), float(percived_value)))
        return customers
