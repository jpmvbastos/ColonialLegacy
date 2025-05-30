options(repos = c(CRAN = "https://cloud.r-project.org"))

# install.packages("conleyreg")
# install.packages("stargazer")
# install.packages("haven")

# Load packages
library(haven)
library(conleyreg)           
library(stargazer)

# Read the Stata file
data <- read_dta("/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/Data/ColonialEFW.dta")
data$oilres <- data$oilres / 1000

# Create colonizer at indep. dummies 
data$indep_from[is.na(data$indep_from)] <- "Unknown"
data$indep_from <- as.factor(data$indep_from)
dummies <- model.matrix(~ indep_from - 1, data = data)
data <- cbind(data, dummies)

# Create colonizer dummies
data$colonizer <- as.factor(data$colonizer)
dummies <- model.matrix(~ colonizer - 1, data = data)
data <- cbind(data, dummies)


length(data$colonizer_indep)

print(colonizer)

# Column 1
conleyreg(avg_efw ~ efw_colonizer, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer, data, 10000, lat = "lat", lon = "lon")

# Column 1
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 10000, lat = "lat", lon = "lon")

# Column 3
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8, data, 10000, lat = "lat", lon = "lon")

# Column 4
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 10000, lat = "lat", lon = "lon")

### Table 4: 

# Column 4
conleyreg(avg_efw ~ postwar + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s +
        indep_fromBritain + indep_fromFrance + indep_fromNetherlands + indep_fromPortugal + indep_fromSpain,
        subset(data, !is.na(colonizer_indep)), 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ postwar + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s +
        indep_fromBritain + indep_fromFrance + indep_fromNetherlands + indep_fromPortugal + indep_fromSpain,
        subset(data, !is.na(colonizer_indep)), 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ postwar + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s +
        indep_fromBritain + indep_fromFrance + indep_fromNetherlands + indep_fromPortugal + indep_fromSpain,
        subset(data, !is.na(colonizer_indep)), 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ postwar + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s +
        indep_fromBritain + indep_fromFrance + indep_fromNetherlands + indep_fromPortugal + indep_fromSpain,
        subset(data, !is.na(colonizer_indep)), 10000, lat = "lat", lon = "lon")

# Column 5 
data$postwar_hiel <- data$postwar * data$hiel_indep
conleyreg(avg_efw ~ postwar + hiel_indep + postwar_hiel + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s +
        indep_fromBritain + indep_fromFrance + indep_fromNetherlands + indep_fromPortugal + indep_fromSpain,
        subset(data, !is.na(colonizer_indep)), 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ postwar + hiel_indep + postwar_hiel + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s +
        indep_fromBritain + indep_fromFrance + indep_fromNetherlands + indep_fromPortugal + indep_fromSpain,
        subset(data, !is.na(colonizer_indep)), 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ postwar + hiel_indep + postwar_hiel + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s +
        indep_fromBritain + indep_fromFrance + indep_fromNetherlands + indep_fromPortugal + indep_fromSpain,
        subset(data, !is.na(colonizer_indep)), 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ postwar + hiel_indep + postwar_hiel + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s +
        indep_fromBritain + indep_fromFrance + indep_fromNetherlands + indep_fromPortugal + indep_fromSpain,
        subset(data, !is.na(colonizer_indep)), 10000, lat = "lat", lon = "lon")


## Table 5 
# Create the share_euro2 variable based on conditions
data$share_euro2 <- data$share_euro
data$share_euro2[data$country == "Barbados" | data$country == "Bahamas"] <- 0.2743236
data$share_euro2[data$country == "New Zealand"] <- 0.9736003

# Multiply specified variables by 100
vars_to_multiply <- c("euro_share", "share_euro", "share_euro2")
data[vars_to_multiply] <- data[vars_to_multiply] * 100

## Panel A 

data$hiel_euro_share <- data$efw_colonizer * data$euro_share

# Column 1 
conleyreg(avg_efw ~ efw_colonizer + euro_share, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + euro_share, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + euro_share, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + euro_share, data, 10000, lat = "lat", lon = "lon")

#Column 2 
conleyreg(avg_efw ~ efw_colonizer + euro_share + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + euro_share + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + euro_share + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + euro_share + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 10000, lat = "lat", lon = "lon")

# Column 3 -- None significant 


# Column 4 
conleyreg(avg_efw ~ efw_colonizer + euro_share + hiel_euro_share, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + euro_share + hiel_euro_share, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + euro_share + hiel_euro_share, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + euro_share + hiel_euro_share, data, 10000, lat = "lat", lon = "lon")

# Column 5 -- None significant 
# Column 6 -- None significant 


## Panel B

data$hiel_share_euro <- data$efw_colonizer * data$share_euro

# Column 1 
conleyreg(avg_efw ~ efw_colonizer + share_euro, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro, data, 10000, lat = "lat", lon = "lon")

#Column 2 
conleyreg(avg_efw ~ efw_colonizer + share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 10000, lat = "lat", lon = "lon")

#Column 3 
conleyreg(avg_efw ~ efw_colonizer + share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 10000, lat = "lat", lon = "lon")

# Column 4 
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro, data, 10000, lat = "lat", lon = "lon")

#Column 5 
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 10000, lat = "lat", lon = "lon")

# Column 6

conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro + hiel_share_euro + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 10000, lat = "lat", lon = "lon")



## Panel B=C

data$hiel_share_euro2 <- data$efw_colonizer * data$share_euro2

# Column 1 
conleyreg(avg_efw ~ efw_colonizer + share_euro2, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2, data, 10000, lat = "lat", lon = "lon")

#Column 2 
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 10000, lat = "lat", lon = "lon")

#Column 3 
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 10000, lat = "lat", lon = "lon")

# Column 4 
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2, data, 10000, lat = "lat", lon = "lon")

#Column 5 
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + lpd1500s,
         data, 10000, lat = "lat", lon = "lon")

# Column 6

conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + share_euro2 + hiel_share_euro2 + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s +
        humid1 + humid2 + humid3 + humid4 + temp1 + temp2 + temp3 + temp4 + temp5 + steplow + deslow + stepmid + 
        desmid + drystep + hiland + drywint + goldm + iron + silv + zinc + oilres + colonizer2 + colonizer3 + colonizer4 + 
        colonizer5 + colonizer6 + colonizer7 + colonizer8 + legor_uk + legor_fr, data, 10000, lat = "lat", lon = "lon")
