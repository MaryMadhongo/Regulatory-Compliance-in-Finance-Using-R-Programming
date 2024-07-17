# Regulatory-Compliance-in-Finance-Using-R-Programming(Still in Progress)

Project Overview
This project focuses on regulatory compliance in the finance sector using R programming. The project involves analyzing financial statements from the SEC to ensure compliance with regulatory standards and identifying potential anomalies and areas of non-compliance.

Technologies Used
R Programming
SEC Financial Data
Data Analysis
PostgreSQL
Key Steps
Data Preparation:

Download and save financial statements from the SEC.
Normalize and clean data for analysis.
Database Setup:

Set up PostgreSQL connection.
Create tables in PostgreSQL to store financial documents.
Data Ingestion:

Load financial documents into PostgreSQL.
Data Analysis:

Retrieve data from PostgreSQL.
Perform text preprocessing and create a document-term matrix.
Train a classifier to identify regulatory compliance issues.
Model Training and Evaluation:

Split data into training and testing sets.
Train a Support Vector Machine (SVM) model.
Make predictions and evaluate the model using a confusion matrix.
Installation
Ensure you have the following R libraries installed:

httr
DBI
RPostgreSQL
dplyr
tm
SnowballC
caret
e1071
xml2
R.utils
RODBC
odbc
RPostgres
Install them using R:

R
Copy code
install.packages(c("httr", "DBI", "RPostgreSQL", "dplyr", "tm", "SnowballC", "caret", "e1071", "xml2", "R.utils", "RODBC", "odbc", "RPostgres"))
Running the Project
Load the R script.
Run the script to download financial statements, preprocess data, load data into PostgreSQL, analyze data, train the model, and evaluate its performance.
Conclusion
This project demonstrates the use of R programming for regulatory compliance in the finance sector. It involves comprehensive data analysis to ensure adherence to regulatory standards and highlights areas needing attention.
