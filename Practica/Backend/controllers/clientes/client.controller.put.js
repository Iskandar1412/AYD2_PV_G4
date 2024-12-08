const pool = require('../../config/db')

async function hacerDeposito(cui_enc,cuenta,monto,fecha,idDeposito){
    try{
        const [rows] = await pool.query(
            `CALL realizar_deposito(?,?,?,?,?)`,
            [cui_enc,cuenta,monto,fecha,idDeposito]
        );
        const result = rows[0][0]?.resultado;
        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }
    } catch (error) {
        throw new Error('Error en el deposito: ' + error.message)
    }
}

exports.deposito = async (req,res) =>{
    const data = req.body;
    try{
        const currentDate = new Date().toISOString().split('T')[0];
        const result = await hacerDeposito(data.cui_enc,data.cuenta,data.monto,currentDate,data.idDeposito);
        res.status(201).send(result);
    } catch (error) {
        res.status(500).send({ error:error.message });
    }
}

async function hacerRetiro(cui_enc,cuenta,monto,idRetiro,fecha){
    try{
        const [rows] = await pool.query(
            `CALL realizar_retiro(?,?,?,?,?)`,
            [cui_enc,cuenta,monto,idRetiro,fecha]
        );
        const result = rows[0][0]?.resultado;
        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }
    } catch (error) {
        throw new Error('Error en el retiro: ' + error.message)
    }
}

exports.retiro = async (req,res) =>{
    const data = req.body;
    try{
        const currentDate = new Date().toISOString().split('T')[0];
        const result = await hacerRetiro(data.cui_enc,data.cuenta,data.monto,data.idRetiro,currentDate);
        res.status(201).send(result);
    } catch (error) {
        res.status(500).send({ error:error.message });
    }
}

async function pagoPrestamo(cui_enc,cuenta,id_prestamo,monto,fecha) {
    try{
        const [rows] = await pool.query(
            `CALL realizar_pago_prestamo(?,?,?,?,?)`,
            [cui_enc,cuenta,id_prestamo,monto,fecha]
        );

        const result = rows[0][0]?.resultado;
        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }
    } catch (error) {
        throw new Error('Error en el pago del prestamo: ' + error.message)
    }
}

exports.pagarPrestamo = async (req,res) =>{
    const data = req.body;
    try{
        const currentDate = new Date().toISOString().split('T')[0];
        const result = await pagoPrestamo(data.cui_enc,data.cuenta,data.id_prestamo,data.monto,currentDate);
        res.status(201).send(result);
    } catch (error) {
        res.status(500).send({ error:error.message });
    }
}