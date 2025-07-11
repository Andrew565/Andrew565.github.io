#!/bin/bash

# Function to get the dominant color of an image
get_dominant_color() {
  local image_file="$1"
  ~/Projects/dominantcolor "$image_file"
}

# Process each image file in the current directory
for image_file in *; do
  if [ -f "$image_file" ]; then
    file_name=$(basename "$image_file") # Extract the file name
    echo "Processing: $file_name"

    # Get the image's dominant color
    dominant_color=$(get_dominant_color "$image_file")

    # Create the background
    magick -size 1169x2075 xc:$dominant_color background.png

    # Calculate offsets
    dimensions=$(identify -format "%w %h" "$image_file")
    overlay_width=$(echo "$dimensions" | awk '{print $1}')
    overlay_height=$(echo "$dimensions" | awk '{print $2}')
    background_width=1169
    background_height=2075

    x_offset=$(((background_width - overlay_width) / 2))
    y_offset=$(((background_height - overlay_height) / 2))

    # Overlay the image
    magick background.png "$image_file" -geometry +${x_offset}+${y_offset} -composite "${file_name}_wall.png"

    # Clean up temporary background file.
    rm background.png
  fi
done

exit 0
