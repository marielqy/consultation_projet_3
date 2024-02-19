
library(margins)

library(haven)
df <- read_sav("Desktop/u de m/2/consultation/projet3/new data.sav")
head(df)

df$recuperation <- ifelse(df$recuperation == "full", 1, 0)
unique(df$recuperation)
model <- glm(recuperation ~ age1 + CCL221 + CRP1 + NFL1, data = df, family = "binomial")
summary(model)

m <- margins(model)
summary(m)
round(-8.962e-09)