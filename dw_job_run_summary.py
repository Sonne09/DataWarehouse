import pyodbc
import dao


def insertIntoJobRunSummary(tablename, start_date_Time, end_date_Time, rows_processed, status, error_message, colid, job_run_id):
    try:
        # Establish connection to target database
        cnxn = dao.getTargetConnection()
        cursor = cnxn.cursor()

        if cursor:
            try:
                    #print(type(row["8"]), row["8"])
                    #print(row)
                    # Execute INSERT INTO statement for each row
                    cursor.execute("""INSERT INTO [dbo].[dw_job_run_summary] ([tablename]
                                            ,[start_date_Time]
                                            ,[end_date_Time]
                                            ,[rows_processed]
                                            ,[status]
                                            ,[error_message]
                                            ,[colid]
                                            ,[job_run_id])
                                    VALUES(?,?,?,?,?,?,?,?)""",
                                    tablename, start_date_Time, end_date_Time, rows_processed, status, error_message, colid, job_run_id
                    )
                    #cnxn.commit()
            except Exception as e:
                print(type(str(e)))

            # Commit changes and close the cursor and connection
            cnxn.commit()
            cursor.close()
            cnxn.close()
        else:
            print("Failed to establish the database connection.")
    except pyodbc.Error as e:
        print(f"Error: {e}")