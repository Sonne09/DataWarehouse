import dao
import pyodbc
import pandas as pd
import employees as emp
import countries
import departments
import jobHistory
import jobs
import locations
import regions


job_run_id = 0


def setJobRunId():
    global job_run_id
    try:
        # Establish connection to target database
        cnxn = dao.getTargetConnection()
        cursor = cnxn.cursor()
        sqlQuery = """ SELECT MAX(job_run_id) 
                    FROM [DW].[dbo].[dw_job_run_summary]
                    """
        if cursor:
            cursor.execute(sqlQuery)

            for row in cursor:
                print(row)
                job_run_id = row[0]

            if(job_run_id == None):
                job_run_id = 1
            else:
                job_run_id += 1

            print(f"value of job_run_id is {job_run_id} inside function.")

            cursor.close()
            cnxn.close()
        
        else:
            print("Failed to establish the database connection.")

    except pyodbc.Error as e:
        print(f"Error: {e}")


def fetchRecords(table_name):
    try:
        # Establish connection to source database
        cnxn = dao.getSourceConnection()
        cursor = cnxn.cursor()
        
        if cursor:
            # Fetch records from the specified table
            sql_query = f"SELECT * FROM {table_name};"
            #print(sql_query)
            cursor.execute(sql_query)

            # Create a list to store fetched records
            hrList = []
            for row in cursor:
                hrList.append([element for element in row])

            # Convert fetched records into a DataFrame and save as a CSV file
            pd.DataFrame(hrList).to_csv(f"{table_name}.csv", index=False)

            # Close the cursor and connection
            cursor.close()
            cnxn.close()
        else:
            print("Failed to establish the database connection.")
    except pyodbc.Error as e:
        print(f"Error: {e}")


def truncateTable(table_name):
    try:
        cnxn = dao.getTargetConnection()
        cursor = cnxn.cursor()

        if cursor:
            sqlQuery = f"truncate table  dbo.st_{table_name}"
            #print(sqlQuery)
            cursor.execute(sqlQuery)
            cnxn.commit()
            cursor.close()
            cnxn.close()
        else:
            print("Failed to establish the database connection.")
    except pyodbc.Error as e:
        print(f"Error: {e}")

def insertRecords(table_name):
    if table_name == "regions":
        regions.insertIntoRegions(table_name, job_run_id)

    elif table_name == "countries":
        countries.insertIntoCountries(table_name, job_run_id)

    elif table_name == "locations":
        locations.insertIntoLocations(table_name, job_run_id)
    
    elif table_name == "departments":
        departments.insertIntoDepartments(table_name, job_run_id)
    
    elif table_name == "jobs":
        jobs.insertIntoJobs(table_name, job_run_id)
    
    elif table_name == "employees":
        emp.insertIntoEmployees(table_name, job_run_id)
    
    elif table_name == "job_history":
        jobHistory.insertIntoJobHistory(table_name, job_run_id)

# List of tables to fetch and insert records
target_tables = [
    "regions",
    "countries",
    "locations",
    "departments",
    "jobs",
    "employees",
    "job_history"
]

# Fetch and insert records for each table in the list
setJobRunId()
print(f"value of job_run_id is {job_run_id} after function call.")

for table in target_tables:
    fetchRecords(table)
    truncateTable(table)
    insertRecords(table)
    print(table)  # Display the processed table
