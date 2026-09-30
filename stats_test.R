setwd("C:\\Users\\galde\\OneDrive\\Documents\\TitanicPredictionPytorch")
library(ggplot2)
pass_info = read.csv("train.csv", header = TRUE)
survived = read.csv("survivaldata.csv", header = TRUE)
titanic = cbind(pass_info, survived)
head(titanic)
str(titanic)
titanic$PassengerId = NULL
titanic$Age = titanic$Age + 30
titanic$Fare = titanic$Fare + 35
titanic$Sex = ifelse(titanic$Sex == 1, "Male", "Female")
titanic$Survived = ifelse(titanic$Survived == 1, "Survived", "Died")


ggplot(titanic, aes(x = Sex, fill = factor(Survived))) +
  geom_bar(position = "fill") +
  labs(
    title = "Titanic Survival Proportion by Sex",
    x = "Sex",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()


chisq.test(table(titanic$Sex, titanic$Survived))

