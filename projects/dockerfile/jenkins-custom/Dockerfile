FROM jenkins/jenkins

USER root

RUN apt-get update && apt-get install python3-pip --fix-missing -y && \ 
pip3 install ansible --upgrade

USER jenkins
