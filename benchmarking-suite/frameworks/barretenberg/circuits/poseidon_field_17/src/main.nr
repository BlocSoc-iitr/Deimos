use dep::poseidon::poseidon::bn254::sponge;

fn main(input: [Field; 17]) -> pub Field {
    sponge(input)
}
