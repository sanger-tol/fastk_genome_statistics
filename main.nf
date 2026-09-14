#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    sanger-tol/fastk_genome_statistics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/sanger-tol/fastk_genome_statistics
----------------------------------------------------------------------------------------
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS / WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { FASTK_GENOME_STATISTICS   } from './workflows/fastk_genome_statistics'
include { PIPELINE_INITIALISATION   } from './subworkflows/local/utils_nfcore_fastk_genome_statistics_pipeline'
include { PIPELINE_COMPLETION       } from './subworkflows/local/utils_nfcore_fastk_genome_statistics_pipeline'
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOWS FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Run main analysis pipeline depending on type of input
//
workflow SANGERTOL_FASTK_GENOME_STATISTICS {

    take:
    assemblies // channel: assemblies read in from --input
    reads      // channel: reads read in from --reads
    outdir     // channel: output directory

    main:

    //
    // WORKFLOW: Run pipeline
    //
    FASTK_GENOME_STATISTICS (
        assemblies,
        reads,
        outdir,
    )

    emit:
    gs_stats                    = FASTK_GENOME_STATISTICS.out.gs_stats
    gs_asmstats                 = FASTK_GENOME_STATISTICS.out.gs_asmstats
    gs_gfastats                 = FASTK_GENOME_STATISTICS.out.gs_gfastats
    gs_merqury                  = FASTK_GENOME_STATISTICS.out.gs_merqury
    gs_merqury_qv               = FASTK_GENOME_STATISTICS.out.gs_merqury_qv
    gs_merqury_completeness     = FASTK_GENOME_STATISTICS.out.gs_merqury_completeness
    gs_merqury_phased_stats     = FASTK_GENOME_STATISTICS.out.gs_merqury_phased_stats
    gs_merqury_images           = FASTK_GENOME_STATISTICS.out.gs_merqury_images
    fastk_ktabs                 = FASTK_GENOME_STATISTICS.out.fastk_ktabs
    fastk_hist                  = FASTK_GENOME_STATISTICS.out.fastk_hist
    genomescope_lin_plot        = FASTK_GENOME_STATISTICS.out.genomescope_lin_plot
    genomescope_trans_lin_plot  = FASTK_GENOME_STATISTICS.out.genomescope_trans_lin_plot
    genomescope_log_plot        = FASTK_GENOME_STATISTICS.out.genomescope_log_plot
    genomescope_trans_log_plot  = FASTK_GENOME_STATISTICS.out.genomescope_trans_log_plot
    genomescope_model           = FASTK_GENOME_STATISTICS.out.genomescope_model
    genomescope_summary         = FASTK_GENOME_STATISTICS.out.genomescope_summary
    genomescope_json_report     = FASTK_GENOME_STATISTICS.out.genomescope_json_report
    smudgeplot_report           = FASTK_GENOME_STATISTICS.out.smudgeplot_report
    smudgeplot_png              = FASTK_GENOME_STATISTICS.out.smudgeplot_png
    smudgeplot_centrality_txt   = FASTK_GENOME_STATISTICS.out.smudgeplot_centrality_txt
}
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    main:
    //
    // SUBWORKFLOW: Run initialisation tasks
    //
    PIPELINE_INITIALISATION (
        params.version,
        params.validate_params,
        params.monochrome_logs,
        args,
        params.outdir,
        params.input,
        params.help,
        params.help_full,
        params.show_hidden
    )

    //
    // WORKFLOW: Run main workflow
    //
    SANGERTOL_FASTK_GENOME_STATISTICS (
        PIPELINE_INITIALISATION.out.assemblies,
        PIPELINE_INITIALISATION.out.longreads,
        params.outdir
    )
    //
    // SUBWORKFLOW: Run completion tasks
    //
    PIPELINE_COMPLETION (
        params.email,
        params.email_on_fail,
        params.plaintext_email,
        params.outdir,
        params.monochrome_logs,
    )

    publish:
    gs_stats                    = SANGERTOL_FASTK_GENOME_STATISTICS.out.gs_stats
    gs_asmstats                 = SANGERTOL_FASTK_GENOME_STATISTICS.out.gs_asmstats
    gs_gfastats                 = SANGERTOL_FASTK_GENOME_STATISTICS.out.gs_gfastats
    gs_merqury                  = SANGERTOL_FASTK_GENOME_STATISTICS.out.gs_merqury
    gs_merqury_qv               = SANGERTOL_FASTK_GENOME_STATISTICS.out.gs_merqury_qv
    gs_merqury_completeness     = SANGERTOL_FASTK_GENOME_STATISTICS.out.gs_merqury_completeness
    gs_merqury_phased_stats     = SANGERTOL_FASTK_GENOME_STATISTICS.out.gs_merqury_phased_stats
    gs_merqury_images           = SANGERTOL_FASTK_GENOME_STATISTICS.out.gs_merqury_images
    fastk_ktabs                 = SANGERTOL_FASTK_GENOME_STATISTICS.out.fastk_ktabs
    fastk_hist                  = SANGERTOL_FASTK_GENOME_STATISTICS.out.fastk_hist
    genomescope_lin_plot        = SANGERTOL_FASTK_GENOME_STATISTICS.out.genomescope_lin_plot
    genomescope_trans_lin_plot  = SANGERTOL_FASTK_GENOME_STATISTICS.out.genomescope_trans_lin_plot
    genomescope_log_plot        = SANGERTOL_FASTK_GENOME_STATISTICS.out.genomescope_log_plot
    genomescope_trans_log_plot  = SANGERTOL_FASTK_GENOME_STATISTICS.out.genomescope_trans_log_plot
    genomescope_model           = SANGERTOL_FASTK_GENOME_STATISTICS.out.genomescope_model
    genomescope_summary         = SANGERTOL_FASTK_GENOME_STATISTICS.out.genomescope_summary
    genomescope_json_report     = SANGERTOL_FASTK_GENOME_STATISTICS.out.genomescope_json_report
    smudgeplot_report           = SANGERTOL_FASTK_GENOME_STATISTICS.out.smudgeplot_report
    smudgeplot_png              = SANGERTOL_FASTK_GENOME_STATISTICS.out.smudgeplot_png
    smudgeplot_centrality_txt   = SANGERTOL_FASTK_GENOME_STATISTICS.out.smudgeplot_centrality_txt
}

output {
    gs_stats {
        path { meta, file -> "${meta.id}_${meta._hap}/statistics/"}
    }

    gs_asmstats {
        path { meta, file -> "${meta.id}_${meta._hap}/statistics/"}
    }

    gs_gfastats {
        path { meta, file -> "${meta.id}_${meta._hap}/statistics/"}
    }

    gs_merqury {
        path { meta, file -> "${meta.id}_${meta._hap}/merqury/"}
    }

    gs_merqury_phased_stats {
        path { meta, file -> "${meta.id}_${meta._hap}/merqury/"}
    }

    gs_merqury_qv {
        path { meta, file -> "${meta.id}_${meta._hap}/merqury/"}
    }

    gs_merqury_completeness {
        path { meta, file -> "${meta.id}_${meta._hap}/merqury/"}
    }

    gs_merqury_images {
        path { meta, file -> "${meta.id}_${meta._hap}/merqury/"}
    }

    fastk_ktabs {
        path { meta, files -> "${meta.id}_ALL/fastk/"}
    }

    fastk_hist {
        path { meta, file -> "${meta.id}_ALL/fastk/"}
    }

    genomescope_lin_plot {
        path { meta, file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_trans_lin_plot {
        path { meta, file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_log_plot {
        path { meta, file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_trans_log_plot {
        path { meta, file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_model {
        path { meta, file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_summary {
        path { meta, file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_json_report {
        path { meta, file -> "${meta.id}_ALL/genomescope/"}
    }

    smudgeplot_report {
        path { meta, file -> "${meta.id}_ALL/smudgeplot/"}
    }

    smudgeplot_png {
        path { meta, file -> "${meta.id}_ALL/smudgeplot/"}
    }

    smudgeplot_centrality_txt {
        path { meta, file -> "${meta.id}_ALL/smudgeplot/"}
    }
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
