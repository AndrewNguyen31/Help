from flask import Flask, request, jsonify
from endpoints.statuses import status_bp
from endpoints.users import users_bp
from endpoints.businesses import business_bp
from endpoints.reviews import reviews_bp
from endpoints.comments import comments_bp

app = Flask(__name__)

app.register_blueprint(status_bp)
app.register_blueprint(users_bp)
app.register_blueprint(business_bp)
app.register_blueprint(reviews_bp)
app.register_blueprint(comments_bp)

@app.route('/')
def home():
    return 'Welcome to the Hyelp API!', 200

if __name__ == '__main__':
    app.run(debug=True)