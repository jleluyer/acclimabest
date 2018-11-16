#!/usr/bin/env Rscript
################ WGCNA RNA-seq Analysis ############
####################################################
ls()
rm(list=ls())
ls()
#source("http://bioconductor.org/biocLite.R") 
#biocLite(c("AnnotationDbi", "impute", "GO.db", "preprocessCore")) 
#install.packages("WGCNA")

#install.packages("scales")
#install.packages("assertthat")
library("assertthat")
library("scales")
library("WGCNA")

ALLOW_WGCNA_THREADS=20
setwd("wgcna/")

load("dataInput_subset.Rda")
load("sft_signed_cell_culture.Rda")
message("data loaded")


softPower = 8; #reach 85%
adjacency = adjacency(datExpr, power = softPower,type="signed");
#save(adjacency,file="adjacency_cell.Rda")
TOM = TOMsimilarity(adjacency,TOMType = "signed");
dissTOM = 1-TOM

#save(dissTOM,file="disTOM.Rda")
save(TOM,file="TOM.Rda")
message("dissimilarity done")
#=====================================================================================
#
#  Code chunk 5
#
#=====================================================================================

# Call the hierarchical clustering function
geneTree = hclust(as.dist(dissTOM), method = "average");
# Plot the resulting clustering tree (dendrogram)
pdf("genetree_subset.pdf",width=12,height=9)
plot(geneTree, xlab="", sub="", main = "Gene clustering on TOM-based dissimilarity",
     labels = FALSE, hang = 0.04);
dev.off()


#=====================================================================================
#
#  Code chunk 6
#
#=====================================================================================


# We like large modules, so we set the minimum module size relatively high:
minModuleSize = 50;
# Module identification using dynamic tree cut:
dynamicMods = cutreeDynamic(dendro = geneTree, distM = dissTOM,
                            deepSplit = 2, pamRespectsDendro = FALSE,
                            minClusterSize = minModuleSize);
table(dynamicMods)

#=====================================================================================
#
#  Code chunk 7
#
#=====================================================================================


# Convert numeric lables into colors
dynamicColors = labels2colors(dynamicMods)
table(dynamicColors)
# Plot the dendrogram and colors underneath
 pdf("genetree_dyn_subset.pdf",width=8,height=6)
plotDendroAndColors(geneTree, dynamicColors, "Dynamic Tree Cut",
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05,
                    main = "Gene dendrogram and module colors")
dev.off()

#=====================================================================================
#
#  Code chunk 8
#
#=====================================================================================


# Calculate eigengenes
MEList = moduleEigengenes(datExpr, colors = dynamicColors)
MEs = MEList$eigengenes
# Calculate dissimilarity of module eigengenes
MEDiss = 1-cor(MEs);
# Cluster module eigengenes
METree = hclust(as.dist(MEDiss), method = "average");
# Plot the result
pdf("cluster_modules_subset.pdf",width=8,height=6)
plot(METree, main = "Clustering of module eigengenes",
     xlab = "", sub = "")

#=====================================================================================
#
#  Code chunk 9
#
#=====================================================================================


MEDissThres = 0.25
# Plot the cut line into the dendrogram
abline(h=MEDissThres, col = "red")
# Call an automatic merging function
merge = mergeCloseModules(datExpr, dynamicColors, cutHeight = MEDissThres, verbose = 3)
# The merged module colors
mergedColors = merge$colors;
# Eigengenes of the new merged modules:
mergedMEs = merge$newMEs;
dev.off()

pdf(file = "geneDendro-3_subset.pdf", wi = 9, he = 6)
plotDendroAndColors(geneTree, cbind(dynamicColors, mergedColors),
                    c("Dynamic Tree Cut", "Merged dynamic"),
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05)
dev.off()

#=====================================================================================
#
#  Code chunk 11
#
#=====================================================================================


# Rename to moduleColors
moduleColors = mergedColors
# Construct numerical labels corresponding to the colors
colorOrder = c("grey", standardColors(50));
moduleLabels = match(moduleColors, colorOrder)-1;
MEs = mergedMEs;
# Save module colors and labels for use in subsequent parts
save(MEs, moduleLabels, moduleColors, geneTree, file = "networkConstruction-stepByStep_culture.Rda")
exit

######################### Visualize network ##########################
#######################################################################

#=====================================================================================
#
#  Code chunk 1
#
#=====================================================================================

# Load the expression and trait data saved in the first part
lnames = load(file = "dataInput_subset.Rda");
#The variable lnames contains the names of loaded variables.
lnames
# Load network data saved in the second part.
lnames = load(file = "networkConstruction-stepByStep_temp_cell.Rda");
lnames
nGenes = ncol(datExpr)
nSamples = nrow(datExpr)
# load SFT  ### not made in the proper package
lnames=load(file="sft_signed_cell_culture_subset.Rda")
lnames
#=====================================================================================
#
#  Code chunk 2
#
#=====================================================================================


# Calculate topological overlap anew: this could be done more efficiently by saving the TOM
# calculated during module detection, but let us do it again here.
#dissTOM = 1-TOMsimilarityFromExpr(datExpr, power = 22);
# Transform dissTOM with a power to make moderately strong connections more visible in the heatmap
#plotTOM = dissTOM^7;
# Set diagonal to NA for a nicer plot
#diag(plotTOM) = NA;
# Call the plot function
#sizeGrWindow(9,9)
#pdf(file = "03_results/network_heatmap.pdf", wi = 9, he = 6)
#TOMplot(plotTOM, geneTree, moduleColors, main = "Network heatmap plot, all genes")
#dev.off()

#=====================================================================================
#
#  Code chunk 3
#
#=====================================================================================


#nSelect = 400
# For reproducibility, we set the random seed
#set.seed(10);
#select = sample(nGenes, size = nSelect);
#selectTOM = dissTOM[select, select];
# There's no simple way of restricting a clustering tree to a subset of genes, so we must re-cluster.
#selectTree = hclust(as.dist(selectTOM), method = "average")
#selectColors = moduleColors[select];
# Open a graphical window
#sizeGrWindow(9,9)
# Taking the dissimilarity to a power, say 10, makes the plot more informative by effectively changing 
# the color palette; setting the diagonal to NA also improves the clarity of the plot
#plotDiss = selectTOM^7;
#diag(plotDiss) = NA;
#pdf(file = "03_results/network_heatmap_subset.pdf", wi = 9, he = 6)
#TOMplot(plotDiss, selectTree, selectColors, main = "Network heatmap plot, selected genes")
#dev.off()

#=====================================================================================
#
#  Code chunk 4
#
#=====================================================================================


# Recalculate module eigengenes
MEs = moduleEigengenes(datExpr, moduleColors)$eigengenes
# Isolate weight from the clinical traits
Temperature = as.data.frame(datTraits$Temperature);
names(Temperature) = "Temperature"
# Add the weight to existing module eigengenes
MET = orderMEs(cbind(MEs, Temperature))
# Plot the relationships among the eigengenes and the trait
sizeGrWindow(5,7.5);
par(cex = 0.9)
pdf(file = "03_results/relationship_network_trait.pdf", wi = 9, he = 6)
plotEigengeneNetworks(MET, "", marDendro = c(0,4,1,2), marHeatmap = c(3,4,1,2), cex.lab = 0.8, xLabelsAngle= 90)
dev.off()

#=====================================================================================
#
#  Code chunk 5
#
#=====================================================================================


# Plot the dendrogram
#sizeGrWindow(6,6);
#pdf(file = "03_results/eigene_dendogramv2.pdf", wi = 9, he = 6)
#par(cex = 1.0)
#plotEigengeneNetworks(MET, "Eigengene dendrogram", marDendro = c(0,4,2,0),
#                      plotHeatmaps = FALSE)
#dev.off()
# Plot the heatmap matrix (note: this plot will overwrite the dendrogram plot)
#par(cex = 1.0)

#pdf(file = "03_results/eigengene_adjency_heatmap.pdf", wi = 9, he = 6)
#plotEigengeneNetworks(MET, "Eigengene adjacency heatmap", marHeatmap = c(3,4,2,2),
#                      plotDendrograms = FALSE, xLabelsAngle = 90)
#dev.off()
