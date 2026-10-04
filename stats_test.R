#setwd("C:\\Users\\galde\\OneDrive\\Documents\\true_dataPredictionPytorch")
library(ggplot2)
library(readxl)
library(patchwork)
pass_info = read.csv("train.csv", header = TRUE)
survived = read.csv("survivaldata.csv", header = TRUE)
model_predictions = read_excel(path = "predictions.xlsx", range="B1:C713")
true_data = cbind(pass_info, survived)

true_data$PassengerId = NULL
true_data$Age = true_data$Age + 30
true_data$Fare = true_data$Fare + 35
true_data$Sex = ifelse(true_data$Sex == 1, "Male", "Female")
true_data$Pclass = true_data$Pclass + 2
true_data$Survived = ifelse(true_data$Survived == 1, "Survived", "Died")

model_predictions$Prediction = ifelse(model_predictions$Prediction == 1, "Survived", "Died")
combined_data = cbind(true_data, model_predictions)
combined_data$PassengerId = NULL


options(scipen=9999)
performance = read_excel(path = 'performance.xlsx', range="B1:C1001")
plot(performance*100, pch = 20, ylim=c(60,100))
plot(performance*100, log="x", pch = 20, ylim=c(60,100))

confusion_matrix = table(
  Actual = combined_data$Survived,
  Predicted = combined_data$Prediction
)
confusion_matrix

TN = confusion_matrix["Died", "Died"]
FP = confusion_matrix["Died", "Survived"]
FN = confusion_matrix["Survived", "Died"]
TP = confusion_matrix["Survived", "Survived"]

accuracy = (TP + TN) / sum(confusion_matrix)
precision = TP / (TP + FP)

accuracy
precision



p1 = ggplot(combined_data, aes(x = Sex, fill = Survived)) +
  geom_bar(position = "fill") +
  labs(
    title = "Actual",
    x = "Sex",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()

p2 = ggplot(combined_data, aes(x = Sex, fill = Prediction)) +
  geom_bar(position = "fill") +
  labs(
    title = "Predicted",
    x = "Sex",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()

p1 + p2 + 
  plot_layout(ncol = 2, guides = "collect") +
  plot_annotation(title = "Actual vs Predicted Survival by Sex")


p3 = ggplot(combined_data, aes(x = Pclass, fill = Survived)) +
  geom_bar(position = "fill") +
  labs(
    title = "Actual",
    x = "Class",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()


p4 = ggplot(combined_data, aes(x = Pclass, fill = Prediction)) +
  geom_bar(position = "fill") +
  labs(
    title = "Predicted",
    x = "Class",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()

p3 + p4 + 
  plot_layout(ncol = 2, guides = "collect") +
  plot_annotation(title = "Actual vs Predicted Survival by Passenger Class")

p5 = ggplot(combined_data, aes(x = SibSp, fill = Survived)) +
  geom_bar(position = "fill") +
  labs(
    title = "Actual",
    x = "No. of siblings or parents",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()+
  scale_x_continuous(breaks = seq(0, 5, by = 1))

p6 = ggplot(combined_data, aes(x = SibSp, fill = Prediction)) +
  geom_bar(position = "fill") +
  labs(
    title = "Predicted",
    x = "No. of siblings or parents",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()+
  scale_x_continuous(breaks = seq(0, 5, by = 1))

p5 + p6 + 
  plot_layout(ncol = 2, guides = "collect") +
  plot_annotation(title = "Actual vs Predicted Survival by number of siblings\nor parents onboard")


chisq.test(table(combined_data$Sex, combined_data$Survived))
chisq.test(table(combined_data$Sex, combined_data$Prediction))
chisq.test(table(combined_data$Pclass, combined_data$Survived))
chisq.test(table(combined_data$Pclass, combined_data$Prediction))
chisq.test(table(combined_data$Parch, combined_data$Survived))
