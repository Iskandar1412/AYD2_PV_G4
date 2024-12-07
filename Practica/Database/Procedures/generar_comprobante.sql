create
    definer = root@`%` procedure generar_comprobante(IN p_trans_id int)
BEGIN
    DECLARE v_cuenta_id INT;
    DECLARE v_tipo_transaccion VARCHAR(50);
    DECLARE v_fecha DATETIME;
    DECLARE v_monto DECIMAL(10, 2);
    DECLARE v_encargado_nombre VARCHAR(100);
    DECLARE v_encargado_apellido VARCHAR(100);

    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT JSON_OBJECT(
            'status', 'error',
            'message', 'Ha ocurrido un error al generar el comprobante'
        ) AS resultado;
    END;

    -- Obtener los detalles de la transacción
    SELECT t.cuenta_id, t.tipo, t.fecha, t.monto, u.nombres, u.apellidos
    INTO v_cuenta_id, v_tipo_transaccion, v_fecha, v_monto, v_encargado_nombre, v_encargado_apellido
    FROM transaccion t
    JOIN usuario u ON t.encargado = u.cui
    WHERE t.trans_id = p_trans_id;

    -- Verificar si la transacción existe
    IF v_cuenta_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La transacción no existe';
    END IF;

    -- Devolver la información en formato JSON
    SELECT JSON_OBJECT(
        'numero_de_cuenta', v_cuenta_id,
        'tipo_transaccion', v_tipo_transaccion,
        'fecha_hora', v_fecha,
        'monto', v_monto,
        'nombre_encargado', CONCAT(v_encargado_nombre, ' ', v_encargado_apellido)
    ) AS comprobante;

END;

