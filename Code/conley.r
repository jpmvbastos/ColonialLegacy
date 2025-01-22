options(repos = c(CRAN = "https://cloud.r-project.org"))

# install.packages("conleyreg")
# install.packages("stargazer")

library(conleyreg)           
library(stargazer)

data <- read.csv("/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/Data/colonies-final.csv")

conleyreg(avg_efw ~ efw_colonizer, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer, data, 10000, lat = "lat", lon = "lon")

conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 10000, lat = "lat", lon = "lon")

conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s, data, 10000, lat = "lat", lon = "lon")

### Table 4

# Create data subsets 
d1 <- subset(data, first >= 1850)
d2 <- subset(data, africa != 1)
d3 <- subset(data, america!= 1)
d4 <- subset(data, rich4 != 1)

# Column 1: Post-1850
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + 
        landlock + island +ruggedness + lpd1500s, d1, 5000, lat = "lat", lon = "lon")

# Column 2: No Africa
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island +
             ruggedness + lpd1500s,d2, 5000, lat = "lat", lon = "lon"
)

# Column 3: No Americas
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island +
             ruggedness + lpd1500s,d3, 5000, lat = "lat", lon = "lon")

# Column 4: Without neo-Europes
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island +
             ruggedness + lpd1500s, d4,  5000, lat = "lat", lon = "lon")




### To get the error message

conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 
                                + lpd1500s + temp1 + temp2 + temp3+ temp4 + temp5 + steplow + deslow +
				stepmid + desmid + drystep + hiland + drywint + goldm  + iron  + silv + zinc +
				oilres  + legor_uk + legor_fr, data, 10000, lat = "lat", lon = "lon")