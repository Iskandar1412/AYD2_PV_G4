const { findUser,getUserSaldo } = require('../controllers/personal.controller')
const router = require('express').Router()

// GETS
router.get('/userData',findUser);
router.get('/userSaldo',getUserSaldo);

module.exports = router;