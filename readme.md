# Single Cell RNA Sequencing Analysis - Docker Image

## Quick deploy (disposable container)

````sh
docker run --rm -it pranavmishra90/sc-rna-seq-r:v0.0.1a bash
````

## Building

````sh
docker buildx build -f ./docker/Dockerfile -t pranavmishra90/sc-rna-seq-r:v0.0.1a .
````