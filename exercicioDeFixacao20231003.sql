-- 01
DELIMITER //
CREATE FUNCTION tl_livros_genero(genero_nome VARCHAR(255)) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fim INT DEFAULT FALSE;
    DECLARE total_liv INT;
    DECLARE id_genero INT;
    DECLARE Caminho CURSOR FOR SELECT id FROM Genero WHERE nome_genero = genero_nome;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;

    SET total_liv = 0;

    OPEN Caminho;

    read_loop: LOOP
        FETCH Caminho INTO id_genero;

        IF fim THEN
            LEAVE read_loop;
        END IF;

        SELECT COUNT(*) INTO total_liv FROM Livro WHERE Livro.id_genero = id_genero;
         END LOOP;

    CLOSE Caminho;
    RETURN total_liv;

END //

SELECT tl_livros_genero('História');

-- 02
DELIMITER //
CREATE FUNCTION listar_livros_por_autor(primeiro_nome VARCHAR(255), ultimo_nome VARCHAR(255)) 
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
    DECLARE list_liv VARCHAR(2000) DEFAULT '';
    DECLARE tlivro VARCHAR(255);
    DECLARE fim INT DEFAULT FALSE;

    DECLARE Caminho CURSOR FOR
        SELECT l.titulo
        FROM Livro l
        INNER JOIN Livro_Autor la ON l.id = la.id_livro
        INNER JOIN Autor a ON la.id_autor = a.id
        WHERE a.primeiro_nome = primeiro_nome AND a.ultimo_nome = ultimo_nome;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;

    OPEN Caminho;

    read_loop: LOOP
        FETCH Caminho INTO tlivro;
        IF fim THEN
            LEAVE read_loop;
        END IF;

        SET list_liv = CONCAT(list_liv, tlivro, ', ');
    END LOOP;

    CLOSE Caminho;

    RETURN list_liv;
END //

SELECT listar_livros_por_autor('Pedro', 'Alvares');

-- 03
DELIMITER //
CREATE FUNCTION atualizar_resumos() 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fim INT DEFAULT FALSE;
    DECLARE id_liv INT;
    DECLARE resumoat VARCHAR(1000);
    DECLARE Caminho CURSOR FOR SELECT id, resumo FROM Livro;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;

    OPEN Caminho;

    update_loop: LOOP
        FETCH Caminho INTO id_liv, resumoat;

        IF fim THEN
            LEAVE update_loop;
        END IF;

        UPDATE Livro
        SET resumo = CONCAT(resumoat, ' Este livro é excelente!!')
        WHERE id = id_liv;
       
    END LOOP;

    CLOSE Caminho;

    RETURN 1;
END //

SELECT atualizar_resumos();

-- 04
DELIMITER //
CREATE FUNCTION media_livros_por_editora() 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE media DECIMAL(10, 2);
    DECLARE total_liv INT;
    DECLARE totaledit INT;
    DECLARE numedit INT;
    DECLARE idedit INT;
    DECLARE fim INT DEFAULT FALSE;
    DECLARE Caminho_editora CURSOR FOR SELECT id FROM Editora;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim = TRUE;

    SET total_liv = 0;
    SET numedit = 0;

    OPEN Caminho_editora;

    read_loop: LOOP
        FETCH Caminho_editora INTO idedit;
        IF fim THEN
            LEAVE read_loop;
        END IF;

        SELECT COUNT(*) INTO totaledit FROM Livro WHERE id_editora = idedit;

        SET total_liv = total_liv + totaledit;
        SET numedit = numedit + 1;
    END LOOP;

    CLOSE Caminho_editora;

    IF numedit = 0 THEN
        SET media = 0;
    ELSE
        SET media = total_liv / numedit;
    END IF;

    RETURN media;
END //

SELECT media_livros_por_editora();
