#!/bin/sh

# This script sets up Adobe AIR.

. "${CB_SDK_SCRIPT:-$(dirname "$0")}/common.sh"

# -----------------------------------------------------------------------------
# Setup Adobe AIR with no compiler
#
. "${CB_SDK_SETUP_SCRIPT}/setup_air_no_compiler.sh"

# -----------------------------------------------------------------------------
# Setup Adobe AIR with compiler
#
. "${CB_SDK_SETUP_SCRIPT}/setup_air_compiler.sh"

# -----------------------------------------------------------------------------
# Setup iOS
#
. "${CB_SDK_SETUP_SCRIPT}/setup_ios.sh"

common_success