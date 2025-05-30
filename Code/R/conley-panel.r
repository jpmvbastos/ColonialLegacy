options(repos = c(CRAN = "https://cloud.r-project.org"))

# install.packages("conleyreg")
# install.packages("stargazer")
install.packages("haven")

# Load packages
library(haven)
library(conleyreg)           
library(stargazer)

# Read the Stata file
data <- read_dta("/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/Data/ColonialEFW_Panel.dta")
data$oilres <- data$oilres / 1000

filtered_complete_cases <- complete.cases(data[c("efw", "hiel_indep", "time","year")]) & 
                           data$year >= data$year_independence
data1 <- data[filtered_complete_cases, ]

data1$indep_from <- as.factor(data1$indep_from)

# Create colonizer dummies
data1$colonizer <- as.factor(data1$colonizer)

# Create year dummies 
data1$yearf <- as.factor(data1$year)

# Column 1 
conleyreg(efw ~ hiel_indep * time + year + yearf, data1, 1000, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf, data1, 2500, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf, data1, 5000, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf, data1, 10000, lat = "lat", lon = "lon")

# Column 2 
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s, data1, 1000, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s, data1, 2500, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s, data1, 5000, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s, data1, 10000, lat = "lat", lon = "lon")

# Column 3 
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s + humid1 + humid2 + humid3 + humid4 + 
    temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + desmid + 
    drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + legor_uk + 
    legor_fr + indep_from, data1, 1000, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s + humid1 + humid2 + humid3 + humid4 + 
    temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + desmid + 
    drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + legor_uk + 
    legor_fr + indep_from, data1, 2500, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s + humid1 + humid2 + humid3 + humid4 + 
    temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + desmid + 
    drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + legor_uk + 
    legor_fr + indep_from, data1, 5000, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s + humid1 + humid2 + humid3 + humid4 + 
    temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + desmid + 
    drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + legor_uk + 
    legor_fr + indep_from, data1, 10000, lat = "lat", lon = "lon")


#Column 4
conleyreg(efw ~ efw_colonizer * time + year + yearf, data1, 1000, lat = "lat", lon = "lon")
conleyreg(efw ~ efw_colonizer * time + year + yearf, data1, 2500, lat = "lat", lon = "lon")
conleyreg(efw ~ efw_colonizer * time + year + yearf, data1, 5000, lat = "lat", lon = "lon")
conleyreg(efw ~ efw_colonizer * time + year + yearf, data1, 10000, lat = "lat", lon = "lon")

#Column 5
conleyreg(efw ~ efw_colonizer * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s, data1, 1000, lat = "lat", lon = "lon")
conleyreg(efw ~ efw_colonizer * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s, data1, 2500, lat = "lat", lon = "lon")
conleyreg(efw ~ efw_colonizer * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s, data1, 5000, lat = "lat", lon = "lon")
conleyreg(efw ~ efw_colonizer * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s, data1, 10000, lat = "lat", lon = "lon")

#Column 6
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s + humid1 + humid2 + humid3 + humid4 + 
    temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + desmid + 
    drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + legor_uk + 
    legor_fr + colonizer, data1, 1000, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s + humid1 + humid2 + humid3 + humid4 + 
    temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + desmid + 
    drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + legor_uk + 
    legor_fr + colonizer, data1, 2500, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s + humid1 + humid2 + humid3 + humid4 + 
    temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + desmid + 
    drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + legor_uk + 
    legor_fr + colonizer, data1, 5000, lat = "lat", lon = "lon")
conleyreg(efw ~ hiel_indep * time + year + yearf + america + africa + asia + lat_abst + landlock + 
    island + ruggedness + logem4 + lpd1500s + humid1 + humid2 + humid3 + humid4 + 
    temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + desmid + 
    drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + legor_uk + 
    legor_fr + colonizer, data1, 10000, lat = "lat", lon = "lon")
