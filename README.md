# Makefile targets
## Deploy a local environment from scratch.
This command will create and start all containers, networks and volumes from scratch.
```
make deploy
```
You can also use the following command:
```
make setup
```
## Destroy local environment.
This command will destroy and erase all containers, networks, images, and anonymous volumes.
```
make destroy
```
## Start services.
This command will start all services specified in docker-compose.yml without recreating containers.
```
make up
```
## Stop services.
This command will stop all services specified in docker-compose.yml without removing containers.
```
make stop
```
## varnishlog command
This command will let you see the varnish log in real time.
```
make varnishlog
```
If you want pass some arguments to varnishlog, you can use the command as follows:
```
Ex1: make varnishlog OPTIONS=-q "ReqUrl ~ '/admin'"
Ex2: make varnishlog OPTIONS="-q" "RespStatus ~ 200"
```
Note that double queotes are required when passing more than one option.

## Rebuild varnish configuration specified in vcl files.
This command will rebuild the varnish configuration specified in vcl files.
```
make varnish-vcl
```
You can also use the following command:
```
make vcl
```