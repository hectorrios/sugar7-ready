#!/bin/bash

### USAGE
###
### ./ElasticSearch.sh 1.7 will install Elasticsearch 1.7
### ./ElasticSearch.sh will fail because no version was specified (exit code 1)
###
### CLI options Contributed by @janpieper
### Check http://www.elasticsearch.org/download/ for latest version of ElasticSearch
 
### Install Java 8
apt-get install python-software-properties -y
sleep 1
add-apt-repository ppa:webupd8team/java -y
sleep 1
apt-get update
sleep 1
# Auto-accept oracle license
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
apt-get install oracle-java8-installer -y

### Download and install the Public Signing Key
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -

### Setup Repository
echo "deb http://packages.elastic.co/elasticsearch/1.4/debian stable main" | tee -a /etc/apt/sources.list.d/elk.list

### Install Elasticsearch
apt-get update && apt-get install elasticsearch -y

echo "Setting up Elasticsearch as a service"
update-rc.d elasticsearch defaults 95 10
