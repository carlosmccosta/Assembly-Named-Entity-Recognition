# Assembly-Named-Entity-Recognition

Named entity recognition from assembly operations text manuals.

This project has associated the following conference paper:

[Evaluation of Stanford NER for Extraction of Assembly Information from Instruction Manuals](https://www.researchgate.net/publication/315719375_Evaluation_of_Stanford_NER_for_Extraction_of_Assembly_Information_from_Instruction_Manuals).


## Setup

### Java 8

The CoreNLP libraries require Java 8.

You can install it from the [Oracle webpage](http://www.oracle.com/technetwork/java/javase/downloads/index.html).


### [Stanford CoreNLP](http://stanfordnlp.github.io/CoreNLP/index.html)

Download and extract the following archives into the [lib/corenlp](lib/corenlp) folder:

- [CoreNLP 3.7.0](http://nlp.stanford.edu/software/stanford-corenlp-full-2016-10-31.zip)
- [CoreNLP english models](http://nlp.stanford.edu/software/stanford-english-corenlp-2016-10-31-models.jar)
- [CoreNLP english kbp models](http://nlp.stanford.edu/software/stanford-english-kbp-corenlp-2016-10-31-models.jar)


### [Stanford NER](http://nlp.stanford.edu/software/CRF-NER.html)

Download and extract the following archive into the [lib/corenlp-ner](lib/corenlp-ner) folder:

- [Stanford-NER](http://nlp.stanford.edu/software/stanford-ner-2016-10-31.zip)

More info:

- [CRF-NER](http://nlp.stanford.edu/software/CRF-NER.html)
- [CRF-NER-FAQ](http://nlp.stanford.edu/software/crf-faq.html)
- [Live demo](http://corenlp.run)



## Procesing pipeline


### Create an annotated dataset

For creating a new dataset, use [tools/tokenize.sh](tools/tokenize.sh) to create a tsv file in the format required by the Stanford CRF-NER.

Then manually annotate the tsv file and split it into train and test set.

Each line in the tsv files should have the following format:

```
<TextToken><TAB><ANNOTATION-CLASS>
```

Examples:

```
gearbox	PART
install	OPER
between	RPOS
hammer	TOOL
```

For multi-token entities simply label each token with the appropriate class and Stanford NER will recognize that it is a multi-token entity and not several entities with the same class.


### Or use the provided annotated dataset

Currently annotated files:

- 5231 annotated tokens with assembly instructions from [Heavy-duty-brushless-alternator-service-manual.pdf](dataset/alternators/A1-Heavy-duty-brushless-alternator-service-manual/Heavy-duty-brushless-alternator-service-manual.pdf) in [Heavy-duty-brushless-alternator-service-manual-train-annotated.tsv](dataset/alternators/A1-Heavy-duty-brushless-alternator-service-manual/Heavy-duty-brushless-alternator-service-manual-train-annotated.tsv) and [Heavy-duty-brushless-alternator-service-manual-test-annotated.tsv](dataset/alternators/A1-Heavy-duty-brushless-alternator-service-manual/Heavy-duty-brushless-alternator-service-manual-test-annotated.tsv)

- 10953 annotated tokens with assembly instructions from [AeroVee-Manual.pdf](dataset/engines/E1-AeroVee-Manual/AeroVee-Manual.pdf) in [AeroVee-Manual-train-annotated.tsv](dataset/engines/E1-AeroVee-Manual/AeroVee-Manual-train-annotated.tsv) and [AeroVee-Manual-test-annotated.tsv](dataset/engines/E1-AeroVee-Manual/AeroVee-Manual-test-annotated.tsv)

- 8163 annotated tokens with 10 out of 52 instruction pages from [Mechanical-gearbox-repair-manual.pdf](dataset/gearboxes/G2-Mechanical-gearbox-repair-manual/Mechanical-gearbox-repair-manual.pdf) in [Mechanical-gearbox-repair-manual-train-annotated.tsv](dataset/gearboxes/G2-Mechanical-gearbox-repair-manual/Mechanical-gearbox-repair-manual-train-annotated.tsv) and [Mechanical-gearbox-repair-manual-test-annotated.tsv](dataset/gearboxes/G2-Mechanical-gearbox-repair-manual/Mechanical-gearbox-repair-manual-test-annotated.tsv)

It is also provided the merge of the above train and test files in [dataset-A1-E1-G2-train-annotated.tsv](dataset/alternators-engines-gearboxes/dataset-A1-E1-G2-train-annotated.tsv) and [dataset-A1-E1-G2-test-annotated.tsv](dataset/alternators-engines-gearboxes/dataset-A1-E1-G2-test-annotated.tsv) which results in a dataset with 24347 tokens (20370 train tokens and 3977 test tokens).

The description of the annotated classes is in [dataset/classes.tsv](dataset/classes.tsv)


### Create a fine tuned model for the annotated dataset

After having a dataset, use [tools/train.sh](tools/train.sh) to generate the CRF model and [tools/test.sh](tools/test.sh) to compute the precision, recall and F1 metrics (allows to fine tune the features and processing pipeline to the text that were are expecting to annotate).


### Annotate text and extract entities

Finally, new text can be annotated with inline xml tags using [tools/annotate.sh](tools/annotate.sh) and its entities can be extracted to separate files containing the unique and sorted entities using [tools/extract-entities.sh](tools/extract-entities.sh).

For a Java GUI, you can run the ner-gui.sh script that comes with the [Stanford-NER](http://nlp.stanford.edu/software/stanford-ner-2016-10-31.zip) zip file, then:

- Load the classifier (Classifier -> Load CRF from file)
- Paste some sentences into the text box
- Click Run NER


For a web interface / server you can start the [CoreNLPServer](http://stanfordnlp.github.io/CoreNLP/corenlp-server.html) using [tools/corenlpserver.sh](tools/corenlpserver.sh) and then open [http://localhost:1337/](http://localhost:1337/) for accessing the GUI (for setting the [ner.model property](http://stanfordnlp.github.io/CoreNLP/ner.html) you need to compile CoreNLP, since the [support for setting a custom server properties file](https://github.com/stanfordnlp/CoreNLP/commit/2e4c4dc48ab8a34f6696757a5351a48412f66d61) was only added after the last release (3.7.0)).


### Notes

You can use [tools/processing-pipeline.sh](tools/processing-pipeline.sh) to automatically:

- Create a model from an annotated tsv file using [tools/train.sh](tools/train.sh)
- Test the model with an annotated tsv file using [tools/test.sh](tools/test.sh)
- Annotate a given txt file using [tools/annotate.sh](tools/annotate.sh)
- Extract its entities using [tools/extract-entities.sh](tools/extract-entities.sh)


The scripts in the [tools](tools) folder will save their output files into the [ner](ner) folder.


## Related git repositories:

* [Assembly-Named-Entity-Recognition-Article](https://github.com/carlosmccosta/Assembly-Named-Entity-Recognition-Article)
* [Assembly-Named-Entity-Recognition-Dataset](https://github.com/carlosmccosta/Assembly-Named-Entity-Recognition-Dataset)
