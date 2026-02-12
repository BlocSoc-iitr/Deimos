use dep::poseidon::poseidon::bn254::sponge;

fn main(input: [Field; 9]) -> pub Field {
    sponge(input)
}
