#!/usr/bin/Rscript

################ WGCNA RNA-seq Analysis project snapper ############
####################################################
ls()
rm(list=ls())
ls()
#install.packages("assertthat")
library("assertthat")
library("scales")
library("WGCNA")
setwd("/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/wgcna/")
# The following setting is important, do not omit.
options(stringsAsFactors = FALSE);

lnames = load(file = "dataInput_culture.Rda");
#The variable lnames contains the names of loaded variables.
lnames

load("sft_signed_culture.Rda")
message("data loaded")

softPower = 8; #90 %
#beta1=softPower

#Connectivity=softConnectivity(datExprCulture,power=beta1)-1
# Restrict to most connected genes
#ConnectivityCut = 20000 # number of most connected genes to keep
#ConnectivityRank = rank(-Connectivity)
#restConnectivity = ConnectivityRank <= ConnectivityCut # true/false for ea. gene to keep or not
#sum(restConnectivity)
#datExprCulture <- datExprCulture[,restConnectivity]

adjacencyCulture = adjacency(datExprCulture, power = softPower,type="signed");
save(adjacencyCulture,file="adjacency_culture.Rda")
message("done adjency")
#load("adjacency_host.Rda")
TOMCulture = TOMsimilarity(adjacencyCulture,TOMType = "signed");
save(TOMCulture,file="TOM_culture.Rda")
#load("TOM_host.Rda")
dissTOM = 1-TOMCulture

#save(dissTOM,file="disTOM.Rda")
message("dissimilarity done")
#=====================================================================================
#
#  Code chunk 5
#
#=====================================================================================

# Call the hierarchical clustering function
geneTreeCulture = hclust(as.dist(dissTOM), method = "average");

#=====================================================================================
#
#  Code chunk 6
#
#=====================================================================================


# We like large modules, so we set the minimum module size relatively high:
minModuleSize = 30;
# Module identification using dynamic tree cut:
dynamicMods = cutreeDynamic(dendro = geneTreeCulture, distM = dissTOM,
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

#=====================================================================================
#
#  Code chunk 8
#
#=====================================================================================


# Calculate eigengenes
MEList = moduleEigengenes(datExprCulture, colors = dynamicColors)
MEsCulture = MEList$eigengenes
# Calculate dissimilarity of module eigengenes
MEDiss = 1-cor(MEsCulture);
# Cluster module eigengenes
METree = hclust(as.dist(MEDiss), method = "average");
# Plot the result

#=====================================================================================
#
#  Code chunk 9
#
#=====================================================================================


MEDissThres = 0.25
# Plot the cut line into the dendrogram
#abline(h=MEDissThres, col = "red")
# Call an automatic merging function
merge = mergeCloseModules(datExprCulture, dynamicColors, cutHeight = MEDissThres, verbose = 3)
# The merged module colors
mergedColors = merge$colors;
# Eigengenes of the new merged modules:
mergedMEs = merge$newMEs;


#=====================================================================================
#
#  Code chunk 11
#
#=====================================================================================


# Rename to moduleColors
moduleColorsCulture = mergedColors
# Construct numerical labels corresponding to the colors
colorOrder = c("grey", standardColors(50));
moduleLabelsCulture = match(moduleColorsCulture, colorOrder)-1;
MEsCulture = mergedMEs;
# Save module colors and labels for use in subsequent parts
save(MEsCulture, moduleLabelsCulture, moduleColorsCulture, geneTreeCulture, file = "network_culture.Rda")
