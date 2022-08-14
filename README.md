# gap-docker-slim
This is a docker environment for GAP system, which is
different from the [official one](https://hub.docker.com/r/gapsystem/gap-docker) in the following sense:
1. The docker image is created from mulit-stage build to minimize its size.
2. The docker image does not contain some extra softwares
required by some GAP packages, which include
   * cxsc
   * fplll
   * singular
   * 4ti2
   * pari
   * Macaulay2

## Quickstart
### `docker-compose`
Take this approach when using GAP system in Jupyter notebook.
In such a case, one needs to download the repo, and then run the container via `docker-compose`:
```console
$ git clone https://github.com/psistwu/gap-docker-slim.git
$ cd gap-docker-slim
$ docker-compose up
```
After the container is up, copy and paste the URL of Jupyter notebook shown in the console to your browser.  For example,
```console
http://127.0.0.1:8888/?token=cafdfc89d863dad4cd3696bf62b43bed69fe7df85bee9fe8
```
> If the container runs on a remote system, simply replace `127.0.0.1` by the ip address of the remote system.

### `docker run`
Alternatively, take this approach when using GAP system in console.  In such a case, simply run the following command:
```console
$ docker run -it --rm psistwu/gap-docker:4.11.1-slim gap
```
> Check the [repo on Docker Hub](https://hub.docker.com/r/psistwu/gap-docker) for available tags.