create table deposito
(
    deposito_id int auto_increment
        primary key,
    tipo        varchar(50) not null
);

create table retiro
(
    retiro_id int auto_increment
        primary key,
    tipo      varchar(50) not null,
    limite    int         not null
);

create table servicio
(
    servicio_id int auto_increment
        primary key,
    tipo        varchar(50) not null
);

create table usuario
(
    cui            bigint                                not null
        primary key,
    nombres        varchar(50)                           not null,
    apellidos      varchar(50)                           not null,
    password       varchar(200)                          not null,
    fecha_creacion datetime                              not null,
    rol            enum ('admin', 'personal', 'usuario') not null
);

create table cuenta
(
    cuenta_id int auto_increment
        primary key,
    saldo     int    not null,
    cui       bigint not null,
    constraint cuenta_ibfk_1
        foreign key (cui) references usuario (cui)
);

create index cui
    on cuenta (cui);

create table prestamo
(
    prestamo_id int auto_increment
        primary key,
    fecha       datetime not null,
    saldo       int      not null,
    cuenta_id   int      not null,
    constraint prestamo_ibfk_1
        foreign key (cuenta_id) references cuenta (cuenta_id)
);

create index cuenta_id
    on prestamo (cuenta_id);

create table transaccion
(
    trans_id    int auto_increment
        primary key,
    monto       int                                                 not null,
    tipo        enum ('servicio', 'prestamo', 'retiro', 'deposito') not null,
    fecha       datetime                                            not null,
    cuenta_id   int                                                 not null,
    servicio_id int                                                 null,
    retiro_id   int                                                 null,
    deposito_id int                                                 null,
    prestamo_id int                                                 null,
    encargado   bigint                                              not null,
    constraint transaccion_ibfk_1
        foreign key (cuenta_id) references cuenta (cuenta_id),
    constraint transaccion_ibfk_2
        foreign key (servicio_id) references servicio (servicio_id),
    constraint transaccion_ibfk_3
        foreign key (retiro_id) references retiro (retiro_id),
    constraint transaccion_ibfk_4
        foreign key (deposito_id) references deposito (deposito_id),
    constraint transaccion_ibfk_5
        foreign key (prestamo_id) references prestamo (prestamo_id),
    constraint transaccion_ibfk_6
        foreign key (encargado) references usuario (cui),
    check (((`servicio_id` is not null) and (`retiro_id` is null) and (`deposito_id` is null) and
            (`prestamo_id` is null)) or
           ((`retiro_id` is not null) and (`servicio_id` is null) and (`deposito_id` is null) and
            (`prestamo_id` is null)) or
           ((`deposito_id` is not null) and (`servicio_id` is null) and (`retiro_id` is null) and
            (`prestamo_id` is null)) or
           ((`prestamo_id` is not null) and (`servicio_id` is null) and (`retiro_id` is null) and
            (`deposito_id` is null)))
);

create index cuenta_id
    on transaccion (cuenta_id);

create index deposito_id
    on transaccion (deposito_id);

create index encargado
    on transaccion (encargado);

create index prestamo_id
    on transaccion (prestamo_id);

create index retiro_id
    on transaccion (retiro_id);

create index servicio_id
    on transaccion (servicio_id);

create definer = root@`%` trigger before_retiro
    before insert
    on transaccion
    for each row
BEGIN
    -- Declaración de variables locales al inicio
    DECLARE limite_retiro INT;

    -- Verificar si la transacción es de tipo 'retiro'
    IF NEW.tipo = 'retiro' THEN
        -- Obtener el límite del tipo de retiro asociado
        SELECT limite
        INTO limite_retiro
        FROM retiro
        WHERE retiro_id = NEW.retiro_id;

        -- Validar que el monto no exceda el límite permitido
        IF NEW.monto > limite_retiro THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El monto del retiro excede el límite permitido.';
        END IF;
    END IF;
END;

create
    definer = root@`%` procedure autenticar_usuario(IN p_cui bigint, IN p_password varchar(200))
BEGIN
    DECLARE v_rol VARCHAR(50);
    DECLARE v_password_hash VARCHAR(200);
    DECLARE v_password_input_hash VARCHAR(200);
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

    -- Verificar si el usuario existe y obtener su contraseña almacenada
    SELECT password, rol INTO v_password_hash, v_rol
    FROM usuario
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
        'rol', v_rol
    ) AS resultado;

END;

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

create
    definer = root@`%` procedure crear_prestamo(IN p_cuenta_id int, IN p_saldo int, IN p_fecha datetime)
BEGIN
    DECLARE v_cuenta_existente INT;

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

    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Préstamo creado exitosamente',
        'cuenta_id', p_cuenta_id,
        'saldo', p_saldo,
        'fecha', p_fecha
    ) AS resultado;

END;

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

create
    definer = root@`%` procedure realizar_deposito(IN p_encargado_cui bigint, IN p_cuenta_id int,
                                                   IN p_monto decimal(10, 2), IN p_fecha datetime, IN p_id_deposito int)
BEGIN
    DECLARE v_saldo_actual DECIMAL(10, 2);
    DECLARE v_encargado_existe INT;
    DECLARE v_error_message VARCHAR(255);
    DECLARE v_deposito_id INT;
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

    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Depósito realizado exitosamente',
        'cuenta_id', p_cuenta_id,
        'monto', p_monto,
        'fecha', p_fecha,
        'tipo_deposito', v_tipo_deposito
    ) AS resultado;
END;

create
    definer = root@`%` procedure realizar_pago_prestamo(IN p_encargado_cui bigint, IN p_cuenta_id int,
                                                        IN p_prestamo_id int, IN p_monto decimal(10, 2),
                                                        IN p_fecha datetime)
BEGIN
    DECLARE v_saldo_actual DECIMAL(10,2);
    DECLARE v_prestamo_monto DECIMAL(10,2);
    DECLARE v_encargado_existe INT;
    DECLARE v_pago_total DECIMAL(10,2);
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
        SET MESSAGE_TEXT = 'El monto del pago debe ser positivo';
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

    -- Verificar que el préstamo existe y obtener el monto del préstamo
    SELECT saldo INTO v_prestamo_monto
    FROM prestamo
    WHERE prestamo_id = p_prestamo_id;

    IF v_prestamo_monto IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Préstamo no encontrado';
    END IF;

    -- Verificar que el saldo de la cuenta es suficiente para el pago
    IF v_saldo_actual < p_monto THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Saldo insuficiente en la cuenta para realizar el pago';
    END IF;

    -- Verificar que el monto del pago no exceda el saldo del préstamo
    IF p_monto > v_prestamo_monto THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto del pago excede el saldo del préstamo';
    END IF;

    -- Calcular el nuevo saldo del préstamo después del pago
    SET v_pago_total = v_prestamo_monto - p_monto;

    -- Actualizar el saldo del préstamo
    UPDATE prestamo
    SET saldo = v_pago_total
    WHERE prestamo_id = p_prestamo_id;

    -- Actualizar el saldo de la cuenta
    UPDATE cuenta
    SET saldo = saldo - p_monto
    WHERE cuenta_id = p_cuenta_id;

    -- Registrar la transacción de pago
    INSERT INTO transaccion (
        monto, tipo, fecha, cuenta_id, prestamo_id, encargado
    ) VALUES (
        p_monto, 'prestamo', p_fecha, p_cuenta_id, p_prestamo_id, p_encargado_cui
    );

    -- Commit de la transacción
    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Pago del préstamo realizado exitosamente',
        'cuenta_id', p_cuenta_id,
        'prestamo_id', p_prestamo_id,
        'monto', p_monto,
        'fecha', p_fecha
    ) AS resultado;

END;

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

create
    definer = root@`%` procedure realizar_retiro(IN p_encargado_cui bigint, IN p_cuenta_id int,
                                                 IN p_monto decimal(10, 2), IN p_codigo_retiro int, IN p_fecha datetime)
BEGIN
    DECLARE v_saldo_actual DECIMAL(10, 2);
    DECLARE v_retiro_id INT;
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

    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Retiro realizado exitosamente',
        'cuenta_id', p_cuenta_id,
        'monto', p_monto,
        'fecha', p_fecha,
        'tipo_retiro', v_tipo_retiro
    ) AS resultado;
END;

create
    definer = root@`%` procedure registrar_cuenta(IN p_cui bigint, IN p_saldo_inicial decimal(10, 2))
BEGIN
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

    -- Verificar que el monto sea positivo
    IF p_saldo_inicial < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El saldo inicial debe ser positivo';
    END IF;

    -- Verificar que el usuario existe
    SELECT COUNT(*) INTO v_usuario_existe
    FROM usuario
    WHERE cui = p_cui;

    IF v_usuario_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario no existe';
    END IF;

    -- Crear la cuenta con el saldo inicial
    INSERT INTO cuenta (saldo, cui)
    VALUES (p_saldo_inicial, p_cui);

    -- Commit de la transacción
    COMMIT;

    -- Retornar respuesta exitosa
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Cuenta registrada exitosamente',
        'cui', p_cui,
        'saldo_inicial', p_saldo_inicial
    ) AS resultado;

END;

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

