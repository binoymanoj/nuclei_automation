#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <domain name without protocol eg: domain.com>"
    exit 1
fi

# Create folder with argument name
mkdir "$1"

# Automating nuclei tool with subfinder and httpx-toolkit

subfinder -d "$1" -silent | httpx-toolkit -o "$1"/httpx_result.txt && nuclei -l "$1"/httpx_result.txt | tee -a "$1"/nuclei_result.txt

