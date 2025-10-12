pragma circom 2.0.3;

include "../circomlib/circuits/poseidon/poseidon.circom";

template PoseidonBench(nInputs) {
    signal input in[nInputs];
    signal output out;

    component poseidon = Poseidon(nInputs);
    for (var i = 0; i < nInputs; i++) {
        poseidon.inputs[i] <== in[i];
    }
    
    out <== poseidon.out;
}

// render this file before compilation
component main {public[in]} = PoseidonBench(8);