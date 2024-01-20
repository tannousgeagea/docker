# docker
Installation of Docker in Ubuntu

## How
Run the following command to install the latest docker version on your ubunto:
```
./install_docker_ubuntu.sh
```

## Build your image
to build your custom image change the configuration parameters like image name, image tag, the packages inside the requirements.txt etc.
```
./docker_setup.sh -b 
```

or 
```
./docker_setup.sh -build 
```

the image might take up to 10 mins to be build

## Run your container
to run your container, change the parameters inside the file and run the following:
```
./docker_setup.sh -r
```

or 
```
./docker_setup.sh --run
```
