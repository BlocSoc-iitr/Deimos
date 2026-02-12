use dep::sha256::digest;

fn main(input: [u8; 32]) -> pub [u8; 32] {
    digest(input)
}
