use dbmoneybin;
CALL registrar_usuario(3848221850101, 'Carlos', 'García', 'password456', '2024-12-06', 'admin');

CALL registrar_usuario(123456789, 'Carlos', 'García', 'password456', '2024-12-06', 'admin');

CALL registrar_cuenta(3848221850101, 0.00);

CALL realizar_pago_servicio(123456789,1,100.00,1,'2024-12-06 10:00:00');

CALL realizar_pago_prestamo(123456789,1,1,100,'2024-12-06 10:00:00');

CALL realizar_retiro(123456789,1,100,1,'2024-12-06 10:00:00');

CALL realizar_deposito(123456789,1,1000,'2024-12-06 10:00:00',1);

CALL autenticar_usuario(3848221850101, 'password45678');

call buscar_cliente(3848221850101);

call crear_prestamo(1,10000,'2024-12-06 10:00:00');

call obtener_prestamos(1);

call consultar_saldo(1);

call generar_comprobante(1);