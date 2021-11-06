#!/bin/sh

srcdir="$PWD"
path=$(zenity --entry --title='Install Snippets' --text='Copy and paste the absolute path to your Godot project directory:' 2> /dev/null)

if [ -z "$path" ]; then
    echo 'No path provided...aborting'
    exit
fi

# Make sure the directory exists
cd "$path" || {
    echo "Invalid path '$path'" >&2
    exit 1
}

# Must be the root of a Godot project
if [ ! -f "$path/project.godot" ]; then
    echo "'$path' is not a Godot project folder" >&2
    exit 1
fi

# Create 'snippets' folder
mkdir --parents "$path/snippets" || {
    echo "Failed to create directory '$path/snippets'" >&2
    exit 1
}

targetdir="$path/addons/snippets_plugin"

# Create target directory
mkdir --parents "$targetdir" || {
    echo "Failed to create directory '$targetdir'" >&2
    exit 1
}

# Copy addon files into destination
cd "$srcdir/Snippets-EditorPlugin/addons/snippets_plugin" || exit 1

cp --no-clobber --verbose *.*  --target-directory="$targetdir" || {
    echo "Failed to copy files into '$targetdir'" >&2
    exit 1
}

# Copy premade snippets into 'snippets' folder
targetdir="$path/snippets"

cd "$srcdir/snippets" || exit 1

cp --no-clobber --verbose *.* --target-directory="$targetdir" || {
    echo "Failed to copy files into '$targetdir'" >&2
    exit 1
}
