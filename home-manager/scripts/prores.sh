#!/usr/bin/env bash

# Script to convert an MP4 file to Apple ProRes 422 HQ format (.mov)
# This script requires FFmpeg to be installed on your system.

# --- Usage Information ---
# How to use:
#   1. Save this content to a file (e.g., convert_to_prores.sh).
#   2. Make the script executable: chmod +x convert_to_prores.sh
#   3. Run the script: ./convert_to_prores.sh /path/to/your/input_video.mp4
#
# Replace '/path/to/your/input_video.mp4' with the actual path to your MP4 file.

# --- Input Validation ---
if [ -z "$1" ]; then
  echo "Error: No input file provided."
  echo "Usage: $0 <input_mp4_file>"
  exit 1
fi

INPUT_FILE="$1"

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: Input file '$INPUT_FILE' not found."
  exit 1
fi

# Check if the input file has a .mp4 extension (optional, but good practice)
if [[ "${INPUT_FILE##*.}" != "mp4" ]]; then
  echo "Warning: Input file '$INPUT_FILE' does not have a .mp4 extension. Proceeding anyway."
fi

# --- Generate Output Filename ---
# Get the base name of the input file (without path or extension)
FILENAME=$(basename -- "$INPUT_FILE")
FILENAME_NO_EXT="${FILENAME%.*}"

# Construct the output filename
OUTPUT_FILE="${FILENAME_NO_EXT}_prores_hq.mov"

# --- FFmpeg Conversion Command ---
echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE' using Apple ProRes 422 HQ..."
echo "This may take some time and create a large file."

ffmpeg -i "$INPUT_FILE" \
       -c:v prores_ks \
       -profile:v 3 \
       -vendor apl0 \
       -pix_fmt yuv422p10le \
       -c:a pcm_s16le \
       "$OUTPUT_FILE"

# --- Completion Message ---
if [ $? -eq 0 ]; then
  echo "Conversion successful! Output file: '$OUTPUT_FILE'"
else
  echo "Error: FFmpeg conversion failed. Please check the console output for details."
fi
