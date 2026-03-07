use dep::poseidon::poseidon::bn254::sponge;

fn main(input: [Field; 2]) -> pub Field {
    sponge(input)
}
