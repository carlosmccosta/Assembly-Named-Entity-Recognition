#!/usr/bin/env sh

scriptpath=$(readlink -e "$0") || scriptpath=$0
scriptdir=$(dirname "$scriptpath")
nerlibdir="${scriptdir}/../lib/corenlp-ner"
javaclasspath="${nerlibdir}/*:${nerlibdir}/lib/*"

input_file=${1:?'Must specify text file'}

output_directory="${scriptdir}/../ner"
input_file_basename=$(basename "${input_file}" | cut -d. -f1)
output_file=${2:-"${output_directory}/${input_file_basename}"}

create_default_entity=${3:-true}
java_max_memory=${4:-2g}


echo "\n >>> Tokenizing ${input_file} using edu.stanford.nlp.process.PTBTokenizer\n"

java -mx${java_max_memory} -cp ${javaclasspath} edu.stanford.nlp.process.PTBTokenizer "${input_file}" > "${output_file}.tok"

if [ "${create_default_entity}" = true ]; then
	perl -ne 'chomp; print "$_\tO\n"' "${output_file}.tok" > "${output_file}.tsv"
fi
