#golang test app with ci/cd using github actions

The objective of this project is to use a [simple golang app](https://github.com/golang/example/tree/master/outyet) and create the smallest possible and secure container using docker and upload the container to a docker registry( docker hub in this case) on every push.

The automation on each push is done via github actions using workflows with [this config file](https://github.com/ahsang/golang-cicd/blob/main/.github/workflows/push.yml)

The public accessible image can be downloaded via

```
 docker pull ahsangondal/golang-cicd:main
``` 