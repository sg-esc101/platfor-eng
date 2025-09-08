from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_status_endpoint():
    response = client.get("/status")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

def test_root_endpoint():
    response = client.get("/")
    assert response.status_code == 200
    assert "Hello World" in response.text
