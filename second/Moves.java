import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Deque;

class Node {
    int[] position;
    int value;
    List<Node> children;

    Node(int[] position, int value) {
        this.position = position;
        this.value = value;
        this.children = new ArrayList<>();
    }
}

public class Moves {
    public static void printTree(Node node) {
        if (node == null) return;

        System.out.println("Position: " + node.position[0] + ", " + node.position[1] + ", Value: " + node.value);

        for (Node child : node.children) {
            printTree(child);
        }
    }

    public static int[][] findNeighbors(int[] position, int N) {
        int i = position[0];
        int j = position[1];

        int[][] neighborPositions = {
                {-1, -1}, {-1, 0}, {-1, 1},
                {0, -1},          {0, 1},
                {1, -1}, {1, 0}, {1, 1}
        };

        List<int[]> neighbors = new ArrayList<>();

        for (int[] neighbor : neighborPositions) {
            int new_r = i + neighbor[0];
            int new_c = j + neighbor[1];

            if (new_r >= 0 && new_r < N && new_c >= 0 && new_c < N) {
                neighbors.add(new int[]{new_r, new_c});
            }
        }

        return neighbors.toArray(new int[0][0]);
    }

    public static List<Node> keepPossible(int[][] neighbors, int value, int[][] matrix, Set<String> visited) {
        List<Node> possibleNeighbors = new ArrayList<>();

        for (int[] n : neighbors) {
            int i = n[0];
            int j = n[1];
            if (value > matrix[i][j] && !visited.contains(i + "," + j)) {
                Node node = new Node(n, matrix[i][j]);
                possibleNeighbors.add(node);
            }
        }

        return possibleNeighbors;
    }

    public static void expandTree(Node currentNode, int N, int[][] matrix, Set<String> visited) {
        visited.add(currentNode.position[0] + "," + currentNode.position[1]);
        int[][] neighbors = findNeighbors(currentNode.position, N);
        List<Node> possibleNeighbors = keepPossible(neighbors, currentNode.value, matrix, visited);
        currentNode.children.addAll(possibleNeighbors);
        for (Node child : currentNode.children) {
            expandTree(child, N, matrix, new HashSet<>(visited));
        }
    }

    public static List<int[]> bfs(Node root, int N) {
        Deque<NodePathPair> queue = new ArrayDeque<>();
        queue.addLast(new NodePathPair(root, new ArrayList<>() {{
            add(root.position);
        }}));

        while (!queue.isEmpty()) {
            NodePathPair pair = queue.removeFirst();
            Node currentNode = pair.node;
            List<int[]> path = pair.path;

            if (currentNode.position[0] == N - 1 && currentNode.position[1] == N - 1) {
                return path;
            }

            for (Node child : currentNode.children) {
                List<int[]> newPath = new ArrayList<>(path);
                newPath.add(child.position);
                queue.addLast(new NodePathPair(child, newPath));
            }
        }

        return null;
    }

    static class NodePathPair {
        Node node;
        List<int[]> path;

        NodePathPair(Node node, List<int[]> path) {
            this.node = node;
            this.path = path;
        }
    }

    public static String pathToMoves(List<int[]> path) {
        if (path == null) return null;
        else {
            StringBuilder directions = new StringBuilder("[");
            for (int i = 1; i < path.size(); i++) {
                int[] currentStep = path.get(i);
                int[] prevStep = path.get(i - 1);
                int dr = currentStep[0] - prevStep[0];
                int dc = currentStep[1] - prevStep[1];
                String direction = "";
                if (dr == -1) direction += "N";
                else if (dr == 1) direction += "S";
                if (dc == 1) direction += "E";
                else if (dc == -1) direction += "W";
                directions.append(direction).append(",");
            }
            directions.deleteCharAt(directions.length() - 1);
            directions.append("]");
            return directions.toString();
        }
    }

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Wrong usage.");
            System.exit(1);
        }

        String filename = args[0];
        try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
            int N = Integer.parseInt(br.readLine());
            int[][] matrix = new int[N][N];

            for (int i = 0; i < N; i++) {
                String[] values = br.readLine().split(" ");
                for (int j = 0; j < N; j++) {
                    matrix[i][j] = Integer.parseInt(values[j]);
                }
            }

            Node root = new Node(new int[]{0, 0}, matrix[0][0]);
            Set<String> visited = new HashSet<>();
            visited.add("0,0");

            expandTree(root, N, matrix, visited);

            List<int[]> path = bfs(root, N);

            String result = pathToMoves(path);

            if (result != null) {
                System.out.println(result);
            } else {
                System.out.println("IMPOSSIBLE");
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
