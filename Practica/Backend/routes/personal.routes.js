const { findUser,getUserSaldo,pagarServicio } = require('../controllers/personal.controller')
const router = require('express').Router()

// GETS
router.get('/userData',findUser);
router.get('/userSaldo',getUserSaldo);

// POST
router.post('/pagoServicio',pagarServicio);

module.exports = router;