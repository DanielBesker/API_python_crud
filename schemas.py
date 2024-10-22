from pydantic import BaseModel, EmailStr

# Modelo para criar um Funcionário
class FuncionarioCreate(BaseModel):
    nome: str
    email: EmailStr
    senha: str
    cargo: str

# Modelo para criar um Aluno
class AlunoCreate(BaseModel):
    nome: str
    email: EmailStr
    idade: int
    nota_primeiro_modulo: float
    nota_segundo_modulo: float
    turma_id: int
