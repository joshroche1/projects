from flask import Flask

#Flask Web Server
app = Flask(__name__)
httptext = ""

def readfile():
    f = open("readings.log", "r")
    httptext = f.read()
    f.close()

@app.route('/')
def index():
    readfile()
    return '<!DOCTYPE html><head><title>jarPiZw EnviroPlus</title><meta name="viewport" content="width=device-width, initial-scale=1.0"></head><body>'
    return httptext
    return '</body></html>'

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')
