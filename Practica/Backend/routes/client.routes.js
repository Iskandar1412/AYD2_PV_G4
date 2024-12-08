const { findAll,getSaldo,getTransaccionData,deposito,retiro,hacerPrestamo,pagarPrestamo,getMisPrestamos,getMyData } = require('../controllers/client.controller');

const router = require('express').Router()

// GETS
router.get('/saldo',getSaldo);
router.get('/comprobante',getTransaccionData);
router.get('/prestamos',getMisPrestamos)
router.get('/misDatos',getMyData)

// PUT
router.put('/deposito',deposito);
router.put('/retiro',retiro);
router.put('/pago_prestamo',pagarPrestamo);

// POST
router.post('/hacerPrestamo',hacerPrestamo)

module.exports = router;