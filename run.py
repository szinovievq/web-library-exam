from app import create_app, db
from app.models import Role, ReviewStatus, Genre, User
from werkzeug.security import generate_password_hash

app = create_app()

@app.cli.command("init-db")
def init_db():
    db.create_all()
    if not Role.query.first():
        roles = [
            Role(name='администратор', description='Полный доступ'),
            Role(name='модератор', description='Редактирование книг и модерация рецензий'),
            Role(name='пользователь', description='Может оставлять рецензии')
        ]
        db.session.add_all(roles)
        db.session.commit()
    if not ReviewStatus.query.first():
        statuses = [
            ReviewStatus(name='на рассмотрении'),
            ReviewStatus(name='одобрена'),
            ReviewStatus(name='отклонена')
        ]
        db.session.add_all(statuses)
        db.session.commit()
    if not Genre.query.first():
        genres = ['Фантастика', 'Детектив', 'Роман', 'Наука', 'Поэзия']
        for g in genres:
            db.session.add(Genre(name=g))
        db.session.commit()
    if not User.query.filter_by(login='admin').first():
        admin_role = Role.query.filter_by(name='администратор').first()
        admin = User(
            login='admin',
            password_hash=generate_password_hash('admin'),
            last_name='Admin',
            first_name='Admin',
            role_id=admin_role.id
        )
        db.session.add(admin)
        db.session.commit()
        print('Created admin user: login=admin, password=admin')
    print('Database initialized')

if __name__ == '__main__':
    app.run(debug=True)