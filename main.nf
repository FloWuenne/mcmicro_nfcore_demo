/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// MODULE: Installed directly from nf-core/modules
//
// include { CUSTOM_DUMPSOFTWAREVERSIONS } from '../modules/nf-core/custom/dumpsoftwareversions/main'

include { ILASTIK_PIXELCLASSIFICATION } from './modules/nf-core/ilastik/pixelclassification/main'
include { ILASTIK_MULTICUT } from './modules/nf-core/ilastik/multicut/main'

// MODULE: Local modules (not yet merged into nf-core/modules main)
include { BACKSUB } from './modules/local/backsub/main'
include { MESMER } from './modules/local/deepcell/mesmer/main'
include { MCQUANT } from './modules/local/mcquant/main'
include { SCIMAP_MCMICRO } from './modules/local/scimap/mcmicro/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    // Manually define inputs here
    image_tuple = tuple([ id:'test', single_end:false ], '/workspace/test/cycif_tonsil_registered.ome.tif')
    marker_tuple = tuple([ id:'test', single_end:false ], '/workspace/test/markers.csv')

    // Background subtraction
    BACKSUB(image_tuple,marker_tuple)

    // Segmentation
    MESMER(BACKSUB.out.backsub_tif)

    // Quantification
    MCQUANT(BACKSUB.out.backsub_tif,
            MESMER.out.mask,
            BACKSUB.out.markerout)

    // Scimap
    SCIMAP_MCMICRO(MCQUANT.out.csv)

}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
