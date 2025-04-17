This code of greedy heuristic solution to the Generalized Assignment Problem (GAP) by processing datasets gap1.txt through gap12.txt. Each dataset contains multiple problem 
instances, where each instance specifies a number of servers and users, along with associated cost matrices, resource requirement matrices, and server capacity vectors. The script reads
these inputs and attempts to assign users to servers such that the total cost is minimized and server capacities are not exceeded. The core logic is implemented in the greedy_gap_assignment() 
function, which iteratively assigns each user to the feasible server offering the lowest cost. If no server can accommodate a user, they remain unassigned.
For every problem instance, the total cost and number of users successfully assigned are computed.
