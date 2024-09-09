#!/bin/bash

input_dir="input"
output_dir="output/avif"

if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
fi

for movfile in "$input_dir"/*.mov; do
  base_name="$(basename "$movfile" .mov)"
  output_file="$output_dir/${base_name}.avif"
  ffmpeg -i "$movfile" -pix_fmt yuva444p -f yuv4mpegpipe -strict -1 - | avifenc --stdin "$output_file"

  if [ $? -eq 0 ]; then
    echo "Converted $movfile to $output_file successfully."
  else
    echo "Failed to convert $movfile."
  fi
done
