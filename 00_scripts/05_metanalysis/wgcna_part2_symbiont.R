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

#Read in the expr data set
#logcpm_test<-read.table("log_matrix_host_clam.txt", header=T)

#rownames(logcpm_test)=logcpm_test$X
#logcpm_test$X <- NULL

#temp<-read.table("data_trait_symb_tridacna_physio_Temp_Time_percentclade.txt",sep="\t", header=T,na.strings="NA")
#vector<-temp$Ind

#logcpm_test<-logcpm_test[, names(logcpm_test) %in% vector]

# Take a quick look at what is in the data set:
#dim(logcpm_test)

#=====================================================================================
#
#  Code chunk 2
#
#=====================================================================================
#datExpr0 = as.data.frame(t(logcpm_test))

#=====================================================================================
#
#  Code chunk 3
#
#=====================================================================================


#gsg = goodSamplesGenes(datExpr0, verbose = 3);
#gsg$allOK

#=====================================================================================
#
#  Code chunk 4
#
#=====================================================================================


#if (!gsg$allOK)
#{
  # Optionally, print the gene and sample names that were removed:
  #if (sum(!gsg$goodGenes)>0) 
   # printFlush(paste("Removing genes:", paste(names(datExpr0)[!gsg$goodGenes], collapse = ", ")));
  #if (sum(!gsg$goodSamples)>0) 
  #  printFlush(paste("Removing samples:", paste(rownames(datExpr0)[!gsg$goodSamples], collapse = ", ")));
  # Remove the offending genes and samples from the data:
 # datExpr0 = datExpr0[gsg$goodSamples, gsg$goodGenes]
#}

#=====================================================================================
#
#  Code chunk 5
#
#=====================================================================================


#sampleTree = hclust(dist(datExpr0), method = "average");
# Plot the sample tree: Open a graphic output window of size 12 by 9 inches
# The user should change the dimensions if the window is too large or too small.
#sizeGrWindow(12,9)
#pdf(file = "Plots/sampleClustering.pdf", width = 12, height = 9);
#
#  Code chunk 6: check outliers
#
#=====================================================================================


# Plot a line to show the cut
# Determine cluster under the line
#clust = cutreeStatic(sampleTree, cutHeight = 250, minSize = 10)
#table(clust)
# clust 1 contains the samples we want to keep.
#keepSamples = (clust==1)
#datExpr = datExpr0[keepSamples, ]
#nGenes = ncol(datExpr)
#nSamples = nrow(datExpr)
#variancedatExpr=as.vector(apply(as.matrix(datExpr),2,var, na.rm=T))
#no.presentdatExpr=as.vector(apply(!is.na(as.matrix(datExpr)),2, sum) )
# Another way of summarizing the number of pressent entries
#table(no.presentdatExpr)

# Keep only genes whose variance is non-zero and have at least 4 present entries
#KeepGenes= variancedatExpr>0.05
#table(KeepGenes)
#datExpr=datExpr[, KeepGenes]

#name_datExpr <-colnames(datExpr)

#=====================================================================================
#
#  Code chunk 7: add traits
#
#=====================================================================================


#allTraits = read.table("data_trait_symb_tridacna_physio_Temp_Time_percentclade.txt",header=T,na.strings="NA");
#names(allTraits)
#allTraits$percent_B<-NULL
# Form a data frame analogous to expression data that will hold the clinical traits.

#femaleSamples = rownames(datExpr);
#traitRows = match(femaleSamples, allTraits$Ind);
#datTraits = allTraits[traitRows, -1];
#rownames(datTraits) = allTraits[traitRows, 1];
#str(datTraits)

#collectGarbage();


#=====================================================================================
#
#  Code chunk 8
#
#=====================================================================================


# Re-cluster samples
#sampleTree2 = hclust(dist(datExpr), method = "average")
# Convert traits to a color representation: white means low, red means high, grey means missing entry
#traitColors = numbers2colors(datTraits,signed= TRUE);
#
#  Code chunk 9
#
#=====================================================================================


#save(datExpr, datTraits, file = "dataInput_host.Rda")



########################## Module construction step-by-step #################################
################################################################################
#=====================================================================================
#
#  Code chunk 1
#
#=====================================================================================

#setting is important, do not omit.
#options(stringsAsFactors = FALSE);
# Allow multi-threading within WGCNA. At present this call is necessary.
# Any error here may be ignored but you may want to update WGCNA if you see one.
# Caution: skip this line if you run RStudio or other third-party R environments.
# See note above.
#enableWGCNAThreads()
# Load the data saved in the first part
lnames = load(file = "dataInput_symbiont.Rda");
#The variable lnames contains the names of loaded variables.
lnames


#=====================================================================================
#
#  Code chunk 2
#
#=====================================================================================

# Choose a set of soft-thresholding powers
#powers = c(c(1:10), seq(from = 20, to=30, by=2))
# Call the network topology analysis function
#sft = pickSoftThreshold(datExpr, powerVector = powers, verbose = 5,networkType="signed")
# Plot the results:
# Scale-free topology fit index as a function of the soft-thresholding power

#save(sft,file="sft_signed_symbiont.Rda")

########################## Module construction step-by-step #################################
################################################################################
#=====================================================================================
#
#  Code chunk 1
#
#=====================================================================================

#setting is important, do not omit.
#options(stringsAsFactors = FALSE);
# Allow multi-threading within WGCNA. At present this call is necessary.
# Any error here may be ignored but you may want to update WGCNA if you see one.
# Caution: skip this line if you run RStudio or other third-party R environments.
# See note above.
#enableWGCNAThreads()
# Load the data saved in the first part
lnames = load(file = "dataInput_symbiont.Rda");
#The variable lnames contains the names of loaded variables.
lnames


load("dataInput_symbiont.Rda")
load("sft_signed_symbiont.Rda")
message("data loaded")

softPower = 26; #75 %
adjacency = adjacency(datExpr, power = softPower,type="signed");
save(adjacency,file="adjacency_symbiont.Rda")
message("done adjency")
#load("adjacency_symbiont.Rda")
TOM = TOMsimilarity(adjacency,TOMType = "signed");
#load("TOM.Rda")
dissTOM = 1-TOM

#save(dissTOM,file="disTOM.Rda")
save(TOM,file="TOM_symbiont.Rda")
message("dissimilarity done")
#=====================================================================================
#
#  Code chunk 5
#
#=====================================================================================

# Call the hierarchical clustering function
geneTree = hclust(as.dist(dissTOM), method = "average");

#=====================================================================================
#
#  Code chunk 6
#
#=====================================================================================


# We like large modules, so we set the minimum module size relatively high:
minModuleSize = 30;
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

#=====================================================================================
#
#  Code chunk 9
#
#=====================================================================================


MEDissThres = 0.25
# Plot the cut line into the dendrogram
#abline(h=MEDissThres, col = "red")
# Call an automatic merging function
merge = mergeCloseModules(datExpr, dynamicColors, cutHeight = MEDissThres, verbose = 3)
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
moduleColors = mergedColors
# Construct numerical labels corresponding to the colors
colorOrder = c("grey", standardColors(50));
moduleLabels = match(moduleColors, colorOrder)-1;
MEs = mergedMEs;
# Save module colors and labels for use in subsequent parts
save(MEs, moduleLabels, moduleColors, geneTree, file = "network_symbiont.Rda")
