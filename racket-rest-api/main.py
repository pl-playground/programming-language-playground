import subprocess

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


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
