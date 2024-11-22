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
FILENAME=nicFW-Nightly-$DATETIME.bin

# Get the latest, with a bit of magic to make sure it's not a cached version.
curl --insecure -o $FILENAME https://nicsure.co.uk/h3/firmware.bin?_=$(date +%s)

# Do magic to get the nicFW version from the downloaded file
# Thanks Kelvin Hill!
#
OFFSET=$(grep -a -b -o "nicFW" "$FILENAME" | cut -d: -f1)
# Check if the string was found
if [ -z "$OFFSET" ]; then
  echo "Error: String 'nicFW' not found in the file."	
  exit 1
else
  OFFSET=$(( $OFFSET + 5 ))
  echo "Success: nicFW version found at location $OFFSET" 
fi

# Read the string "nicFW" plus the next 20 characters and terminate at null character
NICFWVERSION=$(xxd -p -s "$OFFSET" -l 20 "$FILENAME" | xxd -r -p | tr '\0' '\n' | head -n 1 )
# Clean up the version string and create the filename 
NICFWVERSION=$(echo "$NICFWVERSION" | sed -E -e 's/ +//g' | sed -E -e 's/\./-/' )
NEWFILENAME=$(echo "$FILENAME" | sed -E -e 's/$DATETIME//' )
NEWFILENAME=nicFW_Nightly-$NICFWVERSION.bin
echo "Renaming $FILENAME to $NEWFILENAME"
mv "$FILENAME" "$NEWFILENAME"

# Grab the list of files in the directory matching "nicFW*.bin" and create an array with them.
shopt -s nullglob
set -- nicFW*.bin
if [ "$#" -gt 0 ]; then
	# Run md5sum with the list of files.
  md5sum "$@" 
fi

# Uncomment when testing to remove the downloaded file.
#rm $NEWFILENAME
