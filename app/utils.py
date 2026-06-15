import os
import hashlib
import bleach
import markdown
from werkzeug.utils import secure_filename
from flask import current_app
from app.models import Cover, db

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def save_cover(file, book_id):
    if not file or file.filename == '':
        return None
    if not allowed_file(file.filename):
        return None
    file_data = file.read()
    md5_hash = hashlib.md5(file_data).hexdigest()
    existing_cover = Cover.query.filter_by(md5_hash=md5_hash).first()
    if existing_cover:
        existing_cover.book_id = book_id
        db.session.commit()
        return existing_cover.id
    upload_dir = current_app.config['UPLOAD_FOLDER']
    if not os.path.exists(upload_dir):
        os.makedirs(upload_dir)
    cover = Cover(filename='', mime_type=file.content_type, md5_hash=md5_hash, book_id=book_id)
    db.session.add(cover)
    db.session.flush()
    filename = f"{cover.id}.{file.filename.rsplit('.', 1)[1].lower()}"
    cover.filename = filename
    file_path = os.path.join(upload_dir, filename)
    with open(file_path, 'wb') as f:
        f.write(file_data)
    db.session.commit()
    return cover.id

def delete_cover_file(cover):
    if cover:
        file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], cover.filename)
        if os.path.exists(file_path):
            os.remove(file_path)

def sanitize_html(text):
    allowed_tags = ['a', 'abbr', 'acronym', 'b', 'blockquote', 'code', 'em', 'i', 'li', 'ol', 'pre', 'strong', 'ul', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p']
    allowed_attributes = {'a': ['href', 'title']}
    return bleach.clean(text, tags=allowed_tags, attributes=allowed_attributes, strip=True)

def markdown_to_html(text):
    return markdown.markdown(text, extensions=['extra', 'nl2br'])

def process_markdown_field(raw_text):
    safe_text = sanitize_html(raw_text)
    html = markdown_to_html(safe_text)
    return safe_text, html