import subprocess

from fastapi import FastAPI
from pydantic import BaseModel

from starlette.middleware.cors import CORSMiddleware

app = FastAPI()

origins = [
    "http://localhost",
    "http://localhost:8080",
    "http://localhost:4200",
    "http://localhost:*",
    "null",
    # This is for the cloud?
    "http://example.appspot.com"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def read_root():
    return {"Hello": "Matthias. Tell Amal I said Hi."}

class Item(BaseModel):
    interpret_name: str
    user_input: str


@app.post("/code/")
async def read_item(item:  Item):
    cmd = ["racket", f"{item.interpret_name}.rkt", item.user_input]
    racket_output = subprocess.check_output(cmd).decode()

    return {"output": racket_output}
