---
title: My Crazy iOS Wallpapers Setup
published: false
description: How I use a small army of Shortcuts and Scripts to manage my 2000+ wallpapers collection and keep things fresh!
tags: ios, wallpapers, shortcuts
cover_image: http://andrew565.github.io/assets/img/wallpapers.png
# published_at: 2025-07-09 18:55 +0000
---

Do you have a lot of wallpapers for your phone, but struggle to manage them and get them to display randomly? Do you have wallpapers that just refuse to "fit the screen" well? Is your collection, like mine, constantly growing? Are you dissatisfied with the "Photo Shuffle" which only lets you cycle through 40 photos at a time?

Welcome to my tutorial on how to use iOS Shortcuts and a handful of shell scripts to manage your wallpapers! I'll include links to my shortcuts and scripts as I go, but there will also be a "link dump" at the bottom of the article. Hopefully these tips and tricks will help you to more fully enjoy your collection!

## Step One: Organize Locally

The first thing I recommend doing is moving your wallpaper collection out of the Photos app and onto your local device. The main reason for this is if you're pulling from Photos or iCloud you're going to waste bandwidth/data with downloading pics "on the fly" when you need them. If you still want to have a backup, you could also keep a copy of your files in your iCloud Drive, just keep in mind for the shortcuts and such to work they're assuming you have your files and folders on your local device. I also found that the Shortcuts were more likely to "timeout" and throw an error if you were trying to run them on cloud-hosted files.

If you want to batch modify your files, you should move them first to a Mac or PC. My scripts are written assuming you have access to a shell script like Bash or zsh. If you don't want to batch modify anything, or you don't have access to a Mac or PC, just skip this part.

To move your files out of Photos, I recommend first going through your Photos and adding all of your wallpapers to a "Wallpapers" album. This will make it easier to batch move them elsewhere, and there's a shortcut that takes advantage of this album for later adding to your collection. Once you've collected all of your pics in one place, go into the album and then tap the "Select" button in the upper right, and then tap "Select All" in the upper left. Next, go to the bottom left and tap the "Share" icon. From the share screen, select "Save to Files". At this point, you can choose to save directly to your computer, or you can save locally to your phone as an intermediate step. I recommend saving locally first, it will make the process a little smoother in my experience. In the file browser that pops up, navigate to "On my iPhone", tap the three-dots-menu at the top right, then create a new folder for "Wallpapers", tap the folder to open it, and then tap "Save".

Once you've got your files saved locally, you can optionally remove them from your Photos collection. I chose to remove them to free up room and so they would stop showing up in "Memories" and "Featured Collections". From the Wallpapers album, tap "Select", then "Select All", and then the "Trash Can" icon and confirm that you wish to delete them (not just remove from the album). Don't forget that anything you delete will actually still count against your data quota for 30 days, or until you go into the "Recently Deleted" collection and re-select them and force delete them.

Finally, move the newly-saved files from your phone to your computer. If you have "network sharing" enabled on your computer, you should be able to find it using the Files app. You might also consider using a Mac or PC app to access your phone's storage directly (similar to how iTunes used to do it). I'm pretty sure the Finder app can do this on Macs. Just make sure you put the files somewhere you can remember.

## Step Two: Batch Processing

I had a bunch of pics that were nowhere close to the correct aspect ratio for my iPhone 13 Mini (which is a mind-boggling 19.5:9, or 2.16:1), so the first step I took was figuring out which files I would need to resize in order to "letterbox" them and make them fit. This meant resizing them to a good width (I chose 960px for a variety of reasons), and then adding some "whitespace" to the top and bottom and sides in order to center the image. I decided to get extra fancy with this whitespace part, and found a script to pull out the dominant color of the image and use that for the "background".

Here then are the general steps I took:
1. Determine too-wide files with get_aspect.sh script
2. Resize the too-wide files with resize_images script
3. Create new wallpapers with the "featured" paper in the center, and the dominant color in the background with the create_wallpaper.sh script

These scripts depend on ImageMagick and exiftool (for HEIC files), so make sure you have [ImageMagick](https://imagemagick.org/script/download.php) and [exiftool](https://exiftool.org/) installed. The dominantcolor script was written by Fred Weinhaus and shared on his [website](http://www.fmwconcepts.com/imagemagick/dominantcolor/index.php).

You can find the scripts here:
* [get_aspect](https://andrew565.github.io/wallpaper-scripts/get_aspect.sh)
* [resize_images](https://andrew565.github.io/wallpaper-scripts/resize_images.sh)
* [dominantcolor](https://andrew565.github.io/wallpaper-scripts/dominantcolor)
* [create_wallpaper](https://andrew565.github.io/wallpaper-scripts/create_wallpaper.sh)

Download and copy these files to the same directory where your images are. You may need to `chmod +X` each of the scripts in order to be able to execute them on your computer. First, run the `get_aspect.sh` script, this will sort out the too-wide pics into a separate directory. Next, go into the `resize_images.sh` file and modify the `desired_width=1080` variable to reflect your desired width. Then run `resize_images.sh` so that they're the right width. Lastly, run the `create_wallpaper.sh` script, which will call dominantcolor and create a new wallpaper file with the dominant color as the background and your pic as the foreground.

Optionally, you can choose to rename your wallpapers at this time. The Shortcuts don't care what the files names are, though, so this is up to personal preference.

## Step Three: Split Them Up

One of the downsides of the "get random file" function used by Shortcuts is that it needs to read all of the files in a directory into memory before it can then select one of them at random. Because of this, I highly recommend splitting your files up into separate folders. I chose 300 pictures per folder, and this works for me more than not. In order to work with the Shortcuts I made, put the first 300 images in a folder labeled "1", the second 300 in folder "2", and so on until all of the files are in a folder. Don't worry if the last folder doesn't have a full 300 images, the shortcuts will still work.

Now you're ready to move your files back to your phone. Do so in whatever way works for you, but make sure all of the individually-numbered folders end up together in a single folder.

## Step Four: Shortcuts Time

