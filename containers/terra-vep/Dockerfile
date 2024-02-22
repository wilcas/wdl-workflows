FROM us.gcr.io/broad-dsp-gcr-public/terra-jupyter-python:latest
USER root
RUN apt-get update && apt-get install -y cpanminus \
 	build-essential\
	curl \
	zip \
	git \
	libbz2-dev \
	liblzma-dev \
	zlib1g-dev \
	libssl-dev 
RUN pip3 install hail
RUN cpan install Archive::Zip DBI 
ENV NO_NETWORK_TESTING=True
RUN cpan install LWP::Simple
RUN curl -L -O https://github.com/Ensembl/ensembl-vep/archive/release/111.zip && unzip 111.zip && rm 111.zip
RUN cd ensembl-vep-release-111/; echo "no" | perl INSTALL.pl --NO_HTSLIB

ENV PIP_USER=true
USER $USER
ENTRYPOINT ["/opt/conda/bin/jupyter", "notebook"]
