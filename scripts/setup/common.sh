#!/bin/sh

. "${CB_SDK_SCRIPT:-$(dirname "$0")}/../common.sh"

# Set up paths for setup scripts
if [ -z "${CB_SDK_SETUP_SCRIPT}" ]; then
    CB_SDK_SETUP_SCRIPT="${CB_SDK_SCRIPT}/setup"

    # The name of the tar file containing the AIR SDK with compiler
    AIR_SDK_COMP_FILENAME="air_sdk_comp.tbz2"

    # The URL of the tar file containing the AIR SDK with compiler
    AIR_SDK_COMP_URL="http://airdownload.adobe.com/air/mac/download/latest/AIRSDK_Compiler.tbz2"
    
    # The name of the tar file containing the AIR SDK without the compiler
    AIR_SDK_NO_COMP_FILENAME="air_sdk_no_comp.tbz2"

    # The URL of the tar file containing the AIR SDK without the compiler
    AIR_SDK_NO_COMP_URL="http://airdownload.adobe.com/air/mac/download/latest/AdobeAIRSDK.tbz2"
fi