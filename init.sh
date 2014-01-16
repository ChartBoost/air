
# don’t worry about running this, the other scripts do automatically

# get config data
eval `sed '/^ *#/d;s/:/ /;' < "build/build.config" | while read key val
do
    str="$key='$val'"
    echo "$str"
done`

# make sure air sdk is extracted
if [ ! -f "air/sdk/bin/compc" ]; then
  mkdir -p air
  cd air
  if [ ! -f airsdk.tbz2 ]; then
    echo "DOWNLOADING AIR SDK..."
    curl -o airsdk.tbz2 http://airdownload.adobe.com/air/mac/download/latest/AIRSDK_Compiler.tbz2
    echo "DOWNLOADING AIR SDK... COMPLETE!"
  fi
  mkdir -p sdk
  cd sdk
  echo "UNPACKING AIR SDK..."
  tar -xjf ../airsdk.tbz2
  echo "UNPACKING AIR SDK... COMPLETE!"
  cd ../..
fi
air_sdk=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)/"air/sdk"
