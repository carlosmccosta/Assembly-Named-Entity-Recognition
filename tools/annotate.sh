#!/usr/bin/env sh

scriptpath=$(readlink -e "$0") || scriptpath=$0
scriptdir=$(dirname "$scriptpath")
nerlibdir="${scriptdir}/../lib/corenlp-ner"
javaclasspath="${nerlibdir}/*:${nerlibdir}/lib/*"

input_file=${1:-"${scriptdir}/../dataset/alternators-engines-gearboxes/dataset-A1-E1-G2-test.txt"}
classifier=${2:-"${scriptdir}/../ner/dataset-A1-E1-G2-train-annotated-ner-model.ser.gz"}

java_max_memory=${3:-2g}

output_format=${4:-"inlineXML"} # slashTags | xml | inlineXML | tsv | tabbedEntities

output_directory="${scriptdir}/../ner"
input_file_basename=$(basename "${input_file}" | cut -d. -f1)
output_file_basename=${5:-"${output_directory}/${input_file_basename}"}


echo "\n >>> Annotating ${input_file} using edu.stanford.nlp.ie.crf.CRFClassifier\n"

java -mx${java_max_memory} -cp ${javaclasspath} edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier "${classifier}" -outputFormat ${output_format} -textFile "${input_file}" > "${output_file_basename}.ner"
