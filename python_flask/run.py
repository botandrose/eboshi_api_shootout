from app import app
import signal
import sys

def signal_handler(signal, frame):
    sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)

if __name__ == "__main__":
    app.run(debug=True, port=6969)
