pragma circom 2.0.0;

include "./blake3.circom";


template Main(N) {
    signal input in[N];
    signal output out[32];
    
    component hash = Blake3Bytes(N);
    hash.in <== in;
    out <== hash.out;
}


component main {public[in]} = Main(64);
