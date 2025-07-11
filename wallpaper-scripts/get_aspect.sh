#!/bin/bash

# Process each image file in the current directory
for image_file in *; do
  if [ -f "$image_file" ]; then
    file_name=$(basename "$image_file") # Extract the file name

    # Determine the image type and use the appropriate tool
    file_type=$(file --mime-type -b "$image_file")

    if [[ "$file_type" == image/jpeg || "$file_type" == image/png || "$file_type" == image/gif || "$file_type" == image/webp ]]; then
      # Use identify (ImageMagick) to get image dimensions
      if command -v identify &>/dev/null; then
        dimensions=$(identify -format "%w %h" "$image_file")
        width=$(echo "$dimensions" | awk '{print $1}')
        height=$(echo "$dimensions" | awk '{print $2}')

        if [ -n "$width" ] && [ -n "$height" ]; then
          ratio=$(echo "scale=2; $height / $width" | bc -l)
        else
          echo "Error: Could not determine image dimensions for '$file_name'."
          continue
        fi
      else
        echo "Error: ImageMagick (identify) is not installed. Please install it."
        exit 1
      fi
    elif [[ "$file_type" == image/heic ]]; then
      if command -v exiftool &>/dev/null; then
        width=$(exiftool -s -ImageWidth "$image_file")
        height=$(exiftool -s -ImageHeight "$image_file")

        if [ -n "$width" ] && [ -n "$height" ]; then
          ratio=$(echo "scale=2; $height / $width" | bc -l)
        else
          echo "Error: Could not determine image dimensions for '$file_name'."
          continue
        fi
      else
        echo "Error: exiftool is not installed. Please install it."
        exit 1
      fi
    else
      echo "Error: Unsupported image type: $file_type"
      continue
    fi

    echo "$ratio - $file_name"
    # Check if the ratio is less than 2.1
    if (($(echo "$ratio < 2.1" | bc -l))); then
      mv "$image_file" "../wide_images/$file_name"
    fi
  fi
done

exit 0
