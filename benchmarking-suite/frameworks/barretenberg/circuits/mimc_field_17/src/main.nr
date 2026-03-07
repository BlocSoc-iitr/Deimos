use dep::mimc::mimc_bn254;

fn main(input: [Field; 17]) -> pub Field {
    mimc_bn254(input)
}
