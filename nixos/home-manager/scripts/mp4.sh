#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Error: No input file provided."
  echo "Usage: $0 <input_video_file>"
  exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: Input file '$INPUT_FILE' not found."
  exit 1
fi

FILENAME=$(basename -- "$INPUT_FILE")
FILENAME_NO_EXT="${FILENAME%.*}"

OUTPUT_FILE="${FILENAME_NO_EXT}_mp4.mp4"

echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE' using Apple ProRes 422 HQ..."
echo "This may take some time and create a large file."

ffmpeg -i "$INPUT_FILE" "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
  echo "Conversion successful! Output file: '$OUTPUT_FILE'"
else
  echo "Error: FFmpeg conversion failed. Please check the console output for details."
fi
