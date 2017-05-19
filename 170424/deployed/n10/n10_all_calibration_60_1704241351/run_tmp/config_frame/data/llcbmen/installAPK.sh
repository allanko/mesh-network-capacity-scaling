#!/system/xbin/bash -login

ret=0

while [ -n "$1" ] && [ -n "$2" ]; do
   pkgName=$1
   apkName=$2
   shift 2
   echo -n "Uninstalling $pkgName..."
   pm uninstall $pkgName
   echo -n "Installing "
   pmOut=`pm install $apkName 2>&1`
   echo $pmOut
   if echo $pmOut | grep -iq "Failure" ; then
       echo
       echo ">>>  Failed to install $apkName"
       echo
       ret=$(expr $ret + 1)
   fi
done

exit $ret
