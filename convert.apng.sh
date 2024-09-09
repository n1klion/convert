#!/bin/bash

INPUT_DIR="input"
OUTPUT_DIR="output/png"

if [ ! -d "$OUTPUT_DIR" ]; then
  mkdir -p "$OUTPUT_DIR"
fi

for MOVFILE in "$INPUT_DIR"/*.mov; do
  BASE_NAME="$(basename "$MOVFILE" .mov)"
  OUTPUT_FILE="$OUTPUT_DIR/${BASE_NAME}.png"
  TMP_DIR="$OUTPUT_DIR/tmp"
  FRAMES_DIR="$TMP_DIR/frames"
  mkdir -p $FRAMES_DIR

  ffmpeg -i "$MOVFILE" -vf "scale=out_color_matrix=bt709" -qscale:v 6 "$FRAMES_DIR/output_%04d.png"
  PNG_COUNT=$(ls -1q $FRAMES_DIR/*.png | wc -l)
  if [ "$PNG_COUNT" -eq 0 ]; then
    echo "No PNG frames were extracted. Exiting."
    exit 1
  fi

  pngquant --strip --quality=60-80 --force --ext .png $(ls "$FRAMES_DIR/" | xargs -I {} echo $FRAMES_DIR/{})
  apngasm -o "$OUTPUT_FILE" "$FRAMES_DIR/output_*.png"

  rm -rf $TMP_DIR
done
