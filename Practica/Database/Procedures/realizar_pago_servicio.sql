create
    definer = root@`%` procedure realizar_pago_servicio(IN p_encargado_cui bigint, IN p_codigo_servicio int,
                                                        IN p_monto decimal(10, 2), IN p_cuenta_id int,
                                                        IN p_fecha datetime)
BEGIN
    DECLARE v_saldo_actual DECIMAL(10,2);
    DECLARE v_servicio_id INT;
    DECLARE v_encargado_existe INT;
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
    IF p_monto <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto debe ser positivo';
    END IF;

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

    -- Verificar que el saldo sea suficiente
    IF v_saldo_actual < p_monto THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Saldo insuficiente';
    END IF;

    -- Verificar que el servicio existe
    SELECT servicio_id INTO v_servicio_id
    FROM servicio
    WHERE servicio_id = p_codigo_servicio;

    IF v_servicio_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Servicio no encontrado';
    END IF;

    -- Actualizar el saldo de la cuenta
    UPDATE cuenta
    SET saldo = saldo - p_monto
    WHERE cuenta_id = p_cuenta_id;

    -- Registrar la transacción
    INSERT INTO transaccion (
        monto, tipo, fecha, cuenta_id, servicio_id, encargado
    ) VALUES (
        p_monto, 'servicio', p_fecha, p_cuenta_id, v_servicio_id, p_encargado_cui
    );

    -- Commit de la transacción
    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Pago de servicio realizado exitosamente',
        'cuenta_id', p_cuenta_id,
        'monto', p_monto,
        'fecha', p_fecha
    ) AS resultado;

END;

