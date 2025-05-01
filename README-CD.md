# Project 5 Continuous Deployment 
## Brandie Ewing

## Project Detailing 

This goal of this project is to implement a workflow of Continuoss while designing and developing the angular site application. Github is used for pushing changes and semantic tagging to shared repository while also using workflow file to push and implement changed images to Dockerhub. Dockerhub is out enfpoint deployment where webhooks is enabled to show work payloads for new images and tags for managing url usages. Below is a diagram explaining concepts and usages of this CD implementation. 

 ```mermaid
flowchart LR
    id4{{Developer Pushes Commit to Main Branch}}-->id5{{Developer Pushes Tag to Main Branch}}-->id6[[Github workflow file builds and pushes tagged image to dockerhub with metadata action]]-->id7[[Dockerhub receives semantic tag and latest image build]]-->id8>Webhooks payload is triggered to send payload posts on new images to EC2 server IP]-->id9[(EC2 webhook service listener gets logs from 54.224.95.223:9000 to then execute cd.sh build refresh script when payload is received)]
    

```

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

## Dockerhub Connection to EC2 instance 

* In this Continous Deployment, I am working with my EC2 Instance, Dockerhub , and Github by setting up a webhook server listener. To create my EC2 instance, I launched a instance manually on the EC2 resource in AWS. When launching my instance I set the AMI as Ubuntu with ssh access, in t3.medium and recommended 30gb volume for handling docker images. In launching the instance, in security groups, I clicked all three allow of SSH, HTTP, and HTTPs. After launching the instance, I made 2 other security rules to allow inbound traffic for ports 9000, and 3000. Port 9000 is default in webhooks service as it ... Port 3000 is my angular site port bind in the docker file configuration.
  
* Setting up dockerhub on the EC2 instance required this reference and the commands below 
  * ``sudo apt update``
  * ``sudo apt-get install docker.io -y``
  * ``sudo systemctl start docker``
  *  To verify if docker was able to build images in a container this command ``sudo docker run hello-world`` which is a default image provided from docker. This command will give verbose details ``docker ps -a``on image run times, status, names, and port binds.
* Pulling the dockerhub image consist of using the two commands as it runs the image to make sure it is runable in a container. As stated the docker ps flag lists and shows containers. 
    *  ``docker pull bewinggs/ewing-ceg3120:0.5.8``
    *  ``docker run -p 3000:3000 bewinggs/ewing-ceg3120:0.5.8``
    *  ``docker ps -a``
    * From the host side, a host side curl http://100.24.119.122:3000 showed a running angular application. An external     connection on Google Chrome of http://100.24.119.122:9000 showed content serving. Manually refreshing the container application from dockerhub will involve a docker pull command like above.

* Automating this process in deployment with Dockerhub firstly involves a bash script templated from [devblog](https://blog.devgenius.io/build-your-first-ci-cd-pipeline-using-docker-github-actions-and-webhooks-while-creating-your-own-da783110e151) that shows the functions of the script. It is made of docker commands, bash will execute during our hooks.json trigger endpoint configuration from Dockerhub. It pulls the latest image from Dockerhub with docker pull , Stops any running containe with docker image prune, and removes the running container with docker rm . The final step is recreating the container, which will involve a docker run -p --name flag to reproduce our container name. My docker image runs on port 3000 and will be named eloquent_panini. It will most importantly automate the process of refreshing and pulling the latest tag of development changes from our application. 
  
* Testing my [Bash Script](https://github.com/WSU-kduncan/ceg3120-cicd-brandielynnnnn/blob/c0b0712cdd8563f92e59933539bd2c6f7fe5e965/deployment/cd.sh) , manually pulling an image from my Dockerhub repository as a start, ran the script, checked ``docker ps -a`` for a new image build after dev changes.


## WebHooks
* Webhook in the integration is used to send events happening in Dockerhub and will receive a automated delivery of data  reports to the payload sender. It will also trigger a response from our EC2 instance to refresh the image. 
  
* To install webhooks, command ``sudo apt-get install webhook`` installs webhooks to EC2 instance. To verify a successful I used a ``webhooks --version`` and ``which webhooks`` to see if service files were created.

* To utilize webhooks, a hook definition is implemented to serve a payload endpoint configuration. Using dockerhub with webhooks, it will send POST request to a URL in Dockerhub. It is in JSON format. This file will be triggered when our tag is pushed and will signal a bash script when a payload is received. It will also validate that the payload came from Dockerhub with a shared secret. I used template from in class demonstations to implement a secret in the hooks.json file with a "trigger-rule" value the file will abide by. This is important to verify hosts so that triggering can be managed based on tag changes of the angular-site. '
    * Loading the hook definition file consisted of webhook commands of loading it to the hooks. Our hooks.json tells webhook that url with mappings to ``cd?ceg3120blynn=banana`` will execute the bash script with defined trigger rules for secret constraints. In this commands the --hooks flag tells webhooks what events and urls to listen to for payloads. The events are listed in the hooks.json file. Verbose mode provides detailed loggings.
      * `` webhooks --hooks /home/ubuntu/ceg3120cicdbrandielynnnnnn/deployment/hooks.json --verbose`` This command will also verify the webhook with a loaded message using verbose. 
      * ``curl http:/54.224.95.223:9000/hooks/cd?ceg3120blynn=banana`` was put into the **Webhooks** section in Dockerhub Repository with ability to pull history. This shows our EC2 server IP address binding with port 9000 loaded in hooks with hooks.json parameters and execute commands.
      * Here is [my hooks definition file](https://github.com/WSU-kduncan/ceg3120-cicd-brandielynnnnn/blob/c0b0712cdd8563f92e59933539bd2c6f7fe5e965/deployment/hooks.json)

* For the Payload Sender, as stated, Dockerhub was selected as payload sender because of frequent image and tag pushing it will receive. I decided this because it will acheive the continous deployment process of github being the integration for teh developers to push a dev change while retaining each image and semantic versioning in Dockerhub.
  
* To enable my selection to send payloads as a service on my EC2 webhook listener, I went to [Dockerhub Repository](https://hub.docker.com/repository/docker/bewinggs/ewing-ceg3120/general), Webhooks Option, then inserted my hooks.json trigger url ``http://54.224.95.223:9000/hooks/cd?ceg3120blynn=banana``, I named it payload2 and and loaded it in my Dockerhub Repository. I am able to check call-backs with the **3 dots**, **View History**. This will allow me to get status messages and codes for success updates when an image is pushed to Dockerhub. To trigger a payload an image needs to pushed to Dockerhub which will be done in our integration with Github in command ``git push`` git tag origin v1.0.0``.
  
* As stated, in the history of our payload url in Dockerhub, a success 200 message will show reponses to our server in the EC2 instance. To create is as a service on our EC2 instance a webhooks.service file can be implemented. To do so I firstly enabled, started and checked the status of the webhook.service file with the commands below. It first showed not running due to inadequate hooks.json file. To do so I vimmed into the service file given located in ``sudo vim /usr/lib/systemd/system/webhook.service`` and added a command  with my json file under **ExecStart**: to trigger this service in my EC2 instance.
  * ``sudo systemctl enable webhook.service``
  * ``sudo systemctl start webhook.service``
  * `` sudo systemctl status webhook.service``
  * `` sudo vim /usr/lib/systemd/system/webhook.service``
  * After making the execstart change, the services need to be restarted with commands ``sudo systemctl daemon-reload`` to implement changes on the webhook.service file. Here is my service file for this configuration. After this checking status and logs with command ``sudo journalctl -f -u webhook.service`` shows detailed output of service on EC2 instance loading and servering hooks on **http://0.0.0.0:9000/hooks/{id}**. Here is my [webhooks.service](https://github.com/WSU-kduncan/ceg3120-cicd-brandielynnnnn/blob/a614a790bb768464c1f05421fd24b864bbd75fec/deployment/webhook.service) file loaded on server. 
    


## Citations 
* [CD Course Notes for help links](https://github.com/pattonsgirl/CEG3120/blob/ee78618c1fc25096819ed677f2083c4e2397b720/CourseNotes/continuous-deployment.md)
* In Class Demonstrations(Webex Recordings Last two 4/23 and 4/25 for webhooks.service file)
* [Semantic Versioning Documentation](https://semver.org/)
    * This is referenced in deciding version tag versioning for my docker build. 
* [Dockerhub Github Actions Workflow File Template](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/)
    * This is referenced heavily in my workflow file as it give syntax for utilizing new metadata action for dockerhub tag managing.
* [Github Workflow Syntax Meanings](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions)
    * I used this reference is detail syntax usage in documentation to explain critical usage in workflow file.
* [Dev Genius Docker/Webhooks CD](https://blog.devgenius.io/build-your-first-ci-cd-pipeline-using-docker-github-actions-and-webhooks-while-creating-your-own-da783110e151)
    * I used this heavily in this lab as it gave very sufficient directions and paths on implementing a github, webhook, dockerhub deployment for our angular application. It also gave me install intructions for my ubuntu AMI of docker and webhooks while also supplying bash script template and useful webhooks commands. 
* [Web Hooks](https://github.com/adnanh/webhook)
    * This is documentation for webhooks by adnanh that gave installation details and webhook examples. 
* [Web Hooks Delivery](https://docs.docker.com/docker-hub/repos/manage/webhooks/)
    * This gave good details on using and configuring dockerhub as endpoing delivery for payload mananagemetn and posts. 
  
