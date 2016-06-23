wget -O /tmp/qshell.zip http://devtools.qiniu.com/qshell-v1.8.0.zip
md5sum /tmp/qshell.zip
unzip /tmp/qshell.zip -d ./qiniu || exit 2
mv ./qiniu/qshell_linux_amd64 ./qiniu/qshell
