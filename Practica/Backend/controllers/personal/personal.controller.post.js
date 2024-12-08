const pool = require('../../config/db')

async function pagoServicio(cui_enc,cod_servicio,monto,cuenta,fecha){
    try{
        const [rows] = await pool.query(`
            CALL realizar_pago_servicio(?,?,?,?,?)`,
            [cui_enc,cod_servicio,monto,cuenta,fecha]
        );
        const result = rows[0][0];
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

exports.pagarServicio = async (req,res) =>{
    const data = req.body;
    try{
        const currentDate = new Date().toISOString().split('T')[0];
        const result = await pagoServicio(data.cui_enc,data.cod_servicio,data.monto,data.cuenta,currentDate);
        res.status(201).send(result);
    } catch (error) {
        res.status(500).send({ error: 'Error al registrar el usuario: ' + error.message });
    }
}