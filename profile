export PATH=$PATH:/opt/usr/bin
export HISTFILESIZE=10000
export HISTSIZE=2000
PS1='`basename \w`\$ '
export RAMDISK="/mnt/RAMDISK"

# java setup
export JAVA_HOME=/opt/java/jdk
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
export UNZIP="-O gb18030"
export ZIPINFO="-O gb18030"
