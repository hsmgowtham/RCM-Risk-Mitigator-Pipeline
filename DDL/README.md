# Upload EMR Data
Upload CSV files DDL for Hospital A and Hospital B EMR Data

## Create Azure SQL Databases
1. Create 2 SQL Databases Hospital A and B
2. Create DDL in both Hospital A and B SQL Databases in Azure using the scripts

## Upload CSV Files
1. Create 1 Container (sqldata) and 2 folders (Hospital-A and Hospital-B) in it in Azure Storage Account    
2. Upload CSV files into 2 folders

## Create Dataflow
1. Open Data factory
2. Create Data flow
3. Select Source -> delimted CSV -> Create Linked Service -> select the file
4. Select Sink -> select Azure SQL Database -> Create Linked Service -> Select DB

## Create Pipeline
1. Drag Dataflow, and hit on debug, this will run the Pipeline