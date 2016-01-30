from flask import Flask
from flask import render_template

app = Flask(__name__)

app.debug = True



@app.route("/")
@app.route("/index")
def index():
    ports=[8000,80,8094]
    return render_template("porttest.html",ports = ports)



if __name__ == "__main__":

    app.run()
