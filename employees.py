import pyodbc
import pandas as pd
import dao
import dw_job_run_summary as jobRunSummary
from datetime import datetime


def insertIntoEmployees(table_name, job_run_id):   
    try:
        # Establish connection to target database
        start_date_Time = datetime.now()
        rows_processed = 0
        success = True
        cnxn = dao.getTargetConnection()
        cursor = cnxn.cursor()

        if cursor:
            # Read data from the previously saved CSV file
            df = pd.read_csv(f"{table_name}.csv")
            df.fillna(value=0 , inplace=True)

            # Iterate over each row and insert data into target table
            for index, row in df.iterrows():
                rows_processed += 1
                try:
                    #print(type(row["8"]), row["8"])
                    #print(row)
                    # Execute INSERT INTO statement for each row
                    cursor.execute("""INSERT INTO [dbo].[st_employees] ([employee_id]
                                        ,[first_name]
                                        ,[last_name]
                                        ,[email]
                                        ,[phone_number]
                                        ,[hire_date]
                                        ,[job_id]
                                        ,[salary]
                                        ,[commission_pct]
                                        ,[manager_id]
                                        ,[department_id])
                                    VALUES(?,?,?,?,?,?,?,?,?,?,?)""",
                                    row["0"], row["1"], row["2"], row["3"],
                                    row["4"], row["5"], row["6"], row["7"],
                                    row["8"], row["9"], row["10"]
                    )
                    #cnxn.commit()
                except Exception as e:
                    print(str(e))
                    success = False
                    jobRunSummary.insertIntoJobRunSummary(table_name, start_date_Time, datetime.now(), rows_processed, "Fail", str(e), row["0"], job_run_id)

            if(success):
                jobRunSummary.insertIntoJobRunSummary(table_name, start_date_Time, datetime.now(), rows_processed, "Success", "", "", job_run_id)

            # Commit changes and close the cursor and connection
            cnxn.commit()
            cursor.close()
            cnxn.close()
        else:
            print("Failed to establish the database connection.")
    except pyodbc.Error as e:
        print(f"Error: {e}")