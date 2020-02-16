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
  "http://programming-language-playground.com/"
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
  return {"Hello": "Matthias."}


class Item(BaseModel):
  interpret_name: str
  user_input: str


@app.post("/code/")
async def read_item(item: Item):
  clean_interpret_name = ''.join(e for e in item.interpret_name if e.isalnum())
  cmd = ["racket", f"{clean_interpret_name}.rkt", item.user_input]
  racket_output = subprocess.check_output(cmd).decode()

  return {"output": racket_output}
