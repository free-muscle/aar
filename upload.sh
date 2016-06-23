set -e
source ./qiniu.conf
qshell $access_key $secret_key
apks = `find ./dist -name "*[arm|x86].apk" -maxdepth 1`
for localName in $apks; do
  filename = ${localName/.apk/`date "+%Y-%m-%d %H:%M:%S"`".apk"};
  qshell rput $bucket $filename $localName true
done