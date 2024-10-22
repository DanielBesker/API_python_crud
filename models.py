#bloco2

# models.py
from sqlalchemy import Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base

# Modelo para o Aluno
class Aluno(Base):
    __tablename__ = "alunos"
    id = Column(Integer, primary_key=True, autoincrement=True)  # PK autoincremental
    nome = Column(String, nullable=False)  # Nome obrigatório
    email = Column(String, nullable=False, unique=True)  # E-mail único e obrigatório
    idade = Column(Integer, nullable=False)  # Idade obrigatória
    nota_primeiro_modulo = Column(Float, nullable=False)  # Nota do primeiro módulo
    nota_segundo_modulo = Column(Float, nullable=False)  # Nota do segundo módulo
    media = Column(Float)  # Média das notas (opcional)
    turma_id = Column(Integer, ForeignKey("turmas.id"))  # Relacionamento com a turma

# Modelo para a Turma
class Turma(Base):
    __tablename__ = "turmas"
    id = Column(Integer, primary_key=True, autoincrement=True)  # PK autoincremental
    nome = Column(String, nullable=False)  # Nome da turma
    instrutor = Column(String, nullable=False)  # Nome do instrutor
    alunos = relationship("Aluno", backref="turma")  # Relacionamento com os alunos

# Modelo para o Funcionario
class Funcionario(Base):
    __tablename__ = "funcionarios"
    id = Column(Integer, primary_key=True, autoincrement=True)  # PK autoincremental
    nome = Column(String, nullable=False)  # Nome obrigatório
    email = Column(String, nullable=False, unique=True)  # E-mail único e obrigatório
    senha = Column(String, nullable=False)  # Senha obrigatória (deve ser criptografada)
    cargo = Column(String, nullable=False)  # Cargo do funcionário
