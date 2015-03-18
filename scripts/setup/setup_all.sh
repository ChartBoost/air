#!/bin/sh

# This script sets up Adobe AIR environment.

. "${CB_SDK_SCRIPT:-$(dirname "$0")}/common.sh"

# -----------------------------------------------------------------------------
# Call out to setup Adobe AIR.
#
. "${CB_SDK_SETUP_SCRIPT}/setup_air.sh"

common_success