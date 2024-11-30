from flask import Blueprint, request, jsonify
from db_config import get_db_connection

# Create a Blueprint for user-related endpoints
users_bp = Blueprint('users', __name__)

# GET all users
@users_bp.route('/users', methods=['GET'])
def get_users():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM Users')
        rows = cursor.fetchall()
        users = [dict(zip([column[0] for column in cursor.description], row)) for row in rows]
        return jsonify(users)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# POST a new user
@users_bp.route('/users', methods=['POST'])
def add_user():
    try:
        # Extract data from the request body
        data = request.json
        username = data['username']
        firstName = data['firstName']
        lastName = data['lastName']
        dateOfBirth = data['dateOfBirth']  # 'YYYY-MM-DD' format
        dateJoined = data['dateJoined']  # 'YYYY-MM-DD' format
        userType = data['userType']  # Must be 'Both', 'Owner', or 'Reviewer'
        businessCount = data.get('businessCount', 0)  # Default to 0 if not provided
        reviewCount = data.get('reviewCount', 0)  # Default to 0 if not provided

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Insert query for the Users table
        cursor.execute('''
            INSERT INTO Users (username, firstName, lastName, dateOfBirth, dateJoined, userType, businessCount, reviewCount)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', (username, firstName, lastName, dateOfBirth, dateJoined, userType, businessCount, reviewCount))

        conn.commit()

        return jsonify({'message': 'User added successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()
        
# PUT (update) a user
@users_bp.route('/users/<string:username>', methods=['PUT'])
def update_user(username):
    try:
        # Extract data from the request body
        data = request.json
        firstName = data.get('firstName')
        lastName = data.get('lastName')
        dateOfBirth = data.get('dateOfBirth')  # 'YYYY-MM-DD' format
        dateJoined = data.get('dateJoined')  # 'YYYY-MM-DD' format
        userType = data.get('userType')  # Must be 'Both', 'Owner', or 'Reviewer'
        businessCount = data.get('businessCount')
        reviewCount = data.get('reviewCount')

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Update query for the Users table
        cursor.execute('''
            UPDATE Users
            SET firstName = ?, lastName = ?, dateOfBirth = ?, dateJoined = ?, userType = ?, businessCount = ?, reviewCount = ?
            WHERE username = ?
        ''', (firstName, lastName, dateOfBirth, dateJoined, userType, businessCount, reviewCount, username))

        conn.commit()

        return jsonify({'message': 'User updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()
        
# DELETE (remove) a user
@users_bp.route('/users/<string:username>', methods=['DELETE'])
def delete_user(username):
    try:
        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Delete query for the Users table
        cursor.execute('DELETE FROM Users WHERE username = ?', (username,))
        
        conn.commit()

        return jsonify({'message': 'User deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()