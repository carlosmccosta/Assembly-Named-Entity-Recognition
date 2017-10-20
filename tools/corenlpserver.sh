#!/usr/bin/env sh

scriptpath=$(readlink -e "$0") || scriptpath=$0
scriptdir=$(dirname "$scriptpath")
corelibdir="${scriptdir}/../lib/corenlp"
javaclasspath=$(echo ${corelibdir}/* | tr " " ":")

properties_file=${1:-"${scriptdir}/../configs/server.prop"}
java_max_memory=${2:-4g}
server_port=${3:-1337}


echo "\n >>> Starting CoreNLP server using edu.stanford.nlp.pipeline.StanfordCoreNLPServer (webpage available at http://localhost:${server_port}/)\n"

java -mx${java_max_memory} -cp ${javaclasspath} edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port ${server_port} -timeout 15000 -serverProperties "${properties_file}"

