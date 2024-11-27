from flask import Blueprint, request, jsonify
from db_config import get_db_connection

status_bp = Blueprint('status', __name__)

# GET: retrieve all statuses or a specific status by ID
@status_bp.route('/statuses', methods=['GET'])
def get_status():
    conn = get_db_connection()
    cursor = conn.cursor()
    
    status_id = request.args.get('statusID')
    
    if status_id:
        cursor.execute('SELECT * FROM Status WHERE statusID = ?', (status_id,))
        row = cursor.fetchone()
        if row:
            result = {
                'statusID': row[0],
                'statusName': row[1],
                'description': row[2]
            }
        else:
            return jsonify({'error': 'Status not found'}), 404
    else:
        cursor.execute('SELECT * FROM Status')
        rows = cursor.fetchall()
        result = [
            {
                'statusID': row[0],
                'statusName': row[1],
                'description': row[2]
            } 
            for row in rows
        ]
    conn.close()
    return jsonify(result)

# POST: add a new status
@status_bp.route('/statuses', methods=['POST'])
def add_status():
    data = request.json
    status_name = data.get('statusName')
    description = data.get('description')
    
    if not status_name or not description:
        return jsonify({'error': 'statusName and description are required'}), 400
    
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute('INSERT INTO Status (statusName, description) VALUES (?, ?)', (status_name, description))
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

    return jsonify({'message': 'Status added successfully'}), 201

# PUT: update an existing status
@status_bp.route('/statuses/<status_id>', methods=['PUT'])
def update_status(status_id):
    data = request.json
    status_name = data.get('statusName')
    description = data.get('description')
    
    if not status_name or not description:
        return jsonify({'error': 'statusName and description are required'}), 400
    
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute('UPDATE Status SET statusName = ?, description = ? WHERE statusID = ?', (status_name, description, status_id))
        if cursor.rowcount == 0:
            return jsonify({'error': 'Status not found'}), 404
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

    return jsonify({'message': 'Status updated successfully'}), 200

# DELETE: remove an existing status
@status_bp.route('/statuses/<status_id>', methods=['DELETE'])
def delete_status(status_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute('DELETE FROM Status WHERE statusID = ?', (status_id,))
        if cursor.rowcount == 0:
            return jsonify({'error': 'Status not found'}), 404
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

    return jsonify({'message': 'Status deleted successfully'}), 200