options(repos = c(CRAN = "https://cloud.r-project.org"))

# install.packages("conleyreg")
# install.packages("stargazer")

library(conleyreg)           
library(stargazer)

data <- read.csv("/Users/jpmvbastos/Documents/GitHub/ColonialLegacy/Data/colonies-final.csv")


conleyreg(avg_efw ~ efw_colonizer, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer, data, 10000, lat = "lat", lon = "lon")

conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island, data, 10000, lat = "lat", lon = "lon")

conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s, data, 1000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s, data, 2500, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s, data, 5000, lat = "lat", lon = "lon")
conleyreg(avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island + ruggedness + logem4 + lpd1500s, data, 10000, lat = "lat", lon = "lon")

### Table 4

# Column 1: Post-1850
model_post_1850 <- conleyreg(
  avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island +
             ruggedness + lpd1500s,
  data = subset(data, first >= 1850),
  cutoff = 1000, lat = "lat", lon = "lon"
)

# Column 2: No Africa
model_no_africa <- conleyreg(
  avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island +
             ruggedness + lpd1500s,
  data = subset(data, africa != 1),
  cutoff = 1000, lat = "lat", lon = "lon"
)

# Column 3: No Americas
model_no_americas <- conleyreg(
  avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island +
             ruggedness + lpd1500s,
  data = subset(data, america != 1),
  cutoff = 1000, lat = "lat", lon = "lon"
)

# Column 4: Without neo-Europes
model_no_rich4 <- conleyreg(
  avg_efw ~ efw_colonizer + america + africa + asia + lat_abst + landlock + island +
             ruggedness + lpd1500s,
  data = subset(data, rich4 != 1),
  cutoff = 1000, lat = "lat", lon = "lon"
)

