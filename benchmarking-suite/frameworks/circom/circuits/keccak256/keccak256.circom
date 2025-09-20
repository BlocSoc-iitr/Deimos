pragma circom 2.0.0;

include "../circomlib/circuits/gates.circom";
include "../circomlib/circuits/sha256/xor3.circom";
include "../circomlib/circuits/sha256/shift.circom";

include "../keccak-circom/circuits/keccak.circom";

template KeccakMain(N) {

    signal input in[N];
    signal input hash[32];
    signal output out[32];


    component keccak = Keccak(N, 256);
    
    for (var i = 0; i < N; i++) {
        keccak.in[i] <== in[i];
    }

    for (var i = 0; i < 32; i++) {
        out[i] <== keccak.out[i];
    }
}

 component main = KeccakMain(32);


