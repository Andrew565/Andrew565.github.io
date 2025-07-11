#!/bin/bash

# Set to the width and height of your specific device
final_wallpaper_size="1080x2340"

# Splits the size into width and height for later
IFS='x' read -r background_width background_height <<<"$final_wallpaper_size"

# Function to get the dominant color of an image
get_dominant_color() {
  local image_file="$1"
  ./dominantcolor "$image_file"
}

# Process each image file in the current directory
for image_file in *; do
  if [ -f "$image_file" ]; then
    file_name=$(basename "$image_file") # Extract the file name
    echo "Processing: $file_name"

    # Get the image's dominant color
    dominant_color=$(get_dominant_color "$image_file")

    # Create the background
    magick -size $final_wallpaper_size xc:$dominant_color background.png

    # Calculate "foreground/overlay" width and heights
    dimensions=$(identify -format "%w %h" "$image_file")
    overlay_width=$(echo "$dimensions" | awk '{print $1}')
    overlay_height=$(echo "$dimensions" | awk '{print $2}')

    # Calculate the offsets needed in order to center the foreground image
    x_offset=$(((background_width - overlay_width) / 2))
    y_offset=$(((background_height - overlay_height) / 2))

    # Overlay the image
    magick background.png "$image_file" -geometry +${x_offset}+${y_offset} -composite "${file_name}_wall.png"

    # Clean up temporary background file.
    rm background.png
  fi
done

exit 0
