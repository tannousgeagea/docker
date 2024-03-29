# others
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\e[34m'
YELLOW='\033[1;33m'
NC='\033[0m' # no color

_user=appuser
_group=appuser
_userid=1000
_groupid=1000
_hostname=detectioncontainer
_network=host
_container_name=deeplearning
image_tag=v3.0
repo=tannousgeagea
image_name=object-detection-pytorch-cuda11.5.2


if [ "$1" == "--build" ] || [ "$1" == "-b" ]; then
    docker build --build-arg user=$_user \
        --build-arg userid=$_userid \
        --build-arg group=$_group \
        --build-arg groupid=$_groupid \
        -t $repo/$image_name:$image_tag .
fi


if [ "$1" == "--run" ] || [ "$1" == "-r" ]; then
    docker run -d -it --gpus all \
        --name $_container_name \
        --hostname $_hostname \
        --network $_network \
        --user $_user \
        --env="DISPLAY" \
        -v /home/tannousgeagea/Documents/object-detection/src:/home/appuser/src \
        -v /home/tannousgeagea/Documents/object-detection/data:/home/appuser/data \
        $repo/$image_name:$image_tag

fi


if [ "$1" == "--terminal" ] || [ "$1" == "-t" ]; then
    container_name=${_container_name}
    echo -e "${GREEN}>>> Entering console in container ${container_name} ...${NC}"
    docker exec -ti ${container_name} /bin/bash -c "/bin/bash"
    exit 0
fi

if [ "$1" == "--start" ]; then
    container_name=${_container_name}
    echo -e "${GREEN}>>> Starting container ${container_name} ...${NC}"
    docker start ${container_name}
    exit 0
fi

if [ "$1" == "--stop" ]; then
    container_name=${_container_name}
    echo -e "${GREEN}>>> Stopping container ${container_name} ...${NC}"
    docker stop ${container_name}
    exit 0
fi

if [ "$1" == "--rm" ]; then
    container_name=${_container_name}
    echo -e "${GREEN}>>> Removing container ${container_name} ...${NC}"
    docker rm -f ${container_name}
    exit 0
fi
