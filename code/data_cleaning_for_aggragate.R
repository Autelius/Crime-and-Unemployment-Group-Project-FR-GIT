#importing data sets

agg_unemployment <- read.csv("data/raw_data/aggragate_total_unemployment.csv")
agg_crime <- read.csv("data/raw_data/aggragate_total_crime.csv")

#cleaning data: removing unnecessary rows, for agg_crime till 1975

agg_unemployment <- agg_unemployment[-c(51,52) ,]
agg_unemployment <- agg_unemployment[, -1]

agg_crime <- agg_crime[-82 , ]
agg_crime <- agg_crime[-c(1:31) ,]
agg_crime <- agg_crime[, -1]

# giving colnames

colnames(agg_unemployment) = c("year", "unemployment")
colnames(agg_crime) = c("year", "total_crimes")

#merging the two data set

agg_merged <- cbind(agg_unemployment, agg_crime[, 2])


