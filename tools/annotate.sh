#!/usr/bin/env sh

scriptpath=$(readlink -e "$0") || scriptpath=$0
scriptdir=$(dirname "$scriptpath")
nerlibdir="${scriptdir}/../lib/corenlp-ner"
javaclasspath="${nerlibdir}/*:${nerlibdir}/lib/*"

input_file=${1:?'Must specify text file'}
classifiers=${2:-${nerlibdir}/classifiers/english.all.3class.distsim.crf.ser.gz}
output_format=${3:-"inlineXML"} # slashTags | xml | inlineXML | tsv | tabbedEntities
java_max_memory=${4:-2g}

output_directory="${scriptdir}/../ner"
input_file_basename=$(basename "${input_file}" | cut -d. -f1)
output_file="${output_directory}/${input_file_basename}.ner"

echo "\n >>> Annotating ${input_file} using edu.stanford.nlp.ie.crf.CRFClassifier\n"

java -mx${java_max_memory} -cp ${javaclasspath} edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier ${classifiers} -outputFormat ${output_format} -textFile ${input_file} > ${output_file}
