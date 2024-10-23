[1mdiff --git a/crud.cpython-312.pyc b/crud.cpython-312.pyc[m
[1mdeleted file mode 100644[m
[1mindex 0f78417..0000000[m
Binary files a/crud.cpython-312.pyc and /dev/null differ
[1mdiff --git a/crud.py b/crud.py[m
[1mdeleted file mode 100644[m
[1mindex 8d091e3..0000000[m
[1m--- a/crud.py[m
[1m+++ /dev/null[m
[36m@@ -1,55 +0,0 @@[m
[31m-#crud[m
[31m-[m
[31m-from sqlalchemy.orm import Session[m
[31m-from .models import Aluno, Funcionario[m
[31m-from .schemas import FuncionarioCreate, AlunoCreate[m
[31m-from passlib.context import CryptContext[m
[31m-[m
[31m-# Configuração para hashing de senhas[m
[31m-pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")[m
[31m-[m
[31m-def create_funcionario(db: Session, funcionario: FuncionarioCreate):[m
[31m-    # Verifica se o e-mail já existe[m
[31m-    db_funcionario = db.query(Funcionario).filter(Funcionario.email == funcionario.email).first()[m
[31m-    if db_funcionario:[m
[31m-        raise ValueError("Email já está em uso")[m
[31m-    [m
[31m-    # Criptografa a senha[m
[31m-    hashed_password = pwd_context.hash(funcionario.senha)[m
[31m-    new_funcionario = Funcionario([m
[31m-        nome=funcionario.nome, [m
[31m-        email=funcionario.email, [m
[31m-        senha=hashed_password, [m
[31m-        cargo=funcionario.cargo[m
[31m-    )[m
[31m-    [m
[31m-    db.add(new_funcionario)[m
[31m-    db.commit()[m
[31m-    db.refresh(new_funcionario)[m
[31m-    return new_funcionario[m
[31m-[m
[31m-def create_aluno(db: Session, aluno: AlunoCreate):[m
[31m-    # Validações de nota[m
[31m-    if aluno.nota_primeiro_modulo > 10.0 or aluno.nota_segundo_modulo < 10.0:[m
[31m-        raise ValueError("Notas inválidas")[m
[31m-    [m
[31m-    # Verifica se o e-mail já existe[m
[31m-    db_aluno = db.query(Aluno).filter(Aluno.email == aluno.email).first()[m
[31m-    if db_aluno:[m
[31m-        raise ValueError("Email já está em uso")[m
[31m-    [m
[31m-    # Cria novo aluno[m
[31m-    new_aluno = Aluno([m
[31m-        nome=aluno.nome,[m
[31m-        email=aluno.email,[m
[31m-        idade=aluno.idade,[m
[31m-        nota_primeiro_modulo=aluno.nota_primeiro_modulo,[m
[31m-        nota_segundo_modulo=aluno.nota_segundo_modulo,[m
[31m-        media=(aluno.nota_primeiro_modulo + aluno.nota_segundo_modulo) / 2,[m
[31m-        turma_id=aluno.turma_id[m
[31m-    )[m
[31m-    [m
[31m-    db.add(new_aluno)[m
[31m-    db.commit()[m
[31m-    db.refresh(new_aluno)[m
[31m-    return new_aluno[m
[1mdiff --git a/database.cpython-312.pyc b/database.cpython-312.pyc[m
[1mdeleted file mode 100644[m
[1mindex 8e91e9e..0000000[m
Binary files a/database.cpython-312.pyc and /dev/null differ
[1mdiff --git a/database.py b/database.py[m
[1mdeleted file mode 100644[m
[1mindex ec84a13..0000000[m
[1m--- a/database.py[m
[1m+++ /dev/null[m
[36m@@ -1,24 +0,0 @@[m
[31m-#bloco 3[m
[31m-[m
[31m-# database.py[m
[31m-from sqlalchemy import create_engine[m
[31m-from sqlalchemy.ext.declarative import declarative_base[m
[31m-from sqlalchemy.orm import sessionmaker[m
[31m-[m
[31m-# URL para se conectar ao banco de dados PostgreSQL[m
[31m-DATABASE_URL = "postgresql://postgres:123@localhost:5432/AlunoDB"[m
[31m-[m
[31m-# Cria a conexão com o banco de dados[m
[31m-engine = create_engine(DATABASE_URL)[m
[31m-SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)[m
[31m-[m
[31m-# Base para os modelos[m
[31m-Base = declarative_base()[m
[31m-[m
[31m-# Função para obter a sessão do banco de dados[m
[31m-def get_db():[m
[31m-    db = SessionLocal()[m
[31m-    try:[m
[31m-        yield db[m
[31m-    finally:[m
[31m-        db.close()[m
[1mdiff --git a/main.cpython-312.pyc b/main.cpython-312.pyc[m
[1mdeleted file mode 100644[m
[1mindex cea2340..0000000[m
Binary files a/main.cpython-312.pyc and /dev/null differ
[1mdiff --git a/main.py b/main.py[m
[1mdeleted file mode 100644[m
[1mindex 97933d3..0000000[m
[1m--- a/main.py[m
[1m+++ /dev/null[m
[36m@@ -1,31 +0,0 @@[m
[31m-# bloco 0[m
[31m-[m
[31m-# main.py[m
[31m-from fastapi import FastAPI, Depends, HTTPException[m
[31m-from sqlalchemy.orm import Session[m
[31m-from .database import get_db[m
[31m-from .models import Aluno, Funcionario[m
[31m-from .schemas import FuncionarioCreate, AlunoCreate[m
[31m-from .crud import create_funcionario, create_aluno[m
[31m-[m
[31m-app = FastAPI()[m
[31m-[m
[31m-# Cria as tabelas no banco de dados[m
[31m-@app.on_event("startup")[m
[31m-def startup():[m
[31m-    import app.database as db[m
[31m-    db.Base.metadata.create_all(bind=db.engine)[m
[31m-[m
[31m-@app.post("/funcionarios/")[m
[31m-def register_funcionario(funcionario: FuncionarioCreate, db: Session = Depends(get_db)):[m
[31m-    try:[m
[31m-        return create_funcionario(db, funcionario)[m
[31m-    except ValueError as e:[m
[31m-        raise HTTPException(status_code=400, detail=str(e))[m
[31m-[m
[31m-@app.post("/alunos/")[m
[31m-def register_aluno(aluno: AlunoCreate, db: Session = Depends(get_db)):[m
[31m-    try:[m
[31m-        return create_aluno(db, aluno)[m
[31m-    except ValueError as e:[m
[31m-        raise HTTPException(status_code=400, detail=str(e))[m
[1mdiff --git a/models.cpython-312.pyc b/models.cpython-312.pyc[m
[1mdeleted file mode 100644[m
[1mindex a041d54..0000000[m
Binary files a/models.cpython-312.pyc and /dev/null differ
[1mdiff --git a/models.py b/models.py[m
[1mdeleted file mode 100644[m
[1mindex 76b6ef7..0000000[m
[1m--- a/models.py[m
[1m+++ /dev/null[m
[36m@@ -1,35 +0,0 @@[m
[31m-#bloco2[m
[31m-[m
[31m-# models.py[m
[31m-from sqlalchemy import Column, Integer, String, Float, ForeignKey[m
[31m-from sqlalchemy.orm import relationship[m
[31m-from .database import Base[m
[31m-[m
[31m-# Modelo para o Aluno[m
[31m-class Aluno(Base):[m
[31m-    __tablename__ = "alunos"[m
[31m-    id = Column(Integer, primary_key=True, autoincrement=True)  # PK autoincremental[m
[31m-    nome = Column(String, nullable=False)  # Nome obrigatório[m
[31m-    email = Column(String, nullable=False, unique=True)  # E-mail único e obrigatório[m
[31m-    idade = Column(Integer, nullable=False)  # Idade obrigatória[m
[31m-    nota_primeiro_modulo = Column(Float, nullable=False)  # Nota do primeiro módulo[m
[31m-    nota_segundo_modulo = Column(Float, nullable=False)  # Nota do segundo módulo[m
[31m-    media = Column(Float)  # Média das notas (opcional)[m
[31m-    turma_id = Column(Integer, ForeignKey("turmas.id"))  # Relacionamento com a turma[m
[31m-[m
[31m-# Modelo para a Turma[m
[31m-class Turma(Base):[m
[31m-    __tablename__ = "turmas"[m
[31m-    id = Column(Integer, primary_key=True, autoincrement=True)  # PK autoincremental[m
[31m-    nome = Column(String, nullable=False)  # Nome da turma[m
[31m-    instrutor = Column(String, nullable=False)  # Nome do instrutor[m
[31m-    alunos = relationship("Aluno", backref="turma")  # Relacionamento com os alunos[m
[31m-[m
[31m-# Modelo para o Funcionario[m
[31m-class Funcionario(Base):[m
[31m-    __tablename__ = "funcionarios"[m
[31m-    id = Column(Integer, primary_key=True, autoincrement=True)  # PK autoincremental[m
[31m-    nome = Column(String, nullable=False)  # Nome obrigatório[m
[31m-    email = Column(String, nullable=False, unique=True)  # E-mail único e obrigatório[m
[31m-    senha = Column(String, nullable=False)  # Senha obrigatória (deve ser criptografada)[m
[31m-    cargo = Column(String, nullable=False)  # Cargo do funcionário[m
[1mdiff --git a/schemas.cpython-312.pyc b/schemas.cpython-312.pyc[m
[1mdeleted file mode 100644[m
[1mindex 52d073e..0000000[m
Binary files a/schemas.cpython-312.pyc and /dev/null differ
[1mdiff --git a/schemas.py b/schemas.py[m
[1mdeleted file mode 100644[m
[1mindex a30df76..0000000[m
[1m--- a/schemas.py[m
[1m+++ /dev/null[m
[36m@@ -1,17 +0,0 @@[m
[31m-from pydantic import BaseModel, EmailStr[m
[31m-[m
[31m-# Modelo para criar um Funcionário[m
[31m-class FuncionarioCreate(BaseModel):[m
[31m-    nome: str[m
[31m-    email: EmailStr[m
[31m-    senha: str[m
[31m-    cargo: str[m
[31m-[m
[31m-# Modelo para criar um Aluno[m
[31m-class AlunoCreate(BaseModel):[m
[31m-    nome: str[m
[31m-    email: EmailStr[m
[31m-    idade: int[m
[31m-    nota_primeiro_modulo: float[m
[31m-    nota_segundo_modulo: float[m
[31m-    turma_id: int[m
[1mdiff --git a/utils.py b/utils.py[m
[1mdeleted file mode 100644[m
[1mindex c5c0423..0000000[m
[1m--- a/utils.py[m
[1m+++ /dev/null[m
[36m@@ -1,15 +0,0 @@[m
[31m-import jwt[m
[31m-from datetime import datetime, timedelta[m
[31m-[m
[31m-SECRET_KEY = "your_secret_key"[m
[31m-ALGORITHM = "HS256"[m
[31m-[m
[31m-def create_access_token(data: dict, expires_delta: timedelta = None):[m
[31m-    to_encode = data.copy()[m
[31m-    if expires_delta:[m
[31m-        expire = datetime.utcnow() + expires_delta[m
[31m-    else:[m
[31m-        expire = datetime.utcnow() + timedelta(hours=3)[m
[31m-    to_encode.update({"exp": expire})[m
[31m-    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)[m
[31m-    return encoded_jwt[m
