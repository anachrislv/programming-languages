#include <cstdio>
#include <vector>
#include <algorithm>
#include <climits> // Include this header for INT_MAX
#include <iostream>
using namespace std;


int N;

int minDifference(const vector<int>& seq ) {
    int total_sum = 0;
    for (int num : seq) {
        total_sum += num;
    }

    vector<vector<bool>> dp(N, vector<bool>(total_sum + 1, false));


    // Initialize dp array
    dp[0][0] = true;
    dp[0][seq[0]] = true;


    for (int i = 1; i < N; i++) {
        for (int j = 0; j <= total_sum; j++) {
            dp[i][j] = dp[i-1][j] || (j >= seq[i] && dp[i-1][j - seq[i]]);
        }
    }

    int min_diff = INT_MAX;

    for (int j = 0; j <= total_sum; ++j) {
        if (dp[N-1][j]) {
            min_diff = min(min_diff, abs(total_sum - 2 * j));
        }
    }
    
    return min_diff;


}


int main() {

    scanf("%d", &N);
    vector<int> sequence(N);


    for (int i = 0; i < N; i++ ){
        scanf("%d", &sequence[i]);


    }

    cout << "Minimum difference: " << minDifference(sequence) << endl;


}