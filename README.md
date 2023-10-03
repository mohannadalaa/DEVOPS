docker file => generate an image which is excutable file => excute it to create container that contains out app

example of basic node app docker file
FROM node:alpine => the base image that contains node image to be able to run node js and nom on our container

WORKDIR /usr/src/app => out unique working directory where our files will go to inside the container

copy .. => copy all the files from the path in the docker file to the workdir

RUN npm install => to install out dependencies on the container and generate nodemodules folder and package.loc.json file

EXPOSE 3000 => to expose the port 3000 that our app uses

CMD ["npm","run","start"] => to run our app inside the container

-----------------------------------

to build the image using docker cli:
docker build -t <imagename> .
-t => tagging the image with a name
. => specify the directory where the docker file lives

docker build -t mynodeappimage .

docker images => list all our images

then we need to run the image
docker run --name <container name> <image name>
ex => docker run --name mynodeappcontainer mynodeappimage

docker ps => to see running images or i can check docker desktop app

then we need a port mapping to be able to pull the container app port into our local machine port:
docker run --name <containername> -p <exposedport>:<containerapp port>  <imagename>

docker run --name mynodeappcontainer -p 8060:3000  mynodeappimage

-----------------------------------------------------
to make changes in the app reflect to the image i need to rebuild the app using docker build
rebuild the image
stop then delete all the running container
run the image

docker stop/kill <containername> => to stop the container
stop => stops the container gradually to make a safe stop
kill => directly kills it

docker rm <containername> => to remove container
docker rm <imagename> => to remove image
------------------------------------------------------
Volumes:
to sync between the working directory and our local machine we use bind mounts volums -v
docker run --name mynodeappcontainer -p 8060:3000 -v $(C:\Users\mohannad.alaa\Desktop\Dockerstudy\nodeapp)/src:/use/src/app  mynodeappimage

----------------------------------------------------------
to leave some files as it is in the container we can use anonymous volume like if we need to maintain  node modules folder
docker run -p 8060:3000 -v /use/src/app/node_modules nodeappimage
-----------------------------------------------------------
if we have multiple docker files we can use -f to choose
docker build -t nodeapp -f dockerfile.dev

---------------------------------------------------------
every docker command is considered a layer and docker caches the result in memory for each layer and it's smart enough to detect if changes exists to not use cached

but if the change affect a layer in the steps it does not use the cache of the subsequent layers and excute them from scratch

so for example in these docker layers if i made a change in the code itself it will not the used cache starting from copy . . command
FROM node:alpine
WORKDIR /usr/src/app
copy . .
RUN npm install
EXPOSE 3000
CMD ["npm","run","start"]

but in this case i dont need to rerun npm install so as an enhancement i can move the step of npm install and copy the package.json before copy . .
FROM node:alpine
WORKDIR /usr/src/app
COPY ./package.json .
RUN npm install
copy . .
EXPOSE 3000
CMD ["npm","run","start"]

--------------------------------------
regex can be used in the docker file ex: COPY go.*
----------------------------------------
if i need the docker run command not consume my terminal we can add -d stands for detach in the command before the image name
------------------------------------------
docker images => to display current images
------------------------------------------
lets say i have an app using mongo db so the normal flow to have a mongo db container is to :
make a docker file > build it to get an image > run the image to get the mongo DB container

Another approache that we can run "docker run mongo" so it will look in our local images for a mongo image but it will not find it so it will go automatically to docker hub and pull that image and build and run it
-------------------------------------------
i can avoid the step of deleting the container after stopping it with adding --rm when running the container to delete it when we stop or kill it => docker run --rm imagename
---------------------------------------------
Use case: i have a backend node js app running on a container and it needs to connect to mongo db container

First approache:
i can expose a port from the mongo db container and connect to it from the node js container on our local machine
lets say we are exposing mongo db image on 27017 and we will have a collection called todos
mongo url in this case: "mongodb://host.docker.internal:27017/todos"
host.docker.internal => this is used to let the docker container know that we need to access the local machine which the container is used on
but this is not a good approache as this will not work when deploy the 2 containers 
----------
Second approache:
using IP address of the mongo DB container
to get the IP address of already running container
docker container inspect <containername>
then we look for the ip address, so the mongo db connection string will be something like this:
mongodb://172.17.0.2:27017/todos

but also this approache not the best one as i may not be able to get this IP address on prod environment also this may change by time so i will need to update all the apps using it
----------
Third approache: using docker networks "best one"
by placing the two container on the same network so the mongo connection string will be something like this:
mongodb://<containername>:27017/todos
so this will search the container name and replace it with what ever ip in the network

to list the running networks
docker network ls

to create a new network
docker network create <newtwork name>

then we can run both backend and mongo containers inside the newly created network by using --newtwork <networkname> in the docker run command
docker run --rm --name containername --newtwork networkname imagename

------------------------------------------------
Docker compose:
docker compose up => to put all the instructions needed to run out app in specific order to avoid to do it manually every time

on the directory of docker compose file
docker-compose up => to run the file
docker-compose down => to undo the changes
