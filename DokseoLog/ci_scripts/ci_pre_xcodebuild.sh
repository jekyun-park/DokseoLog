#!/bin/sh

#  ci_pre_xcodebuild.sh
#  DokseoLog
#
#  Created by 박제균 on 3/13/24.
#

echo "Stage: PRE-Xcode Build is activated .... "

# for future reference
# https://developer.apple.com/documentation/xcode/environment-variable-reference

#cd ../DokseoLog/
#
#plutil -replace SEARCH_API_KEY -string $SEARCH_API_KEY Info.plist
#plutil -p Info.plist
echo $GOOGLE_SERVICE_INFO > ../DokseoLog/GoogleService-Info.plist
echo $SEARCH_API_KEY > ../DokseoLog/Secrets.xcconfig
echo "Stage: PRE-Xcode Build is DONE .... "

exit 0
