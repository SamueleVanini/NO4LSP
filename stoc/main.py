from math import floor
from pathlib import Path

from simulator.clients_traces import CustomersSimulator
from solvers.agent import FiniteHorizonValueIteration
from solvers.environment import AirlineModel


MAX_TICKETS = 50
MAX_PRICE = 200
MIN_PRICE = 100
discout_factor = 0.5

ticket_left: int = MAX_TICKETS
ticket_sold: int = floor((MAX_PRICE - MIN_PRICE) / 10)
demand: int = 10
days_left: int = 5


def sim_trace(file_path):
    sim = CustomersSimulator(5, {"lambd": 10, "a": 1, "b": 2}, seed=42)
    customers = sim.generate_trace()
    CustomersSimulator.save_trace(customers, file_path)
    return customers


def load_trace(file_path):
    customers = CustomersSimulator.load_trace(file_path)
    return customers


LOAD = True

if __name__ == "__main__":
    project_folder = Path(__file__).parent
    relative_file_path = "/data/trace.txt"
    file_path = Path(f"{project_folder}/{relative_file_path}")
    if LOAD:
        customers = load_trace(file_path)
    else:
        customers = sim_trace(file_path)
    model = AirlineModel(discout_factor, MAX_TICKETS, days_left, MIN_PRICE, MAX_PRICE, demand, customers)
    agent = FiniteHorizonValueIteration(model)
    agent.solve()
    revenue, ticket_sold = agent.score_greedy_policy(customers)
    print(f"sold {ticket_sold} tickets, total revenue: {revenue}")
