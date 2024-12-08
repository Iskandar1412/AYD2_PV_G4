create
    definer = root@`%` procedure realizar_retiro(IN p_encargado_cui bigint, IN p_cuenta_id int,
                                                 IN p_monto decimal(10, 2), IN p_codigo_retiro int, IN p_fecha datetime)
BEGIN
    DECLARE v_saldo_actual DECIMAL(10, 2);
    DECLARE v_retiro_id INT;
   	DECLARE num_retiro_id INT;
    DECLARE v_encargado_existe INT;
    DECLARE v_error_message VARCHAR(255);
    DECLARE v_tipo_retiro VARCHAR(255);

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

    -- Verificar que el monto a retirar no exceda el saldo disponible ni el límite
    IF p_monto <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto debe ser positivo';
    END IF;

    IF p_monto > v_saldo_actual THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Saldo insuficiente';
    END IF;

    -- Verificar que el tipo de retiro existe
    SELECT retiro.retiro_id, tipo INTO v_retiro_id,v_tipo_retiro
    FROM retiro
    WHERE retiro_id = p_codigo_retiro;

    IF v_retiro_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de Retiro no encontrado';
    end if;

    -- Realizar el retiro, actualizando el saldo de la cuenta
    UPDATE cuenta
    SET saldo = saldo - p_monto
    WHERE cuenta_id = p_cuenta_id;

    -- Registrar la transacción de retiro
    INSERT INTO transaccion (
        monto, tipo, fecha, cuenta_id, encargado, retiro_id
    ) VALUES (
        p_monto, 'retiro', p_fecha, p_cuenta_id, p_encargado_cui, v_retiro_id
    );
	SET num_retiro_id = LAST_INSERT_ID();
    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Retiro realizado exitosamente',
        'retiro_id',num_retiro_id,
        'cuenta_id', p_cuenta_id,
        'monto', p_monto,
        'fecha', p_fecha,
        'tipo_retiro', v_tipo_retiro
    ) AS resultado;
END;
