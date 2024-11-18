#!/bin/bash

########################################################################
# File Name    : setup_c_and_cpp_env.sh
# Description  : This script sets up a basic C and C++ environment.
# Usage        : • Make the script executable with:
#                sudo chmod +x setup_c_and_cpp_env.sh
#                • Run the script with:
#                sudo bash setup_c_and_cpp_env.sh
# Author       : Me and the bois
# License      : Free of charge, no warranty
########################################################################

echo "Installing basic environment for C and C++ development..."

# Update package lists
echo "Updating package lists..."
sudo apt update

# Install essential development tools, build-essential includes compilers, libraries, and tools for C/C++ development
echo "Installing essential development tools..."
sudo apt install -y build-essential

# Ask for compiler preference
echo "Choose a compiler:"
echo "1) GNU Compiler Collection (GCC) with GDB (GNU Debugger) and cgdb: A widely-used compiler."
echo "2) Tiny C Compiler (TCC): A smaller and faster compiler with debugger."
echo "3) Install both GCC and TCC."
echo "4) Clang: A compiler for C, C++, and Objective-C."
read -p "Enter 1, 2, 3, or 4: " compiler_choice

case $compiler_choice in
  2)
    echo "Installing Tiny C Compiler (TCC)..."
    sudo apt install -y tcc  # Install Tiny C Compiler (TCC)
    ;;
  3)
    echo "Installing GNU Compiler Collection (GCC) and Tiny C Compiler (TCC)..."
    sudo apt install -y gcc g++ tcc  # Install both GCC and TCC
    echo "Installing GDB (GNU Debugger) and cgdb for GCC..."
    sudo apt install -y gdb cgdb  # Install debugger (GDB) and cgdb for GCC
    ;;
  4)
    echo "Installing Clang..."
    sudo apt install -y clang  # Install Clang (C/C++ compiler with LLVM backend)
    ;;
  *)
    echo "Installing GNU Compiler Collection (GCC)..."
    sudo apt install -y gcc g++  # Install GNU Compiler Collection (GCC)
    echo "Installing GDB (GNU Debugger) and cgdb for GCC..."
    sudo apt install -y gdb cgdb  # Install debugger (GDB) and cgdb for GCC
    ;;
esac

# Ask to install additional tools. Software Build, process of compiling source code into executable software
echo "Software Build. Process of compiling source code into executable software."
echo "Do you want to install these tools?"
echo "1) make: Build automation tool that reads a Makefile to compile source code."
echo "2) cmake: Cross-platform tool for managing the build process using platform-independent configuration files."
echo "3) GNU Autotools (autoconf, automake, libtool): Tools for automatically configuring, building, and installing software on different Unix-like systems."
echo "4) Meson: A modern build system that focuses on speed and user-friendliness."
echo "5) Install all of the above."
read -p "Enter 1, 2, 3, 4, or 5: " build_tools_choice

case $build_tools_choice in
  1)
    echo "Installing make..."
    sudo apt install -y make  # Build automation tool that reads a Makefile to compile source code.
    ;;
  2)
    echo "Installing cmake..."
    sudo apt install -y cmake  # Cross-platform tool for managing the build process using platform-independent configuration files.
    ;;
  3)
    echo "Installing GNU Autotools (autoconf, automake, libtool)..."
    sudo apt install -y autoconf automake libtool  # Tools for automatically configuring, building, and installing software on different Unix-like systems.
    ;;
  4)
    echo "Installing Meson..."
    sudo apt install -y meson  # A modern build system that focuses on speed and user-friendliness.
    ;;
  5)
    echo "Installing make, cmake, GNU Autotools, and Meson..."
    sudo apt install -y make cmake autoconf automake libtool meson
    ;;
  *)
    echo "No build tools selected for installation."
    ;;
esac

# Function to install selected libraries/frameworks
install_libraries() {
  for choice in "$@"; do
    case $choice in
      1)
        echo "Installing OpenSSL (secure communication library)..."
        sudo apt install -y libssl-dev
        ;;
      2)
        echo "Installing libcurl (URL transfer library)..."
        sudo apt install -y libcurl4-openssl-dev
        ;;
      3)
        echo "Installing Boost (set of C++ libraries)..."
        sudo apt install -y libboost-all-dev
        ;;
      4)
        echo "Installing SQLite (lightweight database library)..."
        sudo apt install -y libsqlite3-dev
        ;;
      5)
        echo "Installing GTK development tools (GUI toolkit)..."
        sudo apt install -y libgtk-3-dev
        ;;
      6)
        echo "Installing Qt development tools..."
        sudo apt install -y qtcreator qt5-default
        ;;
      7)
        echo "Installing OpenGL (graphics library)..."
        sudo apt install -y libglu1-mesa-dev freeglut3-dev mesa-common-dev
        ;;
      8)
        echo "Installing zlib (compression library)..."
        sudo apt install -y zlib1g-dev
        ;;
      9)
        echo "Installing ncurses (text user interface library)..."
        sudo apt install -y libncurses5-dev libncursesw5-dev
        ;;
      10)
        echo "Installing libpcap (packet capture library)..."
        sudo apt install -y libpcap-dev
        ;;
      11)
        echo "Installing Boost.Asio (C++ network programming library)..."
        sudo apt install -y libboost-all-dev
        ;;
      *)
        echo "Invalid option. Skipping installation for invalid choice: $choice"
        ;;
    esac
  done
}

# Prompt user for libraries to install
echo "Choose libraries to install (enter numbers separated by spaces, or 0 to finish):"
echo "1) OpenSSL (secure communication library)"
echo "2) libcurl (URL transfer library)"
echo "3) Boost (set of C++ libraries)"
echo "4) SQLite (lightweight database library)"
echo "5) GTK development tools (GUI toolkit)"
echo "6) Qt development tools"
echo "7) OpenGL (graphics library)"
echo "8) zlib (compression library)"
echo "9) ncurses (text user interface library)"
echo "10) libpcap (packet capture library)"
echo "11) Boost.Asio (C++ network programming library)"
echo "0) Finish installation"

read -a library_choices
if [ "${library_choices[0]}" == "0" ]; then
  echo "No libraries selected. Exiting..."
else
  install_libraries "${library_choices[@]}"
fi

# Function to install additional useful tools
install_useful_tools() {
  echo "Installing useful tools..."
  sudo apt install -y curl wget
}

# Install useful tools
install_useful_tools

# Ask for user choices
echo "Choose options to install (enter numbers separated by spaces):"
echo " Dev Utilities:"
echo "1) Curl"
echo "2) Wget"
echo "3) Git"
echo " Basic IDEs:"
echo "4) Geany"
echo "5) NeoVim"
echo "6) Emacs"
echo " Basic Text Editors:"
echo "7) CherryTree"
echo "8) Zim"
echo "0) Skip installation or exit"

read -p "Enter your choices: " user_choices

# Function to install selected tools
install_tools() {
  for choice in $user_choices; do
    case $choice in
      1)
        echo "Installing Curl..."
        sudo apt install -y curl
        ;;
      2)
        echo "Installing Wget..."
        sudo apt install -y wget
        ;;
      3)
        echo "Installing Git..."
        sudo apt install -y git
        ;;
      4)
        echo "Installing Geany IDE..."
        sudo apt install -y geany
        ;;
      5)
        echo "Installing NeoVim IDE..."
        sudo apt install -y neovim
        ;;
      6)
        echo "Installing Emacs IDE..."
        sudo apt install -y emacs
        ;;
      7)
        echo "Installing CherryTree..."
        sudo apt install -y cherrytree
        ;;
      8)
        echo "Installing Zim..."
        sudo apt install -y zim
        ;;
      0)
        echo "Skipping installation..."
        return  # Exit the function if the user chooses 0
        ;;
      *)
        echo "Invalid option: $choice. Skipping..."
        ;;
    esac
  done
}

# Install selected tools
install_tools

echo "Installation completed successfully!"