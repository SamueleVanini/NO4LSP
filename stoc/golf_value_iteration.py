# Value Iteration Algorithm for Markov Decision Processes (MDPs)
# This script performs value iteration to find the optimal value function and policy for a given MDP.
# The MDP is defined by its states, actions, transition probabilities, and rewards.
# The algorithm iteratively updates the value function until it converges, then derives the optimal policy
# based on the converged value function.
# Components:
# - States: A list of states in the MDP.
# - Actions: A list of actions available in the MDP.
# - Transition Probabilities: A nested dictionary where the keys are states and actions, and the values
#     are dictionaries of next states and their corresponding probabilities.
# - Rewards: A nested dictionary where the keys are states and actions, and the values are the rewards
#     for taking those actions in those states.
# - Gamma: The discount factor for future rewards.
# - Theta: The convergence threshold for the value iteration algorithm.
# Functions:
# - value_iteration(V, transition_probabilities, rewards, gamma, theta): Performs the value iteration
#     algorithm to find the optimal value function.
# Outputs:
# - Optimal Values: The optimal value function for each state.
# - Optimal Policy: The optimal policy for each state, derived from the optimal value function.
# Note:
# - The algorithm is inspired by https://towardsdatascience.com/reinforcement-learning-an-easy-introduction-to-value-iteration-e4cfe0731fd5


import sys

# File path for saving the output
output_file = "stoc\\golf_value_iteration_output.txt"

# Redirecting stdout to the file
with open(output_file, "w") as f:
    sys.stdout = f  # Redirect print statements to the file

    # Your Value Iteration code here (the one we wrote earlier)
    # Define the MDP components
    states = ['Fairway', 'Green', 'Hole']
    actions = ['Hit to Fairway', 'Hit to Green', 'Hit in Hole']
    
    transition_probabilities = {
        'Fairway': {
            'Hit to Fairway': {'Fairway': 1.0},
            'Hit to Green': {'Fairway': 0.1, 'Green': 0.9},
            'Hit in Hole': {'Fairway': 0.2, 'Green': 0.8}
        },
        'Green': {
            'Hit to Fairway': {'Fairway': 0.9, 'Green': 0.1},
            'Hit to Green': {'Green': 0.7, 'Hole': 0.3},
            'Hit in Hole': {'Green': 0.4, 'Hole': 0.6}
        },
        'Hole': {
            'Hit in Hole': {'Hole': 1.0}
        }
    }
    
    rewards = {
        'Fairway': {
            'Hit to Fairway': 0,
            'Hit to Green': 0, 
            'Hit in Hole': 0
            },
        'Green': {
            'Hit to Fairway': 0, 
            'Hit to Green': 0, 
            'Hit in Hole': 10
            },
        'Hole': {
            'Hit in Hole': 0
            }
    }

    gamma = 0.9  # Discount factor
    theta = 1e-5  # Convergence threshold

    # Initialize value function
    V = {state: 0 for state in states}
    
    # Print a legend of symbols used
    print("\n" + "=" * 40)
    print("Legend of Symbols Used:")
    print("=" * 40)
    print("V(s): Value function for state s")
    print("Q(s, a): Action-value function for state s and action a")
    print("Policy(s): Optimal policy for state s")
    print("Delta: Maximum change in value function in an iteration")
    print("=" * 40 + "\n")

    # Print the data that we have until now
    print("\n" + "=" * 40)
    print("MDP Components:")
    print("=" * 40)
    print("States:", states)
    print()
    print("Actions:", actions)
    print()
    print("Transition Probabilities:")
    for state, actions in transition_probabilities.items():
        print(f"  State: {state}")
        for action, next_states in actions.items():
            print(f"    Action: {action}")
            for next_state, prob in next_states.items():
                print(f"      Next State: {next_state}, Probability: {prob}")
    print()
    print("Rewards:")
    for state, actions in rewards.items():
        print(f"  State: {state}")
        for action, reward in actions.items():
            print(f"    Action: {action}, Reward: {reward}")
    print()
    print("Gamma:", gamma)
    print("Theta:", theta)
    print("=" * 40 + "\n")

    def value_iteration(V, transition_probabilities, rewards, gamma, theta):
        iteration = 1
        while True:
            delta = 0
            
            print(f"\n{'*' * 40}")
            print(f"*********** Iteration {iteration} ***********")
            print(f"{'*' * 40}\n")

            for state in states:
                print(f"{'*' * 15} State: {state} {'*' * 15}\n")
                
                v = V[state]
                action_values = {}
                avaible_actions = transition_probabilities[state].keys()
                for action in avaible_actions:
                    action_value = 0
                    for next_state, prob in transition_probabilities[state][action].items():
                        action_value += prob * (rewards[state][action] + gamma * V[next_state])
                    action_values[action] = action_value
                    print(f"Q({state}, {action}) = {action_value:.4f}")
                V[state] = max(action_values.values())
                
                print(f"\nV({state}) updated to {V[state]:.4f}\n")
                
                delta = max(delta, abs(v - V[state]))
            
            print(f"{'*' * 40}")
            print(f"Delta: {delta:.6f}")
            print(f"{'*' * 40}\n")
            
            if delta < theta:
                break
            
            iteration += 1
        return V

    # Run value iteration
    optimal_values = value_iteration(V, transition_probabilities, rewards, gamma, theta)

    # Derive the optimal policy
    policy = {}
    for state in states:
        action_values = {}
        avaible_actions = transition_probabilities[state].keys()
        for action in avaible_actions:
            action_value = 0
            for next_state, prob in transition_probabilities[state][action].items():
                action_value += prob * (rewards[state][action] + gamma * optimal_values[next_state])
            action_values[action] = action_value
        best_action = max(action_values, key=action_values.get)
        policy[state] = best_action

    # Display the results
    print("\n" + "=" * 40)
    print("Optimal Values:")
    print("=" * 40)

    for state, value in optimal_values.items():
        print(f"V({state}) = {value:.4f}")

    print("\n" + "=" * 40)
    print("Optimal Policy:")
    print("=" * 40)
    
    for state, action in policy.items():
        print(f"Policy({state}) = {action}")

# Reset stdout to default
sys.stdout = sys.__stdout__

print(f"Output successfully saved to {output_file}.")
