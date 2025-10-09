pragma circom 2.1.2;

include "../circomlib/circuits/keccak256-circom/circuits/keccak.circom";
include "../circomlib/circuits/bitify.circom";

/**
 * Wrapper around Keccak256 to support bytes as input instead of bits
 * @param  n   The number of input bytes
 * @input  in  The input bytes
 * @output out The Keccak256 output of the n input bytes, in bytes
 */
template Keccak256Bytes(n) {
  signal input in[n];
  signal output out[32];

  component byte_to_bits[n];
  for (var i = 0; i < n; i++) {
    byte_to_bits[i] = Num2Bits(8);
    byte_to_bits[i].in <== in[i];
  }

  component keccak256 = Keccak(n*8, 32*8);
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < 8; j++) {
      keccak256.in[i*8+j] <== byte_to_bits[i].out[j];
    }
  }

  component bits_to_bytes[32];
  for (var i = 0; i < 32; i++) {
    bits_to_bytes[i] = Bits2Num(8);
    for (var j = 0; j < 8; j++) {
      bits_to_bytes[i].in[j] <== keccak256.out[i*8+j];
    }
    out[i] <== bits_to_bytes[i].out;
  }
}
