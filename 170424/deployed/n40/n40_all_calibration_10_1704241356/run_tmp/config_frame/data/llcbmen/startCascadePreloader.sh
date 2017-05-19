#!/system/xbin/bash -login

usage () {
cat <<EOF
$0 <content_dir>

Start the Cascasr content preloader

EOF
}

content_dir=$1
shift

if [ -z "$content_dir" ]; then
   echo "No content directory given"
   exit -1
fi

PACKAGE=cbmen.comet.workflow.cascade
CLASS=com.bbn.cascade.preloader.Preloader
COMPONENT=$PACKAGE/$CLASS
am startService -n $COMPONENT -es $COMPONENT.directory $content_dir

# FIXME think about error checking
exit 0
