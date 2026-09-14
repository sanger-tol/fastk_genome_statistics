# sanger-tol/fastk_genome_statistics: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.1.0 - Rapid Wrapper [unreleased]

Initial release of sanger-tol/fastk_genome_statistics, created with the [nf-core](https://nf-co.re/) template.

### `Added`

- Added the `sanger-tol/genomestatistics` subworkflow
  - This includes the `nf-core` modules `BUSCO_BUSCO`, `GFASTATS`, and `MERQURYFK_MERQURYFK`
  - This includes the `sanger-tol` module `ASMSTATS`
- Added `nf-core` modules `GENOMESCOPE2`, `FASTK_FASTK` and `FASTK_HISTEX`
- Added the local modules `SMUDGEPLOT_HETMETS` and `SMUDGEPLOT_ALL`
  - These will be submitted to `nf-core`
- `--sample` parameter to specify the sample name
- `--fasta` parameter to specify the FASTA file
- `--kmer_length` parameter to specify the length of k-mer to use in analysis
- `--longreads` parameter to specify the long reads files in use
- Adopted the workflow_output system

### `Dependencies`

| Module                | Tool           | Old Version | New Version |
| --------------------- | -------------- | ----------- | ----------- |
| `ASMSTATS`            | `asmstats`     | `NA`        | `1.0.0`     |
| `ASMSTATS`            | `seqtk`        | `NA`        | `1.5-r133`  |
| `FASTK_FASTK`         | `fastk`        | `NA`        | `1.2`       |
| `FASTK_HISTEX`        | `fastk`        | `NA`        | `1.2`       |
| `GENOMESCOPE2`        | `genomescope2` | `NA`        | `2.0`       |
| `GFASTATS`            | `gfastats`     | `NA`        | `1.3.11`    |
| `MERQURYFK_MERQURYFK` | `R`            | `NA`        | `4.3.3`     |
| `MERQURYFK_MERQURYFK` | `fastk`        | `NA`        | `1.2`       |
| `MERQURYFK_MERQURYFK` | `merquryfk`    | `NA`        | `1.2`       |
| `SMUDGEPLOT_HETMERS`  | `fastk`        | `NA`        | `1.2`       |
| `SMUDGEPLOT_HETMERS`  | `smudgeplot`   | `NA`        | `0.5.3`     |
| `SMUDGEPLOT_ALL`      | `fastk`        | `NA`        | `1.2`       |
| `SMUDGEPLOT_ALL`      | `smudgeplot`   | `NA`        | `0.5.3`     |
