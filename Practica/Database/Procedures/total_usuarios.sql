create
    definer = root@`%` procedure contar_usuarios_por_rol()
BEGIN
    DECLARE v_total_usuarios INT;
    DECLARE v_total_admin INT;
    DECLARE v_total_personal INT;

    -- Contar el total de usuarios con rol 'usuario'
    SELECT COUNT(*) INTO v_total_usuarios
    FROM usuario
    WHERE rol = 'usuario';

    -- Contar el total de usuarios con rol 'admin'
    SELECT COUNT(*) INTO v_total_admin
    FROM usuario
    WHERE rol = 'admin';

    -- Contar el total de usuarios con rol 'personal'
    SELECT COUNT(*) INTO v_total_personal
    FROM usuario
    WHERE rol = 'personal';

    -- Retornar los totales en formato JSON
    SELECT JSON_OBJECT(
        'status', 'success',
        'total_usuarios', v_total_usuarios,
        'total_admin', v_total_admin,
        'total_personal', v_total_personal
    ) AS resultado;
END;
