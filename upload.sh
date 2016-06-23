set -e
source ./qiniu.conf
qshell account $access_key $secret_key
for localPath in `find ./dist -name "*[arm|x86].apk" -maxdepth 1`; do
  echo $localPath
  filename=${localPath/.apk/"_"`date "+%Y-%m-%d %H:%M:%S"`".apk"};
  filename=${filename##*/};
  echo $filename
  qshell rput $bucket $filename $localPath true
done
