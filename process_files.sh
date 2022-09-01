#ls!/bin/bash
# NOTE : Quote it else use array to avoid problems #
FILES="/home/to/workspace/all-panoramas/*.tif"
counter=0
for absolute_filepath in $FILES
do
    echo "PWD is $(pwd)"
    echo "File is $absolute_filepath"
    file_dirname=$(dirname $absolute_filepath)
    file_basename=$(basename $absolute_filepath)
    basename_noext=${file_basename%.tif}
    destination_file=${basename_noext}.dzi
    destination_python_file=$file_dirname/$basename_noext.py
    echo destination_dzi


    echo "PWD is $(pwd)"
    echo "File is $absolute_filepath"
    echo "Basename is $basename_noext"
    echo "Dirname is $file_dirname"
    echo "Destpath is $file_dirname/$basename_noext"
    echo "Destpy is $destination_python_file"

    mkdir $file_dirname/$basename_noext
    export f
    export destination
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
    image_quality=0.8,
    resize_filter="bicubic",
)

# Create Deep Zoom image pyramid from source
creator.create(SOURCE, "$basename_noext/$destination_file")
EOF
    echo "Counter is $counter"
    ((counter++))
    chmod u+x $destination_python_file
    cd $file_dirname
    ./$basename_noext.py
    #rm $destination_python_file

done