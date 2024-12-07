const { findAll,getSaldo,getTransaccionData } = require('./clientes/client.controller.get')
const { deposito,retiro,prestamo } = require('./clientes/client.controller.put')
const { hacerPrestamo } = require('./clientes/client.controller.post')

module.exports ={
    findAll,
    getSaldo,
    getTransaccionData,
    deposito,
    retiro,
    prestamo,
    hacerPrestamo
};