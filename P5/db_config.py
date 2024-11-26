import pyodbc

# Function to establish a connection to the MSSQL database
def get_db_connection():
    try:
        conn = pyodbc.connect(
            'DRIVER={ODBC Driver 17 for SQL Server};'  
            'SERVER=localhost;'
            'DATABASE=;'
        )
        return conn
    except Exception as e:
        print(f"Error connecting to database: {e}")
        raise e