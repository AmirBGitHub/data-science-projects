
rm(list = setdiff(ls(), lsf.str()))

#setwd(paste("./CollegeScorecard_Raw_Data",sep=""))

#dataFiles <- lapply(Sys.glob("MERGED*.csv"), read.csv)

load("AllData.RData")

#finding institutions that have valid entries for this field across all 10 years.
INTSCTOPEID<-Reduce(intersect, list(dataFiles[[6]]$OPEID,
                                    dataFiles[[7]]$OPEID,
                                    dataFiles[[8]]$OPEID,
                                    dataFiles[[9]]$OPEID,
                                    dataFiles[[10]]$OPEID,
                                    dataFiles[[11]]$OPEID,
                                    dataFiles[[12]]$OPEID,
                                    dataFiles[[13]]$OPEID,
                                    dataFiles[[14]]$OPEID,
                                    dataFiles[[15]]$OPEID))

#extracting the data for undergraduate women who were seeking degrees
UGDS_WOMEN<-numeric()
for (i in 6:15){
  UGDS_WOMEN_TOT<-dataFiles[[i]]
  UGDS_WOMEN_TEMP<-data.frame(UGDS_WOMEN_TOT[,1741][match(INTSCTOPEID,dataFiles[[i]]$OPEID)])
  UGDS_WOMEN<-data.frame(append(UGDS_WOMEN,UGDS_WOMEN_TEMP))
}

#concatenation data in one matrix and finding average for valid entries
mm <- as.matrix(UGDS_WOMEN)
mm<-as.numeric(mm)
UGDS_WOMEN_MTX <- matrix(mm, ncol = ncol(UGDS_WOMEN), dimnames = NULL)
UGDS_WOMEN_AVGSCHL<-rowMeans(UGDS_WOMEN_MTX, na.rm = FALSE)
UGDS_WOMEN_AVG<-mean(UGDS_WOMEN_AVGSCHL,na.rm = TRUE)
options(digits=10)

# UGDS_WOMEN_AVG = 0.6453985397




