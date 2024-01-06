import pyodbc 
import configparser


config = configparser.ConfigParser()
config.read_file(open(r'config.ini'))
DSN = config.get('DB', 'DSN')
DB = config.get('DB', 'DB')
UID = config.get('DB', 'UID')
PWD = config.get('DB', 'PWD')


# Formulate the connection string
conn_str = (
    "Driver=ODBC Driver 18 for SQL Server;"
    f"Server={DSN};"
    f"Database={DB};"
    f"UID={UID};"
    f"PWD={PWD};"
    "TrustServerCertificate=yes;"
)

# Establish the connection
try:
    cnxn = pyodbc.connect(conn_str)
    cursor = cnxn.cursor()

    # Define your SQL query
    sql_query = 'SELECT * FROM jobs'
    cursor.execute(sql_query)

    # Fetch and print the results with formatting
    for row in cursor:
        formatted_row = (
            row[0],  # job_id
            f"'{row[1]}'", 
            f"{row[2]:.2f}",  
            f"{row[3]:.2f}"
        )
        print('row =', ', '.join(formatted_row))

    # Close the cursor and connection
    cursor.close()
    cnxn.close()

except pyodbc.Error as e:
    print(f"Error: {e}")
