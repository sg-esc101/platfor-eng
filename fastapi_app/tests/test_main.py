import sys
import os

# Add the parent directory of 'fastapi_app' to sys.path
# sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
sys.path.append("/home/hacker/platfor-eng/platfor-eng")
# import fastapi_app
from fastapi_app.main import app
from fastapi.testclient import TestClient


client = TestClient(app)


def test_status():
    response = client.get("/status")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_root():
    response = client.get("/")
    assert response.status_code == 200

