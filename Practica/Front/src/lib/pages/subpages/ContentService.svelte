<script>
	import { user } from "../../stores/auth";

    let cuentaUsuario = $state();
    let servicioSeleccionado = $state("");
    let montoAPagar = $state();

    function realizarGestion() {
        console.log("Pago de Servicios:");
        console.log(`Cuenta del usuario: ${cuentaUsuario}`);
        console.log(`Servicio seleccionado: ${servicioSeleccionado}`);
        console.log(`Monto a pagar: ${montoAPagar}`);
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
