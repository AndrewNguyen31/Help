from flask import Flask, request, jsonify, render_template
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
    return render_template('index.html')

@app.route('/businesses')
def businesses_page():
    return render_template('businesses.html')

@app.route('/users-page')
def users_page():
    return render_template('users.html')

@app.route('/reviews-page')
def reviews_page():
    return render_template('reviews.html')

@app.route('/comments-page')
def comments_page():
    return render_template('comments.html')

@app.route('/statuses-page')
def statuses_page():
    return render_template('statuses.html')

if __name__ == '__main__':
    app.run(debug=True)