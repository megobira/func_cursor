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
