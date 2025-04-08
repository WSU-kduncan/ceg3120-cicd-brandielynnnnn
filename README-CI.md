#CI Project 
## Brandie Ewing 


The project encases docker. It is a container manager that will create, run , and build a web application name angular-site. This container manager also allows for easy accessibility and disposability with command options. It is installed on the backend of windows wsl and signals instructions from user.

## Docker Configuration Detailing 
* To install docker on wsl-ubuntu, I added a resource on docker desktop. I downloaded docker desktop from the [dockers installation website](https://docs.docker.com/desktop/features/wsl/) that downloads it on the backend of Windows. Once the installer is downloaded, I signed in to my personal account and accessed Settings->Resource->WSL 2 integration->Apply and Restart.
* To build and configure a container without building an image I used the docker run command
  * The command come with options to configure how the container runs.
 
  * To have the process automating loaded as a image and run, I utilized a Dockerfile. The dockerfile has from, run, and copy commands that docker uses to run the application. I is a list of **instructions** docker will read to build the image. 
  * To build that image I use docker build command
  * To run the container from the image built I
  * To view the browser I accessed the port it exposed
 
  * Sources
    * [Course Notes and Inclass demonstrations on docker installation and docker run command](https://github.com/pattonsgirl/CEG3120/blob/main/CourseNotes/containers.md)
    * [Docker Run How to](https://docs.docker.com/reference/cli/docker/container/run/) 
    * [DockerFile How to](https://dev.to/rodrigokamada/creating-and-running-an-angular-application-in-a-docker-container-40mk)

## DockerHub Details 

* To create a public repo in Dockerhub, I
* To push a container image to dockerhub, I 
* This is my Dockerhub Repository 


