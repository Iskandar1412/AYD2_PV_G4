create
    definer = root@`%` procedure obtener_prestamos(IN p_parametro int)
BEGIN
    DECLARE v_cuenta_id INT;
    DECLARE v_existe_cliente INT;
    DECLARE v_nombre_cliente VARCHAR(255);

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT JSON_OBJECT(
            'status', 'error',
            'message', 'Ha ocurrido un error al obtener los préstamos'
        ) AS resultado;
    END;

    -- Verificar si el número de cuenta existe
    SELECT COUNT(*) INTO v_existe_cliente
    FROM cuenta
    WHERE cuenta_id = p_parametro;

    IF v_existe_cliente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cuenta no existe';
    END IF;

    -- Obtener la cuenta y el nombre del cliente asociado
    SELECT c.cuenta_id, CONCAT(u.nombres, ' ', u.apellidos) INTO v_cuenta_id, v_nombre_cliente
    FROM cuenta c
    JOIN usuario u ON u.cui = c.cui
    WHERE c.cuenta_id = p_parametro;

    -- Obtener todos los préstamos asociados a la cuenta
    SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'prestamo_id', p.prestamo_id,
                'fecha', p.fecha,
                'saldo', p.saldo
            )
    ) AS prestamos
    FROM prestamo p
    WHERE p.cuenta_id = v_cuenta_id;

    -- Retornar la información completa del cliente y los préstamos
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Préstamos obtenidos exitosamente',
        'cliente', JSON_OBJECT(
            'nombre_cliente', v_nombre_cliente,
            'cuenta_id', v_cuenta_id
        ),
        'prestamos', (SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'prestamo_id', p.prestamo_id,
                'fecha', p.fecha,
                'saldo', p.saldo
            )
        ) FROM prestamo p WHERE p.cuenta_id = v_cuenta_id)
    ) AS resultado;

END;

