#!/usr/bin/bash

# Simple Vulnerability Pattern Scanner
# Uses: grep, awk, sed

echo "Simple Vulnerability Pattern Scanner"
echo "--------------------------------------"

# Step 1: Ask user for directory
read -p "Enter the directory to scan(enter . for current directory): " dir

# Step 2: Check if directory exists
if [ ! -d "$dir" ]; then
  echo "Directory not found!"
  exit 1
fi

# Step 3: Define suspicious patterns
patterns="password=|passwd|secret|key=|token|chmod 777|eval"

echo
echo "Scanning files for insecure patterns..."
echo

grep -r -nE "$patterns" "$dir" --exclude="result.txt" > result.txt


# Step 5: Format results using awk
echo "⚠️  Vulnerable Lines Found:"
echo "--------------------------------------"
awk -F: '{printf "File: %-25s Line: %-4s --> %s\n", $1, $2, $3}' result.txt

# Step 6: Hide sensitive info using sed
echo
echo "--------------------------------------"
echo "After masking sensitive info:"
sed 's/password=[^ ]*/password=*****/g' result.txt | \
awk -F: '{printf "File: %-25s Line: %-4s --> %s\n", $1, $2, $3}'
echo "--------------------------------------"

echo "✅ Scan complete. Results saved to result.txt"

