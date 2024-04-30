       
#include <iostream>
#include <vector>
#include <algorithm>

struct Node {
    int number;
    Node* left;
    Node* right;
    Node* parent;
    int minimum = -1;
};

void printNodeInfo(const Node* node) {
    if (node == nullptr) {
        std::cout << "Node is null" << std::endl;
        return;
    }

    std::cout << "Node number: " << node->number << std::endl;
    std::cout << "Left child: ";
    if (node->left != nullptr) {
        std::cout << node->left->number;
    } else {
        std::cout << "None";
    }
    std::cout << std::endl;

    std::cout << "Right child: ";
    if (node->right != nullptr) {
        std::cout << node->right->number;
    } else {
        std::cout << "None";
    }
    std::cout << std::endl;

    std::cout << "Parent: ";
    if (node->parent != nullptr) {
        std::cout << node->parent->number;
    } else {
        std::cout << "None";
    }
    std::cout << std::endl;

    std::cout << "Minimum: " << node->minimum << std::endl;
}

void node_permutation(Node* node) {
    Node* temp;
    temp = node->left;
    node->left = node->right;
    node->right = temp;
}

std::string inOrderToStringNonZero(Node* node) {
    std::string result;
    if (node == nullptr) {
        return result;
    }
    
    // Traverse left subtree
    result += inOrderToStringNonZero(node->left);
    
    // Add the node's number to the string if it's not zero
    if (node->number != 0) {
        result += std::to_string(node->number) + " ";
    }
    
    // Traverse right subtree
    result += inOrderToStringNonZero(node->right);
    
    return result;
}

int set_nodes_minimum(Node* node, int N) {

    if (node->number == 0) {
        node->minimum = N+1;
        return node->minimum;
    }

    if (node->left->number == 0 && node->right->number == 0)
        node->minimum = node->number;
    else {
        node->minimum = std::min({set_nodes_minimum(node->left, N), set_nodes_minimum(node->right, N), node->number});
    }
    return node->minimum;
}

void get_minimum_string(Node* node) {
    if (node->left->number != 0)
        get_minimum_string(node->left);
    if (node->right->number != 0)
        get_minimum_string(node->right);
    
    if (node->left->number !=0 || node->right->number != 0) {
        int left_min = node->left->minimum;
        int right_min = node->right->minimum;
        if (node->left->number == 0) {
            if (node->number > right_min) 
                node_permutation(node);
        }
        else if (node->right->number == 0) {
            if (node->number < left_min)
                node_permutation(node);
        }
        else {
            if (left_min > right_min)
            node_permutation(node);
        }
    }
}


std::vector<Node*> create_nodes(FILE* file) {
    std::vector<Node*> nodes;

    int value, counter = 0;
    Node* prev_node = nullptr;
    Node* n;

    while (fscanf(file, "%d", &value) == 1) {
        n = new Node();
        n->number = value;
        n->left = nullptr;
        n->right = nullptr;
        n->parent = nullptr;

        nodes.push_back(n);

        if (prev_node != nullptr) {
            n->parent = prev_node;
            if ((*prev_node).left == nullptr) {
                (*prev_node).left = n;
            }
            else {
                (*prev_node).right = n;
            }
        }

        prev_node = n;

        if (value == 0) {
            counter++;
            prev_node = (*prev_node).parent;
            while (((*prev_node).left != nullptr && (*prev_node).right != nullptr) && prev_node->parent != nullptr) {
                prev_node = (*prev_node).parent;
            }
        }
    }

    return nodes;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL) {
        fprintf(stderr, "Failed to open file.\n");
        return 1;
    }

    int N;
    if (fscanf(file, "%d", &N) != 1) {
        fprintf(stderr, "Failed to read integer from file.\n");
        return 1;
    }

    std::vector<Node*> nodes = create_nodes(file);

    // for (const auto* node : nodes) {
    //     printNodeInfo(node);
    //     std::cout << std::endl;
    // }

    fclose(file); // Close the file when you're done with it

    set_nodes_minimum(nodes.front(), N);

    get_minimum_string(nodes.front());

    std::string result = inOrderToStringNonZero(nodes.front());

    std::cout << result << std::endl;

    return 0;
}
