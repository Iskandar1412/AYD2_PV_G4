const { findAll,getSaldo,getTransaccionData,getMisPrestamos,getMyData } = require('./clientes/client.controller.get')
const { deposito,retiro,pagarPrestamo } = require('./clientes/client.controller.put')
const { hacerPrestamo } = require('./clientes/client.controller.post')

module.exports ={
    findAll,
    getSaldo,
    getTransaccionData,
    getMisPrestamos,
    deposito,
    retiro,
    pagarPrestamo,
    hacerPrestamo,
    getMyData
};