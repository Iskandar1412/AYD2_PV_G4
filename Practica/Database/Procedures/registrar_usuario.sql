create
    definer = root@`%` procedure registrar_usuario(IN p_cui bigint, IN p_nombres varchar(50),
                                                   IN p_apellidos varchar(50), IN p_password varchar(200),
                                                   IN p_fecha_creacion date,
                                                   IN p_rol enum ('admin', 'personal', 'usuario'))
BEGIN
    -- Declarar variables
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

    -- Verificar si el usuario ya existe
    SELECT COUNT(*) INTO v_usuario_existe
    FROM usuario
    WHERE cui = p_cui;

    IF v_usuario_existe > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El CUI ya está registrado';
    END IF;

    -- Encriptar la contraseña usando SHA2 (256 bits)
    SET p_password = SHA2(p_password, 256);

    -- Insertar el nuevo usuario con la contraseña encriptada
    INSERT INTO usuario (cui, nombres, apellidos, password, fecha_creacion, rol)
    VALUES (p_cui, p_nombres, p_apellidos, p_password, p_fecha_creacion, p_rol);

    -- Commit de la transacción
    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Usuario registrado exitosamente',
        'cui', p_cui,
        'nombres', p_nombres,
        'apellidos', p_apellidos,
        'rol', p_rol
    ) AS resultado;

END;

