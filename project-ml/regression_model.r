# build a regression ,odel

head(mtcars)

model <- lm(mpg ~ hp + wt, data = mtcars)

summary(model
