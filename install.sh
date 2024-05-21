#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

echo "[*] Checking and installing required tools..."

tools=("subfinder" "httpx-toolkit" "nuclei")

failed_tools=()

for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "[*] $tool is not installed. Installing $tool"
        echo "[*] Installing $tool..."
        apt-get install -y "$tool"  # Package manager changes upon system. This command works for Debian-based systems. Modify for other package managers
        # Check if the installation was successful
        if ! command -v "$tool" &> /dev/null; then
            echo "[!] Error: Installation of $tool failed. Please install it manually."
            failed_tools+=("$tool")
        else
            echo "[*] $tool installed successfully."
        fi
    else
        echo "[*] $tool is already installed."
    fi
done

if [ ${#failed_tools[@]} -gt 0 ]; then
    echo "[!] The following tools could not be installed automatically. Please install them manually:"
    for failed_tool in "${failed_tools[@]}"; do
        echo "    - $failed_tool"
    done
    exit 1
fi

# coping the tool to bin directory for accessing anywhere in the terminal
cp nuclei_automation.sh /usr/bin/nuto

# Display completion message
echo
echo "[*] Tool is installed successfully!"
echo
echo "[*] You can use the tool by \$ nuto <domain>"
