from flask import Blueprint, render_template, redirect, url_for, flash, request, abort, current_app
from flask_login import login_user, logout_user, login_required, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from sqlalchemy import desc
from app import db
from app.models import Book, Genre, Cover, Review, ReviewStatus, User, Role
from app.forms import BookForm, ReviewForm, LoginForm
from app.utils import save_cover, delete_cover_file, process_markdown_field, sanitize_html, markdown_to_html

bp = Blueprint('main', __name__)


def admin_required(func):
    def wrapper(*args, **kwargs):
        if not current_user.is_authenticated or current_user.role.name != 'администратор':
            flash('У вас недостаточно прав для выполнения данного действия')
            return redirect(url_for('main.index'))
        return func(*args, **kwargs)

    wrapper.__name__ = func.__name__
    return wrapper


def moderator_or_admin_required(func):
    def wrapper(*args, **kwargs):
        if not current_user.is_authenticated or current_user.role.name not in ('администратор', 'модератор'):
            flash('У вас недостаточно прав для выполнения данного действия')
            return redirect(url_for('main.index'))
        return func(*args, **kwargs)

    wrapper.__name__ = func.__name__
    return wrapper


@bp.route('/')
def index():
    page = request.args.get('page', 1, type=int)
    books = Book.query.order_by(desc(Book.year)).paginate(page=page, per_page=10, error_out=False)

    approved_status = ReviewStatus.query.filter_by(name='одобрена').first()
    approved_status_id = approved_status.id if approved_status else None

    books_with_stats = []
    for book in books.items:
        reviews = book.reviews.filter_by(status_id=approved_status_id).all()
        count = len(reviews)
        avg = sum(r.rating for r in reviews) / count if count > 0 else None
        books_with_stats.append({
            'avg_rating': avg,
            'reviews_count': count
        })

    return render_template('index.html', books=books, books_with_stats=books_with_stats)


@bp.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('main.index'))
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(login=form.login.data).first()
        if user and check_password_hash(user.password_hash, form.password.data):
            login_user(user, remember=form.remember_me.data)
            next_page = request.args.get('next')
            return redirect(next_page or url_for('main.index'))
        else:
            flash('Невозможно аутентифицироваться с указанными логином и паролем')
    return render_template('login.html', form=form)


@bp.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('main.index'))


@bp.route('/book/<int:id>')
def book_detail(id):
    book = Book.query.get_or_404(id)
    approved_status = ReviewStatus.query.filter_by(name='одобрена').first()
    reviews = Review.query.filter_by(book_id=id, status_id=approved_status.id).all()
    user_review = None
    if current_user.is_authenticated:
        user_review = Review.query.filter_by(book_id=id, user_id=current_user.id).first()
    return render_template('book_detail.html', book=book, reviews=reviews, user_review=user_review)


@bp.route('/book/add', methods=['GET', 'POST'])
@admin_required
def add_book():
    form = BookForm()
    if request.method == 'POST':
        if form.validate_on_submit():
            try:
                safe_desc, _ = process_markdown_field(form.description.data)
                book = Book(
                    title=form.title.data,
                    description=safe_desc,
                    year=form.year.data,
                    publisher=form.publisher.data,
                    author=form.author.data,
                    pages=form.pages.data
                )
                db.session.add(book)
                db.session.flush()
                book.genres = Genre.query.filter(Genre.id.in_(form.genres.data)).all()
                if form.cover.data:
                    save_cover(form.cover.data, book.id)
                db.session.commit()
                flash('Книга успешно добавлена', 'success')
                return redirect(url_for('main.book_detail', id=book.id))
            except Exception as e:
                db.session.rollback()
                flash('При сохранении данных возникла ошибка. Проверьте корректность введённых данных.', 'danger')
                print(f"Ошибка: {e}")
        else:
            print("Ошибки валидации формы добавления книги:", form.errors)
            flash('Пожалуйста, исправьте ошибки в форме (заполните все поля, выберите жанры).', 'danger')
    return render_template('book_form.html', form=form, title='Добавление книги')


@bp.route('/book/<int:id>/edit', methods=['GET', 'POST'])
@moderator_or_admin_required
def edit_book(id):
    book = Book.query.get_or_404(id)
    form = BookForm(obj=book)
    if form.validate_on_submit():
        try:
            safe_desc, _ = process_markdown_field(form.description.data)
            book.title = form.title.data
            book.description = safe_desc
            book.year = form.year.data
            book.publisher = form.publisher.data
            book.author = form.author.data
            book.pages = form.pages.data
            book.genres = Genre.query.filter(Genre.id.in_(form.genres.data)).all()
            db.session.commit()
            flash('Книга успешно обновлена', 'success')
            return redirect(url_for('main.book_detail', id=book.id))
        except Exception as e:
            db.session.rollback()
            flash('При сохранении данных возникла ошибка. Проверьте корректность введённых данных.', 'danger')
    else:
        form.genres.data = [g.id for g in book.genres]
    return render_template('book_form.html', form=form, title='Редактирование книги', book=book)


@bp.route('/book/<int:id>/delete', methods=['POST'])
@admin_required
def delete_book(id):
    book = Book.query.get_or_404(id)
    try:
        if book.cover:
            delete_cover_file(book.cover)
        db.session.delete(book)
        db.session.commit()
        flash('Книга успешно удалена', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Ошибка при удалении книги', 'danger')
    return redirect(url_for('main.index'))


@bp.route('/book/<int:id>/review/add', methods=['GET', 'POST'])
@login_required
def add_review(id):
    book = Book.query.get_or_404(id)
    existing_review = Review.query.filter_by(book_id=id, user_id=current_user.id).first()
    if existing_review:
        flash('Вы уже оставляли рецензию на эту книгу', 'warning')
        return redirect(url_for('main.book_detail', id=id))
    form = ReviewForm()
    if request.method == 'POST':
        if form.validate_on_submit():
            try:
                safe_text, _ = process_markdown_field(form.text.data)
                pending_status = ReviewStatus.query.filter_by(name='на рассмотрении').first()
                if not pending_status:
                    pending_status = ReviewStatus(name='на рассмотрении')
                    db.session.add(pending_status)
                    db.session.commit()
                review = Review(
                    book_id=id,
                    user_id=current_user.id,
                    rating=form.rating.data,
                    text=safe_text,
                    status_id=pending_status.id
                )
                db.session.add(review)
                db.session.commit()
                flash('Рецензия отправлена на модерацию', 'success')
                return redirect(url_for('main.book_detail', id=id))
            except Exception as e:
                db.session.rollback()
                flash('Ошибка при сохранении рецензии', 'danger')
                print(f"Ошибка сохранения рецензии: {e}")
        else:
            print("Ошибки валидации формы рецензии:", form.errors)
            flash('Пожалуйста, заполните все поля рецензии (оценка и текст).', 'danger')
    return render_template('review_form.html', form=form, book=book)


@bp.route('/my-reviews')
@login_required
def my_reviews():
    reviews = Review.query.filter_by(user_id=current_user.id).order_by(desc(Review.created_at)).all()
    return render_template('my_reviews.html', reviews=reviews)


@bp.route('/moderation/reviews')
@login_required
def moderation_reviews():
    if current_user.role.name not in ('администратор', 'модератор'):
        abort(403)
    pending_status = ReviewStatus.query.filter_by(name='на рассмотрении').first()
    page = request.args.get('page', 1, type=int)
    reviews = Review.query.filter_by(status_id=pending_status.id).order_by(desc(Review.created_at)).paginate(page=page,
                                                                                                             per_page=10,
                                                                                                             error_out=False)
    return render_template('moderation_reviews.html', reviews=reviews)


@bp.route('/moderation/review/<int:id>', methods=['GET', 'POST'])
@login_required
def moderate_review(id):
    if current_user.role.name not in ('администратор', 'модератор'):
        abort(403)
    review = Review.query.get_or_404(id)
    if request.method == 'POST':
        action = request.form.get('action')
        if action == 'approve':
            approved_status = ReviewStatus.query.filter_by(name='одобрена').first()
            review.status_id = approved_status.id
            flash('Рецензия одобрена', 'success')
        elif action == 'reject':
            rejected_status = ReviewStatus.query.filter_by(name='отклонена').first()
            review.status_id = rejected_status.id
            flash('Рецензия отклонена', 'warning')
        db.session.commit()
        return redirect(url_for('main.moderation_reviews'))
    return render_template('moderation_review.html', review=review)