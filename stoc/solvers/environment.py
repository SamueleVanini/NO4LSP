"""
Module to provide classes and functions to create an environment for a Markov decision process
"""

from stoc.simulator.clients_traces import Customer


class AirlineModel:

    def __init__(
        self, nmax_tickets: int, nmax_days: int, min_price: int, max_price: int, nbins_price: int, trace: list[Customer]
    ) -> None:
        self.nmax_tickets = nmax_tickets
        self.nmax_days = nmax_days
        self.min_price = min_price
        self.max_price = max_price
        self.nbins_price = nbins_price
        self.price_levels = [min_price + nbin * ((max_price - min_price) / nbins_price) for nbin in range(nbins_price)]
        self.customers = trace

    # TODO: the check in the trace can be optimized
    def step(self, action: tuple[int, float, int]) -> tuple[float, bool]:
        """Performe an action in the environment

        Args:
            action (tuple[int, int, int]): 0 = ticket to sell, 1 = demand level, 2 = days from flight

        Returns:
            tuple[int, int, bool]: tuple containing the reward obtained and an indication to check if we have other tickets to sell
        """
        ticket_to_sell, demand_level, day = action
        ticket_sold = 0
        demand_scaled = (demand_level - self.min_price) / (self.max_price - self.min_price)
        if ticket_to_sell == 0:
            return 0, True
        for customer in self.customers:
            if customer.arrival_day != day:
                continue
            if ticket_to_sell == 0:
                break
            if demand_scaled <= customer.percived_value:
                ticket_sold += 1
        price = max(demand_level - ticket_sold, 0)
        reward = price * ticket_sold
        return reward, False
