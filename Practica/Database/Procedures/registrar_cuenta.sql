create
    definer = root@`%` procedure registrar_cuenta(IN p_cui bigint, IN p_saldo_inicial decimal(10, 2))
BEGIN
    DECLARE v_usuario_existe INT;
    DECLARE v_error_message VARCHAR(255);

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Obtener detalles del error
        GET DIAGNOSTICS CONDITION 1
            v_error_message = MESSAGE_TEXT;

        -- Hacer rollback de la transacción
        ROLLBACK;

        -- Retornar el error en formato JSON con el mensaje heredado
        SELECT JSON_OBJECT(
            'status', 'error',
            'message', CONCAT('Ha ocurrido un error: ', v_error_message)
        ) AS resultado;
    END;

    -- Iniciar transacción
    START TRANSACTION;

    -- Verificar que el monto sea positivo
    IF p_saldo_inicial < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El saldo inicial debe ser positivo';
    END IF;

    -- Verificar que el usuario existe
    SELECT COUNT(*) INTO v_usuario_existe
    FROM usuario
    WHERE cui = p_cui;

    IF v_usuario_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    -- Crear la cuenta con el saldo inicial
    INSERT INTO cuenta (saldo, cui)
    VALUES (p_saldo_inicial, p_cui);

    -- Commit de la transacción
    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Cuenta registrada exitosamente',
        'cui', p_cui,
        'saldo_inicial', p_saldo_inicial
    ) AS resultado;

END;

