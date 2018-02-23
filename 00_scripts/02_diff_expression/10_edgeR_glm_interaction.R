## test anova GxE interaction ###
#see post
ls()
rm(list=ls())
ls()

# install edgeR
#source("https://bioconductor.org/biocLite.R")
#biocLite("edgeR")

library('edgeR')

setwd("~/Documents/Projets/Coho_transgenic/transcriptome_liver/")
counts <- read.table("02_data/join_htseq.txt",header=T,na.strings="NA")

# Create design
targets <- read.table("01_info_files/design.txt",header=T,na.strings="NA")
targets$genotype <- relevel(targets$genotype, ref=c("wild"))
targets$environment<- relevel(targets$environment, ref=c("stream"))
targets


#reassignng column name
dim(counts)
str(counts)
summary(counts)
colSums(counts) / 1e06

#nb gene with low count
table( rowSums( counts ) )[ 1:30 ]
#create object
Group <-  factor(paste(targets$environment,targets$genotype,sep="."))
Group
cds <- DGEList( counts , group = Group )
head(cds$counts)
cds$samples
levels(cds$samples$group)

#filtering low counts
cds <- cds[rowSums(1e+06 * cds$counts/expandAsMatrix(cds$samples$lib.size, dim(cds)) > 1) >= 2, ]
dim( cds )

#calcultate normalization factors
cds <- calcNormFactors( cds )
cds$samples

#library size
cds$samples$lib.size*cds$samples$norm.factors

#Create design (can be created manually)
design <- model.matrix(~genotype *environment, data=targets)
colnames(design)
design
#library size
cds$samples$lib.size*cds$samples$norm.factors
cds$samples$norm.factors
#estimate dispersion
cds <-estimateDisp(cds,design) #estimate all dispersions in one run #add different prior values (prior.df = INT)
names( cds )

#create a logcpm matrix
logcpm_total <- cpm(cds, prior.count=2, log=TRUE,normalized.lib.sizes = TRUE)
write.table(logcpm_total, file="03_results/logcpm_edger.txt", row.names = TRUE,quote=F)

#Compute average logCPM
locpm_average<-aveLogCPM(cds, normalized.lib.sizes=TRUE, prior.count=2,log=TRUE)
write.table(locpm_average, file="03_results/logcpm_average_edger.txt", row.names = TRUE,quote=F)


#PCompute CPM by group
logcpm_group<- cpmByGroup(cds, normalized.lib.sizes=TRUE)
write.table(logcpm_group, file="03_results/logcpm_group_nocpm.txt", row.names = TRUE, quote=F)

# Testing comparison any treatment test
fit <- glmFit(cds, design)
colnames(fit)
lrt <- glmLRT(fit, coef=4) #see contrast explanation https://www.bioconductor.org/packages/devel/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf
lrt$comparison # which groups have been compared
topTags( lrt , n = 10 , sort.by = "PValue" )
topTags(lrt)


#### plot#### 
#plot MDS
plotMDS( cds , main = "MDS Plot for Count Data", labels = colnames( cds$counts ) )
d<-as.data.frame(plotMDS( cds , main = "MDS Plot for Count Data", labels = colnames( cds$counts ) ))

meanVarPlot <- plotMeanVar( cds ,show.raw.vars=TRUE , show.tagwise.vars=TRUE , show.binned.common.disp.vars=FALSE , show.ave.raw.vars=FALSE , dispersion.method = "qcml" , NBline = TRUE , nbins = 100 , #these are arguments about what is plotted
                            pch = 16 , xlab ="Mean Expression (Log10 Scale)" , ylab = "Variance (Log10 Scale)" , main = "Mean-Variance Plot" ) #these arguments are to make it look prettier


#sort byt fold change
resultsByFC.tgw <- topTags( lrt , n = nrow( lrt$table ) , sort.by = "logFC" )$table

head( resultsByFC.tgw )

#store full toptags
resultsTbl.tgw <- topTags( lrt , n = nrow( lrt$table ) )$table
head(resultsTbl.tgw)

#extract significant with FDR < 0.05
resOrdered = resultsTbl.tgw[order(resultsTbl.tgw$FDR),]

resSig2 = subset(resOrdered, FDR<0.05)
resSig = subset(resOrdered, FDR<0.01)
#write table in a file
dim(resSig2)
dim(resSig)
write.table(resSig, file="03_results/edger_interaction_liver_fdr0.01.txt",sep= "\t",quote=F )
write.table(resSig2, file="03_results/edger_interaction_liver_fdr0.05.txt",sep= "\t",quote=F )


#### visualize interaction
library(ggplot2)
#source("http://bioconductor.org/biocLite.R")
#biocLite("ComplexHeatmap")
library(ComplexHeatmap)
library(circlize)


#########################  Heatmap logcpm ########################@

# load 
#interaction_logcpm<-read.table("03_results/logcpm_interaction_temp.txt", header=T)
interaction_logcpm<-read.table("03_results/logcpm_interaction.txt", header=T)
str(interaction_logcpm)
matrix_locpminteraction<-as.matrix(interaction_logcpm)
summary(interaction_logcpm)
str(matrix_locpminteraction)

#Complex heatmap
type = gsub("s\\d+_", "", colnames(matrix_locpminteraction))
ha = HeatmapAnnotation(df = data.frame(type = type))
tiff(file = "03_results/heatmap_de_interaction.tiff", width = 40, height = 40, units = "cm", res = 300)
Heatmap(matrix_locpminteraction,name = "Log CPM", km=10, col = colorRamp2(c(-4, 0, 15), c("blue", "white", "red")),
        show_row_names = T, show_column_names = T,clustering_distance_rows = "euclidean")
dev.off()

#subset
interaction_logcpm<-read.table("03_results/logcpm_interaction.txt", header=T)
matrix_locpminteraction<-as.matrix(interaction_logcpm)
summary(interaction_logcpm)
str(matrix_locpminteraction)

#Complex heatmap
type = gsub("s\\d+_", "", colnames(matrix_locpminteraction))
ha = HeatmapAnnotation(df = data.frame(type = type))
tiff(file = "03_results/match_de_dmr_interaction.tiff", width = 40, height = 40, units = "cm", res = 100)
Heatmap(matrix_locpminteraction,name = "Log CPM", km=8, col = colorRamp2(c(-2, 2, 10), c("dodgerblue4", "white", "red4")),
        show_row_names = F, show_column_names = T,clustering_distance_rows = "euclidean")
dev.off()
?heatmap()


######################### heatmap for centered gene expression ########################@
#install.packages("pheatmap")
library(pheatmap)
mat  <- interaction_logcpm
mat  <- mat - rowMeans(mat)
#anno <- as.data.frame(colData(rld)[, c("cell","dex")])

tiff(file = "03_results/heatmap_clusters.tiff", width = 15, height = 15, units = "cm", res = 300)
pheatmap(mat,kmeans_k = 8)
dev.off()




######################### Visualize each gene ########################@
#For interaction graphs logcpm
library(ggplot2)

log_counts_interaction <-t(interaction_logcpm)
total <- merge(log_counts_interaction,targets,by="row.names")
plot<- (ggplot(data = total, aes(x=environment, y=igf1,group=genotype,shape=genotype)) 
        + geom_point(aes(colour=genotype)) 
        + scale_y_continuous(limits = c(5, 8))
        + stat_summary(fun.y = mean, geom="line",aes(color=genotype))
        + ggtitle("")
)
plot



######################### heatmap for correlating samples ########################@
# Plot correlation matrix for samples
cormat <- round(cor(logcpm_group),2)
head(cormat)
library(reshape2)
melted_cormat <- melt(cormat)
head(melted_cormat)

# Plot correlation matrix
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()

# Get lower triangle of the correlation matrix
get_lower_tri<-function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}
# Get upper triangle of the correlation matrix
get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}


# usage
upper_tri <- get_upper_tri(cormat)
upper_tri

# Melt the correlation matrix
melted_cormat <- melt(upper_tri, na.rm = TRUE)

# Heatmap
ggplot(data = melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed()

# Reorder matri correlation
reorder_cormat <- function(cormat){
  # Use correlation between variables as distance
  dd <- as.dist((1-cormat)/2)
  hc <- hclust(dd)
  cormat <-cormat[hc$order, hc$order]
}

# Reorder the correlation matrix
cormat <- reorder_cormat(cormat)
upper_tri <- get_upper_tri(cormat)
# Melt the correlation matrix
melted_cormat <- melt(upper_tri, na.rm = TRUE)
# Create a ggheatmap
ggheatmap <- ggplot(melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed() +
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.justification = c(1, 0),
    legend.position = c(0.4, 0.7),
    legend.direction = "horizontal")+
  guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                               title.position = "top", title.hjust = 0.5))

# Print the heatmap
tiff(file = "03_results/heatmap_correlation_interaction.tiff", width = 15, height = 15, units = "cm", res = 300)
print(ggheatmap)
dev.off()


######################### Test clustering genes ########################@
# Define best number of clusters 
# Bayesian approach
#install.packages("mclust")
library("mclust")
d_clust <- Mclust(as.matrix(interaction_logcpm), G=1:15, 
                  modelNames = mclust.options("emModelNames"))
d_clust$BIC
plot(d_clust)


# kmeans cluster
clusters = kmeans(x = interaction_logcpm, centers=4)

#plot

library(fpc)
plotcluster(interaction_logcpm, clusters$cluster)
# extract cluster info
interaction_logcpm_cluster <- data.frame(interaction_logcpm, clusters$cluster)
#cluster_labels <- as.factor(interaction_logcpm_cluster[,9]) in individuals

cluster_labels <- as.factor(interaction_logcpm_cluster[,5]) #in groups
library(colorspace)
cluster_col <- rev(rainbow_hcl(12))[as.numeric(cluster_labels)]
pairs(interaction_logcpm_cluster[,1:4], col = cluster_col,
      lower.panel = NULL,
      cex.labels=1.5, pch=0:12, cex = 1)


######################### Hierarchical clustering of samples with bootstrap ########################@


#install.packages("pvclust")
library(pvclust)
fit_btsp <- pvclust(interaction_logcpm, method.hclust="ward.D",
                    method.dist="euclidean",nboot=1000)
plot(fit_btsp)
pvrect(fit_btsp, alpha=.95)



######################## Parallel coordinate plots ########################@
# The ideas:
# 1- cluster by K-means
# 2- plot parallel plots
# 3- make diff. images graphs

library("cdparcoord")
library(GGally)
library(MASS)

# Compute mean value
#gd <- interaction_logcpm_cluster %>% 
#  group_by(clusters.cluster) %>% 
#  summarise(
#    GxEL11 = mean(GxEL11),
#    GxEL12 = mean(GxEL12),
#    GxEL13 = mean(GxEL13),
#    GxEL14 = mean(GxEL14),
#    GxEL15 = mean(GxEL15),
#    GxEL16 = mean(GxEL16),
#    GxEL17 = mean(GxEL17),
#    GxEL18 = mean(GxEL18))


# Create cluster labels
occurences<-table(unlist(interaction_logcpm_cluster$clusters.cluster))
occurences

# For individuals
#label.cluster<- c(
#  `1` = "cluster 1 (95 genes)",
#  `2` = "cluster 2 (38 genes)",
# `3` = "cluster 3 (251 genes)",
# `4` = "cluster 4 (138 genes)",
# `5` = "cluster 5 (202 genes)",
# `6` = "cluster 6 (150 genes)",
# `7` = "cluster 7 (62 genes)",
# `8` = "cluster 8 (213 genes)")

# For groups
label.cluster<- c(
  `1` = "cluster 1 (302 genes)",
  `2` = "cluster 2 (438 genes)",
`3` = "cluster 3 (85 genes)",
 `4` = "cluster 4 (286 genes)")

# plot
plotparallel<-ggparcoord( interaction_logcpm_cluster,
                          mapping=aes(color=as.factor(clusters.cluster)),
                          #columns = 1:8, for individuals
                          columns = 1:4, #for groups
                          groupColumn=5, #for groups
                          #groupColumn=9, #for individuals
                          #order=c(3,5,2,4,6,7,1,8 ),#for individuals
                          order=c(1,2,3,4),#for groups
                          boxplot=FALSE,
                          alphaLines = 0.6,
                          shadeBox=NULL) +
      labs(y = "log2FC to the mean",x="") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1),
                          legend.position="none")+ 
      scale_color_discrete("clusters.cluster") 

plotparallel
plotparallel + facet_wrap( ~ clusters.cluster ,labeller=as_labeller(label.cluster),ncol=2) +
  theme(strip.text.x = element_text(size=10,face="bold")) 



# Plot only means

plotparallel<-ggparcoord( gd,
                          mapping=aes(color=as.factor(clusters.cluster)),
                          columns = 2:9,
                          groupColumn=9,
                          order=c(2,3,4,5,6,7,8,9),
                          boxplot=FALSE,
                          alphaLines = 0.6,
                          shadeBox=NULL) +
  labs(y = "logCPM",x="") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position="none")+ 
  scale_color_discrete("clusters.cluster") 

plotparallel


citation("mclust")

