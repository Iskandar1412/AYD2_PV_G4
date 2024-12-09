const { findAll,getSaldo,getTransaccionData,deposito,retiro,hacerPrestamo,pagarPrestamo,getMisPrestamos,getMyData } = require('../controllers/client.controller');

const router = require('express').Router()

// GETS
router.get('/saldo/:cuenta',getSaldo);
router.get('/comprobante/:ntrans',getTransaccionData);
router.get('/prestamos/:cuenta',getMisPrestamos)
router.get('/misDatos/:cui',getMyData)

// PUT
router.put('/deposito',deposito);
router.put('/retiro',retiro);
router.put('/pago_prestamo',pagarPrestamo);

// POST
router.post('/hacerPrestamo',hacerPrestamo)

module.exports = router;