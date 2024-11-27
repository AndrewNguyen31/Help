from flask import Blueprint, request, jsonify
from db_config import get_db_connection

# Create a Blueprint for user-related endpoints
reviews_bp = Blueprint('reviews', __name__)

# GET all reviews
@reviews_bp.route('/reviews', methods=['GET'])
def get_reviews():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM Review')
        rows = cursor.fetchall()
        reviews = [dict(zip([column[0] for column in cursor.description], row)) for row in rows]
        return jsonify(reviews)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# GET one review by reviewID
@reviews_bp.route('/reviews/<reviewID>', methods=['GET'])
def get_review(reviewID):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM Review WHERE reviewID = ?', (reviewID,))
        row = cursor.fetchone()
        if row:
            review = dict(zip([column[0] for column in cursor.description], row))
            return jsonify(review)
        else:
            return jsonify({'message': 'Review not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# POST a new review
@reviews_bp.route('/reviews', methods=['POST'])
def add_review():
    try:
        data = request.json
        reviewID = data['reviewID']
        username = data['username']
        rating = data['rating']
        description = data.get('description', '')

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute('''
            INSERT INTO Review (reviewID, username, rating, description)
            VALUES (?, ?, ?, ?)
        ''', (reviewID, username, rating, description))

        conn.commit()
        return jsonify({'message': 'Review added successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# PUT (Update) an existing review
@reviews_bp.route('/reviews/<reviewID>', methods=['PUT'])
def update_review(reviewID):
    try:
        data = request.json
        rating = data.get('rating')
        description = data.get('description')

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Update query for the Review table
        cursor.execute('''
            UPDATE Review
            SET rating = ?, description = ?
            WHERE reviewID = ?
        ''', (rating, description, reviewID))

        if cursor.rowcount == 0:
            return jsonify({'message': 'Review not found'}), 404

        conn.commit()
        return jsonify({'message': 'Review updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# DELETE an existing review
@reviews_bp.route('/reviews/<reviewID>', methods=['DELETE'])
def delete_review(reviewID):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute('DELETE FROM Review WHERE reviewID = ?', (reviewID,))

        if cursor.rowcount == 0:
            return jsonify({'message': 'Review not found'}), 404

        conn.commit()
        return jsonify({'message': 'Review deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()