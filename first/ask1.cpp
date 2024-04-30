#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <limits.h>
#include <numeric>

using namespace std;

int N, result;

int calculateFairness(const vector<int>& seq) {

    int sum, current, difference;

    current = 0;
    difference = INT_MAX;
    sum = accumulate(seq.begin(), seq.end(), 0);

    vector<int> prefixSums(seq.size() + 1);
    partial_sum(seq.begin(), seq.end(), prefixSums.begin() + 1);

    
    for (int i = 0; i < N; i++) {
        for (int j = i + 1; j <N; j++) {
            current = prefixSums[j] - prefixSums[i];
            difference = min(difference, abs(current - (sum - current)));
        }
    }

    


    return difference;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " <filename>\n";
        return 1;
    }

    ifstream file(argv[1]);
    if (!file) {
        cerr << "Failed to open file.\n";
        return 1;
    }

    if (!(file >> N)) {
        cerr << "Failed to read integer from file.\n";
        return 1;
    }

    vector<int> seq(N);
    for (int i = 0; i < N; ++i) {
        if (!(file >> seq[i])) {
            cerr << "Failed to read integer from file.\n";
            return 1;
        }
    }

    file.close();

    result = calculateFairness(seq);
    printf("%d\n", result);


    return 0;
}
