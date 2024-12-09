<script>
	import jsPDF from "jspdf";
	import { user } from "../../stores/auth";
	import { PathBackend } from "../../stores/host";

    let cuentaUsuario = $state();
    let servicioSeleccionado = $state("");
    let montoAPagar = $state();
    // agua 1 luz 2 tele 3 inter 4
    // <option value="agua">Agua</option>
    // <option value="luz">Luz</option>
    // <option value="telefono">Teléfono</option>
    // <option value="internet">Internet</option>
    let servicioInt = $state()
    $effect(() => {
        if(servicioSeleccionado === 'agua') servicioInt = 1
        if(servicioSeleccionado === 'luz') servicioInt = 2
        if(servicioSeleccionado === 'telefono') servicioInt = 3
        if(servicioSeleccionado === 'internet') servicioInt = 4
    })

    function generacionPDF(message) {
        try { 
            const doc = new jsPDF();
            doc.setFont("helvetica", "normal");
            doc.text(new Date().toString(), 10, 10);

            doc.setFontSize(16);
            doc.setFont("helvetica", "bold");
            doc.text(`Pago Servicio ${servicioSeleccionado.toUpperCase()}`, 105, 20, { align: "center" });

            doc.setFontSize(12);
            doc.text("Número de cuenta:", 10, 40);
            doc.setFont("helvetica", "normal");
            doc.text(cuentaUsuario.toString(), 60, 40);

            doc.setFont("helvetica", "bold");
            doc.text("Tipo de transacción:", 10, 50);
            doc.setFont("helvetica", "normal");
            doc.text('Pago Servicio', 60, 50);

            doc.setFont("helvetica", "bold");
            doc.text("Fecha y hora:", 10, 60);
            doc.setFont("helvetica", "normal");
            doc.text(Date() , 60, 60);

            doc.setFont("helvetica", "bold");
            doc.text("Monto:", 10, 70);
            doc.setFont("helvetica", "normal");
            doc.text(montoAPagar.toString(), 60, 70);
            if ($user?.nombres && $user.nombres !== 'NULL') {
                doc.setFont("helvetica", "bold");
                doc.text("Nombre del empleado:", 10, 80);
                doc.setFont("helvetica", "normal");
                doc.text(`${$user.nombres} ${$user.apellidos}`, 60, 80);
            }
            
            doc.save(`Comprobante_${servicioSeleccionado.toString()}.pdf`);
        } catch (error) {
            console.error("Error generando el PDF:", error);
            alert("Error generando el PDF. Por favor, verifica los datos.");
        }
    }

    function realizarGestion() {
        // console.log({cui_enc: $user.cui, cod_servicio: servicioInt ,monto: montoAPagar, cuenta: cuentaUsuario});
        
        fetch(`${PathBackend}/personal/pagoServicio`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ cui_enc: $user.cui, cod_servicio: servicioInt ,monto: montoAPagar, cuenta: cuentaUsuario })
        })
        .then(res => {
            // console.log(res)
            if(!res.ok) { throw new Error('Error en la transaccion') }
            return res.json()
        })
        .then(data => {
            if(data.resultado.status === "error") { throw new Error('Error en la transsacción') }
            else {
                alert('Peticion de Servicio aceptada')
                // console.log(data.resultado)
                generacionPDF(data)
            }
        })
        .catch(err => {
            console.log(err)
        })
    }
</script>

<div class="p-6">
    <h2 class="text-2xl font-bold text-gray-800 mb-6">Pago de Servicios</h2>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
            <label for="cuentaUsuario" class="block text-lg font-medium text-gray-700">
                Cuenta del usuario
            </label>
            <input
                id="cuentaUsuario"
                type="number"
                bind:value={cuentaUsuario}
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-base p-3"
            />
        </div>

        <div>
            <label for="servicioSeleccionado" class="block text-lg font-medium text-gray-700">
                Servicio
            </label>
            <select
                id="servicioSeleccionado"
                bind:value={servicioSeleccionado}
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-base p-3"
            >
                <option value="">Seleccionar</option>
                <option value="agua">Agua</option>
                <option value="luz">Luz</option>
                <option value="telefono">Teléfono</option>
                <option value="internet">Internet</option>
            </select>
        </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
        <div>
            <label for="montoAPagar" class="block text-lg font-medium text-gray-700">
                Monto a pagar
            </label>
            <input
                id="montoAPagar"
                type="number"
                bind:value={montoAPagar}
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-base p-3"
            />
        </div>

        <div>
            <label for="nombreUsuario" class="block text-lg font-medium text-gray-700">
                Encargado
            </label>
            <input
                id="nombreUsuario"
                type="text"
                value={$user.nombres}
                readonly
                class="mt-1 block w-full bg-gray-100 cursor-not-allowed rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-base p-3"
            />
        </div>
    </div>

    <div class="mt-6 flex justify-center">
        <button
            onclick={realizarGestion}
            class="px-6 py-2 font-bold rounded-md bg-purple-500 text-white hover:bg-purple-600 focus:outline-none"
        >
            Realizar Gestión
        </button>
    </div>
</div>
