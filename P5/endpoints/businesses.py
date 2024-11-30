from flask import Blueprint, request, jsonify
from db_config import get_db_connection

business_bp = Blueprint('business', __name__)

# GET
@business_bp.route('/businesses', methods=['GET'])
def get_businesses():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM Business')
        rows = cursor.fetchall()
        businesses = [dict(zip([column[0] for column in cursor.description], row)) for row in rows]
        return jsonify(businesses)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# POST
@business_bp.route('/businesses', methods=['POST'])
def add_business():
    try:
        data = request.json
        businessID = data['businessID']
        name = data['name']
        overallRating = data.get('overallRating')
        reviewCount = data.get('reviewCount')
        street = data['street']
        city = data['city']
        state = data['state']
        zipCode = data['zipCode']
        businessType = data['businessType']  # Must be 'Restaurant', 'Entertainment', or 'Service'
        cuisineType = data.get('cuisineType')
        entertainmentType = data.get('entertainmentType')
        serviceType = data.get('serviceType')

        if businessType not in ['Restaurant', 'Entertainment', 'Service']:
            return jsonify({'error': "Invalid businessType. Must be 'Restaurant', 'Entertainment', or 'Service'"}), 400
        if businessType == 'Restaurant' and not cuisineType:
            return jsonify({'error': "cuisineType is required for Restaurant type"}), 400
        if businessType == 'Entertainment' and not entertainmentType:
            return jsonify({'error': "entertainmentType is required for Entertainment type"}), 400
        if businessType == 'Service' and not serviceType:
            return jsonify({'error': "serviceType is required for Service type"}), 400

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute('''
            INSERT INTO Business (businessID, name, overallRating, reviewCount, street, city, state, zipCode, businessType, cuisineType, entertainmentType, serviceType)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (businessID, name, overallRating, reviewCount, street, city, state, zipCode, businessType, cuisineType, entertainmentType, serviceType))

        conn.commit()

        return jsonify({'message': 'Business added successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

# PUT
@business_bp.route('/businesses/<business_id>', methods=['PUT'])
def update_business(business_id):
    data = request.json
    name = data.get('name')
    overall_rating = data.get('overallRating')
    review_count = data.get('reviewCount')
    street = data.get('street')
    city = data.get('city')
    state = data.get('state')
    zip_code = data.get('zipCode')
    business_type = data.get('businessType')
    cuisine_type = data.get('cuisineType')
    entertainment_type = data.get('entertainmentType')
    service_type = data.get('serviceType')

    if (name is None or 
        overall_rating is None or 
        review_count is None or 
        street is None or 
        city is None or 
        state is None or 
        zip_code is None or 
        business_type is None):
        return jsonify({'error': 'Required fields are missing'}), 400

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute('''
            UPDATE Business
            SET name = ?, overallRating = ?, reviewCount = ?, street = ?, city = ?, state = ?, zipCode = ?, 
                businessType = ?, cuisineType = ?, entertainmentType = ?, serviceType = ?
            WHERE businessID = ?
        ''', (name, overall_rating, review_count, street, city, state, zip_code, business_type, 
              cuisine_type, entertainment_type, service_type, business_id))
        
        if cursor.rowcount == 0:
            return jsonify({'error': 'Business not found'}), 404
        
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

    return jsonify({'message': 'Business updated successfully'}), 200

# DELETE
@business_bp.route('/businesses/<business_id>', methods=['DELETE'])
def delete_business(business_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute('DELETE FROM Business WHERE businessID = ?', (business_id,))
        if cursor.rowcount == 0:
            return jsonify({'error': 'Business not found'}), 404
        conn.commit()
    except Exception as e:
        conn.rollback()
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()

    return jsonify({'message': 'Business deleted successfully'}), 200
