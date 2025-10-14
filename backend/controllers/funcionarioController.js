//import { query } from '../database.js';
const { query } = require('../database');
// Funções do controller

const path = require('path');

exports.abrirCrudFuncionario = (req, res) => {
  console.log('funcionarioController - Rota /abrirCrudFuncionario - abrir o crudFuncionario');
  res.sendFile(path.join(__dirname, '../../frontend/funcionario/funcionario.html'));
}

exports.listarFuncionarios = async (req, res) => {
  try {
    const result = await query('SELECT func.pessoa_cpf_pessoa, p.nome_pessoa,func.salario_funcionario,func.cargo_id_cargo FROM funcionario cli, pessoa p where func.pessoa_cpf_pessoa = p.cpf_pessoa ORDER BY func.pessoa_cpf_pessoa ');
     console.log('Resultado do SELECT:', result.rows);//verifica se está retornando algo
    res.json(result.rows);
  } catch (error) {
    console.error('Erro ao listar funcionarios:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}


exports.criarFuncionario = async (req, res) => {
  //  console.log('Criando funcionario com dados:', req.body);
  try {
    const { pessoa_cpf_pessoa, salario_funcionario, cargo_id_cargo, porcentagem_comissao_funcionario } = req.body;

    // Validação básica
    if (!salario_funcionario) {
      return res.status(400).json({
        error: 'O salario do funconário é obrigatório'
      });
    }

    const result = await query(
      'INSERT INTO funcionario (pessoa_cpf_pessoa, salario_funcionario, cargo_id_cargo, porcentagem_comissao_funcionario) VALUES ($1, $2) RETURNING *',
      [pessoa_cpf_pessoa, salario_funcionario, cargo_id_cargo, porcentagem_comissao_funcionario]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao criar funcionario:', error);

   

    // Verifica se é erro de violação de constraint NOT NULL
    if (error.code === '23502') {
      return res.status(400).json({
        error: 'Dados obrigatórios não fornecidos'
      });
    }

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.obterFuncionario = async (req, res) => {
  try {
    const id = parseInt(req.params.id);

   // console.log("estou no obter funcionario id="+ id);
    if (isNaN(id)) {
      return res.status(400).json({ error: 'ID deve ser um número válido' });
    }

    const result = await query(
      'SELECT * FROM funcionario WHERE pessoa_cpf_pessoa = $1',
      [id]
    );

    //console.log(result)

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Funcionario não encontrado' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao obter funcionario:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.atualizarFuncionario = async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const { salario_funcionario} = req.body;

   
    // Verifica se a funcionario existe
    const existingPersonResult = await query(
      'SELECT * FROM funcionario WHERE pessoa_cpf_pessoa = $1',
      [id]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ error: 'Funcionario não encontrada' });
    }

    // Constrói a query de atualização dinamicamente para campos não nulos
    const currentPerson = existingPersonResult.rows[0];
    const updatedFields = {
      salario_funcionario: salario_funcionario !== undefined ? salario_funcionario : currentPerson.salario_funcionario     
    };

    // Atualiza a funcionario
    const updateResult = await query(
      'UPDATE funcionario SET salario_funcionario = $1 WHERE pessoa_cpf_pessoa = $2 RETURNING *',
      [updatedFields.salario_funcionario,  id]
    );

    res.json(updateResult.rows[0]);
  } catch (error) {
    console.error('Erro ao atualizar funcionario:', error);

  
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.deletarFuncionario = async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    // Verifica se a funcionario existe
    const existingPersonResult = await query(
      'SELECT * FROM funcionario WHERE pessoa_cpf_pessoa = $1',
      [id]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ error: 'Funcionario não encontrada' });
    }

    // Deleta a funcionario (as constraints CASCADE cuidarão das dependências)
    await query(
      'DELETE FROM funcionario WHERE pessoa_cpf_pessoa = $1',
      [id]
    );

    res.status(204).send();
  } catch (error) {
    console.error('Erro ao deletar funcionario:', error);

    // Verifica se é erro de violação de foreign key (dependências)
    if (error.code === '23503') {
      return res.status(400).json({
        error: 'Não é possível deletar funcionario com dependências associadas'
      });
    }

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}


