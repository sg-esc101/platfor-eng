from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
import psutil

app = FastAPI()

templates = Jinja2Templates(directory="templates")
app.mount("/static", StaticFiles(directory="static"), name="static")

def test():
    return "OK"

@app.get("/", response_class=HTMLResponse)
async def read_root(request: Request):
    return templates.TemplateResponse(
        "index.html", {"request": request, "message": "Hello World"}
    )


@app.get("/status")
async def get_status():
    return {"status": "ok"}


@app.get("/health", response_class=HTMLResponse)
async def get_health(request: Request):
    cpu_percent = psutil.cpu_percent(interval=1)
    memory_info = psutil.virtual_memory()
    disk_usage = psutil.disk_usage('/')

    health_data = {
        "cpu_percent": cpu_percent,
        "memory_total": round(memory_info.total / (1024**3), 2),  # GB
        "memory_available": round(memory_info.available / (1024**3), 2),  # GB
        "memory_used": round(memory_info.used / (1024**3), 2),  # GB
        "memory_free": round(memory_info.free / (1024**3), 2),  # GB
        "disk_total": round(disk_usage.total / (1024**3), 2),  # GB
        "disk_used": round(disk_usage.used / (1024**3), 2),  # GB
        "disk_free": round(disk_usage.free / (1024**3), 2),  # GB
        "disk_percent": disk_usage.percent,
    }
    return templates.TemplateResponse(
        "health.html", {"request": request, "health_data": health_data}
    )
