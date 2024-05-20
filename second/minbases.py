def find_minimum_b(n):
    def find_b(b):
        if b > n - 1:
            return -1
        def find_k(k):
            x = (b ** k - 1) // (b - 1)
            if b ** (k - 1) > n:
                return find_b(b + 1)
            if n % x == 0 and n // x <= b - 1:
                return b
            else:
                return find_k(k + 1)
        return find_k(2)
    return find_b(2)

def read_numbers(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
    # Skip the first line
    numbers = [int(line.strip()) for line in lines[1:]]
    return numbers

if __name__ == '__main__':
    import sys
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <input_filename>")
    else:
        input_filename = sys.argv[1]

        # Read the list of numbers from the input file
        numbers = read_numbers(input_filename)

        # Compute the smallest base for each number
        bases = [find_minimum_b(n) for n in numbers]

        # Print the list of bases
        for base in bases:
            print(base)
