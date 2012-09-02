LINK_OR_DIR=/opt/socialapp
RELEASE=`date +%m%d%Y%H%M%S`
LAST_RELEASE=`ls -x /opt/socialapp|awk '{print $1}'`
killall -v java
CURRENT=$LINK_OR_DIR/current
RELEASES=$LINK_OR_DIR"/releases

if [ -f $LINK_OR_DIR/RUNNING_PID ]
then
   sudo kill -9 `cat RUNNING_PID`
   sudo rm RUNNING_PID
fi

rm -f $CURRENT

#rm -f $LINK_OR_DIR/socialapp-LAST_RELEASE $LINK_OR_DIR/socialapp-LATEST-$RELEASE 

if [ ! -d "$LINK_OR_DIR" ]; then 
echo NO $LINK_OR_DIR dir - creating....
        # It's a directory!
        # Directory command goes here.
        mkdir -p "$LINK_OR_DIR"
		mkdir -p "$LINK_OR_DIR"/backup
		mkdir -p "$RELEASES"
fi


mkdir -p $RELEASES/$RELEASE

if [ -d "$RELEASES/$RELEASE" ]; then 
echo DOWNLOAD RELEASE
/opt/nexus-script/download-artifact-from-nexus.sh  \
-a socialapp:socialapp:LATEST \
-e jar \
-c dist \
-o $RELEASES/$RELEASE/socialapp.zip \
-r releases \
-n <%= url %> \
-u <%= username %> -p '<%= password %>'
fi


if [ ! -f "$RELEASES/$RELEASE/socialapp.zip" ]; then 
echo UNZIP $RELEASES/$RELEASE/socialapp.zip
cd $RELEASES/$RELEASE
unzip *.zip
fi


ln -s $RELEASES/$RELEASE $CURRENT

