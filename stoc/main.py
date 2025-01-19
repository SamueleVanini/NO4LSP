from math import floor
from pathlib import Path

from simulator.clients_traces import Customer, CustomersSimulator
from solvers.agent import Agent
from solvers.environment import AirlineModel


MAX_TICKETS = 20
MAX_PRICE = 200
MIN_PRICE = 100
discout_factor = 0.5
theta = 0.01

ticket_left: int = MAX_TICKETS
ticket_sold: int = floor((MAX_PRICE - MIN_PRICE) / 10)
demand: int = 10
days_left: int = 5
seat_fixed_cost = -10

distributions_params: dict[str, float] = {"lambd": 5, "alpha": 2, "beta": 5}


def sim_trace(file_path: Path):
    sim = CustomersSimulator(5, distributions_params, seed=42)
    customers = sim.generate_trace()
    sim.save_trace(file_path)
    return customers, sim


def load_trace(file_path: Path):
    sim = CustomersSimulator.load_trace(file_path)
    return sim.customers, sim


# ticket left, price bin, day left => next price bin
def eval_policy(policy: dict[tuple[int, int, int], int], customers: list[Customer], model: AirlineModel):
    ticket_left = MAX_TICKETS
    # price_bin = int(demand / 2)
    price_bin = demand - 1
    tot_revenue = 0
    tot_ticket_sold = 0

    for day in range(days_left, 0, -1):
        ticket_sold = 0
        price = model.price_levels[price_bin]
        for customer in customers:
            if customer.arrival_day != day:
                continue
            if ticket_left == 0:
                break
            if model.price_levels_scaled[price_bin] <= customer.percived_value:
                ticket_sold += 1
                ticket_left -= 1
        tot_revenue += price * ticket_sold
        tot_ticket_sold += ticket_sold
        price_bin = policy[ticket_left, price_bin, day]
    cost = ticket_left * model.seat_fixed_cost
    print(f"Unsold tickets: {ticket_left} for a cost of {cost}")
    return tot_ticket_sold, tot_revenue


LOAD = False

if __name__ == "__main__":
    project_folder = Path(__file__).parent
    relative_file_path = "/data/trace.txt"
    file_path = Path(f"{project_folder}/{relative_file_path}")
    if LOAD:
        customers, sim = load_trace(file_path)
    else:
        customers, sim = sim_trace(file_path)
    model = AirlineModel(MAX_TICKETS, days_left, MIN_PRICE, MAX_PRICE, demand, seat_fixed_cost)
    agent = Agent(discout_factor, theta, model, distributions_params)
    agent.solve()
    policy = agent.get_policy()
    ticket_sold, revenue = eval_policy(policy, customers, model)  # type: ignore
    print(f"sold {ticket_sold} tickets, total revenue: {revenue}")
