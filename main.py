# bloco 0

# main.py
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from .database import get_db
from .models import Aluno, Funcionario
from .schemas import FuncionarioCreate, AlunoCreate
from .crud import create_funcionario, create_aluno

app = FastAPI()

# Cria as tabelas no banco de dados
@app.on_event("startup")
def startup():
    import app.database as db
    db.Base.metadata.create_all(bind=db.engine)

@app.post("/funcionarios/")
def register_funcionario(funcionario: FuncionarioCreate, db: Session = Depends(get_db)):
    try:
        return create_funcionario(db, funcionario)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/alunos/")
def register_aluno(aluno: AlunoCreate, db: Session = Depends(get_db)):
    try:
        return create_aluno(db, aluno)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
