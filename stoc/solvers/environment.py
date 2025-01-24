"""
Module to provide classes and functions to create an environment for a Markov decision process
"""

from dataclasses import dataclass


@dataclass
class AirlineModel:

    tot_tickets: int
    horizon: int
    min_price: int
    max_price: int
    nbins_price: int
    seat_fixed_cost: int

    @property
    def price_levels(self):
        d = (self.max_price - self.min_price) / self.nbins_price
        price_levels = [d * nbin + self.min_price + (d / 2) for nbin in range(self.nbins_price)]
        return price_levels

    @property
    def price_levels_scaled(self):
        return [(price_level - self.min_price) / (self.max_price - self.min_price) for price_level in self.price_levels]
