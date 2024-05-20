import sys
import copy
from collections import deque

class Node:
    def __init__(self, position, value):
        self.position = position
        self.value = value
        self.children = []

def print_tree(node):
    if node is None:
        return

    # Print the position and value of the current node
    print(f"Position: {node.position}, Value: {node.value}")
    
    # Recursively print each child
    for child in node.children:
        print_tree(child)

def find_neighbors(position, N):
    i = position[0]
    j = position[1]

    neighbor_positions = [
        (-1, -1), (-1, 0), (-1, 1),
        (0, -1),         (0, 1),
        (1, -1), (1, 0), (1, 1)
    ]
    
    neighbors = []
    rows = N
    cols = N if rows > 0 else 0
    
    for dr, dc in neighbor_positions:
        new_r, new_c = i + dr, j + dc
        # Check if the new position is within the grid bounds
        if 0 <= new_r < rows and 0 <= new_c < cols:
            neighbors.append((new_r, new_c))
    
    return neighbors

def keep_possible(neighbors, value, matrix, visited):
    possible_neighbors = []

    for n in neighbors:
        i = n[0]
        j = n[1]
        if value > matrix[i][j] and (n not in visited):
            node = Node(n, matrix[i][j])
            possible_neighbors.append(node)

    return possible_neighbors

def expand_tree(current_node: Node, N, matrix, visited):
    visited.append(current_node.position)
    neighbors = find_neighbors(current_node.position, N)
    neighbors = keep_possible(neighbors, current_node.value, matrix, visited)
    current_node.children = neighbors
    for child in current_node.children:
        expand_tree(child, N, matrix, copy.deepcopy(visited))

def bfs(root: Node, N):
    queue = deque([(root, [root.position])])

    while queue:
        current_node, path = queue.popleft()
        if current_node.position == (N - 1, N - 1):
            return path
        for child in current_node.children:
            new_path = path + [child.position]  # Extend the current path with the child's position
            queue.append((child, new_path))

    return None

def path_to_moves(path):
    if path is None:
        return None
    else:
        directions = '['
        for i in range(1, len(path)):
            current_step = path[i]
            prev_step = path[i - 1]
            dr = current_step[0] - prev_step[0]
            dc = current_step[1] - prev_step[1]

            # Define directions based on the differences
            direction = ''
            if dr == -1:
                direction += 'N'
            elif dr == 1:
                direction += 'S'

            if dc == 1:
                direction += 'E'
            elif dc == -1:
                direction += 'W'

            directions += direction
            directions += ','

        directions = directions[:-1]
        directions += ']'
        return directions

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Wrong usage.")
        sys.exit()

    filename = sys.argv[1]
    with open(filename, 'r') as file:
        N = int(file.readline().strip())
        
        matrix = []
        
        # Read the next N lines to form the matrix
        for _ in range(N):
            line = file.readline().strip()
            # Split the line into integers and append to the matrix
            row = list(map(int, line.split()))
            matrix.append(row)

    current_pos = (0,0)
    current_value = matrix[0][0]
    root = Node(current_pos, current_value)
    visited = [current_pos]

    expand_tree(root, N, matrix, copy.deepcopy(visited))

    path = bfs(root, N)

    path = path_to_moves(path)

    if path is not None:
        print(path)
    else:
        print("IMPOSSIBLE")



