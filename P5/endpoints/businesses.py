from flask import Blueprint, request, jsonify
from db_config import get_db_connection

# Create a Blueprint for business-related endpoints
business_bp = Blueprint('business', __name__)

# GET all businesses
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

# POST a new business
@business_bp.route('/businesses', methods=['POST'])
def add_business():
    try:
        # Extract data from the request body
        data = request.json
        businessID = data['businessID']
        name = data['name']
        overallRating = data.get('overallRating')  # Optional
        reviewCount = data.get('reviewCount')  # Optional
        street = data['street']
        city = data['city']
        state = data['state']
        zipCode = data['zipCode']
        businessType = data['businessType']  # Must be 'Restaurant', 'Entertainment', or 'Service'
        cuisineType = data.get('cuisineType')  # Optional, required for 'Restaurant'
        entertainmentType = data.get('entertainmentType')  # Optional, required for 'Entertainment'
        serviceType = data.get('serviceType')  # Optional, required for 'Service'

        # Validate businessType and corresponding types
        if businessType not in ['Restaurant', 'Entertainment', 'Service']:
            return jsonify({'error': "Invalid businessType. Must be 'Restaurant', 'Entertainment', or 'Service'"}), 400
        if businessType == 'Restaurant' and not cuisineType:
            return jsonify({'error': "cuisineType is required for Restaurant type"}), 400
        if businessType == 'Entertainment' and not entertainmentType:
            return jsonify({'error': "entertainmentType is required for Entertainment type"}), 400
        if businessType == 'Service' and not serviceType:
            return jsonify({'error': "serviceType is required for Service type"}), 400

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Insert query for the Business table
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
