from flask import Blueprint, request, jsonify
from db_config import get_db_connection  # Assuming you have a function to get DB connection

# Create a Blueprint for comment-related endpoints
comments_bp = Blueprint('comments', __name__)

# GET all comments
@comments_bp.route('/comments', methods=['GET'])
def get_comments():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        comment_id = request.args.get('commentID')
        
        if comment_id:
            cursor.execute('SELECT * FROM Comment WHERE commentID = ?', (comment_id,))
            row = cursor.fetchone()
            if row:
                comments = [{
                    'commentID': row[0],
                    'username': row[1],
                    'reviewID': row[2],
                    'description': row[3]
                }]
            else:
                return jsonify({'error': 'Comment not found'}), 404
        else:        
            cursor.execute('SELECT * FROM Comment')
            rows = cursor.fetchall()
            comments = [dict(zip([column[0] for column in cursor.description], row)) for row in rows]
        return jsonify(comments)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# GET a single comment by commentID
@comments_bp.route('/comments/<int:commentID>', methods=['GET'])
def get_comment(commentID):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM Comment WHERE commentID = ?', (commentID,))
        row = cursor.fetchone()
        if row:
            comment = dict(zip([column[0] for column in cursor.description], row))
            return jsonify(comment)
        else:
            return jsonify({'message': 'Comment not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# POST a new comment
@comments_bp.route('/comments', methods=['POST'])
def add_comment():
    try:
        data = request.json
        commentID = data['commentID']
        username = data['username']
        reviewID = data['reviewID']
        description = data['description']

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Insert query for the Comment table
        cursor.execute('''
            INSERT INTO Comment (commentID, username, reviewID, description)
            VALUES (?, ?, ?, ?)
        ''', (commentID, username, reviewID, description))

        conn.commit()
        return jsonify({'message': 'Comment added successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# PUT (Update) an existing comment
@comments_bp.route('/comments/<int:commentID>', methods=['PUT'])
def update_comment(commentID):
    try:
        data = request.json
        description = data.get('description')

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Update query for the Comment table
        cursor.execute('''
            UPDATE Comment
            SET description = ?
            WHERE commentID = ?
        ''', (description, commentID))

        if cursor.rowcount == 0:
            return jsonify({'message': 'Comment not found'}), 404

        conn.commit()
        return jsonify({'message': 'Comment updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# DELETE an existing comment
@comments_bp.route('/comments/<int:commentID>', methods=['DELETE'])
def delete_comment(commentID):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Delete query for the Comment table
        cursor.execute('DELETE FROM Comment WHERE commentID = ?', (commentID,))

        if cursor.rowcount == 0:
            return jsonify({'message': 'Comment not found'}), 404

        conn.commit()
        return jsonify({'message': 'Comment deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()
