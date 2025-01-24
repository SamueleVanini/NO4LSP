import matplotlib.pyplot as plt
import matplotlib as mpl
from math import floor
from pathlib import Path

from simulator.clients_traces import Customer, CustomersSimulator
from solvers.agent import Agent
from solvers.environment import AirlineModel


MAX_TICKETS = 100
MAX_PRICE = 350
MIN_PRICE = 50
discout_factor = 0.5
theta = 0.01

ticket_left: int = MAX_TICKETS
ticket_sold: int = floor((MAX_PRICE - MIN_PRICE) / 10)
demand: int = 10
days_left: int = 30
seat_fixed_cost = -50

distributions_params: dict[str, float] = {"lambd": 20, "alpha": 2, "beta": 2}


def sim_trace(file_path: Path, days_left: int):
    sim = CustomersSimulator(days_left, distributions_params, seed=42)
    customers = sim.generate_trace()
    sim.save_trace(file_path)
    return customers, sim


def load_trace(file_path: Path):
    sim = CustomersSimulator.load_trace(file_path)
    return sim.customers, sim


# ticket left, price bin, day left => next price bin
def eval_policy(
    policy: dict[tuple[int, int, int], int],
    customers: list[Customer],
    model: AirlineModel,
    initial_price_bin: int = demand - 1,
):
    ticket_left = MAX_TICKETS
    price_bin = initial_price_bin
    tot_revenue = 0
    tot_ticket_sold = 0
    steps = []

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
        steps.append((day, ticket_sold, price))
        price_bin = policy[ticket_left, price_bin, day]
    cost = ticket_left * model.seat_fixed_cost
    print(f"Unsold tickets: {ticket_left} for a cost of {cost}")
    return tot_ticket_sold, tot_revenue, steps


def plot_steps(steps: list[tuple[int, int, int]], model: AirlineModel):
    x, y, col = zip(*steps)

    csum = 0
    for idx, value in enumerate(y):
        csum += value
        if csum == MAX_TICKETS:
            break

    x, y, col = x[: idx + 1], y[: idx + 1], col[: idx + 1]

    fig, ax = plt.subplots(figsize=(10, 10))
    cmap = mpl.cm.viridis
    # bounds = model.price_levels
    d = (model.max_price - model.min_price) / model.nbins_price
    bounds = [model.min_price + d * nbin for nbin in range(model.nbins_price + 1)]
    norm = mpl.colors.BoundaryNorm(bounds, cmap.N)
    ax.grid(axis="both")
    im = ax.scatter(x, y, s=200, c=col, norm=norm, cmap=cmap)
    ax.invert_xaxis()
    ax.xaxis.get_major_locator().set_params(integer=True)
    ax.set_xlabel("Days left")
    ax.set_ylabel("Ticket sold")
    ax.set_title("Ticket sold by day and price level")
    ax.xaxis.set_ticks(x)
    ax.yaxis.set_ticks(y)
    fig.colorbar(im, ax=ax, orientation="vertical", label="Price bins", ticks=model.price_levels)
    plt.show()


LOAD = False

if __name__ == "__main__":
    project_folder = Path(__file__).parent
    relative_file_path = "/data/trace.txt"
    file_path = Path(f"{project_folder}/{relative_file_path}")
    if LOAD:
        customers, sim = load_trace(file_path)
    else:
        customers, sim = sim_trace(file_path, days_left)
    model = AirlineModel(MAX_TICKETS, days_left, MIN_PRICE, MAX_PRICE, demand, seat_fixed_cost)
    agent = Agent(discout_factor, theta, model, distributions_params)
    agent.solve()
    policy = agent.get_policy()
    init_bin = agent.V[MAX_TICKETS, :, days_left].argmax()
    ticket_sold, revenue, steps = eval_policy(policy, customers, model, init_bin)  # type: ignore
    print(f"sold {ticket_sold} tickets, total revenue: {revenue}")
    plot_steps(steps, model)
