#!/bin/bash
dashcam_host="localhost:8000"
download_dir="./cars"
vehicle_name="mycar"

if [ ! -d $download_dir ]
then
  mkdir $download_dir
fi

if [ ! -d $download_dir/temp ]
then
  mkdir $download_dir/temp
fi

if [ ! -d $download_dir/$vehicle_name ]
then
  mkdir $download_dir/$vehicle_name
fi

videolist=$(curl -s -f http://$dashcam_host/blackvue_vod.cgi)

list_by_suffix () {
  echo "$videolist" \
| grep "n:/Record" `# video file lines start with this` \
| grep "$1\|$3" `# filter for the correct types of video` \
| sed 's/^n://' | sed 's/,s:1000000//' | sed 's/\r//g' `# this junk is on each line in the file` \
| grep "$1" -C $2 | sed 's/--//' # actually grep for the files we want + context + remove the grep context dividers
}

download_video () {
  echo "Downloading ... http://$dashcam_host$1"
  filename=`echo "$1" | sed 's/\/Record\///'`
  #echo $filename
  if [ -f $download_dir/$vehicle_name/$filename ]
  then
    echo "$filename Already Downloaded..."
  else
#    echo "$1" > $download_dir/temp/$filename
    if (curl "http://$dashcam_host$1" -f -s -o $download_dir/temp/$filename)
    then
      mv $download_dir/temp/$filename $download_dir/$vehicle_name/$filename
    else
      echo "** $filename failed!!!!!"
    fi
  fi
}

download_by_suffix () {
  echo "Downloading $1 files..."
  context_size=$2
  context_type=$3
  if [ -z "$context_size" ]
  then
    context_size=0
    context_type=$1
  fi
  for file in `list_by_suffix "$1" $context_size "$context_type" | tail -n 2000`
  do
    echo "Downloading $file..."
    download_video $file
  done
}

echo "Start download videos from dashcam..."
rm -f $download_dir/temp/*.mp4
rm -f $download_dir/$vehicle_name/*.mp4

# Download the files starting with what is most important to me
# In case the car goes out of range before the ordered list gets to them
# I download Event files (Front and Rear (if available)) first
# Feel free to re-order the list

# Parameters are: <type to download> <number of context (before and after files) to download>

# Example: download all event files...
download_by_suffix "_EF" 
# ...then download the context around the event files...
download_by_suffix "_EF" 1 "_NF"

# ...or download the event + context in one pass.
download_by_suffix "_ER" 1 "_NR"
download_by_suffix "_MF" 1 "_NF"
download_by_suffix "_MR" 1 "_NR"

# ... or download the file, but no context
download_by_suffix "_PF" 0
download_by_suffix "_PR" 0

# all normal files
download_by_suffix "_N" 0 