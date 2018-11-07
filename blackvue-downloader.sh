#!/bin/bash
dashcam_host="localhost:8000"
download_dir="./cars"
vehicle_name="mycar"



videolist=$(curl http://$dashcam_host/blackvue_vod.cgi)

list_by_suffix () {
  echo "$videolist" | grep "n:/Record" | sed 's/^n://' | sed 's/,s:1000000//' | sed 's/\r//g' | grep "$1" 
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
    curl "http://$dashcam_host$1" -s -o $download_dir/temp/$filename
    mv $download_dir/temp/$filename $download_dir/$vehicle_name/$filename
  fi
}

download_by_suffix () {
  echo "Downloading $1 files..."
  for file in `list_by_suffix "$1" | tail -n 2000`
  do
    echo "Downloading $file..."
    download_video $file
  done
}

echo "Start download videos from dashcam..."
rm -f $download_dir/temp/*.mp4
download_by_suffix "_EF"
download_by_suffix "_MF"
download_by_suffix "_PF"
download_by_suffix "_NF"
# wget http://10.0.1.132$file -nc
