use dep::std::hash::blake2s;

fn main(input: [u8; 512]) -> pub [u8; 32] {
    blake2s(input)
}
