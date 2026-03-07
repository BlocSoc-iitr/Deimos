use dep::keccak256::keccak256;

fn main(input: [u8; 16]) -> pub [u8; 32] {
    keccak256(input, 16)
}
