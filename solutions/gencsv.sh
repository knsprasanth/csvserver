#!/bin/bash

# Check if two arguments are provided
if [ $# -ne 2 ]; then
  echo "Error: Two arguments are required. Usage: $0 <start_index> <end_index>"
  exit 1
fi

# Extract the start and end indices from the arguments
start_index=$1
end_index=$2

# Define the filename
filename="inputFile"

# Create or overwrite the file with the desired content
for ((i=0; i<=end_index-start_index; i++))
do
  echo "$((start_index + i)), $((RANDOM%1000))" >> "$filename"
done

# Provide feedback to the user
echo "File '$filename' has been generated with $((end_index - start_index + 1)) entries."
