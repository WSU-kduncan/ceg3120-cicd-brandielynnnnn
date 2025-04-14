# CI Project 4 
## Brandie Ewing 


The project encases docker. It is a container manager that will create, run , and build a web application name angular-site. This container manager also allows for easy accessibility and disposability with command options. It is installed on the backend of windows wsl and signals instructions from user.

## Docker Configuration Detailing 
* To install docker on wsl2-ubuntu, I added a resource on docker desktop. I downloaded docker desktop from the [dockers installation website](https://docs.docker.com/desktop/features/wsl/) that downloads it on the backend of Windows. Once the installer is downloaded, I signed in to my personal account and accessed Settings->Resource->WSL 2 integration->Apply and Restart. After restarting computer, relaunching docker desktop to signal it to start engine is **required.**
 * I utilize a windows computer, therefore docker desktop dependences needs **wsl2 installation backend**. After installing, the command ``docker --version`` will show version and if docker is signalled as engine on wsl2. 
* To build and configure a container without building an image I used the docker run command
  * The command come with options to configure how the container runs.
  * ``docker run -it --rm -v /home/bewing/ceg3120-cicd-brandielynnnnn/angular-site/wsu-hw-ng-main:/app -w /app -p 3000:3000 node:18-bullseye bash``
  * docker run, when engine is started, runs a new container pulling images and nodes. Without building a image, I utilized 5 options that.
  * the -it option is interactive mode with the container
  * the --rm option removes the container when exited, so it doesn't show in **docker images**. This command list local images with uptimes and exit times.
  * the --v (host folder):(containter folder) option mounts the site content to the container as a map.
  * the --w option lets docker now know that the "working directory" is not in /app.
  * the --p option published the containers ports to the host in randomly selected port 3000 also as a map.
  * node is listed as the image we are utilizing
  * Finally, we signal bash to open a bash shell. 

* **The command above**, manually runs a container in a bash shell. When command successfully runs inside the container we have to server the content to our port **3000** to run the application. For this, command ``npm install`` ``npm install -g @angular/cli`` ``ng serve --host 0.0.0.0 3000`` is run while in container. This installs a library for javascript packages. [This site](https://www.w3schools.com/whatis/whatis_npm.asp) details the benefits and how it reads the package.json found in angular site.

  
  * To have the process automatically loading as a image that can be started and stopped with docker, I utilized a Dockerfile. The dockerfile has from, run, and copy commands that docker uses to run the application. I is a list of **instructions** docker will read to build the image.
  * My personal docker file is here. I heavily referenced Dev.to listed in sources that had the same cli as the agular web applications.
    * The from command has the node18:bullseye
    * workdir sets default content directory.
    * copy , copies the files in the extracted angular site to the default content directory.
    * When read by docker, and container is run, it will install the content dependencies like when it was done manually.
    * To make it personalized, I exposed port 3000, maybe referencing avengers and created the container to serve it as local hosts.
    * After successfullty bulding Dockerfile,**Note: After troubleshooting, Dockerfile naming is case sensitive**, to verify the container is successful, it will signal below. Command ``docker ps -a`` also shows running built images start time and tag name. 
```bash
Build at: 2025-04-09T22:31:34.343Z - Hash: c79711fd8a99397d - Time: 33912ms

* Angular Live Development Server is listening on 0.0.0.0:3000, open your browser on http://localhost:3000/ **


✔ Compiled successfully.
✔ Browser application bundle generation complete.
```

 * In host side the ``http://localhost:3000``, will verify if application is run. 
    
   
  * After Dockerfile is completed, you have to build it with -t docker option ``docker build -t angular-site .``
  * We then run and start the build with ``docker run -p 3000:3000 angular-site`` that maps the container and local host to serve contents.

  * Dockerhub repositories can be created in DockerHub in **My Hub** The first side option list Repositores that can be created to pull and push builds. Create Repository can be pushed to name the repo and set visibility options to public. To access at PAT for CLI authentication for tracking, and collaboration. To create a PAT is found in Account Settings->Personal access Tokens-> Generate. It has personalized options for use.
  * After generating, it will give run and personal access token command. This authenticate Dockerhub via CLI personal credentials with ``docker login -u bewinggs``. After this we can push the container from the command line to Dockerhub with these commands after successfuflly logging in.
  * Here is a link to my project for serving angular site web application with tag references. 
  * [Angular-site Image](https://hub.docker.com/r/bewinggs/ewing-ceg3120/tags)
  * After logging in I used docker tag option to tage the image with useful name and pushed it to ceg-3120 repository with these commands ``docker tag angular-site bewinggs/ewing-ceg3120:angular-site`` ``docker push bewinggs/ewing-ceg3120:angular-site``.


## Github Actions 

* To set up github actions, we have to set a connection to our dockerhub repository. A PAT allows for this connection to the Dockerhub repository. I created a PAT with read, and write permisions. This is for.... For Github actions, a repository secret was added to this repository eith my docke username and docker personal access token. The secrets set

* For CI with Github Actions, a workflow YAML file is implemented. I used a base templent similar to project requirements from this
* The workflow steps are
* If this is used in different repository 

* To **verify it worked** , I

* 
 ## Citations 
    * [Course Notes and Inclass demonstrations on docker installation and docker run command](https://github.com/pattonsgirl/CEG3120/blob/main/CourseNotes/containers.md)
    * [Docker Run TODO ](https://docs.docker.com/reference/cli/docker/container/run/)
       * This showed option description of the run command. I referenced those and examplanary docker run commands like  mounting volumes without building an image.  
    * [DockerFile TODO](https://dev.to/rodrigokamada/creating-and-running-an-angular-application-in-a-docker-container-40mk)
       * I referenced this source heavily as it related similar to the conditions of the angular site but with a different node image. I decided to expose a random port personally, but they used the default port for the local host.
    * [Dockerhub IO](https://docs.docker.com/security/for-developers/access-tokens/#:~:text=You%20can%20create%20a%20personal,you%20find%20any%20suspicious%20activity.)
       * This site was referenced in working with dockerhub, It showed how to create access token and the benefits of it for a dockerhub repository. 
    * [DockerPush IO](https://docs.docker.com/get-started/introduction/build-and-push-first-image/)
       * This dockerhub documentation site was referenced in how to push your first image with repository and image name docker push command.  
 


