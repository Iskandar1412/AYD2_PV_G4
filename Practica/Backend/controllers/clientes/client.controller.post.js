const pool = require('../../config/db');

async function crearPrestamo(cuenta,monto,fecha){
    try{
        const [rows] = await pool.query(
            `CALL crear_prestamo(?,?,?)`,
            [cuenta,monto,fecha]
        );
        const result = rows[0][0]?.resultado;
        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }
    } catch (error) {
        throw new Error('Error en la solicitud del prestamo: ' + error.message)
    }
}

exports.hacerPrestamo = async (req,res) =>{
    const data = req.body;
    try{
        const currentDate = new Date().toISOString().split('T')[0];
        const result = await crearPrestamo(data.cuenta,data.monto,currentDate);
        res.status(201).send({ message: result });
    } catch (error) {
        res.status(500).send({ error:error.message });
    }
}
