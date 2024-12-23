from math import floor
from pathlib import Path

from simulator.clients_traces import CustomersSimulator
from stoc.solvers.agent import FiniteHorizonValueIteration
from stoc.solvers.environment import AirlineModel


MAX_TICKETS = 50
MAX_PRICE = 200
MIN_PRICE = 100

ticket_left: int = MAX_TICKETS
ticket_sold: int = floor((MAX_PRICE - MIN_PRICE) / 10)
demand: int = 10
days_left: int = 5


sim = CustomersSimulator(5, {"lambd": 10, "a": 1, "b": 2}, seed=42)
customers = sim.generate_trace()
project_folder = Path(__file__).parent
relative_file_path = "/data/trace.txt"
file_path = Path(f"{project_folder}/{relative_file_path}")
CustomersSimulator.save_trace(customers, file_path)
customers = CustomersSimulator.load_trace(file_path)
model = AirlineModel(MAX_TICKETS, days_left, MIN_PRICE, MAX_PRICE, demand, customers)
agent = FiniteHorizonValueIteration(model)
