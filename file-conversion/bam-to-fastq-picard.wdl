## Copyright Broad Institute, 2018
## 
## This WDL converts BAM  to unmapped BAMs
##
## Requirements/expectations :
## - BAM file
##
## Outputs :
## - Sorted Unmapped BAM
## - File listing location fo BAMs
##
## Cromwell version support
## - Successfully tested on v47
## - Does not work on versions < v23 due to output syntax
##
## Runtime parameters are optimized for Broad's Google Cloud Platform implementation. 
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
workflow BamToFastq {
  input {
    File input_bam

    Int additional_disk_size = 20
    String gatk_docker = "broadinstitute/gatk:latest"
    String gatk_path = "/gatk/gatk"
  }
    Float input_size = size(input_bam, "GB")
    
  call SamToFastq {
    input:
      input_bam = input_bam,
      disk_size = ceil(input_size * 3) + additional_disk_size,
      docker = gatk_docker,
      gatk_path = gatk_path
  }
	call WriteReadGroup { 
		input:
		# @TODO To be completed	
	
	}

  output {
    File output_fastq1 = SamToFastq.fastq1
		File output_fastq2 = SamToFastq.fastq2
		File readgroup_file = WriteReadGroup.readgroup_file
  }
}

task SamToFastq {
  input {
    #Command parameters
    File input_bam
	  String bam_basename
    String gatk_path

    #Runtime parameters
    Int disk_size
    String docker
    Int machine_mem_gb = 2
    Int preemptible_attempts = 3
  }
    Int command_mem_gb = machine_mem_gb - 1    ####Needs to occur after machine_mem_gb is set 

  command { 
 
    ~{gatk_path} --java-options "-Xmx~{command_mem_gb}g" \
    SamToFastq \
    I=~{input_bam} \
		F=~{bam_basename}_1.fastq \
		F2=~{bam_basename}_2.fastq
  }
  runtime {
    docker: docker
    disks: "local-disk " + disk_size + " HDD"
    memory: machine_mem_gb + " GB"
    preemptible: preemptible_attempts
  }
  output {
    File fastq1 = "~{fastq1}"
    File fastq2 = "~{fastq2}"
  }
}

