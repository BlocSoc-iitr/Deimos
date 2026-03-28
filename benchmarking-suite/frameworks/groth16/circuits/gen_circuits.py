import os
import glob

algos = {
    "mimc256": {
        "template_name": "Main",
        "base_file": "mimc256_16f.circom"
    },
    "poseidon": {
        "template_name": "PoseidonBench",
        "base_file": "poseidon_16f.circom"
    },
    "poseidon2": {
        "template_name": "Poseidon2Bench",
        "base_file": "poseidon2_16f.circom"
    },
    "rescue-prime": {
        "template_name": "RescuePrimeBench",
        "base_file": "rescue-prime_16f.circom"
    }
}

sizes = [1, 2, 3, 5, 9, 17, 34]

def run():
    for algo, info in algos.items():
        base_path = os.path.join(algo, info["base_file"])
        if not os.path.exists(base_path):
            print(f"Skipping {algo}, base file not found.")
            continue
        
        with open(base_path, 'r') as f:
            content = f.read()
        
        # We find the component main line and replace the argument.
        # Format usually: component main {public[in]} = TemplateName(1);
        # We will split by component main and rebuild it.
        
        parts = content.split("component main")
        prefix = parts[0]
        
        for size in sizes:
            new_filename = f"{algo}_{size}f.circom"
            new_path = os.path.join(algo, new_filename)
            
            # Reconstruct the last line
            # Sometimes it's {public[in]}, so we just replace the number in the call.
            # Easiest way is to just do prefix + "component main {public[in]} = " + info["template_name"] + f"({size});\n"
            
            new_content = prefix + f"component main {{public[in]}} = {info['template_name']}({size});\n"
            
            with open(new_path, "w") as f:
                f.write(new_content)
            print(f"Created {new_path}")
            
        # Delete old files
        old_patterns = [f"{algo}_16f.circom", f"{algo}_32f.circom", f"{algo}_64f.circom", f"{algo}_128f.circom"]
        for pat in old_patterns:
            p = os.path.join(algo, pat)
            if os.path.exists(p):
                os.remove(p)
                print(f"Removed {p}")

if __name__ == "__main__":
    run()
