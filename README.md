# gap-docker
This is a docker environment for GAP system, which is, comparing to the
[official docker image](https://hub.docker.com/r/gapsystem/gap-docker),
created via mulit-stage build to minimize its size.

The difference between the _regular_ version and the _slim_ version is
that the slim version does not contain certain softwares required by
some GAP packages.  For example,
* cxsc
* fplll
* singular
* 4ti2
* pari
* Macaulay2

## Quickstart
### `docker-compose`
Take this approach when using GAP system in Jupyter notebook.
In such a case, one needs to download the repo, and then run the
container via `docker-compose`:
```console
$ git clone https://github.com/psistwu/gap-docker.git
$ cd gap-docker
$ docker-compose up
```
After the container is up, copy and paste the URL of Jupyter notebook
(shown in the console) to your browser.  For example,
```console
http://127.0.0.1:8888/?token=cafdfc89d863dad4cd3696bf62b43bed69fe7df85bee9fe8
```
If the container runs on a remote system,
replace `127.0.0.1` by the ip address of the remote system.

### `docker run`
Alternatively, take this approach instead when using GAP system in console.
In such a case, run the following command:
```console
$ docker run -it --rm psistwu/gap-docker:[tag] gap
```
Check the [repo on Docker Hub](https://hub.docker.com/r/psistwu/gap-docker)
for available tags.