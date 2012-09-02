 /opt/nexus-script/download-artifact-from-nexus.sh  \
-a socialapp:socialapp:LATEST \
-e jar \
-c dist \
-o /opt/socialapp/socialapp-0.1.108-dist.zip \
-r releases \
-n <%= url %> \
-u <%= username %> -p '<%= password %>'
