# Blackvue Downloader Script

## Purpose

Automatically copies the days videos from your dashcam.

I have it scheduled to run every few minutes on my Synology NAS, if it finds my camera, it does the download. Should be equivalent functionality available on QNAP and other NAS systems, or any bash script host.

## Configuration

Set the variables at the top of `blackvue-downloader.sh`:

* `dashcam_host` : Dashcam IP address
* `download_dir` : Path to save videos (videos will be placed in a subdir using `vehicle_name`)
* `vehicle_name` : Friendly name for this camera

## How to use

1. Configure your dashcam to connect to your home wifi

> `BlackVue App` > `Firmware Settings` > `Cloud` > `Turn on, and add your wifi SSID settings`

2. Set up a DHCP reservation for your camera on your router. This ensures that the camera will always have the same IP address.

3. Schedule `blackvue-downloader.sh` to run regularly and when your camera is in wifi range it will start downloading the videos.

4. Optional: Rather than a regular schedule, you may have the ability to run the script when the camera connects to the network. Check your router settings.

## Credits

This blog post for the URLs plus some of the `sed` scripts:

https://gadgetblogist.wordpress.com/2014/10/16/dashcam-hacking/