#!/bin/bash

# Declare the associative array
declare -A animals=( ["moo"]="cow" ["woof"]="dog" )

# Loop through the keys of the array
for key in "${!animals[@]}"; do
  # Get the value corresponding to the current key
  value=${animals[$key]}
  # Print the key and value
  echo "Key: $key, Value: $value"
done

