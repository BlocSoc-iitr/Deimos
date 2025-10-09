pragma circom 2.0.0;

include "./keccak256.circom";

template Keccak256Bench(N) {
    signal input in[N];
    signal output out[32];

    component keccak256 = Keccak256Bytes(N);
    keccak256.in <== in;
    out <== keccak256.out;
}

component main {public[in]} = Keccak256Bench(32);
