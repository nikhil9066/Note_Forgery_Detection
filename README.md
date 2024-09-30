# Banknote Authentication: Logistic Regression Model

This project demonstrates the detection of genuine and forged banknotes using a logistic regression model. The dataset consists of features extracted from banknote images using wavelet transform. The following steps include data exploration, model development, evaluation, and visualization of results.

## Table of Contents

- [Requirements](#requirements)
- [Data Overview](#data-overview)
- [Project Workflow](#project-workflow)
  - [1. Data Loading and Initial Exploration](#1-data-loading-and-initial-exploration)
  - [2. Data Partitioning](#2-data-partitioning)
  - [3. Logistic Regression Model Development](#3-logistic-regression-model-development)
  - [4. Model Evaluation](#4-model-evaluation)
  - [5. Additional Model Performance Metrics](#5-additional-model-performance-metrics)
  - [6. ROC Curve and AUC](#6-roc-curve-and-auc)
  - [7. Visualizations](#7-visualizations)
- [Running the Code](#running-the-code)
- [Contributing](#contributing)

## Requirements

The project requires the following R libraries:

- `caret`
- `pROC`
- `ggplot2`

You can install them using the following commands:

```r
install.packages("caret")
install.packages("pROC")
install.packages("ggplot2")
```

## Data Overview

The dataset, `A6DATA.csv`, contains the following columns:

* **V1**: Variance of wavelet-transformed image
* **V2**: Skewness of wavelet-transformed image
* **V3**: Kurtosis of wavelet-transformed image
* **V4**: Entropy of the image
* **V5**: Class label (1 for genuine, 0 for forged)

## Project Workflow

### 1. Data Loading and Initial Exploration

* The code loads the `A6DATA.csv` file and provides a structure and summary of the data.
* Histograms and pair plots visualize the distributions and relationships between variables.
* A correlation heatmap checks for multicollinearity between the variables.

### 2. Data Partitioning

* The dataset is split into training (60%) and testing (40%) subsets using stratified sampling based on the class label (`V5`).
* The number of genuine and forged banknotes in each set is displayed for verification.

### 3. Logistic Regression Model Development

* A logistic regression model is developed to classify banknotes as genuine or forged.
* Stepwise model selection is used to find the best combination of features.
* The final logistic regression model is evaluated using various metrics.

### 4. Model Evaluation

* Predictions are generated for both training and testing sets using the logistic regression model.
* Confusion matrices and misclassification error rates are calculated for both sets.

### 5. Additional Model Performance Metrics

* The code calculates and prints Accuracy, Sensitivity (Recall), and Specificity for both training and testing sets.

### 6. ROC Curve and AUC

* ROC curves and AUC (Area Under the Curve) values are used to evaluate the model's performance on training and testing data.

### 7. Visualizations

* Several visualizations help explore the logistic regression model's results:
    * Coefficient plot for the logistic regression model.
    * Predicted probabilities vs. actual class for training and testing data.
    * Distribution of predicted probabilities for genuine and forged banknotes.

## Running the Code

1. Ensure R is installed on your machine.
2. Install the necessary packages (`caret`, `pROC`, `ggplot2`) using the commands in "Requirements" steps.
3. Place the A6DATA.csv file in the working directory.
4. Run the code to:
    * Load and explore the dataset.
    * Train a logistic regression model.
    * Evaluate the model performance.
    * Visualize the results.
  
## Contributing
Feel free to submit issues, fork the project, and send pull requests if you wish to contribute. All contributions are welcome!  