#!/bin/bash

SAMPLE_RATE=44100
# Get script args

#fetch_clip(videoID, startTime, label, train/test)
fetch_clip() {
  array=(${1//,/ })   #dou hao bian kong ge
  video_name=${array[0]}
  start_time=${array[1]}
  let end_time=$start_time+10
  label_list=${array[2]}
  train_or_test=${array[3]}  
  num_=${array[4]}  
  # record
  echo "$num_" >> record.txt
  echo "Fetching $video_name ($start_time to $end_time)..."
  outname="v"$video_name"_"$start_time"_"$end_time

 
  label_list=(${label_list//+/ })  #"a_b b_c"

#  arr=($label_list)
#     for s in ${arr[@]} 
#     do

#     dirr=$train_or_test"/"$s
#     if [ ! -d $dirr  ];then
#       mkdir $dirr
#       echo $dirr
#     else
#       echo dir exist
#   fi
# done

   if [ -f "${outname}.mp4" ]; then
    echo "Already have it."
    return
  fi

  yt-dlp -f 'bestvideo[height<=480]+bestaudio/best[height<=480]' https://youtube.com/watch?v=$video_name \
    --output "$outname.%(ext)s" --merge-output-format mkv
  if [ $? -eq 0 ]; then
    # If we don't pipe `yes`, ffmpeg seems to steal a
    # character from stdin. I have no idea why.
    yes | ffmpeg -loglevel quiet -i "./$outname.mkv" \
      -ss "$start_time" -to "$end_time" "./${outname}_out.mkv"
    OLD_IFS="$IFS" 
    IFS="," 
     arr=($label_list)
    for s in ${arr[@]} 
    do

    dirr=$train_or_test"/"$s
    if [ ! -d $dirr  ];then
      mkdir $dirr
      echo $dirr
    else
      echo dir exist

    # dirr=`dirname $tempp`
    
    fi
    mv "${outname}_out.mkv" "$dirr/"
    rm "${outname}.mkv"
    break
    done
    IFS="$OLD_IFS"
    #gzip "./$outname.wav"
  else
    # Give the user a chance to Ctrl+C.
    sleep 1
  fi
}

grep -E '^[^#]' | while read line
do
  fetch_clip $(echo "$line" | sed -E 's/"/+/g;s/ /_/g')
done
