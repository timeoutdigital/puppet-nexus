
LINK_OR_DIR=/opt/socialapp
RELEASES=$LINK_OR_DIR/releases
RELEASE=`date +%m%d%Y%H%M%S`
SAPP_PID=`ps -ef|grep social|grep -v grep| awk '{print $2}'`
SERVICE='social'

if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    echo "$SERVICE service running, KILLING"
	killall -v java
else
    echo "$SERVICE is not running"
fi

if [ ! -d "$LINK_OR_DIR" ]; then 
echo NO $LINK_OR_DIR dir - creating....
        mkdir -p "$LINK_OR_DIR"
		mkdir -p "$LINK_OR_DIR"/backup
		mkdir -p "$RELEASES"
 else
echo "Base Dir Already"
    fi

LAST_RELEASE=`ls -x $RELEASES |awk '{print $1}'`
CURRENT=$LINK_OR_DIR/current

if [ -f $LINK_OR_DIR/RUNNING_PID ]
then
   sudo kill -9 `cat RUNNING_PID`
   sudo rm RUNNING_PID
fi

if [ -d "$CURRENT" ]; then 
echo remove sym link
rm -f $CURRENT
fi

if [ ! -d "$RELEASES/$RELEASE" ]; then 
echo create release $RELEASE dir 
mkdir -p $RELEASES/$RELEASE
fi

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

if [ -f "$RELEASES/$RELEASE/socialapp.zip" ]; then 
echo UNZIP $RELEASES/$RELEASE/socialapp.zip
cd $RELEASES/$RELEASE/
unzip $RELEASES/$RELEASE/socialapp.zip
fi

CURRENT_RELEASE=`ls -x $RELEASES/$RELEASE |awk '{print $1}'|awk -F'-' '{print $2}'`

if [ ! -d "$CURRENT" ]; then 
echo create sym link
ln -s $RELEASES/$RELEASE $CURRENT
fi

echo Deployed SocialApp CURRENT_RELEASE
echo CURRENT_RELEASE $RELEASE   
echo LAST_RELEASE $LAST_RELEASE  $CURRENT/socialapp-$CURRENT_RELEASE/start
#sh $CURRENT/socialapp-$CURRENT_RELEASE/start > /dev/null &

