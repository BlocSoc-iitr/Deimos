pragma circom 2.0.0;

include "../hash-circuits/circuits/poseidon2/poseidon2.circom";


template Poseidon2Bench(nInputs) {
    signal input in[nInputs];
    signal output out[1];

    component rp = Poseidon2(nInputs);
    rp.in <== in;
    out <== rp.out;
}


component main {public[in]} = Poseidon2Bench(34);
