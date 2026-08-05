#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Error: No input file provided."
  echo "Usage: $0 <input_mp4_file>"
  exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: Input file '$INPUT_FILE' not found."
  exit 1
fi

if [[ "${INPUT_FILE##*.}" != "mp4" ]]; then
  echo "Warning: Input file '$INPUT_FILE' does not have a .mp4 extension. Proceeding anyway."
fi

FILENAME=$(basename -- "$INPUT_FILE")
FILENAME_NO_EXT="${FILENAME%.*}"

OUTPUT_FILE="${FILENAME_NO_EXT}_prores_hq.mov"

echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE' using Apple ProRes 422 HQ..."
echo "This may take some time and create a large file."

ffmpeg -i "$INPUT_FILE" \
       -c:v prores_ks \
       -profile:v 3 \
       -vendor apl0 \
       -pix_fmt yuv422p10le \
       -c:a pcm_s16le \
       "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
  echo "Conversion successful! Output file: '$OUTPUT_FILE'"
else
  echo "Error: FFmpeg conversion failed. Please check the console output for details."
fi
