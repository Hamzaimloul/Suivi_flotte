library(tidyverse)
library(readxl)
library(xml2)

#'*import datasets*

units = read.csv("c:/Users/Admin/Documents/R/Git/Driver-Behavior-Cluster/units.csv")
df = read.csv("c:/Users/Admin/Documents/R/Git/Driver-Behavior-Cluster/overview.csv")

#'*VISUALIZATION*
df %>%
  select(id, fuelr, fuelc) %>%
  left_join(units, by = c("id"="id")) %>%
  mutate(service_date = difftime(Sys.Date(), service_date) %>% as.numeric()) %>%
  ggplot(aes(service_date, fuelr)) +
  geom_point() +
  theme_bw()

df %>%
  select(id, fuelc, fuelr) %>%
  left_join(units, by = c("id"="id")) %>%
  mutate(service_date = difftime(Sys.Date(), service_date) %>% as.numeric()) %>%
  ggplot(aes(fuelc, fuelr)) +
  geom_point()+
  theme_bw()

df %>%
  select(id, dist, fuelc) %>%
  left_join(units, by = c("id"="id")) %>%
  mutate(service_date = difftime(Sys.Date(), service_date) %>% as.numeric()) %>%
  ggplot(aes(dist, fuelc, colour = service_date)) +
  geom_point()+
  theme_bw() + 
  geom_smooth()

df %>%
  select(id, dist, idle) %>%
  left_join(units, by = c("id"="id")) %>%
  mutate(service_date = difftime(Sys.Date(), service_date) %>% as.numeric()) %>%
  ggplot(aes(dist,idle, colour = service_date)) +
  geom_point()+
  theme_bw() + 
  geom_smooth() + 
  geom_label(aes(label = id))

df %>%
  select(id, dist, idle) %>%
  left_join(units, by = c("id"="id")) %>%
  mutate(service_date = difftime(Sys.Date(), service_date) %>% as.numeric()) %>%
  ggplot(aes(dist,idle, colour = service_date)) +
  geom_point()+
  theme_bw() + 
  geom_smooth() + 
  geom_label(aes(label = id))

#'*NORMALISATION*
df.norm = 
  df %>%
  select(-c(id)) %>%
  scale()

#'*CORRELATION MATRIX*
pairs(df)

#'*CLUSTRING*
#'*Distance Method - Clustring*

#--------------------------------------------------
names(df)
data = df %>% select(idle, dist)
plot(data)
testdata = data  # To keep our dataset safe, let's create a copy of it called "testdata"
testdata = scale(testdata) # normalization

d = dist(testdata, method = "euclidean") # the dist() function computes the distances of all the observations in our dataset
hcward = hclust(d, method="ward.D") # hclust() function performs hiearchical clustering, we pass it the distances, and we set the method argument to "ward.D"

data$groups = cutree(hcward,k=4) # assign our points to our k=3 clusters 

# The lattice library provides a complete set of functions for producing advanced plots.
library(lattice)
xyplot(idle ~ dist, main = "After Clustering", type="p",group=groups,data=data, # define the groups to be differentiated 
       auto.key=list(title="Group", space = "left", cex=1.0, just = 0.95), # to produce the legend we use the auto.key= list() 
       par.settings = list(superpose.line=list(pch = 0:18, cex=1)), # the par.settings argument allows us to pass a list of display settings
       col=c('blue','green','red', "orange"))

#--------------------------------------------------

d = dist(df.norm, method = "euclidean")
hcward = hclust(d, method="ward.D") # hclust() function performs hiearchical clustering, we pass it the distances, and we set the method argument to "ward.D"

df$groups = cutree(hcward,k=4) # assign our points to our k=4 clusters 
aggdata = aggregate(.~ groups, data=df, FUN=mean) # The aggregate() function presents a summary of a statistic, broken down by one or more groups. Here we compute the mean of each variable for each group. 

# One thing we would like to have is the proportion of our data that is in each cluster
proptemp=aggregate(dist~ groups, data=df, FUN=length) # we create a variable called proptemp which computes the number of observations in each group (using the S variable, but you can take any.)
aggdata$proportion=(proptemp$dist)/sum(proptemp$dist)*50 # proportion of observations in each group we compute the ratio between proptemp and the total number of observations
aggdata=aggdata[order(aggdata$proportion,decreasing=T),] # Let's order the groups from the larger to the smaller

# Let's see the output by calling our aggdata variable
aggdata

cluster.df = df %>% select(id, groups) %>% arrange(groups)
cluster.df

#'*K-MEANS*
k_mn = kmeans(df.norm, 3)
k_mn$cluster

#'*PCA*
pca.out = prcomp(df %>% select(-c("id")), scale = TRUE)
biplot(pca.out, scale = 0)
#---------------------------------------------------------------------------------------------
ccc = matrix(pca.out$sdev)
apply(ccc*ccc,2,sum)
