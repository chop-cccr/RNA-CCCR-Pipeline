process SAMTOOLS_INDEX {
tag { "samtools index ${bam}" }
publishDir "${params.outdir}/star", mode: 'copy', pattern: "*.bai"


input:
tuple val(sid), path(bam)


output:
tuple val(sid), path("${bam}.bai")


conda (params.use_conda ? 'envs/rna.yml' : null)
container params.container


script:
"""
samtools index -@ ${task.cpus} ${bam}
"""
}
