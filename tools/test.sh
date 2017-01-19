#!/usr/bin/env sh

scriptpath=$(readlink -e "$0") || scriptpath=$0
scriptdir=$(dirname "$scriptpath")
nerlibdir="${scriptdir}/../lib/corenlp-ner"
javaclasspath="${nerlibdir}/*:${nerlibdir}/lib/*"

input_file=${1:?'Must specify text file'}

classifier=${2:-${nerlibdir}/classifiers/english.all.3class.distsim.crf.ser.gz}

output_directory="${scriptdir}/../ner"
input_file_basename=$(basename "${input_file}" | cut -d. -f1)
output_file=${3:-"${output_directory}/${input_file_basename}"}

java_max_memory=${4:-2g}


echo "\n >>> Testing ${input_file} using edu.stanford.nlp.ie.crf.CRFClassifier\n"

java -mx${java_max_memory} -cp ${javaclasspath} edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier ${classifier} -outputFormat ${output_format} -testFile ${input_file} > ${output_file}-test-annotations.txt 2> ${output_file}-test-output.txt
