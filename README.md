used commands

to kill the container "you can use "
docker kill devopsbackendcontainer 

to remove the container
docker rm devopsbackendcontainer

to build the image
docker build -t devopsfrontendimage  .
docker build -t devopsbackendimage .

to run both apps
docker run --name devopsfrontendcontainer -p 3000:3000 -d  devopsfrontendimage
docker run --name devopsbackendcontainer -e ASPNETCORE_ENVIRONMENT=Development -p 14600:80 -p 14700:443 -d devopsbackendimage

-------------------------------------------------------------------------------
General notes:
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
. specify the directory where the docker file lives

docker build -t mynodeappimage .

docker images: list all our images

then we need to run the image
docker run --name <container name> <image name>
docker run --name mynodeappcontainer mynodeappimage

docker ps => to see running images or i can check docker desktop app

then we need a port mapping to be able to pull the container app port into our local machine port:
docker run --name <containername> -p <localport>:<containerapp port>  <imagename>

docker run --name mynodeappcontainer -p 8060:3000  mynodeappimage

-----------------------------------------------------
to make changes in the app reflect to the image i need to rebuild the app using docker build
rebuild the image
stop then delete all the running container
run the image

docker stop/kill <containername> => to stop the container
stop => stops the container gradually to make a safe stop
kill => directly kills it

docker rm <containername> => to remove it
docker rm <imagename> => to remove it
------------------------------------------------------
Volumes:
to sync between the working directory and out local machine we use bind mounts volums -v
docker run --name mynodeappcontainer -p 8060:3000 -v $(C:\Users\mohannad.alaa\Desktop\Dockerstudy\nodeapp):/use/src/app  mynodeappimage

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
