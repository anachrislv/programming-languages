import java.io.*;
import java.util.*;

class NodeArrange {
    int number;
    NodeArrange left;
    NodeArrange right;
    NodeArrange parent;
    int minimum = -1;

    NodeArrange(int number) {
        this.number = number;
        this.left = null;
        this.right = null;
        this.parent = null;
    }
}

public class Arrange {
    public static void printNodeInfo(NodeArrange node) {
        if (node == null) {
            System.out.println("Node is null");
            return;
        }

        System.out.println("Node number: " + node.number);
        System.out.print("Left child: ");
        if (node.left != null) {
            System.out.println(node.left.number);
        } else {
            System.out.println("None");
        }

        System.out.print("Right child: ");
        if (node.right != null) {
            System.out.println(node.right.number);
        } else {
            System.out.println("None");
        }

        System.out.print("Parent: ");
        if (node.parent != null) {
            System.out.println(node.parent.number);
        } else {
            System.out.println("None");
        }

        System.out.println("Minimum: " + node.minimum);
    }

    public static void nodePermutation(NodeArrange node) {
        NodeArrange temp = node.left;
        node.left = node.right;
        node.right = temp;
    }

    public static String inOrderToStringNonZero(NodeArrange node) {
        StringBuilder result = new StringBuilder();
        if (node == null) {
            return result.toString();
        }

        result.append(inOrderToStringNonZero(node.left));

        if (node.number != 0) {
            result.append(node.number).append(" ");
        }

        result.append(inOrderToStringNonZero(node.right));

        return result.toString();
    }

    public static int setNodesMinimum(NodeArrange node, int N) {
        if (node.number == 0) {
            node.minimum = N + 1;
            return node.minimum;
        }

        if (node.left.number == 0 && node.right.number == 0) {
            node.minimum = node.number;
        } else {
            node.minimum = Math.min(
                    Math.min(setNodesMinimum(node.left, N), setNodesMinimum(node.right, N)),
                    node.number
            );
        }
        return node.minimum;
    }

    public static void getMinimumString(NodeArrange node) {
        if (node.left.number != 0) {
            getMinimumString(node.left);
        }
        if (node.right.number != 0) {
            getMinimumString(node.right);
        }

        if (node.left.number != 0 || node.right.number != 0) {
            int leftMin = node.left.minimum;
            int rightMin = node.right.minimum;
            if (node.left.number == 0) {
                if (node.number > rightMin) {
                    nodePermutation(node);
                }
            } else if (node.right.number == 0) {
                if (node.number < leftMin) {
                    nodePermutation(node);
                }
            } else {
                if (leftMin > rightMin) {
                    nodePermutation(node);
                }
            }
        }
    }


    public static List<NodeArrange> createNodes(BufferedReader br) throws IOException {
        List<NodeArrange> nodes = new ArrayList<>();

        String line = br.readLine();
        if (line == null) {
            return nodes; // Return empty list if no data
        }

        String[] values = line.trim().split("\\s+");
        NodeArrange prevNode = null;
        NodeArrange n;

        for (String valueStr : values) {
            int value = Integer.parseInt(valueStr);
            n = new NodeArrange(value);

            nodes.add(n);

            if (prevNode != null) {
                n.parent = prevNode;
                if (prevNode.left == null) {
                    prevNode.left = n;
                } else {
                    prevNode.right = n;
                }
            }

            prevNode = n;

            if (value == 0) {
                prevNode = prevNode.parent;
                while (prevNode != null && prevNode.left != null && prevNode.right != null && prevNode.parent != null) {
                    prevNode = prevNode.parent;
                }
            }
        }

        return nodes;
    }

    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Usage: java BinaryTree <filename>");
            System.exit(1);
        }

        String filename = args[0];
        try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
            int N = Integer.parseInt(br.readLine().trim());

            List<NodeArrange> nodes = createNodes(br);

            setNodesMinimum(nodes.get(0), N);

            getMinimumString(nodes.get(0));

            String result = inOrderToStringNonZero(nodes.get(0));

            System.out.println(result);

        } catch (IOException e) {
            e.printStackTrace();
            System.exit(1);
        }
    }
}
