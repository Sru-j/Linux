#!/usr/bin/bash

# perm_scanner_simple.sh
# Simple permission scanner using only: ls, grep, awk, sed, basic shell

echo "Simple Permission Vulnerability Scanner (basic tools only)"
read -p "Enter directory to scan (enter . for current dir): " dir

if [ ! -d "$dir" ]; then
  echo "❌ Directory not found: $dir"
  exit 1
fi


OUT="perm_result.txt"
: > "$OUT"   # empty output file

echo
echo "Scanning: $dir ..."
echo "--------------------------"

# 1) capture full recursive 'ls -l' output into a temp file (so grep won't read our OUT)
TMP_LS=$(mktemp)
ls -lR "$dir" 2>/dev/null > "$TMP_LS"

# 2) Exact 777 files (permission string exactly -rwxrwxrwx)
# lines for files start with '-' so match ^-rwxrwxrwx

grep '^[-]rwxrwxrwx' "$TMP_LS" > /dev/null 2>&1
if [ $? -eq 0 ]; then
  grep '^[-]rwxrwxrwx' "$TMP_LS" | \
  awk '{ perm=$1; owner=$3; 
         fname = substr($0, index($0,$9));
         printf "%s|%s|%s|%s\n", fname, perm, owner, "777 (exact)" }' >> "$OUT"
fi

grep '^[-]rwxrwxrwx' "$TMP_LS" | \ awk '{ perm=$1; owner=$3; fname = substr($0, index($0,$9)); printf "%s|%s|%s|%s\n", fname, perm, owner, "777 (exact)" }' >> "$OUT"

rm -f "$TMP_LS"

# Show results
if [ ! -s "$OUT" ]; then
  echo "No risky permission files found."
  rm -f "$OUT"
  exit 0
fi

echo "Risky files found:"
echo "Path | Perm | Owner | Reason"
echo "-------------------------------------------"
awk -F'|' '{ printf "%-60s  %6s  %-10s  %s\n", $1, $2, $3, $4 }' "$OUT"

echo
echo "Report saved to: $OUT"
