#!/bin/sh

# This script sets up Adobe AIR with no compiler.

. "${CB_SDK_SCRIPT:-$(dirname "$0")}/common.sh"

# -----------------------------------------------------------------------------
# Create backup.
#
progress_message "Checking for FLEX SDK backup: ${AIR_ACTIVE_BASE_SDK} copy"

if [ ! -d "${AIR_ACTIVE_BASE_SDK} copy" ]; then
    progress_message "Creating backup: '${AIR_ACTIVE_BASE_SDK}' to '${AIR_ACTIVE_BASE_SDK} copy'"

    cp -R "${AIR_ACTIVE_BASE_SDK}" "${AIR_ACTIVE_BASE_SDK} copy" || die "Could not copy ${AIR_ACTIVE_BASE_SDK}"

    progress_message "Backup complete."
else
    progress_message "Found FLEX SDK backup: ${AIR_ACTIVE_BASE_SDK} copy"
fi

# -----------------------------------------------------------------------------
# Download latest AIR SDK with the built in compiler if necessary
#
AIR_SDK_NO_COMP_FILEPATH="${AIR_ACTIVE_BASE_SDK}/${AIR_SDK_NO_COMP_FILENAME}"

progress_message "Checking for AIR SDK: ${AIR_SDK_NO_COMP_FILEPATH}"

if [ ! -f "${AIR_SDK_NO_COMP_FILEPATH}" ]; then
    progress_message "File Not Found: ${AIR_SDK_NO_COMP_FILEPATH}"

    progress_message "Downloading: ${AIR_SDK_NO_COMP_FILEPATH} from ${AIR_SDK_NO_COMP_URL}"

    curl -o "${AIR_SDK_NO_COMP_FILEPATH}" "${AIR_SDK_NO_COMP_URL}"
else
    progress_message "Found AIR SDK: ${AIR_SDK_NO_COMP_FILEPATH}"
fi

# -----------------------------------------------------------------------------
# Unpack and overlay AIR SDK
#
progress_message "Unpacking: ${AIR_SDK_NO_COMP_FILEPATH}"

chdir "${AIR_ACTIVE_BASE_SDK}"
tar jxvf "${AIR_SDK_NO_COMP_FILENAME}" || die "Could not untar package."

progress_message "Finished setting up Adobe AIR SDK."

common_success