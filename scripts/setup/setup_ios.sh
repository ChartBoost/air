#!/bin/sh

. "${CB_SDK_SCRIPT:-$(dirname "$0")}/common.sh"

progress_message "Setting up the iOS SDK"

cp -R \
    "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk" \
    "/Applications/Adobe Flash Builder 4.7/sdks/4.6.0/iPhoneOS8.1.sdk" \
    || die "Could not copy iOS SDK"

common_success