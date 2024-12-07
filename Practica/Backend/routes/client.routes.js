const { findAll,getSaldo,getTransaccionData,deposito,retiro,prestamo,hacerPrestamo } = require('../controllers/client.controller')

const router = require('express').Router()

// GETS
router.get('/userData',findAll);
router.get('/saldo',getSaldo);
router.get('/comprobante',getTransaccionData);

// PUT
router.put('/deposito',deposito);
router.put('/retiro',retiro);
router.put('/pago_prestamo',prestamo);

// POST
router.post('/hacerPrestamo',hacerPrestamo)

module.exports = router;