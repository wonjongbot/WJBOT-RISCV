# python script to create project structure

import os

def create_dir(dir_name):
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)

def create_file(file_name, content=""):
    with open(file_name, "w") as f:
        f.write(content)

def main():
    # Root directory
    root_dir = "WJBOT-RISCV"

    # Sub-directories
    sub_dirs = [
        "docs",
        "scripts",
        "tests",
        "src/main",
        "src/modules",
        "src/interfaces",
        "tools/Quartus_Project",
        "tools/Modelsim",
        "lib/third_party_IP",
        "output_files/logs",
        "output_files/bitstreams",
        "output_files/reports",
        "HarrisAndHarris_DDCA/sv",
        "HarrisAndHarris_DDCA/tv"
    ]

    # Create Root Directory
    create_dir(root_dir)

    # Create Sub-directories
    for sub_dir in sub_dirs:
        create_dir(os.path.join(root_dir, sub_dir))

    # Create README.md
    create_file(os.path.join(root_dir, "README.md"), "# WJBOT-RISCV\n\nDescription here.")

    # Create LICENSE
    create_file(os.path.join(root_dir, "LICENSE"), "MIT License\n\nCopyright (c) 2023 [Your Name]\n\n...")

    # Create .gitignore
    gitignore_content = """
    # Ignored files and folders
    *.log
    *.bin
    *.rpt
    """
    create_file(os.path.join(root_dir, ".gitignore"), gitignore_content)

    # Create sample scripts
    create_file(os.path.join(root_dir, "scripts/compile.sh"), "#!/bin/bash\n\n# Compile script here")
    create_file(os.path.join(root_dir, "scripts/synthesis.sh"), "#!/bin/bash\n\n# Synthesis script here")

    # Create Makefile
    create_file(os.path.join(root_dir, "Makefile"), "# Makefile for WJBOT-RISCV")

    # Create placeholder for documentation
    create_file(os.path.join(root_dir, "docs/specifications.md"), "# Specifications")
    create_file(os.path.join(root_dir, "docs/installation_guide.md"), "# Installation Guide")

    # Create README for HarrisAndHarris_DDCA
    starter_readme_content = """
    # HarrisAndHarris_DDCA Starter Code
    This folder contains starter code from the HarveyMuddX ENGR 85 course.
    Textbook: Digital Design and Computer Architecture by Harris and Harris.
    """
    create_file(os.path.join(root_dir, "HarrisAndHarris_DDCA/README.md"), starter_readme_content)

    print(f"Project {root_dir} has been initialized with the required directory structure and files.")

if __name__ == "__main__":
    main()
