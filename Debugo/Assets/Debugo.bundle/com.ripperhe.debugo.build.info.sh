# script version
scriptVersion="1.2"
echo "script version ${scriptVersion}"
# update time
plistUpdateTimestamp="$(date +%s)"
echo "plist update timestamp: ${plistUpdateTimestamp}"
# build configuration
buildConfiguration="${CONFIGURATION}"
echo "build configuration: ${CONFIGURATION}"
# computer info
computerUser="$(whoami)"
echo "computer user: ${computerUser}"
computerUUID="$(system_profiler SPHardwareDataType | awk '/UUID/{print $3;}')"
echo "computer UUID: $(computerUUID)"
# git info
gitEnable=false
if command -v git >/dev/null 2>&1 ; then
  # git installed
  echo "git installed"
  branch=$(git branch)
  if [ -n "$branch" ]; then
    echo "git branch exits"
    gitEnable=true

    gitBranch="$(git symbolic-ref --short -q HEAD)"
    echo "git branch: ${gitBranch}"
    gitLastCommitAbbreviatedHash="$(git log -1 --format="%h")"
    echo "git last commit abbreviated hash: ${gitLastCommitSha}"
    gitLastCommitUser="$(git log -1 --format="%an")"
    echo "git last commit user: ${gitLastCommitUser}"
    gitLastCommitTimestamp="$(git log -1 --format="%ct")"
    echo "git last commit timestamp: ${gitLastCommitTimestamp}"
  else
    echo "Error: git branch not exist."
  fi
else
  # git uninstalled
  echo "Error: git is not installed."
fi
# cocoapods info
cocoaPodsLockFileExist=false
cocoaPodsLockFileName="com.ripperhe.debugo.cocoapods.podfile.lock"
cocoaPodsLockFileSourcePath="$(pwd)/Podfile.lock"
cocoaPodsLockFileDestinationPath="${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/${cocoaPodsLockFileName}"
echo ${BUILT_PRODUCTS_DIR}
echo ${cocoaPodsLockFileSourcePath}
echo ${cocoaPodsLockFileDestinationPath}
if [ -f ${cocoaPodsLockFileDestinationPath} ]; then
  rm -f ${cocoaPodsLockFileDestinationPath}
fi
if [ -f ${cocoaPodsLockFileSourcePath} ]; then
  cp ${cocoaPodsLockFileSourcePath} ${cocoaPodsLockFileDestinationPath}
  if [ -f ${cocoaPodsLockFileDestinationPath} ]; then
    cocoaPodsLockFileExist=true
  fi
fi

# plist file
buildInfoPlist="${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/com.ripperhe.debugo.build.info.plist"
echo "${buildInfoPlist}"

# delete old file
if [ -f ${buildInfoPlist} ]; then
  rm -f ${buildInfoPlist}
fi

# instert value
/usr/libexec/PlistBuddy -c "Add :ScriptVersion string ${scriptVersion}" ${buildInfoPlist}
/usr/libexec/PlistBuddy -c "Add :PlistUpdateTimestamp string ${plistUpdateTimestamp}" ${buildInfoPlist}
/usr/libexec/PlistBuddy -c "Add :BuildConfiguration string ${buildConfiguration}" ${buildInfoPlist}
/usr/libexec/PlistBuddy -c "Add :ComputerUser string ${computerUser}" ${buildInfoPlist}
/usr/libexec/PlistBuddy -c "Add :ComputerUUID string ${computerUUID}" ${buildInfoPlist}
/usr/libexec/PlistBuddy -c "Add :GitEnable bool ${gitEnable}" ${buildInfoPlist}
if [ "${gitEnable}"=true ]; then
  /usr/libexec/PlistBuddy -c "Add :GitBranch string ${gitBranch}" ${buildInfoPlist}
  /usr/libexec/PlistBuddy -c "Add :GitLastCommitAbbreviatedHash string ${gitLastCommitAbbreviatedHash}" ${buildInfoPlist}
  /usr/libexec/PlistBuddy -c "Add :GitLastCommitUser string ${gitLastCommitUser}" ${buildInfoPlist}
  /usr/libexec/PlistBuddy -c "Add :GitLastCommitTimestamp string ${gitLastCommitTimestamp}" ${buildInfoPlist}
fi
/usr/libexec/PlistBuddy -c "Add :CocoaPodsLockFileExist bool ${cocoaPodsLockFileExist}" ${buildInfoPlist}
/usr/libexec/PlistBuddy -c "Add :CocoaPodsLockFileName string ${cocoaPodsLockFileName}" ${buildInfoPlist}
