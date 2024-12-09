const { findUser,getUserSaldo,pagarServicio,getUsuarios } = require('../controllers/personal.controller')
const router = require('express').Router()

// GETS
router.get('/userData',findUser);
router.get('/userSaldo',getUserSaldo);
router.get('/totalUsuarios',getUsuarios)

// POST
router.post('/pagoServicio',pagarServicio);

module.exports = router;