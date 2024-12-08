const { findUser,getUserSaldo } = require('./personal/personal.controller.get')
const { pagarServicio } = require('./personal/personal.controller.post')

module.exports ={
    findUser,
    getUserSaldo,
    pagarServicio
};