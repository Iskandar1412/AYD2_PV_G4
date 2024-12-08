const pool = require('../../config/db')

async function hacerDeposito(cui_enc,cuenta,monto,fecha,idDeposito){
    try{
        const [rows] = await pool.query(
            `CALL realizar_deposito(?,?,?,?,?)`,
            [cui_enc,cuenta,monto,fecha,idDeposito]
        );
        return rows;
    } catch (error) {
        throw new Error('Error en el deposito: ' + error.message)
    }
}

exports.deposito = async (req,res) =>{
    const data = req.body;
    try{
        const currentDate = new Date().toISOString().split('T')[0];
        await hacerDeposito(data.cui_enc,data.cuenta,data.monto,currentDate,data.idDeposito);
        res.status(201).send({ message: 'Deposito eralizado con exito' });
    } catch (error) {
        res.status(500).send({ error:error.message });
    }
}

async function hacerRetiro(cui,cuenta,monto,idRetiro,fecha){
    try{
        const [rows] = await pool.query(
            `CALL realizar_retiro(?,?,?,?,?)`,
            [cui,cuenta,monto,idRetiro,fecha]
        );
        return rows;
    } catch (error) {
        throw new Error('Error en el retiro: ' + error.message)
    }
}

exports.retiro = async (req,res) =>{
    const data = req.body;
    try{
        const currentDate = new Date().toISOString().split('T')[0];
        await hacerRetiro(data.cui,data.cuenta,data.monto,data.idRetiro,currentDate);
        res.status(201).send({ message: 'Retiro eralizado con exito' });
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
        await pagoPrestamo(data.cui_enc,data.cuenta,data.id_prestamo,data.monto,currentDate);
        res.status(201).send({ message: 'Pago del prestamo ralizado con exito' });
    } catch (error) {
        res.status(500).send({ error:error.message });
    }
}