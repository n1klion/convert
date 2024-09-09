#!/bin/bash

input_dir="input"
output_dir="output/webm"

if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
fi

for movfile in "$input_dir"/*.mov; do
  base_name="$(basename "$movfile" .mov)"
  output_file="$output_dir/${base_name}.webm"
  ffmpeg -i "$movfile" -c:v libvpx-vp9 -pix_fmt yuva420p -g 1 -an -metadata:s:v:0 alpha_mode="1" -auto-alt-ref 0 "$output_file"

  if [ $? -eq 0 ]; then
    echo "Converted $movfile to $output_file successfully."
  else
    echo "Failed to convert $movfile."
  fi
done
