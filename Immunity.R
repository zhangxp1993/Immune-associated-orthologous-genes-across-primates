install.packages("VennDiagram")
install.packages("UpSetR")
install.packages("BiocManager")
BiocManager::install("GOSim")
install.packages("ggpubr")
install.packages("ggplot2")
install.packages("ade4")
install.packages("nipals")
install.packages("phytools")
install.packages("multcomp")
install.packages("AICcmodavg")
install.packages("devtools")
install.packages("caper")
install.packages("geiger")
install.packages("openxlsx")
devtools::install_version("dbplyr", version = "2.3.4")
install.packages("BMS")
install.packages("MuMIn")
install.packages("NbClust")
install.packages("factoextra")
BiocManager::install("clusterProfiler")
BiocManager::install("treeio")
BiocManager::install("org.Mmu.eg.db")
library(Seurat)
library(nipals)
library(VennDiagram)
library(UpSetR)
library(GOSim)
library(ade4)
library(ggplot2)
library(phytools)
library(caper)
library(ape)
library(nlme)
library(geiger)
library(readxl)
library(openxlsx)
library(ggpubr)
library(BMS)
library(MuMIn)
library(pheatmap)
library(NbClust)
library(factoextra)
library(clusterProfiler)
library(RColorBrewer)
library(multcomp)
library(AICcmodavg)
library(lme4)
library(biomaRt)
library(karyoploteR)
library(regioneR)
library(dplyr)
library(ggplot2)
library(treeio)
library(ggtree)
setwd("~/R/immunity/")

##################################################################################################################
#
##################################################################################################################
GO = read.table("/home/zhangxp/genome/immunity/immune_genes/GO", header = F)
KEGG = read.table("/home/zhangxp/genome/immunity/immune_genes/KEGG", header = F)
HP = read.table("/home/zhangxp/genome/immunity/immune_genes/HP", header = F)
InnateDB = read.table("/home/zhangxp/genome/immunity/immune_genes/InnateDB", header = F)
Immport = read.table("/home/zhangxp/genome/immunity/immune_genes/Immport", header = F)
elife = read.table("/home/zhangxp/genome/immunity/immune_genes/elife",header = F)
all_immune = unique(c(GO$V1, KEGG$V1, HP$V1, InnateDB$V1, Immport$V1, elife$V1))

my_plot <- venn.diagram(list(gprofile=gprofile$V1,InnateDB=InnateDB$V1,Immport = Immport$V1, elife = elife$V1),filename = NULL,lty = "dotted",lwd = 2,col = "black",  fill = c("dodgerblue", "goldenrod1",  "seagreen3", "orchid3"),alpha = 0.60,cat.col = c("dodgerblue", "goldenrod1", "seagreen3", "orchid3"),cat.cex = 0.8,cat.fontface = "italic",margin = 0.1,cex = 0.8)
ggsave(my_plot, file="my_plot.pdf", device = "pdf", height = 6, width = 6)

up_plot = list(GO = GO$V1, KEGG = KEGG$V1, HP = HP$V1, InnateDB = InnateDB$V1,
               Immport = Immport$V1, elife = elife$V1)
upset(fromList(up_plot), order.by = "freq",line.size = 0.5,nsets = 6)


##################################################################################################################
#PCA immune
##################################################################################################################

og_w_free = read.table("/home/zhangxp/R/immune_w/og_pca_no_outgroup", header = T, sep = "\t")
row.names(og_w_free) = og_w_free$Species
og_w_free = og_w_free[,-1]
og_w_free = og_w_free[, colSums(is.na(og_w_free)) <= 5]
#去除所有数据均为重复的列，不加此步容易报错
og_w_free = log10(og_w_free)
og_w_free <- og_w_free[, - which(sapply(og_w_free, function(col) length(unique(na.omit(col))) == 1))]
impute_species = sort(rowSums(is.na(og_w_free)))

og_w_fitted = nipals(og_w_free, fitted=T, center = T, scale = T)
og_score = og_w_fitted$scores
og_pca =  prcomp(og_w_fitted$fitted,  center = T, scale. = T)
og_pca_x = data.frame(og_pca$x)
View(og_pca_x)
write.table(og_pca_x, file = "/home/zhangxp/genome/immunity/immune_w/og_pca_x", sep = "\t", row.names = T,quote = F)

##################################################################################################################
#Trace
##################################################################################################################
Pri_tree<-read.tree("/home/zhangxp/R/immune_w/itols_newick.txt")
character = data.frame(row.names = row.names(og_pca_x), PC1 = -og_pca_x$PC1)
write.table(character, file = "~/character", row.names = T, quote = F)
species_list = read.table("/home/zhangxp/R/immune_w/species_list", header = F)
character_s = as.matrix(data.frame(row.names =rev(species_list$V1), PC1 = rev(character[match(species_list$V1, row.names(character)),])))
dotTree(Pri_tree,character_s,length=10,ftype="i")
character_s = setNames(character_s[,1],rownames(character_s))
obj<-contMap(Pri_tree,character_s,plot=FALSE)
obj<-setMap(obj,invert=TRUE)
plot(obj,fsize=c(0.8,1),outline=F,lwd=c(3,7),leg.txt="dn/ds")

##################################################################################################################
#PGLS with caper
##################################################################################################################
trait <- read.xlsx("/home/zhangxp/R/immune_w/Primate_species_list_new.xlsx")
#trait = trait[- which(rowSums(is.na(trait)) >= 1), ]
trait$Species = gsub(' ', '_', trait$Species)
trait$w = character[match(trait$Species, row.names(character)),]
trait$GroupSize = as.numeric(trait$GroupSize)
trait$BodyMass = trait$BodyMass/1000
trait_TB = na.omit(trait[,c(1,2,3)])
model_testes_body = lm(log10(TestesWeight) ~ log10(BodyMass), trait_TB)
trait_TB$resid_testes_body = resid(model_testes_body)
trait$resid_testes_body = trait_TB$resid_testes_body[match(trait$Species,trait_TB$Species)]
##################################################################################################################
#PGLS with caper
##################################################################################################################
trait_TG = na.omit(trait[,c("Species","GroupSize","w","resid_testes_body")])
trait_TG[!(trait_TG$Species %in% trait_all$Species),]
#trait_TG = trait_TG[-which(trait_TG$Species == "Homo_sapiens"),]
comp.data1<-comparative.data(Pri_tree, trait_TG, names.col="Species", vcv.dim=3, warn.dropped=TRUE)
modelo1<-pgls(w~ resid_testes_body+log(GroupSize), data=comp.data1, lambda ='ML')
modelo2<-pgls(w~ resid_testes_body+log(GroupSize), data=comp.data1, kappa ='ML')
modelo3<-pgls(w~ resid_testes_body+log(GroupSize), data=comp.data1, delta ='ML')
model_set <- list(modelo1, modelo2, modelo3)
model_weights1 <- model.sel(model_set, rank = BIC)
aaa = anova(modelo2)

modelo4<-pgls(w~ resid_testes_body, data=comp.data1, kappa ='ML')
model_set <- list(modelo2, modelo4)
model_weights2 <- model.sel(model_set, rank = BIC)

trait_TD = trait[,c("Species","Diet","w","resid_testes_body")]
comp.data2<-comparative.data(Pri_tree, trait_TD, names.col="Species", vcv.dim=3, warn.dropped=TRUE)
modelo1<-pgls(w~ resid_testes_body+Diet, data=comp.data2, lambda ='ML')
modelo2<-pgls(w~ resid_testes_body+Diet, data=comp.data2, kappa ='ML')
modelo3<-pgls(w~ resid_testes_body+Diet, data=comp.data2, delta ='ML')
model_set <- list(modelo1, modelo2, modelo3)
model_weights1 <- model.sel(model_set, rank = BIC)
anova(modelo2)
modelo4<-pgls(w~ resid_testes_body, data=comp.data2, kappa ='ML')
model_set <- list(modelo2, modelo4)
model_weights2 <- model.sel(model_set, rank = BIC)

impute_species = c('Pongo_abelii','Hylobates_pileatus','Macaca_assamensis','Cercocebus_atys',
                   'Cercopithecus_albogularis','Cercopithecus_mona','Chlorocebus_sabaeus',
                   'Trachypithecus_crepuscula','Pygathrix_nigripes','Colobus_angolensis',
                   'Aotus_nancymaae','Cebus_albifrons')

trait_all = na.omit(trait[,c("Species","SocialSystem","w","resid_testes_body","GroupSize","Diet")])
trait_all = subset(trait_all, !(Species %in% impute_species))
comp.data3<-comparative.data(Pri_tree, trait_all, names.col="Species", vcv.dim=3, warn.dropped=TRUE)
modelo1<-pgls(w~ resid_testes_body+SocialSystem+GroupSize+Diet, data=comp.data3, lambda ='ML')
modelo2<-pgls(w~ resid_testes_body+SocialSystem+GroupSize+Diet, data=comp.data3, kappa ='ML')
modelo3<-pgls(w~ resid_testes_body+SocialSystem+GroupSize+Diet, data=comp.data3, delta ='ML')
model_set <- list(modelo1, modelo2, modelo3)
model_weights1 <- model.sel(model_set, rank = BIC)
anova(modelo3)
modelo4<-pgls(w~ resid_testes_body, data=comp.data3, kappa ='ML')
model_set <- list(modelo2, modelo4)
model_weights2 <- model.sel(model_set, rank = BIC)

trait_filtered <- subset(trait_all, !Species %in% names(impute_species[48:52]))
comp.data3 <- comparative.data(Pri_tree, trait_filtered,
                               names.col="Species", vcv.dim=3, warn.dropped=TRUE)

modelo1 <- pgls(w ~ resid_testes_body + SocialSystem + GroupSize + Diet,
                data = comp.data3, lambda='ML')
anova(modelo1)


##################################################################################################################


trait_TS = na.omit(trait[,c("Species","SocialSystem","w","resid_testes_body")])
trait_TS[!(trait_TS$Species %in% trait_all$Species),]

comp.data3<-comparative.data(Pri_tree, trait_TS, names.col="Species", vcv.dim=3, warn.dropped=TRUE)
modelo1<-pgls(w~ resid_testes_body+SocialSystem, data=comp.data3, lambda ='ML')
modelo2<-pgls(w~ resid_testes_body+SocialSystem, data=comp.data3, kappa ='ML')
modelo3<-pgls(w~ resid_testes_body+SocialSystem, data=comp.data3, delta ='ML')
model_set <- list(modelo1, modelo2, modelo3)
model_weights1 <- model.sel(model_set, rank = BIC)
anova(modelo2)
modelo4<-pgls(w~ resid_testes_body, data=comp.data3, kappa ='ML')
model_set <- list(modelo2, modelo4)
model_weights2 <- model.sel(model_set, rank = BIC)

fit = aov(w ~ SocialSystem , data = trait_TS)
TukeyHSD(fit)
comparsion1 = list(c("Polygynandry","Pair"))
trait_TS$SocialSystem = factor(trait_TS$SocialSystem, levels = c("Polygynandry","Polygyny","Pair","Solitary"))
p2 = ggboxplot(trait_TS, x = "SocialSystem", y = "w", fill = "SocialSystem" , palette = "npg")+
  stat_compare_means(comparisons = comparsion1, 
  method = "wilcox.test", label = "p.signif")

trait_TS$SocialSystem = factor(trait_TS$SocialSystem)
comp <-  multComp(glm.D93,factor.id = "SocialSystem")
modelo1<-pgls(w~ SocialSystem, data=comp.data3, lambda ='ML')
anova(modelo1)
modelo1<-lm(w~ SocialSystem, data=trait_TS)




trait_TB = na.omit(trait[,c("Species","w","resid_testes_body")])
comp.data4<-comparative.data(Pri_tree, trait_TB, names.col="Species", vcv.dim=3, warn.dropped=TRUE)
modelo1<-pgls(w~ resid_testes_body, data=comp.data4, kappa ='ML')
summary(modelo1)
cor(trait_TB$w~trait_TB$resid_testes_body)
Intercept = modelo1$model$coef[1]
Slope = modelo1$model$coef[2]
trait_TB$n = c(1:nrow(trait_TB))
trait_TB$clade = c(rep("Hominoidea", 9),rep("Cercopithecoidea",18),rep("Platyrrhini",6),rep("Strepsirrhini",7))
p1 = ggscatter(trait_TB, x= "resid_testes_body", y="w",size = 4, color = "clade", alpha = .4, palette = "npg")+
  geom_abline(intercept = Intercept, slope = Slope, color = "black")+xlim(-1,1)+ylim(-30,30)
  
  
  geom_segment(aes(x = -0.9, xend = 0.9, y = -9.886279 + -0.9*10.0747, yend = -9.886279 + 0.9*10.0747))+xlim(-1,1)+ylim(-30,30)
  
  
ggscatter(trait_TB, x= "resid_testes_body", y="w",size = 4, color = "clade", alpha = .4, palette = "npg")+ 
  geom_smooth(data = trait_TB,
              method = "lm", formula = y ~ x, se = F, color = "blue", fill = "lightgray")+xlim(-1,1)+ylim(-30,30)

ggarrange(p1, p2, ncol = 2, align = c("v"))


pp_trait = na.omit(trait[,c("Species","TestesWeight")])
row.names(pp_trait) = pp_trait$Species
p_trait = data.frame(TB = pp_trait[,-c(1,3)],row.names = row.names(pp_trait))



pheatmap(p_trait, cluster_rows = F, cluster_cols = F, show_rownames = T, show_colnames = T, 
         fontsize = 10, border_color = NA, border=T, cellwidth = 20, cellheight = 15, 
         display_numbers = p_trait)


##################################################################################################################
#PGLS with caper for each gene
##################################################################################################################
trait_TB = na.omit(trait[,c("Species","w","resid_testes_body")])
og_species_pca = read.table("/home/zhangxp/R/immune_w/og_species_pca", header = T)
og_species_pca <- og_species_pca[, - which(sapply(og_species_pca, function(col) length(unique(na.omit(col))) == 1))]

Pvalue_TB = data.frame()
og_colnames = colnames(og_species_pca)

for (i in 2:ncol(og_species_pca)) {
  trait_TB$w = og_species_pca[match(trait_TB$Species, og_species_pca$Species), i]
  trait_trim = na.omit(trait_TB)
  trait_trim$w = log10(as.numeric(trait_trim$w))
  if(length(unique(trait_trim$w)) == 1){next}
  comp.data <- comparative.data(Pri_tree, trait_trim, names.col="Species", vcv.dim=3, warn.dropped=TRUE)
  result <- tryCatch(
  {pgls(w ~ resid_testes_body, data=comp.data, kappa ='ML')}, 
  error = function(e) { return(NULL) })
  if (!is.null(result)) {
    modelo_aov = anova(result)
    Pvalue_TB =  rbind(Pvalue_TB, data.frame(og = og_colnames[i], pvalue = modelo_aov$`Pr(>F)`[1]))
  }
}

##################################################################################################################
#dn/ds cluster
##################################################################################################################
BiocManager::install("org.Hs.eg.db")
library("org.Hs.eg.db")
library(NbClust)
library(reshape)
setwd("~/R/immunity/")
immune_OG = read.table("immune_OG", header = T)
og_nodes_pca = read.csv("~/R/immune_w/og_nodes_pca", sep = "\t", header = T)
row.names(og_nodes_pca) = og_nodes_pca$Species
og_nodes_pca = og_nodes_pca[,-1]
og_nodes_pca = data.frame(t(og_nodes_pca))
og_nodes_pca = og_nodes_pca[,c(15,18,19,7,1,8,13,14,12,10,3,6,17,4,9,16,11)]
colnames(og_nodes_pca) = c("Outclade", "Primates","Strepsirrhini",
                           "Haplorrhini","C_bancanus","H_Primates","N_Primates",
                           "O_Primates","Monkeys","Hominoidea","Gibbons",
                           "Great_Apes","Pongo","Gorilla","Hom_pan","Pan","Human")
node = c("Outclade", "Primates","Strepsirrhini",
         "Haplorrhini","C_bancanus","H_Primates","N_Primates",
         "O_Primates","Monkeys","Hominoidea","Gibbons",
         "Great_Apes","Pongo","Gorilla","Hom_pan","Pan","Human")
og_nodes_pca = na.omit(og_nodes_pca)
og_nodes_pca = log10(og_nodes_pca)
og_nodes_pca = og_nodes_pca[- which(apply(og_nodes_pca, 1,function(col) length(unique(na.omit(col))) ==1)),]

dim(og_nodes_pca)
#cluster
res_kmeans <-NbClust(og_nodes_pca, distance = "euclidean", min.nc=3, max.nc=20,
                     method = "kmeans", index = "all")
res_complete <-NbClust(og_nodes_pca, distance = "euclidean", min.nc=3, max.nc=20,
                       method = "complete", index = "all")
res_ward <-NbClust(og_nodes_pca, distance = "euclidean", min.nc=3, max.nc=20,
                   method = "ward.D2", index = "all")

res_ward2 <-NbClust(og_nodes_pca, distance = "euclidean", min.nc=5, max.nc=20,
                   method = "ward.D2", index = "all")



res_kmeans$Best.nc
res_complete$Best.nc
res_ward$Best.nc
res_ward2$Best.nc

E.dist <- dist(og_nodes_pca, method="euclidean")
h.E.cluster <- hclust(E.dist, method="ward.D2")
cut.h.cluster <- cutree(h.E.cluster, k=17)
plot(h.E.cluster)
abline(h=61, col="red")

E.kmeans = kmeans(og_nodes_pca, centers = 13)

table(E.kmeans$cluster)
table(cut.h.cluster)


