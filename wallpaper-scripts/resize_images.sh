#!/bin/bash

desired_width=960 # Set the desired width for the resized images

# Loop through all image files in the directory
for image in *; do
  if [[ -f "$image" ]]; then
    input_image="$image"

    # Get the original image dimensions
    original_dimensions=$(identify -format "%wx%h" "$input_image")
    original_width=$(echo "$original_dimensions" | cut -d 'x' -f 1)
    original_height=$(echo "$original_dimensions" | cut -d 'x' -f 2)

    # Calculate the new height while maintaining aspect ratio
    new_height=$(echo "scale=1; $desired_width * $original_height / $original_width" | bc)
    new_height=$(printf "%.0f" "$new_height")

    # Generate the output filename (e.g., input_resized.png)
    output_image="${input_image%.*}_resized.${input_image##*.}"

    # Resize the image using ImageMagick
    magick "$input_image" -resize "${desired_width}x${new_height}" "$output_image"

    echo "Resized image saved as: $output_image"
  fi
done

exit 0
