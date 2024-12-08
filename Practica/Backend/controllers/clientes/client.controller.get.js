const pool = require('../../config/db')

exports.findAll = async (req,res) =>{
    res.send("Endpoint buscar_cliente");
}

async function obtenerSaldo(cuenta){
    try{
        const [rows] = await pool.query(`
            CALL consultar_saldo(?)`,
            [cuenta]
        );

        const result = rows[0][0]?.resultado;

        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }

    } catch (error) {
        throw new Error('Error en el registro del usuario: '+ error.message)
    }
}

exports.getSaldo = async(req,res) =>{
    const data = req.body;
    try {
        const result = await obtenerSaldo(data.cuenta);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener el saldo del usuario: ' + error.message });
    }
}

async function misPrestamos(cuenta){
    try{
        const [rows] = await pool.query(`
            CALL obtener_prestamos(?)`,
            [cuenta]
        );

        const result = rows[0][0];
        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }

    } catch (error) {
        throw new Error(error.message)
    }
}

exports.getMisPrestamos = async(req,res) => {
    const data = req.body;
    try {
        const result = await misPrestamos(data.cuenta);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener los prestamos: ' + error.message });
    }
}

async function transacciones(num_trans){
    try{
        const [rows] = await pool.query(`
            CALL generar_comprobante(?)`,
            [num_trans]
        );

        const result = rows[0][0];
        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }

    } catch (error) {
        throw new Error(error.message)
    }
}

exports.getTransaccionData = async(req,res) =>{
    const data = req.body;
    try {
        const result = await transacciones(data.numTrans);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener los prestamos: ' + error.message });
    }
}

async function misDatos(cui){
    try{
        const [rows] = await pool.query(`
            CALL buscar_cliente(?)`,
            [cui]
        );

        const result = rows[1][0].resultado;
        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }

    } catch (error) {
        throw new Error(error.message)
    }
}

exports.getMyData = async(req,res) => {
    const data = req.body;
    try {
        const result = await misDatos(data.cui);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener los datos del usuario: ' + error.message });
    }
}