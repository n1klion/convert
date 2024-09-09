#!/bin/bash

input_dir="input"
output_dir="output/gif"

if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
fi

for movfile in "$input_dir"/*.mov; do
  base_name="$(basename "$movfile" .mov)"
  output_file="$output_dir/${base_name}.gif"

  ffmpeg -i "$movfile" -vf "fps=15,scale=600:-1:flags=lanczos" -gifflags -transdiff -y "$output_file"

  if [ $? -eq 0 ]; then
    echo "Converted $movfile to $output_file successfully."
  else
    echo "Failed to convert $movfile."
  fi
done
