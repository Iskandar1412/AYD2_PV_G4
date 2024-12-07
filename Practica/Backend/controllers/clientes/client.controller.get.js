exports.findAll = async (req,res) =>{
    res.send("Endpoint buscar_cliente");
}

exports.getSaldo = async(req,res) =>{
    res.send("Endpint para obtener saldo");
}

exports.getTransaccionData = async(req,res) =>{
    res.send("Endpoint generar comprobante");
}