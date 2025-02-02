# app.py
from flask import Flask, render_template
from src.controller.resume_controller import resume_bp


def create_app():
    app = Flask(__name__)

    # Load configuration from config.py (if needed)
    app.config.from_pyfile("config.py", silent=True)
    print("")

    # Register our blueprint (all resume-related routes)
    app.register_blueprint(resume_bp)

    # A simple index page (e.g., for your SPA)
    @app.route('/')
    def index():
        return render_template('index.html')

    return app


if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)
