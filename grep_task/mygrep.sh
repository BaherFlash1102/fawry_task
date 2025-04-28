#!/bin/bash

# Print usage information
usage() {
  echo "Usage: $0 [-n] [-v] search_string filename"
  echo "Options:"
  echo "  -n    Show line numbers"
  echo "  -v    Invert match (print lines that do NOT match)"
  echo "  --help  Show this help message"
  exit 1
}

# Check for --help
if [[ "$1" == "--help" ]]; then
  usage
fi


# Initialize flags
show_line_numbers=false
invert_match=false

# Check if first argument is an option
if [[ "$1" == -* ]]; then
  options="$1"
  search="$2"
  file="$3"
  
  if [[ "$options" == *n* ]]; then
    show_line_numbers=true
  fi
  if [[ "$options" == *v* ]]; then
    invert_match=true
  fi
else
  options=""
  search="$1"
  file="$2"
fi

# Check if file exists
if [ ! -f "$file" ]; then
  echo "Error: File '$file' not found."
  exit 1
fi

# Read the file line by line
line_num=0
while IFS= read -r line; do
  line_num=$((line_num + 1))
  
  # Match the line case-insensitively
  echo "$line" | grep -qi "$search"
  matched=$?

  if $invert_match; then
    if [ $matched -ne 0 ]; then
      if $show_line_numbers; then
        echo "${line_num}:$line"
      else
        echo "$line"
      fi
    fi
  else
    if [ $matched -eq 0 ]; then
      if $show_line_numbers; then
        echo "${line_num}:$line"
      else
        echo "$line"
      fi
    fi
  fi

done < "$file"
