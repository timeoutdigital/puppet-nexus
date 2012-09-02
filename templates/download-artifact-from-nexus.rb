LINK_OR_DIR=/opt/socialapp
RELEASE=`date +%m%d%Y%H%M%S`
LAST_RELEASE=`ls -x /opt/socialapp|awk '{print $1}'`
killall -v java
CURRENT=$LINK_OR_DIR/current

if [ -f $LINK_OR_DIR/RUNNING_PID ]
then
   sudo kill -9 `cat RUNNING_PID`
   sudo rm RUNNING_PID
fi

rm -f $CURRENT

#rm -f $LINK_OR_DIR/socialapp-LAST_RELEASE $LINK_OR_DIR/socialapp-LATEST-$RELEASE 

if [ -d "$LINK_OR_DIR" ]; then 
        # It's a directory!
        # Directory command goes here.
        mkdir -p "$LINK_OR_DIR"
		mkdir -p "$LINK_OR_DIR"/backup
		mkdir -p "$LINK_OR_DIR"/releases
fi

mkdir -p $LINK_OR_DIR/$RELEASE
cd $LINK_OR_DIR/$RELEASE

/opt/nexus-script/download-artifact-from-nexus.sh  \
-a socialapp:socialapp:LATEST \
-e jar \
-c dist \
-o $LINK_OR_DIR/$RELEASE/socialapp.zip\
-r releases \
-n <%= url %> \
-u <%= username %> -p '<%= password %>'
unzip *.zip

ln -s $LINK_OR_DIR/$RELEASE $CURRENT