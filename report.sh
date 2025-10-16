#!/usr/bin/bash

# simple_dir_report.sh
# List directory contents and create a simple report using awk

# 1) Ask for directory
read -p "Enter directory to scan (use . for current dir): " dir

# 2) Check if directory exists
if [ ! -d "$dir" ]; then
  echo "Directory not found: $dir"
  exit 1
fi

# 3) Prepare output file
OUT="dir_report.txt"
: > "$OUT"

# 4) List files in long format and process with awk
ls -l "$dir" 2>/dev/null | awk 'NR>1 { 
    perm=$1; owner=$3; filename=$9; 
    printf "%-30s  %10s  %-10s\n", filename, perm, owner 
}' >> "$OUT"

# 5) Show the report
echo "📄 Report for directory: $dir"
echo "Filename                        |Permissions |Owner"
echo "---------------------------------------------------"
cat "$OUT"
echo
echo "Report saved to: $OUT"

