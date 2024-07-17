# Load libraries
library(httr)
library(DBI)
library(RPostgreSQL)
library(dplyr)
library(tm)
library(SnowballC)
library(caret)
library(e1071)
library(xml2)
library(R.utils)
library("RODBC")
library("odbc")
library("RPostgres")

# Step 3: Download the Filing
# URL of the Form 10-K filing for Stemtech Corporation
url <- "https://www.sec.gov/ix?doc=/Archives/edgar/data/1511820/000168316824004736/stemtech_i10k-123123.htm"

# Download the filing
response <- GET(url)
filing_text <- rawToChar(response$content)

# Save the filing to a local file
write(filing_text, file = "stemtech_10k_2023.html")

cat("Filing downloaded successfully.\n")

# Step 4: Set Up PostgreSQL Connection
con <- DBI::dbConnect(RPostgres::Postgres(),
                 dbname = "Finance",
                 host = "localhost",
                 port = 5432,
                 user = "postgres",
                 password = "0000",
                 options = "-c search_path=myschema")

cat("Connected to PostgreSQL successfully.\n")

# Step 5: Create Table in PostgreSQL
# Create the regulatory_documents table

# Set the search path to your desired schema
dbSendQuery(con, "SET search_path TO myschema;")

# Create the regulatory_documents table
create_table_query <- "
CREATE TABLE myschema.regulatory_documents (
    filing_date DATE,
    company_name TEXT,
    form_type TEXT,
    document_text TEXT
);"
dbSendQuery(con, create_table_query)


cat("Table created successfully!\n")

# Step 6: Load Data into PostgreSQL
# Read the filing text
filing_text <- readLines("stemtech_10k_2023.html", warn = FALSE)

# Insert data into PostgreSQL
insert_query <- "
INSERT INTO regulatory_documents (filing_date, company_name, form_type, document_text)
VALUES ($1, $2, $3, $4);"

dbExecute(con, insert_query, params = list("2023-12-31", "Stemtech Corporation", "10-K", paste(filing_text, collapse = "\n")))

cat("Filing loaded into PostgreSQL successfully.\n")

# Step 7: Retrieve and Analyze Data
# Retrieve data from PostgreSQL
df <- dbGetQuery(con, "SELECT * FROM regulatory_documents WHERE company_name = 'Stemtech Corporation'")

# Text preprocessing
corpus <- Corpus(VectorSource(df$document_text))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument)

dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.99)

# Convert to data frame
data <- as.data.frame(as.matrix(dtm))
data$class <- df$form_type

# Split the data
set.seed(123)
trainIndex <- createDataPartition(data$class, p = .8, 
                                  list = FALSE, 
                                  times = 1)
dataTrain <- data[trainIndex,]
dataTest  <- data[-trainIndex,]

# Train a classifier
model <- train(class ~ ., data = dataTrain, method = "svmLinear")

# Make predictions
predictions <- predict(model, newdata = dataTest)

# Evaluate the model
confusionMatrix(predictions, dataTest$class)