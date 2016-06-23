set -e
source ./qiniu.conf
qshell account $access_key $secret_key
apks = `find ./dist -name "*[arm|x86].apk" -maxdepth 1`
for localName in $apks; do
  echo $localName
  filename = ${localName/.apk/`date "+%Y-%m-%d %H:%M:%S"`".apk"};
  echo $filename
  qshell rput $bucket $filename $localName true
done
