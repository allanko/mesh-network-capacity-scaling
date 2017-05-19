#!/system/xbin/bash -login

while [ -n "$1" ] ; do
   pkgName=$1
   shift 1
   echo -n "Uninstalling $pkgName..."
   pm uninstall $pkgName
done
