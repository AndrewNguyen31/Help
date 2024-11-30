import pyodbc

def get_db_connection():
    try:
        # Establish a connection to the SQL Server database
        conn = pyodbc.connect(
            'DRIVER={ODBC Driver 17 for SQL Server};'
            'SERVER=localhost;'
            'DATABASE=Hyelp;'
            'UID=;'
            'PWD=;'
        )
        return conn
    except pyodbc.Error as e:
        print("Error connecting to database:", e)
        raise e