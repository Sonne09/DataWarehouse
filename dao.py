import pyodbc
import configparser

def getSourceConnection():
    try:
        config = configparser.ConfigParser()
        config.read_file(open(r'config.ini'))
        DSN = config.get('DB_SOURCE', 'DSN')
        DB = config.get('DB_SOURCE', 'DB')
        UID = config.get('DB_SOURCE', 'UID')
        PWD = config.get('DB_SOURCE', 'PWD')

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
        cnxn = pyodbc.connect(conn_str)

        return cnxn

    except pyodbc.Error as e:
        print(f"Error: {e}")
        return None  # Return None to indicate an error occurred


def getTargetConnection():
    try:
        config = configparser.ConfigParser()
        config.read_file(open(r'config.ini'))
        DSN = config.get('DB_TARGET', 'DSN')
        DB = config.get('DB_TARGET', 'DB')
        UID = config.get('DB_TARGET', 'UID')
        PWD = config.get('DB_TARGET', 'PWD')

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
        cnxn = pyodbc.connect(conn_str)

        return cnxn

    except pyodbc.Error as e:
        print(f"Error: {e}")
        return None  # Return None to indicate an error occurred