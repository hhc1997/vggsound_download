# vggsound dataset

This is a set of tools for downloading [VGG-Sound](https://www.robots.ox.ac.uk/~vgg/data/vggsound/), a dataset of labeled audio-visual files.

# Running
First, mkdir train and test

Run ```cat vggsound.csv | ./download.sh ``` to dowanload all videos.

Run ```cat vggsound.csv | sed -ne '9602,$p' | ./download.sh ``` to dowanload after No.9602 video.

It can automatically mkdir the label , cut the raw video to specified segment and delete the raw video.
