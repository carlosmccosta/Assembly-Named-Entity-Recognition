#!/usr/bin/env sh

scriptpath=$(readlink -e "$0") || scriptpath=$0
scriptdir=$(dirname "$scriptpath")
nerlibdir="${scriptdir}/../lib/corenlp-ner"
javaclasspath="${nerlibdir}/*:${nerlibdir}/lib/*"

input_file=${1:-"${scriptdir}/../dataset/alternators-engines-gearboxes/dataset-A1-E1-G2-train-annotated.tsv"}
properties_file=${2:-"${scriptdir}/../configs/crf.prop"}

java_max_memory=${3:-2g}

output_directory="${scriptdir}/../ner"
input_file_basename=$(basename "${input_file}" | cut -d. -f1)
output_file_basename=${4:-"${output_directory}/${input_file_basename}"}


echo "\n >>> Training ${input_file} using edu.stanford.nlp.ie.crf.CRFClassifier\n"

java -mx${java_max_memory} -cp ${javaclasspath} edu.stanford.nlp.ie.crf.CRFClassifier -prop "${properties_file}" -trainFile "${input_file}" -serializeTo "${output_file_basename}-ner-model.ser.gz" > "${output_file_basename}-training-output.txt" 2>&1
