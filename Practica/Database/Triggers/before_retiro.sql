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

