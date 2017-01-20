# Tools

Tools and scripts for using the [CoreNLP NER](http://nlp.stanford.edu/software/CRF-NER.html) libraries.

For creating a new dataset, use [tokenize.sh](tokenize.sh) to create a tsv file in the format required by the Stanford CRF-NER. Then manually annotate the tsv file and split it into train and test set.

After having a dataset, use [train.sh](train.sh) to generate the CRF model and [test.sh](test.sh) to evaluate the precision, recall and F1 measures (allows to fine tune the features and processing pipeline).

Finally, new text can be annotated with inline xml tags using [annotate.sh](annotate.sh) and its entities can be extracted to separate files containing the unique and sorted entities using [extract-entities.sh](extract-entities.sh).

For a Java GUI, you can run the ner-gui.sh script that comes with the stanford ner zip, then:

- Load the classifier (Classifier -> Load CRF from file)
- Paste some sentences into the text box
- Click Run NER


For a web interface / server you can start the [CoreNLPServer](http://stanfordnlp.github.io/CoreNLP/corenlp-server.html) using [corenlpserver.sh](corenlpserver.sh) and then open [http://localhost:1337/](http://localhost:1337/) for accessing the GUI (for setting the [ner.model property](http://stanfordnlp.github.io/CoreNLP/ner.html) you need to compile CoreNLP, since the [support for setting a custom server properties file](https://github.com/stanfordnlp/CoreNLP/commit/2e4c4dc48ab8a34f6696757a5351a48412f66d61) was only added after the last release (3.7.0)).
