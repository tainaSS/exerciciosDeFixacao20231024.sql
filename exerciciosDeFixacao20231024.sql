CREATE TRIGGER insere_cliente_trigger
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem, data_hora)
    VALUES ('Novo cliente inserido: ' || NEW.nome, NOW());

CREATE TRIGGER tentativa_exclusao_trigger
BEFORE DELETE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem, data_hora)
    VALUES ('Tentativa de exclusão do cliente: ' || OLD.nome, NOW());

CREATE TRIGGER atualiza_nome_cliente_trigger
AFTER UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF NEW.nome IS NOT NULL AND NEW.nome <> OLD.nome THEN
        INSERT INTO Auditoria (mensagem, data_hora)
        VALUES ('Nome antigo: ' || OLD.nome || ', Novo nome: ' || NEW.nome, NOW());
    END IF;

CREATE TRIGGER impede_nome_vazio_trigger
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL OR NEW.nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido atualizar o nome para vazio ou NULL';
    END IF;

CREATE TRIGGER atualiza_estoque_pedido_trigger
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    UPDATE Produtos
    SET estoque = estoque - NEW.quantidade
    WHERE id = NEW.produto_id;
