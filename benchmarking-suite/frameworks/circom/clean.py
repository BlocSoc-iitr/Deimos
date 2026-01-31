import os
import shutil

def main():
    root_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Files/Extensions to explicitly preserve as "Source"
    keep_extensions = {'.circom'}
    keep_filenames = {'Makefile', '.gitignore', 'clean.py', 'README.md'}
    
    # Directories that should be wholly preserved (content not scanned for deletion)
    preserve_dirs = {'inputs', '.git', '.idea', '.vscode', 'circomlib', 'hash-circuits'}

    print(f"Starting cleanup in: {root_dir}")

    for root, dirs, files in os.walk(root_dir, topdown=True):
        # 1. Prune directories we want to preserve completely (so we don't look inside)
        # We also skip hidden directories like .git
        dirs[:] = [d for d in dirs if d not in preserve_dirs and not d.startswith('.')]

        # 2. Identify and remove generated artifact directories (*_js, *_cpp)
        # We iterate over a copy of dirs so we can remove from the list during iteration
        for d in list(dirs):
            if d.endswith('_js') or d.endswith('_cpp'):
                dir_path = os.path.join(root, d)
                print(f"Removing directory: {dir_path}")
                shutil.rmtree(dir_path)
                dirs.remove(d) # Don't traverse into deleted directory

        # 3. Identify and remove separate artifact files
        for file in files:
            # Check if strictly allowed
            if file in keep_filenames:
                continue
            
            _, ext = os.path.splitext(file)
            if ext in keep_extensions:
                continue
            
            # If not allowed, delete
            file_path = os.path.join(root, file)
            try:
                os.remove(file_path)
                print(f"Removing file: {file_path}")
            except OSError as e:
                print(f"Error removing {file_path}: {e}")

    print("Cleanup complete.")

if __name__ == "__main__":
    main()
