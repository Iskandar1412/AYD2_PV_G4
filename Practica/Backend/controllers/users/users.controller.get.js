const pool = require('../../config/db');

async function comprobarUsuario(cui, contrasenia) {
    try {
        const [rows] = await pool.query(`
            CALL autenticar_usuario(?, ?)`,
            [cui, contrasenia]
        );

        const result = rows[0][0]?.resultado;

        if (result) {
            return result;
        } else {
            console.log(result);
            throw new Error('Resultado inesperado del procedimiento');
        }
    } catch (error) {
        throw new Error('Error en el proceso de validación del usuario: ' + error.message);
    }
}

exports.validarUsuario = async (req, res) => {
    const data = req.body;
    try {
        const result = await comprobarUsuario(data.cui, data.contrasenia);
        //se envía un json con el parametro status y valor "success" para indicar que la contraseña es la adecuada
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: 'Error al validar el usuario: ' + error.message });
    }
};
