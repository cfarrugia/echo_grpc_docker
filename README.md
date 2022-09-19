# echo_grpc_docker

An echo server with a fake grpc health probe

## Introduction 

In Kubernetes, we sometimes need to create the structure before we deploy the real life images: The idea is that setting up things like ingress, deployments, etc. will be done via Terraform. Usually this is a slower process, and one that may take time to refresh. In case one needs a quick rollback (because of a failed production deployment), this can be slow and dangerous. Therefore, for the actual image roll outs, we opt for using kubectl. 

However, whilst one is developing the actual image, we need a way to be able to create the structure using a fake/dummy image. This is what this package is about: It provides an echo server for both http and grpc health endpoints. This in turn will be useful to keep the same health checks as production ones, but always returning a positive result.

## How it works.

The http echo is simply the image base, and gotten from: https://hub.docker.com/r/ealen/echo-server. This is simply a nodejs echo server, and will reply back with whatever the request was.

The grpc part, is a little more convoluted. Since Kubernetes doesn't support grpc health checks natively, we can use the methodolody in here: https://github.com/grpc-ecosystem/grpc-health-probe. Now, what we're doing here is simple: we're creating a dummy application in C (literally does nothing else than returning an exit code of 0). 

## Usage

You can find the docker image here: https://hub.docker.com/repository/docker/cfarrugia/k8s-echo-server

And use it as follows:  

`docker pull cfarrugia/k8s-echo-server`  
`docker run -p 8888:80 --name my-fake-k8s-service -it cfarrugia/k8s-echo-server`

If you run something like: `http://localhost:8888/healthz/live` you should always get a 200 Status

If you run this command:  
`docker exec my-fake-k8s-service /bin/grpc_health_probe`  
absolutely nothing should happen, and that's ok! It's because the fake health check ran and returned a status code of 0. 

