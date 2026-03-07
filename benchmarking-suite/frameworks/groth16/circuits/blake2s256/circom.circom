pragma circom 2.0.3;

include "../hash-circuits/circuits/blake2/blake2s.circom";

template Main(N) {
    signal input in[N];
    signal output out[32];

    component blake2s_bytes = Blake2s_bytes(N);
    blake2s_bytes.inp_bytes <== in;
    out <== blake2s_bytes.hash_bytes;
}

component main {public[in]} = Main(32);