version 1.0
## This WDL converts fixes paired fastq files to have the same number of reads
##
## Requirements/expectations :
## - Gzipped forward fastq file (_1)
## - Gzipped reverse fastq file (_2)
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
workflow fixPairedFastq {
  input {
    String sample_id
    File fastq1
    File fastq2
    String fastq_docker = "vanallenlab/fastq-pair:latest"
    String ncbi_docker = "quay.io/broadinstitute/ncbi-tools:latest"
    Int n_threads = 4
    Int size_disk = 50
    String memory = "16 GB"
  }
  call fixFastq {
    input:
      sample_id = sample_id,
      fastq1 = fastq1,
      fastq2 = fastq2,
      size_disk = size_disk,
      fastq_docker = fastq_docker,
      memory = memory,
      n_threads = n_threads
  }
  call compress {
    input:
      fastq1 = fixFastq.fastq1_paired,
      fastq2 = fixFastq.fastq2_paired,
      size_disk = size_disk,
      ncbi_docker = ncbi_docker,
      memory = memory,
      n_threads = n_threads

  }

  output {
    File output_fastq1 = compress.fastq1_gz
    File output_fastq2 = compress.fastq2_gz
  }
}
task fixFastq {
  input{
    # Command parameters
    String sample_id
    File fastq1
    File fastq2

    # Runtime parameters
    String fastq_docker = "vanallenlab/fastq-pair:latest"
    Int n_threads = 4
    Int size_disk = 50
    String memory = "16 GB"
  } 

    command <<< 
      gunzip -c ~{fastq1} > "~{sample_id}"_1.fastq
      gunzip -c ~{fastq2} > "~{sample_id}"_2.fastq
      fastq_pair "~{sample_id}"_1.fastq "~{sample_id}"_1.fastq
    >>>
  
    output {
      File fastq1_paired = "~{sample_id}_1.fastq.paired.fq"
      File fastq2_paired = "~{sample_id}_2.fastq.paired.fq"
    }

  runtime {
      docker: fastq_docker
      cpu: n_threads
      memory: memory
      disks: "local-disk ${size_disk} SSD"
    }
}

task compress {
  input{
    # Command parameters
    File fastq1
    File fastq2

    # Runtime parameters
    String ncbi_docker 
    Int n_threads 
    Int size_disk
    String memory
  } 

    command <<< 
      pigz ~{fastq1}
      pigz ~{fastq2}
    >>>
  
    output {
      File fastq1_gz = "~{fastq1}.gz"
      File fastq2_gz = "~{fastq2}.gz"
    }

  runtime {
      docker: ncbi_docker
      cpu: n_threads
      memory: memory
      disks: "local-disk ${size_disk} SSD"
    }
}

