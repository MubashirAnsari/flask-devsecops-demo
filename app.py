import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    secret_value = os.getenv('DEMO_SECRET', 'Not Set')
    return f'Hello, World! Secret is: {secret_value}'

if __name__ == '__main__':
    debug = os.getenv('FLASK_DEBUG', 'False') == 'True'
    app.run(debug=debug, host='0.0.0.0', port=7549)
