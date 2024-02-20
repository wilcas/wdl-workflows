version 1.0
## This WDL downloads SRA files from the NIH using sratools prefetch
## and converts them into paired fastq files using fasterq-dump
##
## Requirements/expectations :
## - sralite file
##
## Outputs :
## - Gzipped Fastq file for forward (_1) read
## - Gzipped Fastq file for reverse (_2) read

## For program versions, see docker containers. 
##
## LICENSING : 
## This script is released under the WDL source code license (BSD-3) (see LICENSE in 
## https://github.com/broadinstitute/wdl). Note however that the programs it calls may 
## be subject to different licenses. Users are responsible for checking that they are
## authorized to run all programs before running this script. Please see the docker 
## page at https://hub.docker.com/r/broadinstitute/genomes-in-the-cloud/ for detailed
## licensing information pertaining to the included programs.

# WORKFLOW DEFINITION
workflow sraLiteToPairedFastq {
  input {
    String SRRaccession
    File ngcfile
    String sratype = "sralite"
    String sra_docker = "quay.io/broadinstitute/ncbi-tools:latest"
    Int n_threads = 4
    Int size_disk = 50
    String memory = "16 GB"
  }
  call fastqDump {
    input:
      SRRaccession = SRRaccession,
      sratype=sratype,
      ngcfile=ngcfile,
      size_disk = size_disk,
      sra_docker = sra_docker,
      memory = memory,
      n_threads = n_threads
  }

  output {
    File output_fastq1 = fastqDump.fastq1
    File output_fastq2 = fastqDump.fastq2
  }
}
task fastqDump {
  input{
    # Command parameters
    String SRRaccession
    String sratype
    File ngcfile
    # Runtime parameters
    Int n_threads
    String memory
    String sra_docker
    Int size_disk
  } 

    command <<< 
    prefetch -T ~{sratype} ~{SRRaccession} --ngc ~{ngcfile}
    fasterq-dump ~{SRRaccession}
    pigz ~{SRRaccession}_1.fastq
    pigz ~{SRRaccession}_2.fastq
    >>>
  
    output {
      File fastq1 = "${SRRaccession}_1.fastq.gz"
      File fastq2 = "${SRRaccession}_2.fastq.gz"
    }

  runtime {
      docker: sra_docker
      cpu: n_threads
      memory: memory
      disks: "local-disk ${size_disk} SSD"
    }
}

