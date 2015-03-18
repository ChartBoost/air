#!/bin/sh

# This script sets up a consistent environment for the other scripts in this directory.
if [ -z "${CB_SDK_SCRIPT}" ]; then
	# The directory containing this script
	# We need to go there and use pwd so these are all absolute paths
	pushd "$(dirname $BASH_SOURCE[0])" >/dev/null
	CB_SDK_SCRIPT=$(pwd)
	popd >/dev/null
	
	# The root directory where the Chartboost extension for Adobe Air is located.
	CB_SDK_ROOT=$(dirname "${CB_SDK_SCRIPT}")

	# The path to the AIR SDK for Android installed in Flash Builder
    AIR_ACTIVE_ECLIPSE_SDK="/Applications/Adobe Flash Builder 4.7/eclipse/plugins/com.adobe.flash.compiler_4.7.0.349722/AIRSDK"
    
    # The path to the AIR SDK for iOS installed in Flash Builder
    AIR_ACTIVE_BASE_SDK="/Applications/Adobe Flash Builder 4.7/sdks/4.6.0"

    CB_AIR_SDK="${AIR_ACTIVE_BASE_SDK}"

    REQUIRED_JAVA_VERSION="1.6"
fi
	
# Set up one-time variables
if [ -z "${CB_SDK_ENV}" ]; then
 	CB_SDK_ENV=env1
	CB_SDK_BUILD_DEPTH=0

 	# Explains where the log is if this is the outermost build or if
  	# we hit a fatal error.
	function show_summary() {
    	test -r "${CB_SDK_BUILD_LOG}" && echo "Build log is at ${CB_SDK_BUILD_LOG}"
  	}

  	# Determines whether this is out the outermost build.
  	function is_outermost_build() {
    	test 1 -eq $CB_SDK_BUILD_DEPTH
  	}

	# Calls show_summary if this is the outermost build.
	# Do not call outside common.sh.
	function pop_common() {
		CB_SDK_BUILD_DEPTH=$(($CB_SDK_BUILD_DEPTH - 1))
		test 0 -eq $CB_SDK_BUILD_DEPTH && show_summary
	}

	# Deletes any previous build log if this is the outermost build.
	# Do not call outside common.sh.
	function push_common() {
		test 0 -eq $CB_SDK_BUILD_DEPTH && \rm -f "${CB_SDK_BUILD_LOG}"
		CB_SDK_BUILD_DEPTH=$(($CB_SDK_BUILD_DEPTH + 1))
	}

	# Echoes a progress message to stderr
	function progress_message() {
		echo "$@" >&2
	}

	# Any script that includes common.sh must call this once if it finishes
	# successfully.
	function common_success() { 
		pop_common
		return 0
	}
	
	# Call this when there is an error.  This does not return.
	function die() {
		echo ""
		echo "FATAL: $*" >&2
		show_summary
		exit 1
	}

	function chdir() {
		cd "$@" || die "Could not change directory to $@"

		progress_message "Moved to $@"
	}
	
	test -n "$XCODESELECT"  || XCODESELECT=$(which xcode-select)
	test -n "$XCTOOL"       || XCTOOL="${CB_SDK_ROOT}/vendor/xctool/xctool.sh"
	test -n "$LIPO"         || LIPO=$(which lipo)
	test -n "$PACKAGEBUILD" || PACKAGEBUILD=$(which pkgbuild)
	test -n "$PRODUCTBUILD" || PRODUCTBUILD=$(which productbuild)
	test -n "$PRODUCTSIGN"  || PRODUCTSIGN=$(which productsign)
	test -n "$ANT"          || ANT=$(which ant)
	test -n "$TAR"          || TAR=$(which tar)
	test -n "$COMPC"		|| COMPC="${CB_AIR_SDK}/bin/compc"
	test -n "$JH"			|| JH="/usr/libexec/java_home"
	test -n "$UNZIP"        || UNZIP=$(which unzip)
	test -n "$ADT"        	|| ADT="${CB_AIR_SDK}/bin/adt"

	# Set Xcode select for IOS 8
	`sudo "${XCODESELECT}" -r`
	#`sudo "${XCODESELECT}" -s "/Applications/Xcode6-Beta5.app/Contents/Developer"`
	progress_message "XCode CLI Tools Set To: `sudo ${XCODESELECT} -p`"

	# XCode from app store
	XCODEBUILD="`"$XCODESELECT" -p`/usr/bin/xcodebuild"
fi

push_common