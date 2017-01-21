#!/usr/bin/env sh

scriptpath=$(readlink -e "$0") || scriptpath=$0
scriptdir=$(dirname "$scriptpath")

input_file=${1:?'Must specify text file'}
entity_xml_tags=${2:-"PART ID QTY DIM WGT PROP OPER RPOS TOOL"}

output_directory="${scriptdir}/../ner"
input_file_basename=$(basename "${input_file}" | cut -d. -f1)
output_file_basename=${3:-"${output_directory}/${input_file_basename}"}

echo "\n >>> Extracting inlineXML entities from ${input_file}\n"

for entity_xml_tag in ${entity_xml_tags}
do
	cat "${input_file}" | tr -d "\n\r" | grep -Po "<${entity_xml_tag}>\K[^<]*(?=</${entity_xml_tag}>)" > "${output_file_basename}.ner.entities.${entity_xml_tag}"
	cat "${output_file_basename}.ner.entities.${entity_xml_tag}" | awk '!seen[$0]++' > "${output_file_basename}.ner.entities.${entity_xml_tag}.unique"
	cat "${output_file_basename}.ner.entities.${entity_xml_tag}.unique" | sort > "${output_file_basename}.ner.entities.${entity_xml_tag}.unique.sorted"
done
