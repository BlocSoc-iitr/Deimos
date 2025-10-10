use dep::keccak256::keccak256;

fn main(input: [u8; 32]) -> pub [u8; 32] {
    // Hash the full 32-byte input using keccak256
    keccak256(input, 32)
} 
