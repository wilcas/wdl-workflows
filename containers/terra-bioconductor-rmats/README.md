terra-jupyter-bioconductor image
================================

This repo contains the `terra-jupyter-bioconductor` image that is compatible
with notebook service in [Terra]("https://app.terra.bio/") called Leonardo. For example, use
`us.gcr.io/broad-dsp-gcr-public/terra-jupyter-bioconductor:{version}` in terra.

## Image contents

The terra-jupyter-bioconductor image extends the [terra-jupyter-r](../terra-jupyter-r/README.md) by
including the following:

### Bioconductor packages 

* SingleCellExperiment

* Genomic Features

* GenomicAlignments

* ShortRead

* DESeq2

* AnnotationHub

* ExperimentHub

* ensembldb

* scRNAseq

* scran

* Rtsne

**NOTE**: The image is able to install all Bioconductor packages as needed
by the user. Please use `BiocManager::install()` to install additional
packages.

To see the complete contents of this image, please see the
[Dockerfile](./Dockerfile).


# EDITS SPECIFIC TO THIS REPO
* Staged build with RMATS docker image (`xinglab/rmats-turbo:latest`)
* RMATS files and STAR installation are copied over to `/usr/local/bin/`

In theory, the should be compatible with previous versions of the `terra-jupyter-bioconductor` image. 

Updates made in each version were originally listed in the repo from which this was copied, and were re-listed
here in [CHANGELOG.md](./CHANGELOG.md).

