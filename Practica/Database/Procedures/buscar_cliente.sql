create
    definer = root@`%` procedure buscar_cliente(IN p_numero bigint)
BEGIN
    DECLARE v_cuenta_id INT;
    DECLARE v_saldo DECIMAL(10, 2);
    DECLARE v_nombre_cliente VARCHAR(255);
    DECLARE v_apellido_cliente VARCHAR(255);
    DECLARE v_cui_cliente BIGINT;
    DECLARE v_existe_cliente INT;
    DECLARE v_is_cui BOOLEAN;
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

        -- Obtener los detalles de la cuenta y cliente
        SELECT u.nombres, u.apellidos, u.cui, c.cuenta_id, c.saldo
        INTO v_nombre_cliente, v_apellido_cliente, v_cui_cliente, v_cuenta_id, v_saldo
        FROM cuenta c
        JOIN usuario u ON u.cui = c.cui
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

        -- Obtener los detalles de la cuenta
        SELECT u.nombres, u.apellidos, u.cui, c.cuenta_id, c.saldo
        INTO v_nombre_cliente, v_apellido_cliente, v_cui_cliente, v_cuenta_id, v_saldo
        FROM cuenta c
        JOIN usuario u ON u.cui = c.cui
        WHERE c.cuenta_id = p_numero;
    END IF;

    -- Obtener el historial de transacciones
    SELECT
        t.trans_id,
        t.monto,
        t.tipo,
        t.fecha,
        t.encargado
    FROM transaccion t
    WHERE t.cuenta_id = v_cuenta_id
    ORDER BY t.fecha DESC;

    -- Retornar los detalles del cliente y su cuenta en formato JSON
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Cliente encontrado exitosamente',
        'nombre', v_nombre_cliente,
        'apellido', v_apellido_cliente,
        'cui', v_cui_cliente,
        'cuenta_id', v_cuenta_id,
        'saldo', v_saldo,
        'transacciones', JSON_ARRAYAGG(
            JSON_OBJECT(
                'trans_id', t.trans_id,
                'monto', t.monto,
                'tipo', t.tipo,
                'fecha', t.fecha,
                'encargado', u.nombres
            )
        )
    ) AS resultado
    FROM transaccion t
    JOIN usuario u ON u.cui = t.encargado
    WHERE t.cuenta_id = v_cuenta_id
    ORDER BY t.fecha DESC;
END;

