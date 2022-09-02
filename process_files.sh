#ls!/bin/bash
# NOTE : Quote it else use array to avoid problems #
file_path=/home/to/all-panoramas
FILES="$file_path/*.tif"
counter=0
mkdir $file_path/output
for absolute_filepath in $FILES
do
    echo "PWD is $(pwd)"
    echo "Processing $absolute_filepath ..."
    file_dirname=$(dirname $absolute_filepath)
    file_basename=$(basename $absolute_filepath)
    basename_noext=${file_basename%.tif}
    destination_file=${basename_noext}.dzi
    destination_python_file=$file_dirname/$basename_noext.py

    mkdir $file_dirname/output/$basename_noext
    export f
    export file_dirname
    export destination_filename
cat > $destination_python_file <<EOF
#!/usr/bin/env python3

import os

import deepzoom

# Specify your source image
SOURCE = "$absolute_filepath"

# Create Deep Zoom Image creator with weird parameters
creator = deepzoom.ImageCreator(
    tile_size=128,
    tile_overlap=2,
    tile_format="png",
    image_quality=1,
    resize_filter="bicubic",
)

# Create Deep Zoom image pyramid from source
creator.create(SOURCE, "$file_dirname/output/$destination_file")
EOF
    echo "Counter is $counter"
    ((counter++))
    chmod u+x $destination_python_file
    cd $file_dirname
    ./$basename_noext.py
    rm $destination_python_file
    echo output/$basename_noext/$destination_file >> $file_dirname/output/dzi-paths
done