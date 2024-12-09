const pool = require('../../config/db')

async function verificarUsuarioExiste(cui) {
    try {
        const [rows] = await pool.query(`
            SELECT COUNT(*) AS count FROM usuario WHERE cui = ?`, 
            [cui]
        );
        // console.log(`Verificar usuario: ${JSON.stringify(rows)}, CUI: ${cui}`);
        return rows[0].count > 0;
    } catch (error) {
        return true
        // throw new Error('Error al verificar la existencia del usuario: ' + error.message);
    }
}

async function registrarUsuario(cui, nombres, apellidos, contrasenia, currentDate, rol){
    try{
        const [rows] = await pool.query(`CALL registrar_usuario(?,?,?,?,?,?)`, [cui, nombres, apellidos, contrasenia, currentDate, rol]);
        const result = rows[0][0]?.resultado;
        if (result) {
            return result;
        } else {
            console.log('Error')
            throw new Error('Resultado inesperado del procedimiento');
        }
    } catch (error) {
        console.log("Error 2", error)
        throw new Error('Error en el registro del usuario: '+ error.message)
    }
    
}

async function crearCuenta(cui){
    try{
        const [rows] = await pool.query(`CALL registrar_cuenta(?,?)`, [cui,0.00]);
        return rows;
    } catch (error) {
        console.log(error)
        throw new Error('Error en la creación de la cuenta del usuario: ' + error.message)
    }
}

exports.createUser = async (req, res) => {
    const data = req.body;
    try{
        console.log(`Procesando registro para CUI: ${data.cui}`);
        const usuarioExiste = await verificarUsuarioExiste(data.cui);
        // console.log(`¿Usuario existe? ${usuarioExiste}`);

        if (usuarioExiste) {
            return res.status(400).send({ error: 'El usuario ya está registrado' });
        }
        
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const seconds = String(now.getSeconds()).padStart(2, '0');

        const currentDate = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
        const result = await registrarUsuario(data.cui,data.nombres,data.apellidos,data.contrasenia,currentDate,data.rol);
        if (data.rol === 'usuario') {
            const sal = await crearCuenta(data.cui);
            return res.status(200).send({ success: true });
        }
        return res.status(200).send({ success: true });
    } catch (error) {
        return res.status(500).send({ error: 'Error al registrar el usuario: ' + error.message });
    }
}