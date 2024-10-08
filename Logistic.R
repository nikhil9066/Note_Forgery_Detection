# Load necessary libraries
library(caret)
library(pROC)
library(ggplot2)

# Step 1: Data Loading and Initial Exploration
# Read the CSV data
data <- read.csv("A6DATA.csv")

# View the structure of the data
str(data)

# Check summary statistics of the data
summary(data)

# Visualizing the distribution of the variables
ggplot(data, aes(x = V1)) +
  geom_histogram(binwidth = 0.2, fill = "blue", alpha = 0.7) +
  labs(title = "Distribution of V1 (Variance of Wavelet Transformed Image)",
       x = "V1", y = "Count") +
  theme_minimal()

ggplot(data, aes(x = V2)) +
  geom_histogram(binwidth = 0.2, fill = "green", alpha = 0.7) +
  labs(title = "Distribution of V2 (Skewness of Wavelet Transformed Image)",
       x = "V2", y = "Count") +
  theme_minimal()

ggplot(data, aes(x = V3)) +
  geom_histogram(binwidth = 0.2, fill = "orange", alpha = 0.7) +
  labs(title = "Distribution of V3 (Kurtosis of Wavelet Transformed Image)",
       x = "V3", y = "Count") +
  theme_minimal()

ggplot(data, aes(x = V4)) +
  geom_histogram(binwidth = 0.2, fill = "red", alpha = 0.7) +
  labs(title = "Distribution of V4 (Entropy of Image)",
       x = "V4", y = "Count") +
  theme_minimal()

# Visualizing the relationship between variables
pairs(data[,1:4], main = "Pair Plot of Variables V1, V2, V3, V4")

# Correlation heatmap to check multicollinearity
cor_matrix <- round(cor(data[,1:4]), 2)
ggplot(data = as.data.frame(as.table(cor_matrix)), aes(Var1, Var2, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "white") +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "Correlation Matrix of Variables") +
  theme_minimal()

# Step 2: Data Partitioning
# Set seed for reproducibility
set.seed(681)

# Split data into training (60%) and testing (40%)
trainIndex <- createDataPartition(data$V5, p = 0.6, list = FALSE)
trainData <- data[trainIndex, ]
testData <- data[-trainIndex, ]

# Check the number of genuine (1) and forged (0) specimens in training and testing sets
cat("Training Set Specimen Counts:\n")
print(table(trainData$V5))

cat("Testing Set Specimen Counts:\n")
print(table(testData$V5))

# Step 3: Logistic Regression Model Development
# Develop logistic regression model using the training data
# Start with a full model, including all variables
model <- glm(V5 ~ V1 + V2 + V3 + V4, data = trainData, family = binomial)

# Summary of the model to check significant variables
summary(model)

# Perform stepwise selection to find the best model
final_model <- step(model)

# Display the final model
summary(final_model)

# Step 4: Model Evaluation

# Predict on training and testing data using the final model
trainPred <- predict(final_model, newdata = trainData, type = "response")
testPred <- predict(final_model, newdata = testData, type = "response")

# Convert probabilities to class labels (0 or 1)
trainPredClass <- ifelse(trainPred > 0.5, 1, 0)
testPredClass <- ifelse(testPred > 0.5, 1, 0)

# Confusion matrix for training data with labels
trainConfMat <- table(Predicted = trainPredClass, Actual = trainData$V5)
cat("Training Confusion Matrix:\n")
print(trainConfMat)

# Confusion matrix for testing data with labels
testConfMat <- table(Predicted = testPredClass, Actual = testData$V5)
cat("Testing Confusion Matrix:\n")
print(testConfMat)

# Misclassification error for training and testing sets
trainError <- mean(trainPredClass != trainData$V5)
testError <- mean(testPredClass != testData$V5)

# Print misclassification errors
cat("Training Error: ", trainError, "\n")
cat("Testing Error: ", testError, "\n")

# Step 5: Additional Model Performance Metrics

# Accuracy, Sensitivity, and Specificity for Training Set
trainAccuracy <- sum(diag(trainConfMat)) / sum(trainConfMat)
trainSensitivity <- trainConfMat[2, 2] / sum(trainConfMat[, 2])  # True Positives / (True Positives + False Negatives)
trainSpecificity <- trainConfMat[1, 1] / sum(trainConfMat[, 1])  # True Negatives / (True Negatives + False Positives)

cat("Training Accuracy: ", trainAccuracy, "\n")
cat("Training Sensitivity: ", trainSensitivity, "\n")
cat("Training Specificity: ", trainSpecificity, "\n")

# Accuracy, Sensitivity, and Specificity for Testing Set
testAccuracy <- sum(diag(testConfMat)) / sum(testConfMat)
testSensitivity <- testConfMat[2, 2] / sum(testConfMat[, 2])
testSpecificity <- testConfMat[1, 1] / sum(testConfMat[, 1])

cat("Testing Accuracy: ", testAccuracy, "\n")
cat("Testing Sensitivity: ", testSensitivity, "\n")
cat("Testing Specificity: ", testSpecificity, "\n")

# Step 6: ROC Curve and AUC

# ROC Curve and AUC for Training Set
roc_train <- roc(trainData$V5, trainPred)
plot(roc_train, main = "ROC Curve - Training Data", col = "blue")
cat("AUC for Training Data: ", auc(roc_train), "\n")

# ROC Curve and AUC for Testing Set
roc_test <- roc(testData$V5, testPred)
plot(roc_test, main = "ROC Curve - Testing Data", col = "red")
cat("AUC for Testing Data: ", auc(roc_test), "\n")

# Step 7: Visualizations

# Coefficients Plot
coef_df <- data.frame(Variable = names(coef(final_model)),
                      Estimate = coef(final_model))
ggplot(coef_df, aes(x = reorder(Variable, Estimate), y = Estimate)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Logistic Regression Coefficients", x = "Variable", y = "Estimate")

# Predicted probabilities vs actual class for training data
ggplot(trainData, aes(x = trainPred, y = V5)) +
  geom_point(color = "blue") +
  labs(title = "Predicted Probabilities vs Actual Class - Training Data",
       x = "Predicted Probability of Genuine (V5 = 1)",
       y = "Actual Class") +
  theme_minimal()

# Predicted probabilities vs actual class for testing data
ggplot(testData, aes(x = testPred, y = V5)) +
  geom_point(color = "red") +
  labs(title = "Predicted Probabilities vs Actual Class - Testing Data",
       x = "Predicted Probability of Genuine (V5 = 1)",
       y = "Actual Class") +
  theme_minimal()

# Distribution of predicted probabilities for genuine (1) and forged (0) specimens
ggplot(trainData, aes(x = trainPred, fill = as.factor(V5))) +
  geom_histogram(binwidth = 0.05, alpha = 0.6, position = "identity") +
  labs(title = "Distribution of Predicted Probabilities - Training Data",
       x = "Predicted Probability of Genuine",
       fill = "Actual Class") +
  theme_minimal()

# The same for testing data
ggplot(testData, aes(x = testPred, fill = as.factor(V5))) +
  geom_histogram(binwidth = 0.05, alpha = 0.6, position = "identity") +
  labs(title = "Distribution of Predicted Probabilities - Testing Data",
       x = "Predicted Probability of Genuine",
       fill = "Actual Class") +
  theme_minimal()
