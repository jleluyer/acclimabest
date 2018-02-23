## test anova GxE interaction ###
#see post
ls()
rm(list=ls())
ls()
#https://support.bioconductor.org/p/56568/
#setwd("/Users/jeremyleluyer/Documents/post-doc/projects/transgenic/transciptome/muscle/03_results/glm/03_results/")
## test Glm approahc with edger ##
library('edgeR')

setwd("~/Documents/Projets/Coho_transgenic/transcriptome_liver/")
counts <- read.table("02_data/join_htseq.txt",header=T,na.strings="NA")

# Create design
targets <- read.table("01_info_files/design.txt",header=T,na.strings="NA")
targets$genotype <- relevel(targets$genotype, ref=c("wild"))
targets$environment<- relevel(targets$environment, ref=c("stream"))
targets

# remove genes in significant interaction (see glm interaction)
remove <- read.table("03_results/list_de_interaction.txt",na.strings="NA")
counts <-counts[!rownames(counts) %in% remove$V1, ]

#reassignng column name
dim(counts)
str(counts)
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
dim(cds)
#filtering low counts
cds <- cds[rowSums(1e+06 * cds$counts/expandAsMatrix(cds$samples$lib.size, dim(cds)) > 1) >= 2, ]
dim( cds )

#calcultate normalization factors
cds <- calcNormFactors( cds )
cds$samples

#library size
cds$samples$lib.size*cds$samples$norm.factors

#Create design (can be created manually)
design.oneway <- model.matrix(~0+Group)
colnames(design.oneway) <- levels(Group)
design.oneway

#library size
cds$samples$lib.size*cds$samples$norm.factors
cds$samples$norm.factors
#estimate dispersion
cds <-estimateDisp(cds,design.oneway) #estimate all dispersions in one run #add different prior values (prior.df = INT)
names( cds )

# Testing comparison any treatment test
fit <- glmFit(cds, design.oneway)
colnames(fit)



################## environment effect ####################################
##########################################################################

#explanation: https://www.bioconductor.org/packages/devel/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf
lrt <- glmLRT(fit, contrast=c(-1,-1,1,1)) # enviro effect (rivers)


lrt$comparison # which groups have been compared
topTags( lrt , n = 10 , sort.by = "PValue" )
topTags(lrt)


#### plot#### 
#plot MDS
plotMDS( cds , main = "MDS Plot for Count Data", labels = colnames( cds$counts ) )

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
resSig = subset(resOrdered, FDR<0.01)
resSig3=subset(resSig,abs(logFC)>=2)


dim(resSig)
dim(resSig3)
#write table in a file
write.table(resSig3, file="03_results/environment_de.txt", sep = "\t" , quote=F,row.names = TRUE)

# heatmap top 20
# load 
#enviro_logcpm<-read.table("03_results/glm/unique_reads/gene_top20_enviro_logcpm.txt", header=T)
#matrix_locpmenviro<-as.matrix(enviro_logcpm)
#heatmap(matrix_locpmenviro,distfun=dist,hclustfun=hclust,add.expr=T,margins = c(5, 10), ColSideColors=c("red","red","blue","blue","red","red","blue","blue"))

################## genotype effect ####################################
##########################################################################

lrt <- glmLRT(fit, contrast=c(1,-1,1,-1)) #geno effecto#see contrast explanation https://www.bioconductor.org/packages/devel/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf

lrt$comparison # which groups have been compared

#sort byt fold change
resultsByFC.tgw <- topTags( lrt , n = nrow( lrt$table ) , sort.by = "logFC" )$table

#store full toptags
resultsTbl.tgw <- topTags( lrt , n = nrow( lrt$table ) )$table
head(resultsTbl.tgw)

#extract significant with FDR < 0.05
resOrdered = resultsTbl.tgw[order(resultsTbl.tgw$FDR),]
resSig = subset(resOrdered, FDR<0.01)
resSig3=subset(resSig,abs(logFC)>=2)

dim(resSig)
dim(resSig3)
#write table in a file
write.table(resSig3, file="03_results/genotype_de.txt", sep = "\t" , quote=F,row.names = TRUE)

# heatmap top 20
# load 
#geno_logcpm<-read.table("03_results/glm/unique_reads/gene_top20_geno_logcpm.txt", header=T)
#matrix_locpmgeno<-as.matrix(geno_logcpm)
#heatmap(matrix_locpmgeno,distfun=dist,hclustfun=hclust,add.expr=T,margins = c(5, 10), ColSideColors=c("red","red","red","red","blue","blue","blue","blue"))

