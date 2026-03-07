pragma circom 2.0.0;

include "constants.circom";

template Pow5() {
    signal input in;
    signal output out;

    signal sq;
    signal quad;

    sq <== in * in;
    quad <== sq * sq;
    out <== quad * in;
}

template InvPow5() {
    signal input in;
    signal output out;
    
    var alphaInv = 17510594297471420177797124596205820070838691520332827474958563349260646796493;
    out <-- in ** alphaInv;

    signal sq;
    signal quad;

    sq <== out * out;
    quad <== sq * sq;
    in === quad * out;
}

template RescuePrimePermutation() {
    var m = getM();
    var N = getRounds();
    
    signal input state_in[m];
    signal output state_out[m];
    
    signal state[N+1][m];
    
    for(var j=0; j<m; j++) {
        state[0][j] <== state_in[j];
    }
    
    // Rounds
    // Note: Breaking down the steps strictly
    // 1. S-box -> 2. MDS -> 3. Add Const -> 4. Inv S-box -> 5. MDS -> 6. Add Const
    
    // To handle signals correctly, we need intermediate signals for each step or carefully chain them.
    
    //  we can chain logic since they are linear or simple assignments.
    // But we need to declare signals for the non-linear outputs.
    
    component sbox[N][m];
    component inv_sbox[N][m];
    
    signal after_sbox[N][m];
    signal after_mds_1[N][m];
    signal after_const_1[N][m];
    signal after_inv_sbox[N][m];
    signal after_mds_2[N][m];
    
    for (var i = 0; i < N; i++) {
        // 1. Forward S-Box
        for (var j = 0; j < m; j++) {
            sbox[i][j] = Pow5();
            sbox[i][j].in <== state[i][j];
            after_sbox[i][j] <== sbox[i][j].out;
        }
        
        // 2. MDS
        for (var j = 0; j < m; j++) {
            var sum = 0;
            for (var k = 0; k < m; k++) {
                sum += getMDS(j, k) * after_sbox[i][k];
            }
            after_mds_1[i][j] <== sum;
        }
        
        // 3. Add Constants
        for (var j = 0; j < m; j++) {
            after_const_1[i][j] <== after_mds_1[i][j] + getRoundConstant(i * 2 * m + j);
        }
        
        // 4. Inverse S-Box
        for (var j = 0; j < m; j++) {
            inv_sbox[i][j] = InvPow5();
            inv_sbox[i][j].in <== after_const_1[i][j];
            after_inv_sbox[i][j] <== inv_sbox[i][j].out;
        }
        
        // 5. MDS
        for (var j = 0; j < m; j++) {
            var sum = 0;
            for (var k = 0; k < m; k++) {
                sum += getMDS(j, k) * after_inv_sbox[i][k];
            }
            after_mds_2[i][j] <== sum;
        }
        
        // 6. Add Constants (Output of round)
        for (var j = 0; j < m; j++) {
            state[i+1][j] <== after_mds_2[i][j] + getRoundConstant(i * 2 * m + m + j);
        }
    }
    
    for(var j=0; j<m; j++) {
        state_out[j] <== state[N][j];
    }
}

// Since r = 1, We don't need to dynamically pad input

template RescuePrimeHash(inputSize) {
    // Note: inputSize = number of field elements.
    
    signal input in[inputSize];
    signal output out[1]; // since r = 1
    
    var m = getM();
    var rate = 1; 
    var numBlocks = inputSize; // Since rate=1
    component perms[numBlocks + 1];
    
    signal state[numBlocks+1][m];
    
    // Injection
    // Initial state is 0
    for(var j=0; j<m; j++) {
        state[0][j] <== 0;
    }
    
    for (var i = 0; i < numBlocks; i++) {
        // Add input to state[0] (since rate=1, index 0)
        perms[i] = RescuePrimePermutation();
        perms[i].state_in[0] <== state[i][0] + in[i];
 
        for(var k=1; k<m; k++) {
            perms[i].state_in[k] <== state[i][k];
        }
        for(var k=0; k<m; k++) {
            state[i+1][k] <== perms[i].state_out[k];
        }
    }
    out[0] <== state[numBlocks][0];
}
