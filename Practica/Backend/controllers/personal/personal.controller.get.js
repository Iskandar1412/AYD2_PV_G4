const pool = require('../../config/db')

async function userData(cui){
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

exports.findUser = async(req,res) => {
    const data = req.body;
    try {
        const result = await userData(data.cui);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener los datos del usuario: ' + error.message });
    }
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

exports.getUserSaldo = async(req,res) =>{
    const data = req.body;
    try {
        const result = await obtenerSaldo(data.cuenta);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener el saldo del usuario: ' + error.message });
    }
}
