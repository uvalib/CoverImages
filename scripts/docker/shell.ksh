if [ -z "$DOCKER_HOST" ]; then
   echo "ERROR: no DOCKER_HOST defined"
   exit 1
fi

# set the definitions
INSTANCE=coverimages
NAMESPACE=uvadave

docker run -t -i -p 8140:3000 $NAMESPACE/$INSTANCE /bin/bash -l
