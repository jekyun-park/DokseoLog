#!/bin/sh

#  ci_pre_xcodebuild.sh
#  DokseoLog
#
#  Created by 박제균 on 3/13/24.
#

echo "Stage: PRE-Xcode Build is activated .... "
echo $GOOGLE_SERVICE_INFO > ../DokseoLog/Support/GoogleService-Info.plist
echo $INFO > ../DokseoLog/Support/Info.plist
echo $SEARCH_API_KEY > ../DokseoLog/Support/Secrets.xcconfig
echo "Stage: PRE-Xcode Build is DONE .... "

exit 0
