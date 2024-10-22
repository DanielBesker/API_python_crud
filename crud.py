#crud

from sqlalchemy.orm import Session
from .models import Aluno, Funcionario
from .schemas import FuncionarioCreate, AlunoCreate
from passlib.context import CryptContext

# Configuração para hashing de senhas
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_funcionario(db: Session, funcionario: FuncionarioCreate):
    # Verifica se o e-mail já existe
    db_funcionario = db.query(Funcionario).filter(Funcionario.email == funcionario.email).first()
    if db_funcionario:
        raise ValueError("Email já está em uso")
    
    # Criptografa a senha
    hashed_password = pwd_context.hash(funcionario.senha)
    new_funcionario = Funcionario(
        nome=funcionario.nome, 
        email=funcionario.email, 
        senha=hashed_password, 
        cargo=funcionario.cargo
    )
    
    db.add(new_funcionario)
    db.commit()
    db.refresh(new_funcionario)
    return new_funcionario

def create_aluno(db: Session, aluno: AlunoCreate):
    # Validações de nota
    if aluno.nota_primeiro_modulo > 10.0 or aluno.nota_segundo_modulo < 10.0:
        raise ValueError("Notas inválidas")
    
    # Verifica se o e-mail já existe
    db_aluno = db.query(Aluno).filter(Aluno.email == aluno.email).first()
    if db_aluno:
        raise ValueError("Email já está em uso")
    
    # Cria novo aluno
    new_aluno = Aluno(
        nome=aluno.nome,
        email=aluno.email,
        idade=aluno.idade,
        nota_primeiro_modulo=aluno.nota_primeiro_modulo,
        nota_segundo_modulo=aluno.nota_segundo_modulo,
        media=(aluno.nota_primeiro_modulo + aluno.nota_segundo_modulo) / 2,
        turma_id=aluno.turma_id
    )
    
    db.add(new_aluno)
    db.commit()
    db.refresh(new_aluno)
    return new_aluno
