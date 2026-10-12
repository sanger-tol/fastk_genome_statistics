#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    sanger-tol/genomeprofiling
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/sanger-tol/genomeprofiling
----------------------------------------------------------------------------------------
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS / WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { GENOMEPROFILING           } from './workflows/genomeprofiling'
include { PIPELINE_INITIALISATION   } from './subworkflows/local/utils_nfcore_genomeprofiling_pipeline'
include { PIPELINE_COMPLETION       } from './subworkflows/local/utils_nfcore_genomeprofiling_pipeline'
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOWS FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Run main analysis pipeline depending on type of input
//
workflow SANGERTOL_GENOMEPROFILING {

    take:
    assemblies // channel: assemblies read in from --input
    reads      // channel: reads read in from --reads
    outdir     // channel: output directory

    main:

    //
    // WORKFLOW: Run pipeline
    //
    GENOMEPROFILING (
        assemblies,
        reads,
        outdir,
    )

    emit:
    gs_stats                    = GENOMEPROFILING.out.gs_stats
    gs_asmstats                 = GENOMEPROFILING.out.gs_asmstats
    gs_gfastats                 = GENOMEPROFILING.out.gs_gfastats
    gs_merqury                  = GENOMEPROFILING.out.gs_merqury
    gs_merqury_qv               = GENOMEPROFILING.out.gs_merqury_qv
    gs_merqury_completeness     = GENOMEPROFILING.out.gs_merqury_completeness
    gs_merqury_phased_stats     = GENOMEPROFILING.out.gs_merqury_phased_stats
    gs_merqury_images           = GENOMEPROFILING.out.gs_merqury_images
    fastk_ktabs                 = GENOMEPROFILING.out.fastk_ktabs
    fastk_hist                  = GENOMEPROFILING.out.fastk_hist
    genomescope_lin_plot        = GENOMEPROFILING.out.genomescope_lin_plot
    genomescope_trans_lin_plot  = GENOMEPROFILING.out.genomescope_trans_lin_plot
    genomescope_log_plot        = GENOMEPROFILING.out.genomescope_log_plot
    genomescope_trans_log_plot  = GENOMEPROFILING.out.genomescope_trans_log_plot
    genomescope_model           = GENOMEPROFILING.out.genomescope_model
    genomescope_summary         = GENOMEPROFILING.out.genomescope_summary
    genomescope_json_report     = GENOMEPROFILING.out.genomescope_json_report
    smudgeplot_report           = GENOMEPROFILING.out.smudgeplot_report
    smudgeplot_png              = GENOMEPROFILING.out.smudgeplot_png
    smudgeplot_centrality_txt   = GENOMEPROFILING.out.smudgeplot_centrality_txt
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
    SANGERTOL_GENOMEPROFILING (
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
    gs_stats                    = SANGERTOL_GENOMEPROFILING.out.gs_stats
    gs_asmstats                 = SANGERTOL_GENOMEPROFILING.out.gs_asmstats
    gs_gfastats                 = SANGERTOL_GENOMEPROFILING.out.gs_gfastats
    gs_merqury                  = SANGERTOL_GENOMEPROFILING.out.gs_merqury
    gs_merqury_qv               = SANGERTOL_GENOMEPROFILING.out.gs_merqury_qv
    gs_merqury_completeness     = SANGERTOL_GENOMEPROFILING.out.gs_merqury_completeness
    gs_merqury_phased_stats     = SANGERTOL_GENOMEPROFILING.out.gs_merqury_phased_stats
    gs_merqury_images           = SANGERTOL_GENOMEPROFILING.out.gs_merqury_images
    fastk_ktabs                 = SANGERTOL_GENOMEPROFILING.out.fastk_ktabs
    fastk_hist                  = SANGERTOL_GENOMEPROFILING.out.fastk_hist
    genomescope_lin_plot        = SANGERTOL_GENOMEPROFILING.out.genomescope_lin_plot
    genomescope_trans_lin_plot  = SANGERTOL_GENOMEPROFILING.out.genomescope_trans_lin_plot
    genomescope_log_plot        = SANGERTOL_GENOMEPROFILING.out.genomescope_log_plot
    genomescope_trans_log_plot  = SANGERTOL_GENOMEPROFILING.out.genomescope_trans_log_plot
    genomescope_model           = SANGERTOL_GENOMEPROFILING.out.genomescope_model
    genomescope_summary         = SANGERTOL_GENOMEPROFILING.out.genomescope_summary
    genomescope_json_report     = SANGERTOL_GENOMEPROFILING.out.genomescope_json_report
    smudgeplot_report           = SANGERTOL_GENOMEPROFILING.out.smudgeplot_report
    smudgeplot_png              = SANGERTOL_GENOMEPROFILING.out.smudgeplot_png
    smudgeplot_centrality_txt   = SANGERTOL_GENOMEPROFILING.out.smudgeplot_centrality_txt
}

output {
    gs_stats {
        path { meta, _file -> "${meta.id}_${meta._hap}/statistics/"}
    }

    gs_asmstats {
        path { meta, _file -> "${meta.id}_${meta._hap}/statistics/"}
    }

    gs_gfastats {
        path { meta, _file -> "${meta.id}_${meta._hap}/statistics/"}
    }

    gs_merqury {
        path { meta, _file -> "${meta.id}_${meta._hap}/merqury/"}
    }

    gs_merqury_phased_stats {
        path { meta, _file -> "${meta.id}_${meta._hap}/merqury/"}
    }

    gs_merqury_qv {
        path { meta, _file -> "${meta.id}_${meta._hap}/merqury/"}
    }

    gs_merqury_completeness {
        path { meta, _file -> "${meta.id}_${meta._hap}/merqury/"}
    }

    gs_merqury_images {
        path { meta, _file -> "${meta.id}_${meta._hap}/merqury/"}
    }

    fastk_ktabs {
        path { meta, _files -> "${meta.id}_ALL/fastk/"}
    }

    fastk_hist {
        path { meta, _file -> "${meta.id}_ALL/fastk/"}
    }

    genomescope_lin_plot {
        path { meta, _file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_trans_lin_plot {
        path { meta, _file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_log_plot {
        path { meta, _file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_trans_log_plot {
        path { meta, _file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_model {
        path { meta, _file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_summary {
        path { meta, _file -> "${meta.id}_ALL/genomescope/"}
    }

    genomescope_json_report {
        path { meta, _file -> "${meta.id}_ALL/genomescope/"}
    }

    smudgeplot_report {
        path { meta, _file -> "${meta.id}_ALL/smudgeplot/"}
    }

    smudgeplot_png {
        path { meta, _file -> "${meta.id}_ALL/smudgeplot/"}
    }

    smudgeplot_centrality_txt {
        path { meta, _file -> "${meta.id}_ALL/smudgeplot/"}
    }
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
