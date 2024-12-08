create
    definer = root@`%` procedure crear_prestamo(IN p_cuenta_id int, IN p_saldo int, IN p_fecha datetime)
BEGIN
    DECLARE v_cuenta_existente INT;
    DECLARE v_prestamo_id INT;

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT JSON_OBJECT(
            'status', 'error',
            'message', 'Ha ocurrido un error al crear el préstamo'
        ) AS resultado;
    END;

    START TRANSACTION;

    -- Verificar si la cuenta existe
    SELECT COUNT(*) INTO v_cuenta_existente
    FROM cuenta
    WHERE cuenta_id = p_cuenta_id;

    IF v_cuenta_existente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cuenta no encontrada';
    END IF;

    -- Validar que el saldo sea positivo
    IF p_saldo <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El saldo del préstamo debe ser positivo';
    END IF;

    -- Registrar el préstamo
    INSERT INTO prestamo (
        fecha, saldo, cuenta_id
    ) VALUES (
        p_fecha, p_saldo, p_cuenta_id
    );
   
   SET v_prestamo_id = LAST_INSERT_ID();

    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Préstamo creado exitosamente',
        'prestamo_id', v_prestamo_id,
        'cuenta_id', p_cuenta_id,
        'saldo', p_saldo,
        'fecha', p_fecha
    ) AS resultado;

END;