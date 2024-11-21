#/bin/sh
#
# Download the latest nicFW for the TIDRADIO H3. 
# Get the MD5 checksum on the downloaded file and any other file matching nicFW*.bin
# Manually view/check the MD5 checksum of the files to see if the checksum has changed.
#
# nicFW_Nightly-21-Nov-2024-09-00-AM.bin
# DATETIME=$(date '+%Y-%b-%d-%H-%M-%S')
# DATETIME="${DATETIME^^}"

DATETIME=$(date '+%d-%b-%Y-%I-%M-%p')
FILENAME=nicFW_Nightly-$DATETIME.bin

# Get the latest, with a bit of magic to make sure it's not a cached version.
curl --insecure -o $FILENAME https://nicsure.co.uk/h3/firmware.bin?_=$(date +%s)

# Grab the list of files in the directory matching "nicFW*.bin" and create an array with them.
shopt -s nullglob
set -- nicFW*.bin
if [ "$#" -gt 0 ]; then
  md5sum "$@" # Run md5sum with the list of files.
fi
