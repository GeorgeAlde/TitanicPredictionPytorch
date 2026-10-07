setwd("C:\\Users\\galde\\OneDrive\\Documents\\TitanicPredictionPytorch")
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
true_data$Embarked = ifelse(
  true_data$Embarked == -1, "Southampton",ifelse(
    true_data$Embarked == 0, "Cherbourg",ifelse(
      true_data$Embarked == 1, "Queenstown", NA
    )
  ))


model_predictions$Prediction = ifelse(model_predictions$Prediction == 1, "Survived", "Died")
combined_data = cbind(true_data, model_predictions)
combined_data$PassengerId = NULL


options(scipen=9999)
performance = read_excel(path = 'performance.xlsx', range="B1:C1001")
plot(performance*100, pch = 20, ylim=c(50,100))
plot(performance*100, log="x", pch = 20, ylim=c(50,100))

options(scipen=0)


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
recall = TP / (TP + FN)
F1 = 2 * precision * recall / (precision + recall)

accuracy
precision
recall
F1
### Tests for survival based on sex ###

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

chisq.test(table(combined_data$Sex, combined_data$Survived))$p.value * 100
chisq.test(table(combined_data$Sex, combined_data$Prediction))$p.value * 100

### Tests for survival based on age ###

combined_data$AgeGroup = cut(
  combined_data$Age,
  breaks = c(0, 5, 10, 20, 40, 60, Inf),
  labels = c("0-5", "5-10", "10-20", "20-40", "40-60", "60+"),
  include.lowest = TRUE
)

p14 = ggplot(combined_data, aes(x = AgeGroup, fill = Survived)) +
  geom_bar(position = "fill") +
  labs(
    title = "Actual",
    x = "Age",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()+
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

p15 = ggplot(combined_data, aes(x = AgeGroup, fill = Prediction)) +
  geom_bar(position = "fill") +
  labs(
    title = "Predicted",
    x = "Age",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()+
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

p14 + p15 + 
  plot_layout(ncol = 2, guides = "collect") +
  plot_annotation(title = "Actual vs Predicted Survival by Age")

chisq.test(table(combined_data$AgeGroup, combined_data$Survived))$p.value * 100 
chisq.test(table(combined_data$AgeGroup, combined_data$Prediction))$p.value * 100

### Tests for survival based on passenger class ###

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

chisq.test(table(combined_data$Pclass, combined_data$Survived))$p.value * 100
chisq.test(table(combined_data$Pclass, combined_data$Prediction))$p.value * 100


### Tests for survival based on siblings or spouses onboard ###

combined_data$SibSpGroup = cut(
  combined_data$SibSp,
  breaks = c(-1, 0, 1, 2, Inf),
  labels = c("0", "1", "2", "3+"),
  include.lowest = TRUE
)


p5 = ggplot(combined_data, aes(x = SibSpGroup, fill = Survived)) +
  geom_bar(position = "fill") +
  labs(
    title = "Actual",
    x = "No. of siblings or spouses",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()

p6 = ggplot(combined_data, aes(x = SibSpGroup, fill = Prediction)) +
  geom_bar(position = "fill") +
  labs(
    title = "Predicted",
    x = "No. of siblings or spouses",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()

p5 + p6 + 
  plot_layout(ncol = 2, guides = "collect") +
  plot_annotation(title = "Actual vs Predicted Survival by number of siblings\nor spouses onboard")

chisq.test(table(combined_data$SibSpGroup, combined_data$Survived))$p.value * 100
chisq.test(table(combined_data$SibSpGroup, combined_data$Prediction))$p.value * 100

### Tests for survival based on parents or children onboard ###

combined_data$ParchGroup = cut(
  combined_data$Parch,
  breaks = c(-1, 0, 1, 2, Inf),
  labels = c("0", "1", "2", "3+"),
  include.lowest = TRUE
)


p7 = ggplot(combined_data, aes(x = ParchGroup, fill = Survived)) +
  geom_bar(position = "fill") +
  labs(
    title = "Actual",
    x = "No. of parents or children",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()

p8 = ggplot(combined_data, aes(x = ParchGroup, fill = Prediction)) +
  geom_bar(position = "fill") +
  labs(
    title = "Predicted",
    x = "No. of parents or children",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()


p7 + p8 + 
  plot_layout(ncol = 2, guides = "collect") +
  plot_annotation(title = "Actual vs Predicted Survival by number of parents\nor children onboard")




chisq.test(table(combined_data$ParchGroup, combined_data$Survived))$p.value * 100
chisq.test(table(combined_data$ParchGroup, combined_data$Prediction))$p.value * 100

### Tests for survival based on embarked port ###


p9 = ggplot(combined_data, aes(x = Embarked, fill = Survived)) +
  geom_bar(position = "fill") +
  labs(
    title = "Actual",
    x = "Embarked",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()+
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )


p10 = ggplot(combined_data, aes(x = Embarked, fill = Prediction)) +
  geom_bar(position = "fill") +
  labs(
    title = "Predicted",
    x = "Embarked",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal() +
theme(
  axis.text.x = element_text(angle = 45, hjust = 1)
)

p9 + p10 + 
  plot_layout(ncol = 2, guides = "collect") +
  plot_annotation(title = "Actual vs Predicted Survival by Embarked Port")


chisq.test(table(combined_data$Embarked, combined_data$Survived))$p.value * 100
chisq.test(table(combined_data$Embarked, combined_data$Prediction))$p.value * 100

### Tests for survival based on fare ###

combined_data$FareGroup = cut(
  combined_data$Fare,
  breaks = c(0, 10, 25, 50, 100, 999999),
  labels = c("£0–10", "£10–25", "£25–50", "£50–100", "£100+"),
  include.lowest = TRUE
)


p11 = ggplot(combined_data, aes(x = Fare))+
  geom_histogram(colour="black", position = "identity", bins = 30)+
  labs(
    title = "Distribution of fare paid",
    x = "Fare",
    y = "Frequency"
  )+
  theme_minimal()

p11



p12 = ggplot(combined_data, aes(x = FareGroup, fill = Survived)) +
  geom_bar(position = "fill") +
  labs(
    title = "Actual",
    x = "Embarked",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()+
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )


p13 = ggplot(combined_data, aes(x = FareGroup, fill = Prediction)) +
  geom_bar(position = "fill") +
  labs(
    title = "Predicted",
    x = "Embarked",
    y = "Proportion",
    fill = "Survived"
  ) +
  theme_minimal()+
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

p12 + p13 + 
  plot_layout(ncol = 2, guides = "collect") +
  plot_annotation(title = "Actual vs Predicted Survival by Fare")

chisq.test(table(combined_data$FareGroup, combined_data$Survived))$p.value * 100
chisq.test(table(combined_data$FareGroup, combined_data$Prediction))$p.value * 100


