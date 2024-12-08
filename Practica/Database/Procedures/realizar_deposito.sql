create
    definer = root@`%` procedure realizar_deposito(IN p_encargado_cui bigint, IN p_cuenta_id int,
                                                   IN p_monto decimal(10, 2), IN p_fecha datetime, IN p_id_deposito int)
BEGIN
    DECLARE v_saldo_actual DECIMAL(10, 2);
    DECLARE v_encargado_existe INT;
    DECLARE v_error_message VARCHAR(255);
    DECLARE v_deposito_id INT;
   	DECLARE v_num_deposito_id INT;
    DECLARE v_tipo_deposito VARCHAR(50);

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

    START TRANSACTION;

    -- Verificar que el encargado existe como usuario
    SELECT COUNT(*) INTO v_encargado_existe
    FROM usuario
    WHERE cui = p_encargado_cui;

    IF v_encargado_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El encargado no existe como usuario';
    END IF;

    -- Verificar que la cuenta existe y obtener el saldo actual
    SELECT saldo INTO v_saldo_actual
    FROM cuenta
    WHERE cuenta_id = p_cuenta_id;

    IF v_saldo_actual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cuenta no encontrada';
    END IF;

    -- Verificar que el monto a depositar sea positivo
    IF p_monto <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto a depositar debe ser positivo';
    END IF;

    -- Verificar que el tipo de deposito exista
    SELECT deposito.deposito_id, tipo INTO v_deposito_id, v_tipo_deposito
    FROM deposito
    WHERE deposito_id = p_id_deposito;

    -- Actualizar el saldo de la cuenta con el monto depositado
    UPDATE cuenta
    SET saldo = saldo + p_monto
    WHERE cuenta_id = p_cuenta_id;

    -- Registrar la transacción de depósito
    INSERT INTO transaccion (
        monto, tipo, fecha, cuenta_id, encargado, deposito_id
    ) VALUES (
        p_monto, 'deposito', p_fecha, p_cuenta_id, p_encargado_cui, v_deposito_id
    );

   	SET v_num_deposito_id = LAST_INSERT_ID();
    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Depósito realizado exitosamente',
        'deposito_id',v_num_deposito_id,
        'cuenta_id', p_cuenta_id,
        'monto', p_monto,
        'fecha', p_fecha,
        'tipo_deposito', v_tipo_deposito
    ) AS resultado;
END;
