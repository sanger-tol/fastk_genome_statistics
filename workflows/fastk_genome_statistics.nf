/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { FASTK_FASTK           } from '../modules/nf-core/fastk/fastk/main'
include { FASTK_HISTEX          } from '../modules/nf-core/fastk/histex/main'
include { GENOMESCOPE2          } from '../modules/nf-core/genomescope2/main'
include { MERQURYFK_PLOIDYPLOT  } from '../modules/nf-core/merquryfk/ploidyplot/main'
include { GENOME_STATISTICS     } from '../subworkflows/sanger-tol/genome_statistics/main'


include { paramsSummaryMap       } from 'plugin/nf-schema'
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_fastk_genome_statistics_pipeline'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow FASTK_GENOME_STATISTICS {

    take:
    ch_assemblies   // channel: [meta, [assemblies...]]
    ch_reads_list   // channel: [meta, [reads...]]
    outdir          // output directory

    main:

    def ch_versions = channel.empty()


    //
    // MODULE: RUN FASTK FOR KMER COUNTS AND HISTS
    //
    FASTK_FASTK(
        ch_reads_list
    )


    //
    // MODULE: RUN FASTK HISTEX TO CONVERT .hist TO .txt
    //
    FASTK_HISTEX(
        FASTK_FASTK.out.hist
    )


    //
    // SUBWORKFLOW: GENOMESTATISTICS RUNS ASMSTATS AND GFSTATS
    //              BUSCO WILL NOT BE USED FOR THIS CONTEXT
    //

    def fastk_data = FASTK_FASTK.out.hist
        .combine(FASKT_FASTK.out.ktab, by: 0)
        .map { meta, hist, ktab_list ->
            tuple(meta, hist, ktab_list, [], [])
        }

    fastk_data.view{ "FASTK_DATA: $it" }

    GENOMESTATISTICS(
        ch_assemblies,
        fastk_data,
        [[:],[]],
        []
    )


    //
    // MODULE: ALSO KNOWN AS SMUDGEPLOT
    //
    merqury_pp = FASTK_FASTK.out.hist
        .combine(FASKT_FASTK.out.ktab, by: 0)

    ch_merqury_pp.view{"M_PP: $it"}

    MERQURYFK_PLOIDYPLOT(
        ch_merqury_pp
    )


    //
    // Collate and save software versions
    //
    def topic_versions = channel.topic("versions")
        .distinct()
        .branch { entry ->
            versions_file: entry instanceof Path
            versions_tuple: true
        }

    def topic_versions_string = topic_versions.versions_tuple
        .map { process, tool, version ->
            [ process[process.lastIndexOf(':')+1..-1], "  ${tool}: ${version}" ]
        }
        .groupTuple(by:0)
        .map { process, tool_versions ->
            tool_versions.unique().sort()
            "${process}:\n${tool_versions.join('\n')}"
        }

    def ch_collated_versions = softwareVersionsToYAML(ch_versions.mix(topic_versions.versions_file))
        .mix(topic_versions_string)
        .collectFile(
            storeDir: "${outdir}/pipeline_info",
            name:  'fastk_genome_statistics_software_'  + 'versions.yml',
            sort: true,
            newLine: true
        )
    emit:
    versions       = ch_versions                 // channel: [ path(versions.yml) ]
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
