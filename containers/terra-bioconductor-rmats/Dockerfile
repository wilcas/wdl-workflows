FROM xinglab/rmats:latest as builder
RUN chmod +x rmats.py

FROM us.gcr.io/broad-dsp-gcr-public/terra-jupyter-r:2.2.4

COPY --from=builder /rmats /usr/local/bin
COPY --from=builder /usr/local/bin/STAR /usr/local/bin
USER root
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        software-properties-common \
    && add-apt-repository -y ppa:deadsnakes \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3.9-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN sed -i '1s/python/python3.9/g' /usr/local/bin/rmats.py
RUN cp /usr/local/bin/rmatspipeline*.so /usr/local/bin/rmatspipeline.so

USER $USER
