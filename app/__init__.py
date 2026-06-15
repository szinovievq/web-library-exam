from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager
from config import Config
import markdown
import bleach

db = SQLAlchemy()
migrate = Migrate()
login_manager = LoginManager()
login_manager.login_view = 'main.login'
login_manager.login_message = 'Для выполнения данного действия необходимо пройти процедуру аутентификации'

def markdown_filter(text):
    if not text:
        return ''
    allowed_tags = ['a', 'abbr', 'acronym', 'b', 'blockquote', 'code', 'em', 'i', 'li', 'ol', 'pre', 'strong', 'ul', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p', 'br']
    allowed_attributes = {'a': ['href', 'title']}
    html = markdown.markdown(text, extensions=['extra', 'nl2br'])
    clean_html = bleach.clean(html, tags=allowed_tags, attributes=allowed_attributes, strip=True)
    return clean_html

def init_database(app):
    with app.app_context():
        from app.models import Role, ReviewStatus, Genre, User
        from werkzeug.security import generate_password_hash

        inspector = db.inspect(db.engine)
        if not inspector.has_table('role'):
            db.create_all()
            print("Таблицы созданы")

            roles = [
                Role(name='администратор', description='Полный доступ'),
                Role(name='модератор', description='Редактирование книг и модерация рецензий'),
                Role(name='пользователь', description='Может оставлять рецензии')
            ]
            db.session.add_all(roles)
            db.session.commit()
            print("Роли добавлены")

            statuses = [
                ReviewStatus(name='на рассмотрении'),
                ReviewStatus(name='одобрена'),
                ReviewStatus(name='отклонена')
            ]
            db.session.add_all(statuses)
            db.session.commit()
            print("Статусы рецензий добавлены")

            genres = ['Фантастика', 'Детектив', 'Роман', 'Наука', 'Поэзия', 'Приключения', 'Классика']
            for g in genres:
                db.session.add(Genre(name=g))
            db.session.commit()
            print("Жанры добавлены")

            user_role = Role.query.filter_by(name='пользователь').first()
            if user_role:
                users_data = [
                    {'login': 'user1', 'last_name': 'Иванов', 'first_name': 'Иван', 'middle_name': 'Иванович'},
                    {'login': 'user2', 'last_name': 'Петрова', 'first_name': 'Анна', 'middle_name': 'Сергеевна'},
                    {'login': 'user3', 'last_name': 'Сидоров', 'first_name': 'Пётр', 'middle_name': 'Алексеевич'},
                    {'login': 'user4', 'last_name': 'Козлова', 'first_name': 'Елена', 'middle_name': 'Дмитриевна'},
                    {'login': 'user5', 'last_name': 'Смирнов', 'first_name': 'Алексей', 'middle_name': 'Владимирович'}
                ]
                for data in users_data:
                    user = User(
                        login=data['login'],
                        password_hash=generate_password_hash('userpass'),
                        last_name=data['last_name'],
                        first_name=data['first_name'],
                        middle_name=data['middle_name'],
                        role_id=user_role.id
                    )
                    db.session.add(user)
                db.session.commit()
                print("Пользователи user1..user5 созданы (пароль userpass)")

            moderator_role = Role.query.filter_by(name='модератор').first()
            if moderator_role:
                moderator = User(
                    login='moderator',
                    password_hash=generate_password_hash('moderpass'),
                    last_name='',
                    first_name='Модератор',
                    middle_name='',
                    role_id=moderator_role.id
                )
                db.session.add(moderator)
                db.session.commit()
                print("Модератор создан: login=moderator, password=moderpass")

            admin_role = Role.query.filter_by(name='администратор').first()
            if admin_role:
                admin = User(
                    login='admin',
                    password_hash=generate_password_hash('adminpass'),
                    last_name='',
                    first_name='Администратор',
                    middle_name='',
                    role_id=admin_role.id
                )
                db.session.add(admin)
                db.session.commit()
                print("Администратор создан: login=admin, password=adminpass")

            print("База данных полностью инициализирована.")
        else:
            user_role = Role.query.filter_by(name='пользователь').first()
            if user_role:
                users_data = [
                    {'login': 'user1', 'last_name': 'Иванов', 'first_name': 'Иван', 'middle_name': 'Иванович'},
                    {'login': 'user2', 'last_name': 'Петрова', 'first_name': 'Анна', 'middle_name': 'Сергеевна'},
                    {'login': 'user3', 'last_name': 'Сидоров', 'first_name': 'Пётр', 'middle_name': 'Алексеевич'},
                    {'login': 'user4', 'last_name': 'Козлова', 'first_name': 'Елена', 'middle_name': 'Дмитриевна'},
                    {'login': 'user5', 'last_name': 'Смирнов', 'first_name': 'Алексей', 'middle_name': 'Владимирович'}
                ]
                for data in users_data:
                    if not User.query.filter_by(login=data['login']).first():
                        new_user = User(
                            login=data['login'],
                            password_hash=generate_password_hash('userpass'),
                            last_name=data['last_name'],
                            first_name=data['first_name'],
                            middle_name=data['middle_name'],
                            role_id=user_role.id
                        )
                        db.session.add(new_user)
                        print(f"Добавлен пользователь {data['login']}")
                db.session.commit()

            moderator_role = Role.query.filter_by(name='модератор').first()
            if moderator_role and not User.query.filter_by(login='moderator').first():
                moderator = User(
                    login='moderator',
                    password_hash=generate_password_hash('moderpass'),
                    last_name='',
                    first_name='Модератор',
                    middle_name='',
                    role_id=moderator_role.id
                )
                db.session.add(moderator)
                db.session.commit()
                print("Добавлен модератор")

            admin_role = Role.query.filter_by(name='администратор').first()
            if admin_role and not User.query.filter_by(login='admin').first():
                admin = User(
                    login='admin',
                    password_hash=generate_password_hash('adminpass'),
                    last_name='',
                    first_name='Администратор',
                    middle_name='',
                    role_id=admin_role.id
                )
                db.session.add(admin)
                db.session.commit()
                print("Добавлен администратор")

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    app.jinja_env.filters['markdown'] = markdown_filter

    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)

    from app.models import User

    @login_manager.user_loader
    def load_user(user_id):
        return User.query.get(int(user_id))

    from app.routes import bp
    app.register_blueprint(bp)

    init_database(app)

    return app