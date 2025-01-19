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
        price_levels = [
            self.min_price + nbin * ((self.max_price - self.min_price) / self.nbins_price)
            for nbin in range(self.nbins_price)
        ]
        price_levels[0] = self.min_price + 1
        price_levels[-1] = self.max_price - 1
        return price_levels

    @property
    def price_levels_scaled(self):
        return [(price_level - self.min_price) / (self.max_price - self.min_price) for price_level in self.price_levels]
