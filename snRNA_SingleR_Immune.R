# Script to run singleR for automated cell type annotation

# use R/4.0
library(SingleR)
library(celldex)
library(Seurat)

# read in seurat object
analysis_parent_folder <- "./immune_results/"
setwd(analysis_parent_folder)
colon <- readRDS("./clustered_full_colon_immune_proj_seurat_post_doublet_filter.rds")

# set up reference, and define cell types to use
ref <- HumanPrimaryCellAtlasData()
types_to_use <- c("DC","Epithelial_cells","B_cell","Neutrophils","T_cells","Monocyte",
	"Endothelial_cells","Neurons","Macrophage","NK_cell",
	"BM","Platelets","Fibroblasts","Astrocyte","Myelocyte","Pre-B_cell_CD34-","Pro-B_cell_CD34+","Pro-Myelocyte")
ref <- ref[,(colData(ref)$label.main %in% types_to_use)]

# Run singleR
singler.pred <- SingleR(test = as.SingleCellExperiment(colon), ref = ref, labels = ref$label.fine)

# Add to seurat object, and then you cna plot the results if desired
colon <- AddMetaData(colon, metadata = singler.pred$labels, col.name = "SingleR.labels")
