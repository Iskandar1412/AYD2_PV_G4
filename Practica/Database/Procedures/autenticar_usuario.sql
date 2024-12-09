create
    definer = root@`%` procedure autenticar_usuario(IN p_cui bigint, IN p_password varchar(200))
BEGIN
    DECLARE v_rol VARCHAR(50);
    DECLARE v_nombres VARCHAR(50);
    DECLARE v_apellidos VARCHAR(50);
    DECLARE v_password_hash VARCHAR(200);
    DECLARE v_password_input_hash VARCHAR(200);
    DECLARE v_error_message VARCHAR(255);
    DECLARE v_cuenta_id INT;

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

    -- Verificar si el usuario existe y obtener su contraseña almacenada
    SELECT password, rol, nombres, apellidos INTO v_password_hash, v_rol, v_nombres, v_apellidos
    FROM usuario
    WHERE cui = p_cui;

    SELECT cuenta_id INTO v_cuenta_id
    FROM cuenta
    WHERE cui = p_cui;

    -- Si el usuario no existe, retornar error
    IF v_password_hash  IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario no encontrado';
    END IF;

    -- Generar el hash SHA-256 de la contraseña proporcionada
    SET v_password_input_hash = SHA2(p_password, 256);

    -- Verificar si la contraseña coincide con la almacenada (compara los hashes)
    IF v_password_hash != v_password_input_hash THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Contraseña incorrecta';
    END IF;

    -- Retornar el rol del usuario si la autenticación es exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'rol', v_rol,
        'no_cuenta', v_cuenta_id,
        'nombres', v_nombres,
        'apellidos', v_apellidos,
        'cui', p_cui
    ) AS resultado;

END;

