create
    definer = root@`%` procedure consultar_saldo(IN p_numero bigint)
BEGIN
    DECLARE v_cuenta_id INT;
    DECLARE v_saldo DECIMAL(10, 2);
    DECLARE v_fecha_ultima_transaccion DATETIME;
    DECLARE v_existe_cliente INT;
    DECLARE v_is_cui BOOLEAN;

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT JSON_OBJECT(
            'status', 'error',
            'message', 'Ha ocurrido un error al consultar el saldo'
        ) AS resultado;
    END;

    -- Determinar si el parámetro proporcionado es un CUI o número de cuenta
    SET v_is_cui = IFNULL(p_numero, 0) > 1000000000;  -- Suponemos que un número de cuenta es menor que un CUI

    -- Si es CUI, buscar por CUI
    IF v_is_cui THEN
        -- Verificar si el CUI existe
        SELECT COUNT(*) INTO v_existe_cliente
        FROM usuario
        WHERE cui = p_numero;

        IF v_existe_cliente = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El cliente no existe';
        END IF;

        -- Obtener la cuenta y el saldo
        SELECT c.cuenta_id, c.saldo
        INTO v_cuenta_id, v_saldo
        FROM cuenta c
        WHERE c.cui = p_numero;

    ELSE
        -- Si no es CUI, buscar por número de cuenta
        SELECT COUNT(*) INTO v_existe_cliente
        FROM cuenta
        WHERE cuenta_id = p_numero;

        IF v_existe_cliente = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La cuenta no existe';
        END IF;

        -- Obtener la cuenta y el saldo
        SELECT c.cuenta_id, c.saldo
        INTO v_cuenta_id, v_saldo
        FROM cuenta c
        WHERE c.cuenta_id = p_numero;
    END IF;

    -- Obtener la fecha de la última transacción registrada
    SELECT MAX(t.fecha) INTO v_fecha_ultima_transaccion
    FROM transaccion t
    WHERE t.cuenta_id = v_cuenta_id;

    -- Si no hay transacciones, asignar NULL a la fecha
    IF v_fecha_ultima_transaccion IS NULL THEN
        SET v_fecha_ultima_transaccion = 'NULL';
    END IF;

    -- Retornar el saldo y la fecha de última transacción en formato JSON
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Saldo consultado exitosamente',
        'cuenta_id', v_cuenta_id,
        'saldo', v_saldo,
        'fecha_ultima_transaccion', v_fecha_ultima_transaccion
    ) AS resultado;

END;

