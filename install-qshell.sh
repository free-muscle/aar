wget -O /tmp/qshell.zip https://dn-devtools.qbox.me/2.1.5/qshell-linux-x64?ref=developer.qiniu.com
md5sum /tmp/qshell.zip
unzip /tmp/qshell.zip -d ./qiniu || exit 2
mv ./qiniu/qshell_linux_amd64 ./qiniu/qshell
