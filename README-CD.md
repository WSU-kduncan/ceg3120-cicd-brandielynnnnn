# Project 5 Continuous Deployment 
## Brandie Ewing

## Project Detailing 

## Semantic Versioning with Tagging 

* Semantic Versioning a build that is done with github workflows is necessary for seperating builds. For this, tag gernerating each build is important that will be in common with each commit pushed to main in the repository.
* To create a tag, ``git tag`` shows tags in git repository. The commands flags are useful for adding a semantic versioning tag  with ``git tag -a v0.5.8``. I decided to use this standard semantic versioning tag for updated on my application with the major minor patch values. 0 indicates a pre-developement version. This is beneficial for the current docker build since coding development is still needed for officially releasing the angular application. The 5 is how many minor features releases and 8 patches implemeneted to fix small bugs or changes. Pushing the tag to repository requires git push command  ``git push origin v0.5.8``. This will be the push to command to develop changes to our application with semantic versioning.
  
* To **set up** this process, updating the **/github/workflow/build.yml** to needed to implement when the semantic version of this tag is pushed. I used a template from [this useful docker tag management documentation](https://github.com/docker/metadata-action?tab=readme-ov-file#semver) that gives a template that indicates a push on tags with the new values added below.

  * The **tags:** value is added to signal a push on branch in our repository with the semantic tag of ``'v*.*.*'``. This trigger the workflow file when a tagged is pushed. 
  * Another thing added is a uses: value of checking out the repository. This is to useful to better reference the actions located in the docker repository where the actions are located. 
  * I inserted the main action for tagging is adding the uses: value **metadata action** in the template.This adds tags pushes for major tagging, major + minor tagging, and latest tagging. The major tag values a major update while minor values feature updates.  I also included a full version based on template and tag managment. The action is located in the ``docker/metadata-action@v5`` repository for handling the metadata. 
  * In the build and push actions with a context: value that with **tags:** and **labels:** values. This defines the tags and labels with the meta action when pushed to the Dockerhub Repository via Github Actions workflow file.

* To **verify** this process, I added the tag above with the commands and pushed it to my repositry. Going to the repository actions, when the build complete, checking Dockerhub verifying 4 tags were pushed based on workflow implementation in my Dockerhub Repository [here](https://hub.docker.com/repository/docker/bewinggs/ewing-ceg3120/general).
  * If used in a different repository, Updating tag versioning based on the progress of the docker build is neccessary while also updating docker image name in workflow file under the **meta docker** steps under **jobs**
  * As of changes in repository, making sure valid dockerfile for github actions to build and valid secret credentials are essentials.
  * To verify the image works I can run it in a container with the image and tag name. 
  * Here is the working [Github Workflow File](https://github.com/WSU-kduncan/ceg3120-cicd-brandielynnnnn/blob/14f523ec40b97cab879e2bcf4461bc6663449016/.github/workflows/build.yml)

## Continous Deployment

* In this Continous Deployment, I am working with my EC2 Instance, Dockerhub and Github by setting up a webhook server listener. To create my EC2 instance, I launched a instance on the EC2 resource in AWS. When launching my instance I set the AMI as Ubuntu with ssh access, in t3.medium and recommended 30gb volume for handling docker images. In launching the instance, in security groups, I clicked all three allow of SSH, HTTP, and HTTPs. After launching the instance, I made 2 other security rules to allow inbound traffic for ports 9000, and 3000. Port 9000 is default in webhooks service as it ... Port 3000 is my angular site port bind in the docker file configuration.
* To set up dockerhub, I used this reference for the commands below
  * ``sudo apt update``
  * ``sudo apt-get install docker.io -y``
  * ``sudo systemctl start docker``
  * To verify if docker was able to build images in a container this command ``sudo docker run hello-world`` which is a default image provided from docker. This command will give verbose details ``docker ps -a``on image run times, status, names, and port binds.
* To pull and run a container on EC2 instance, I pulled my image from my Dockerhub Repo ``docker pull bewinggs/ewing-ceg3120:0.5.8``
* I used run command stated above for testing semantic versioning ``docker run -p 3000:3000 bewinggs/ewing-ceg3120:0.5.8``and could see from the container side the build was running from ``docker ps -a``. From the host side, a host side curl http://100.24.119.122:3000 showed a running angular application. An external connection on Google Chrome of http://100.24.119.122:9000 showed content serving. 
* To manually refresh the container application if a new image is available,
* To automate this process in deployment with Dockerhub, A bash script was templated from [devblog](https://blog.devgenius.io/build-your-first-ci-cd-pipeline-using-docker-github-actions-and-webhooks-while-creating-your-own-da783110e151) that shows the functions of the script. It is made of docker commands, bash will execute during our hooks.json endpoint configuration from Dockerhub. It pulls the latest image from Dockerhub, Stops the running container, Removes the running container. The final step is recreating the container, which will involve a --name flag to reproduce our container name. To test my [Bash Script](https://github.com/WSU-kduncan/ceg3120-cicd-brandielynnnnn/blob/c0b0712cdd8563f92e59933539bd2c6f7fe5e965/deployment/cd.sh) I manually pulled an image from my Dockerhub repository as a start, ran the script, checked ``docker ps -a`` for a new image build.


## WebHooks
* Webhook in the integration is used to ....

* To install webhooks, command ``sudo apt-get install webhook`` installs webhooks to EC2 instance. To verify a successful I used a ``webhooks --version`` and ``which webhooks`` to see if service files were created.
* To utilize webhooks, a hook definition is implemented to serve a payload endpoint configuration. Using dockerhub with webhooks, it will send POST request to a URL in Dockerhub. It is in JSON format. This file will be triggered when our tag is pushed and will signal a bash script when a payload is received. It will also validate that the payload came from Dockerhub with a shared secret. 
* ``curl http://100.24.119.122:9000/hooks/cd?ceg3120blynn=banana`` was put into the **Webhooks** section in Dockerhub Repository with ability to pull history.
* To verify definition file was loaded by webhook, I
* To verify webhooks is receiving payloads,
* Here is [my hooks definition file](https://github.com/WSU-kduncan/ceg3120-cicd-brandielynnnnn/blob/c0b0712cdd8563f92e59933539bd2c6f7fe5e965/deployment/hooks.json)

* For the Payload Sender, as stated, Dockerhub was selected as payload sender because of frequent image and tag handling 
* To enable my selection to send payloads to EC2 webhook listener, I
* webhook -hooks /home/ubuntu/ceg/hooks.json -verbose


## Citations 

* [CD Coyurse Notes](https://github.com/pattonsgirl/CEG3120/blob/ee78618c1fc25096819ed677f2083c4e2397b720/CourseNotes/continuous-deployment.md)
* [Semantic Versioning Documentation](https://semver.org/)
    * This is referenced in deciding version tag versioning for my docker build. 
* [Dockerhub Github Actions Workflow File Template](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/)
    * This is referenced heavily in my workflow file as it give syntax for utilizing new metadata action for dockerhub tag managing.
* [Github Workflow Syntax Meanings](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions)
    * I used this reference is detail syntax usage in documentation to explain critical usage in workflow file.
* [Dev Genius Docker/Webhooks CD](https://blog.devgenius.io/build-your-first-ci-cd-pipeline-using-docker-github-actions-and-webhooks-while-creating-your-own-da783110e151)
* [Web Hooks](https://github.com/adnanh/webhook)
* [Web Hooks Delivery](https://docs.docker.com/docker-hub/repos/manage/webhooks/)
* 
