import os

class Config:
    SECRET_KEY = 'your-secret-key-change-in-production'
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:12345@localhost:5432/library_db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    UPLOAD_FOLDER = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'app', 'static', 'uploads')
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}