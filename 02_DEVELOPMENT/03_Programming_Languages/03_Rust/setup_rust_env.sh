#!/bin/bash

########################################################################
# File Name    : setup_rust_env.sh
# Description  : This script sets up a basic Rust development 
#                environment.
# Usage        : • Make the script executable with:
#                  sudo chmod +x setup_rust_env.sh
#                • Run the script with:
#                  sudo bash setup_rust_env.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

echo "Installing basic environment for Rust development..."

# Update package lists
echo "Updating package lists to ensure you get the latest versions of software..."
sudo apt update

# Install Rust via Rustup (Rust toolchain installer)
echo "Installing Rust via Rustup..."
echo "Rustup is the recommended tool to install and manage Rust programming language."
echo "Downloading and installing Rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Configure Rust environment
echo "Configuring Rust environment..."
echo "Adding Rust binaries to the system's PATH..."
source $HOME/.cargo/env

# Install additional tools and components (optional)
# Example: Install Rustfmt (Rust code formatter) and Clippy (Rust linter)
echo "Installing Rustfmt (code formatter) and Clippy (linter)..."
rustup component add rustfmt clippy

echo "Installation completed successfully!"

# References for Rust development
echo
echo "### References for Rust Development ###"
echo "- Rust Programming Language: https://www.rust-lang.org"
echo "- Cargo (Rust package manager): https://doc.rust-lang.org/cargo/"
echo "- Rustup (Rust toolchain installer): https://rustup.rs"
echo "- Rustfmt (Rust code formatter): https://github.com/rust-lang/rustfmt"
echo "- Clippy (Rust linter): https://github.com/rust-lang/rust-clippy"
echo "#########################################"
