const { createUser,validarUsuario } = require('../controllers/user.controller')
const router = require('express').Router()


//GETS
router.get('/validarUsuario/:cui/:pass', validarUsuario)

// POST
router.post('/registrarUsuario', createUser);


module.exports = router;    