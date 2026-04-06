use dep::poseidon::poseidon2::Poseidon2::hash;

fn main(input: [Field; 9]) -> pub Field {
    hash(input, 9)
}