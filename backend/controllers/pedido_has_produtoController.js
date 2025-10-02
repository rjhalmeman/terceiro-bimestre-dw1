//import { query } from '../database.js';
const { query } = require('../database');
// Funções do controller

const path = require('path');

exports.abrirCrudPedido_has_produto = (req, res) => {
  console.log('pedido_has_produtoController - Rota /abrirCrudPedido_has_produto - abrir o crudPedido_has_produto');
  res.sendFile(path.join(__dirname, '../../frontend/pedido_has_produto/pedido_has_produto.html'));
}

exports.listarPedido_has_produtos = async (req, res) => {
  try {
    const result = await query('SELECT * FROM pedido_has_produto ORDER BY pedido_id_pedido');
    console.log('Resultado do SELECT:', result.rows);//verifica se está retornando algo
    res.json(result.rows);
  } catch (error) {
    console.error('Erro ao listar pedido_has_produtos:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}


exports.criarPedido_has_produto = async (req, res) => {
  //  console.log('Criando pedido_has_produto com dados:', req.body);
  try {
    const { pedido_id_pedido, produto_id_produto, quantidade, preco_unitario } = req.body;


    const result = await query(
      'INSERT INTO pedido_has_produto (pedido_id_pedido, produto_id_produto, quantidade, preco_unitario) VALUES ($1, $2, $3,$4) RETURNING *',
      [pedido_id_pedido, produto_id_produto, quantidade, preco_unitario]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao criar pedido_has_produto:', error);



    // Verifica se é erro de violação de constraint NOT NULL
    if (error.code === '23502') {
      return res.status(400).json({
        error: 'Dados obrigatórios não fornecidos'
      });
    }

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

/////////////////////////////////////////////////////////////////////
// Nova função para obter itens de um pedido específico
/////////////////////////////////////////////////////////////////////

exports.obterItensDeUmPedido_has_produto = async (req, res) => {
  try {
    console.log("Requisição recebida para obter itens de um pedido especifico:");
    // 1. Extrai o ID do pedido dos parâmetros da requisição
    const { idPedido } = req.params;

    // 2. A query SQL com o parâmetro seguro ($1)
    const result = await query(
      'SELECT php.pedido_id_pedido , php.produto_id_produto , nome_produto , php.quantidade , php.preco_unitario' +
      ' FROM pedido_has_produto php, produto p ' +
      ' WHERE php.pedido_id_pedido = $1 and  php.produto_id_produto = p.id_produto ORDER BY php.produto_id_produto;',
      [idPedido]
    );

    // 4. Verifica se foram encontrados itens
    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Nenhum item encontrado para este pedido.' });
    }

    // 5. Retorna os itens encontrados
    res.status(200).json(result.rows);

  } catch (error) {
    // 6. Em caso de erro, retorna uma mensagem de erro genérica
    console.error('Erro ao obter itens do pedido:', error);
    res.status(500).json({ message: 'Erro ao processar a requisição.', error: error.message });
  }
};

exports.obterPedido_has_produto = async (req, res) => {
  try {
    //chave composta id_pedido e id_produto
    const { id_pedido, id_produto } = req.params;
    const idPedido = parseInt(id_pedido);
    const idProduto = parseInt(id_produto);

     console.log("estou no obter pedido_has_produto =>"+ " IdPedido="+ idPedido + " idProduto= "+ idProduto);
    // Verifica se ambos os IDs são números válidos
    if (isNaN(idPedido) || isNaN(idProduto)) {
      return res.status(400).json({ error: 'IDs devem ser números válidos' });
    }

    const result = await query(
      'SELECT php.pedido_id_pedido , php.produto_id_produto , nome_produto , php.quantidade , php.preco_unitario' +
      ' FROM pedido_has_produto php, produto p ' +
      ' WHERE php.pedido_id_pedido = $1 AND php.produto_id_produto=$2 AND php.produto_id_produto = p.id_produto;',
      [idPedido, idProduto]
    );

    //console.log(result)

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Pedido_has_produto não encontrado' });
    }

    res.json(result.rows); //retorna todos os itens do pedido
  } catch (error) {
    console.error('Erro ao obter pedido_has_produto:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.atualizarPedido_has_produto = async (req, res) => {
  try {
    // Imprime todos os parâmetros da requisição para debugar
    console.log("---------------------------------------");
    console.log("Requisição recebida para atualizar item:");
    console.log("Parâmetros da URL (req.params):", req.params);
    console.log("Corpo da requisição (req.body):", req.body);
    console.log("---------------------------------------");

    // Extraímos ambos os IDs dos parâmetros da requisição, considerando a PK composta
    const { id_pedido, id_produto } = req.params;
    const dadosParaAtualizar = req.body;

    console.log("id_pedido:", id_pedido, "id_produto:", id_produto);
    console.log("dadosParaAtualizar:", dadosParaAtualizar);

    // Verifica se ambos os IDs são números válidos
    if (isNaN(parseInt(id_pedido)) || isNaN(parseInt(id_produto))) {
      return res.status(400).json({ error: 'IDs devem ser números válidos' });
    }

    // Verifica se a pedido_has_produto existe  


    // Verifica se a pedido_has_produto existe
    const existingPersonResult = await query(
      'SELECT * FROM pedido_has_produto WHERE pedido_id_pedido = $1 AND produto_id_produto = $2',
      [id_pedido, id_produto]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ error: 'Pedido_has_produto não encontrado' });
    }

    // Constrói a query de atualização dinamicamente para campos id_pedido, id_produto, quantidade, preco_unitario  
    const updatedFields = {};
    if (dadosParaAtualizar.quantidade !== undefined) {
      updatedFields.quantidade = dadosParaAtualizar.quantidade;
    }
    if (dadosParaAtualizar.preco_unitario !== undefined) {
      updatedFields.preco_unitario = dadosParaAtualizar.preco_unitario;
    }

    if (Object.keys(updatedFields).length === 0) {
      return res.status(400).json({ error: 'Nenhum campo válido para atualizar' });
    }

    console.log("Campos a serem atualizados:", updatedFields);
    console.log("ID da pedido_has_produto a ser atualizada:", id_pedido, id_produto);


    // Atualiza a pedido_has_produto
    const updateResult = await query( // Ajuste na query para considerar a PK composta
      'UPDATE pedido_has_produto SET quantidade = $1, preco_unitario = $2 WHERE pedido_id_pedido = $3 AND produto_id_produto = $4 RETURNING *',
      [updatedFields.quantidade, updatedFields.preco_unitario, id_pedido, id_produto]
    );

    res.json(updateResult.rows[0]);
  } catch (error) {
    console.error('Erro ao atualizar pedido_has_produto:', error);


    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.deletarPedido_has_produto = async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    // Verifica se a pedido_has_produto existe
    const existingPersonResult = await query(
      'SELECT * FROM pedido_has_produto WHERE id_pedido_has_produto = $1',
      [id]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ error: 'Pedido_has_produto não encontrada' });
    }

    // Deleta a pedido_has_produto (as constraints CASCADE cuidarão das dependências)
    await query(
      'DELETE FROM pedido_has_produto WHERE id_pedido_has_produto = $1',
      [id]
    );

    res.status(204).send();
  } catch (error) {
    console.error('Erro ao deletar pedido_has_produto:', error);

    // Verifica se é erro de violação de foreign key (dependências)
    if (error.code === '23503') {
      return res.status(400).json({
        error: 'Não é possível deletar pedido_has_produto com dependências associadas'
      });
    }

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}


