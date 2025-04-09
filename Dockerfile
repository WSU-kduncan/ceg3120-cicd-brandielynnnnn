FROM node:18-bullseye 

WORKDIR /usr/src/app

COPY angular-site/wsu-hw-ng-main/ /usr/src/app

RUN npm install -g @angular/cli

RUN npm install 

EXPOSE 3000

CMD ["ng", "serve", "--host", "0.0.0.0", "--port", "3000"]
