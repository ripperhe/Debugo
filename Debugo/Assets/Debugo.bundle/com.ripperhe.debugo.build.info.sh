# script version
scriptVersion="1.3"
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
    gitLastCommitMessage="$(git log -1 --format="%s")"
    echo "git last commit message: ${gitLastCommitMessage}"
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

# spm Package.resolved
spmResolvedFileExist=false
spmResolvedFileName="com.ripperhe.debugo.spm.package.resolved"
spmResolvedFileDestinationPath="${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/${spmResolvedFileName}"
if [ -f "${spmResolvedFileDestinationPath}" ]; then
  rm -f "${spmResolvedFileDestinationPath}"
fi

spmResolvedFileSourcePath=""
# 常见位置：workspace / xcodeproj 内的 xcshareddata/swiftpm/Package.resolved
search_roots=()
if [ -n "${SRCROOT}" ]; then
  search_roots+=("${SRCROOT}")
  search_roots+=("$(cd "${SRCROOT}/.." 2>/dev/null && pwd)")
fi
if [ -n "${PROJECT_DIR}" ]; then
  search_roots+=("${PROJECT_DIR}")
  search_roots+=("$(cd "${PROJECT_DIR}/.." 2>/dev/null && pwd)")
fi
search_roots+=("$(pwd)")

unique_roots=()
for root in "${search_roots[@]}"; do
  if [ -z "${root}" ] || [ ! -d "${root}" ]; then
    continue
  fi
  skip=false
  for existing in "${unique_roots[@]+"${unique_roots[@]}"}"; do
    if [ "${existing}" = "${root}" ]; then
      skip=true
      break
    fi
  done
  if [ "${skip}" = false ]; then
    unique_roots+=("${root}")
  fi
done

for root in "${unique_roots[@]}"; do
  candidates=(
    "${root}/Package.resolved"
  )
  # shellcheck disable=SC2231
  for ws in "${root}"/*.xcworkspace; do
    if [ -d "${ws}" ]; then
      candidates+=("${ws}/xcshareddata/swiftpm/Package.resolved")
    fi
  done
  # shellcheck disable=SC2231
  for proj in "${root}"/*.xcodeproj; do
    if [ -d "${proj}" ]; then
      candidates+=("${proj}/project.xcworkspace/xcshareddata/swiftpm/Package.resolved")
    fi
  done
  for candidate in "${candidates[@]}"; do
    if [ -f "${candidate}" ]; then
      spmResolvedFileSourcePath="${candidate}"
      break 2
    fi
  done
done

echo "spm Package.resolved source: ${spmResolvedFileSourcePath}"
echo "spm Package.resolved destination: ${spmResolvedFileDestinationPath}"
if [ -n "${spmResolvedFileSourcePath}" ] && [ -f "${spmResolvedFileSourcePath}" ]; then
  cp "${spmResolvedFileSourcePath}" "${spmResolvedFileDestinationPath}"
  if [ -f "${spmResolvedFileDestinationPath}" ]; then
    spmResolvedFileExist=true
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
  /usr/libexec/PlistBuddy -c "Add :GitLastCommitMessage string ${gitLastCommitMessage}" ${buildInfoPlist}
  /usr/libexec/PlistBuddy -c "Add :GitLastCommitAbbreviatedHash string ${gitLastCommitAbbreviatedHash}" ${buildInfoPlist}
  /usr/libexec/PlistBuddy -c "Add :GitLastCommitUser string ${gitLastCommitUser}" ${buildInfoPlist}
  /usr/libexec/PlistBuddy -c "Add :GitLastCommitTimestamp string ${gitLastCommitTimestamp}" ${buildInfoPlist}
fi
/usr/libexec/PlistBuddy -c "Add :CocoaPodsLockFileExist bool ${cocoaPodsLockFileExist}" ${buildInfoPlist}
/usr/libexec/PlistBuddy -c "Add :CocoaPodsLockFileName string ${cocoaPodsLockFileName}" ${buildInfoPlist}
/usr/libexec/PlistBuddy -c "Add :SPMResolvedFileExist bool ${spmResolvedFileExist}" ${buildInfoPlist}
/usr/libexec/PlistBuddy -c "Add :SPMResolvedFileName string ${spmResolvedFileName}" ${buildInfoPlist}
