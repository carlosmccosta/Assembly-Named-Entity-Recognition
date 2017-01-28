#!/usr/bin/env sh

scriptpath=$(readlink -e "$0") || scriptpath=$0
scriptdir=$(dirname "$scriptpath")

train_properties_file=${1:-"${scriptdir}/../configs/crf.prop"}
java_max_memory=${2:-12g}
train_file_tsv=${3:-"${scriptdir}/../dataset/alternators-engines-gearboxes/dataset-A1-E1-G2-train-annotated.tsv"}
test_file_tsv=${4:-"${scriptdir}/../dataset/alternators-engines-gearboxes/dataset-A1-E1-G2-test-annotated.tsv"}
test_file_txt=${5:-"${scriptdir}/../dataset/alternators-engines-gearboxes/dataset-A1-E1-G2-test.txt"}

output_directory="${scriptdir}/../ner"
train_file_tsv_basename=$(basename "${train_file_tsv}" | cut -d. -f1)
train_file_tsv_output_basename="${output_directory}/${train_file_tsv_basename}"
test_file_txt_basename=$(basename "${test_file_txt}" | cut -d. -f1)
test_file_txt_output_basename="${output_directory}/${test_file_txt_basename}"

${scriptdir}/train.sh ${train_file_tsv} ${train_properties_file} ${java_max_memory}
${scriptdir}/test.sh ${test_file_tsv} ${train_file_tsv_output_basename}-ner-model.ser.gz ${java_max_memory}
${scriptdir}/annotate.sh ${test_file_txt} ${train_file_tsv_output_basename}-ner-model.ser.gz ${java_max_memory}
${scriptdir}/extract-entities.sh ${test_file_txt_output_basename}.ner
