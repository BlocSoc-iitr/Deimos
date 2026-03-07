use dep::sha256::digest;

fn main(input: [u8; 512]) -> pub [u8; 32] {
    digest(input)
}
