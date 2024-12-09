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
    try {
        const result = await userData(req.params.cui);
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
    try {
        const result = await obtenerSaldo(req.params.ncuenta);
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener el saldo del usuario: ' + error.message });
    }
}

async function usuarios() {
    try{
        const [rows] = await pool.query(`
            CALL contar_usuarios_por_rol()`
        );

        const result = rows[0][0]?.resultado;

        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }

    } catch (error) {
        throw new Error('Error: '+ error.message)
    }
}

exports.getUsuarios = async(req,res) => {
    try {
        const result = await usuarios();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener el saldo del usuario: ' + error.message });
    }
}

async function usuarios() {
    try{
        const [rows] = await pool.query(`
            CALL contar_usuarios_por_rol()`
        );

        const result = rows[0][0]?.resultado;

        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }

    } catch (error) {
        throw new Error('Error: '+ error.message)
    }
}

exports.getUsuarios = async(req,res) => {
    try {
        const result = await usuarios();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener el saldo del usuario: ' + error.message });
    }
}
