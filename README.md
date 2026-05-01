# fastqc

Container image for FastQC built from upstream source.

## Quick Usage

```bash
docker pull docker.io/picotainers/fastqc:latest
docker run --rm docker.io/picotainers/fastqc:latest --help
```

## Usage

```bash
# Run QC on FASTQ files in the current directory
docker run --rm -v "$(pwd):/data" -w /data docker.io/picotainers/fastqc:latest sample_R1.fastq.gz sample_R2.fastq.gz
```

## Building

```bash
docker build -t docker.io/picotainers/fastqc:latest .
```
