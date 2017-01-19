#!/usr/bin/env sh

scriptpath=$(readlink -e "$0") || scriptpath=$0
scriptdir=$(dirname "$scriptpath")
nerlibdir="${scriptdir}/../lib/corenlp-ner"
javaclasspath="${nerlibdir}/*:${nerlibdir}/lib/*"

input_file=${1:?'Must specify text file'}
properties_file=${2:-"${scriptdir}/../configs/crf.prop"}

output_directory="${scriptdir}/../ner"
input_file_basename=$(basename "${input_file}" | cut -d. -f1)
output_file=${3:-"${output_directory}/${input_file_basename}"}

java_max_memory=${4:-2g}


echo "\n >>> Training ${input_file} using edu.stanford.nlp.ie.crf.CRFClassifier\n"

java -mx${java_max_memory} -cp ${javaclasspath} edu.stanford.nlp.ie.crf.CRFClassifier -prop "${properties_file}" -trainFile "${input_file}" -serializeTo "${output_file}-ner-model.ser.gz" > "${output_file}-training-output.txt" 2>&1
