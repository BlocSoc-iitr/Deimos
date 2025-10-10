use dep::mimc::mimc_bn254;

fn main(input: [Field; 32]) -> pub Field {
    mimc_bn254(input)
}