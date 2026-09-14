/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { FASTK_FASTK           } from '../modules/nf-core/fastk/fastk/main'
include { FASTK_HISTEX          } from '../modules/nf-core/fastk/histex/main'
include { GENOMESCOPE2          } from '../modules/nf-core/genomescope2/main'
include { SMUDGEPLOT_HETMERS    } from '../modules/local/smudgeplot/hetmers/main'
include { SMUDGEPLOT_ALL        } from '../modules/local/smudgeplot/all/main'
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
    // MODULE:
    //
    GENOMESCOPE2(
        FASTK_HISTEX.out.hist
    )


    //
    // MODULE: RUN SMUDGEPLOT
    //
    SMUDGEPLOT_HETMERS(
        FASTK_FASTK.out.ktab
    )

    SMUDGEPLOT_ALL(
        SMUDGEPLOT_HETMERS.out.kmer_cov
    )


    //
    // LOGIC: SETUP CHANNEL FOR GENOME_STATISTICS AND MERQURYFK_PLOIDYPLOT
    //
    def fastk_data = FASTK_FASTK.out.hist
        .combine(FASTK_FASTK.out.ktab, by: 0)
        .map { meta, hist, ktab_list ->
            tuple(meta, hist, ktab_list)
        }


    //
    // SUBWORKFLOW: GENOMESTATISTICS RUNS ASMSTATS AND GFSTATS
    //              BUSCO WILL NOT BE USED FOR THIS CONTEXT
    //
    GENOME_STATISTICS(
        ch_assemblies,
        fastk_data.map{ meta, hist, ktab_list ->
            tuple(meta, hist, ktab_list, [], [])
        },
        channel.empty(),
        channel.empty()
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
    gs_stats                    = GENOME_STATISTICS.out.stats
    gs_asmstats                 = GENOME_STATISTICS.out.asmstats
    gs_gfastats                 = GENOME_STATISTICS.out.gfastats
    gs_merqury                  = GENOME_STATISTICS.out.merqury
    gs_merqury_qv               = GENOME_STATISTICS.out.merqury_qv
    gs_merqury_completeness     = GENOME_STATISTICS.out.merqury_completeness
    gs_merqury_phased_stats     = GENOME_STATISTICS.out.merqury_phased_stats
    gs_merqury_images           = GENOME_STATISTICS.out.merqury_images
    fastk_ktabs                 = FASTK_FASTK.out.ktab
    fastk_hist                  = FASTK_FASTK.out.hist
    genomescope_lin_plot        = GENOMESCOPE2.out.linear_plot_png
    genomescope_trans_lin_plot  = GENOMESCOPE2.out.transformed_linear_plot_png
    genomescope_log_plot        = GENOMESCOPE2.out.log_plot_png
    genomescope_trans_log_plot  = GENOMESCOPE2.out.transformed_log_plot_png
    genomescope_model           = GENOMESCOPE2.out.model
    genomescope_summary         = GENOMESCOPE2.out.summary
    genomescope_json_report     = GENOMESCOPE2.out.json_report
    smudgeplot_report           = SMUDGEPLOT_ALL.out.smudge_report
    smudgeplot_png              = SMUDGEPLOT_ALL.out.png
    smudgeplot_centrality_txt   = SMUDGEPLOT_ALL.out.centrality_txt

    versions                    = ch_collated_versions                 // channel: [ path(versions.yml) ]
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
