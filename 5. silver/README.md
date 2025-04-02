# Silver Layer
In this folder we willl have codes that bring data from Bronze to Silver

here we mainly perform SCD2 and Full Load depending on the type of Data

SCD2 - Slowly Changing Dimension 2 where we keep track and maintain historical data

Full Load - complete refresh, where we will overwrite the entire data

EMR Data

- Patients (SCD2)
- Providers (full load)
- Department (full load)
- Transactions (SC2)
- Encounters (SCD2)

Claims (SCD2)

CPT (SCD2)

NPI

ICD Codes


## Departments_FL.py
In this script we get departments parquet files from both hopistal-a and hosipital-b in bronze layer

