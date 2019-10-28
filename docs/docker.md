# Docker notes

Open Container Initiative (OCI) formed to solve competing standards of Docker and CoreOS (appc container standard and rkt "rocket" implementation).
specs: image-spec, runtime-spec
storage driver (sometimes aka graphdriver), Linux supports many: aufs is oldest, overlay2 in best, also devicemapper, btrfs and zfs.

docker commands:
docker system info (see storage driver, etc.)
docker version (test client and server can talk, and if server only works with sudo, need to add user to docker group)
docker image ls
docker image pull ubuntu:latest
docker images


image is a stopped container, think of image as an OS filesystem and an app, like a virtual machine template.

image reference is repo/image:tag
container refence by name or at least first chars of ID

* `docker version`: List Docker Client and Server info, confirming they can
  talk. If server part only works with `sudo`, you need to add you user to the
  `docker` group.
* `docker login`: Log in to a Docker registry.
* `docker system prune`: Delete unused containers, networks, dangling images.
  * `-a, --all`: Delete all unused images, not just dangling ones.
  * `--volumes`: Delete unused volumes.
* `docker container <command>`
  * `create`: Create a container from an image.
    * `-a, --attach STDIN`
  * `start`: Start an existing container.
  * `run`: Create a new container and start it.
    * `-i, --interactive`: Keep stdin open.
    * `-t, --tty`: connect pseudoterminal to container's stdin and stdout
    * `-p, --port 8000:1000`: map Docker port 8000 to host 1000
    * `--rm`: delete container upon stopping
    * `-d, --detach`: Run container in background.
  * `ls`: List running containers.
    * `-a, --all`: not just running ones
    * `-s, --size`: List sizes.
  * `inspect`: See lots of info about a container.
  * `logs`: Print logs.
  * `stop`: Gracefully stop running container.
  * `kill`: Stop main process in container abruptly.
  * `rm`— Delete a stopped container.
* `docker image <command>`
  * `build`: Build an image.
    * `docker image build -t repo/image:tag .`: `-t` use tag `tag`, `.` use
      `Dockerfile` in current directory.
    * `--no-cache=True`
  * `push`: Push an image to a remote registry.
  * `ls`: List images.
  * `history`: See intermediate image info.
  * `inspect`: See lots of info about an image, including the layers.
  * `rm`: Delete an image.
* `docker container kill $(docker ps -q)`: Kill running containers.
* `docker container rm $(docker ps -a -q)`: Delete all containers not running.
* `docker image rm $(docker images -a -q)`: Delete all images.

Dockerfile commands

* `FROM`: Specifies the base image.
* `LABEL`: Provides metadata like maintainer info.
* `ENV`: Sets a persistent environment variable.
* `RUN`: Runs command and creates image layer. Used to install packages.
* `COPY`: Copies files into the container.
* `ADD`: Copies files into the container. Can upack local `.tar` files.
* `CMD`: Command and arguments (that can be overridden) for an executing
  container. There can be only one `CMD`.
* `WORKDIR`: Sets working directory for following instructions.
* `ARG`: Defines variable to pass to Docker at build time.
* `ENTRYPOINT`: Command and arguments (that persist) for an executing container.
* `EXPOSE`: Exposes a port.
* `VOLUME`: Creates a directory mount point to access and store persistent data.



Cheatsheets from https://towardsdatascience.com/slimming-down-your-docker-images-275f0ca9337e

