use dep::poseidon::poseidon::bn254::sponge;

fn main(input: [Field; 32]) -> pub Field {
    // using The sponge function as it can handle variable-length inputs
    sponge(input)
}