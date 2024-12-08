const pool = require('../../config/db')

async function registrarUsuario(cui, nombres, apellidos, contrasenia, fecha_creacion,rol){
    try{
        const [rows] = await pool.query(`
            CALL registrar_usuario(?,?,?,?,?,?)`,
            [cui,nombres,apellidos,contrasenia,fecha_creacion,rol]
        );
        return rows;
    } catch (error) {
        throw new Error('Error en el registro del usuario: '+ error.message)
    }
    
}

async function crearCuenta(cui){
    try{
        const [rows] = await pool.query(
            `CALL registrar_cuenta(?,?)`,
            [cui,0.00]
        );
        return rows;
    } catch (error) {
        throw new Error('Error en la creación de la cuenta del usuario: ' + error.message)
    }
}

exports.createUser = async (req, res) => {
    const data = req.body;
    try{
        const currentDate = new Date().toISOString().split('T')[0];
        await registrarUsuario(data.cui,data.nombres,data.apellidos,data.contrasenia,currentDate,data.rol);
        if (data.rol === 'usuario') {
            await crearCuenta(data.cui);
        }
        res.status(201).send({ message: 'Usuario registrado con éxito' });
    } catch (error) {
        res.status(500).send({ error: 'Error al registrar el usuario: ' + error.message });
    }
}