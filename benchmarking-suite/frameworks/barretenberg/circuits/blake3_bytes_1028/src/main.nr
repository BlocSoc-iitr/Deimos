use dep::std::hash::blake3;

fn main(input: [u8; 1028]) -> pub [u8; 32] {
    blake3(input)
}
