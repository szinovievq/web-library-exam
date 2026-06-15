from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField, IntegerField, SelectField, SelectMultipleField, FileField, PasswordField, BooleanField, SubmitField
from wtforms.validators import DataRequired, NumberRange, Length, ValidationError, InputRequired
from app.models import Genre

class BookForm(FlaskForm):
    title = StringField('Название', validators=[DataRequired()])
    description = TextAreaField('Описание', validators=[DataRequired()])
    year = IntegerField('Год', validators=[DataRequired(), NumberRange(min=0, max=2026)])
    publisher = StringField('Издательство', validators=[DataRequired()])
    author = StringField('Автор', validators=[DataRequired()])
    pages = IntegerField('Объём (страниц)', validators=[DataRequired(), NumberRange(min=1)])
    genres = SelectMultipleField('Жанры', coerce=int, validators=[DataRequired()])
    cover = FileField('Обложка')
    submit = SubmitField('Сохранить')

    def __init__(self, *args, **kwargs):
        super(BookForm, self).__init__(*args, **kwargs)
        self.genres.choices = [(g.id, g.name) for g in Genre.query.order_by('name')]

class ReviewForm(FlaskForm):
    rating = SelectField('Оценка', choices=[(5, 'Отлично'), (4, 'Хорошо'), (3, 'Удовлетворительно'), (2, 'Неудовлетворительно'), (1, 'Плохо'), (0, 'Ужасно')], coerce=int, validators=[InputRequired()])
    text = TextAreaField('Текст рецензии', validators=[DataRequired()])
    submit = SubmitField('Сохранить')

class LoginForm(FlaskForm):
    login = StringField('Логин', validators=[DataRequired()])
    password = PasswordField('Пароль', validators=[DataRequired()])
    remember_me = BooleanField('Запомнить меня')
    submit = SubmitField('Войти')