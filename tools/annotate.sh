#!/usr/bin/env sh

scriptpath=$(readlink -e "$0") || scriptpath=$0
scriptdir=$(dirname "$scriptpath")
nerlibdir="${scriptdir}/../lib/corenlp-ner"
javaclasspath="${nerlibdir}/*:${nerlibdir}/lib/*"

input_file=${1:?'Must specify text file'}

output_directory="${scriptdir}/../ner"
input_file_basename=$(basename "${input_file}" | cut -d. -f1)
output_file=${2:-"${output_directory}/${input_file_basename}.ner"}

classifier=${3:-${nerlibdir}/classifiers/english.all.3class.distsim.crf.ser.gz}
output_format=${4:-"inlineXML"} # slashTags | xml | inlineXML | tsv | tabbedEntities
java_max_memory=${5:-2g}


echo "\n >>> Annotating ${input_file} using edu.stanford.nlp.ie.crf.CRFClassifier\n"

java -mx${java_max_memory} -cp ${javaclasspath} edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier ${classifier} -outputFormat ${output_format} -textFile ${input_file} > ${output_file}
