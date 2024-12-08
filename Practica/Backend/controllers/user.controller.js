const { createUser } = require('./users/users.controller.post')
const { validarUsuario } = require('./users/users.controller.get')

module.exports ={
    createUser,
    validarUsuario
};