<script>
	let gestion = $state('deposito');
	let numeroCuenta = $state();
	let monto = $state();
	let metodoDeposito = $state('');
	let tipoRetiro = $state('');

	function realizarGestion() {
		console.log('Datos de la gestión:');
		console.log(`Gestión: ${gestion === 'deposito' ? 'Depósito' : 'Retiro'}`);
		console.log(`Número de cuenta: ${numeroCuenta}`);
		console.log(`Monto: ${monto}`);
		if (gestion === 'deposito') {
			console.log(`Método de depósito: ${metodoDeposito}`);
		} else if (gestion === 'retiro') {
			console.log(`Tipo de retiro: ${tipoRetiro}`);
		}
	}
</script>

<div class="flex items-center mb-6">
    <div class="flex items-center">
        <button
            aria-label="Button-Option-Retiro-Deposito"
            class="w-20 h-8 flex items-center rounded-full cursor-pointer shadow-md"
            onclick={() => (gestion = gestion === 'deposito' ? 'retiro' : 'deposito')}
            class:bg-green-500={gestion === 'deposito'}
            class:bg-yellow-500={gestion === 'retiro'}
        >
            <div
                class="w-6 h-6 rounded-full bg-white shadow transform transition-transform duration-300"
                class:translate-x-12={gestion === 'retiro'}
                class:translate-x-1={gestion === 'deposito'}
            ></div>
        </button>
    </div>
    <div class="ml-4 text-lg font-semibold">
        Gestión seleccionada:
        <span class={gestion === 'deposito' ? 'text-green-600' : 'text-yellow-600'}>
            {gestion === 'deposito' ? 'Depósito' : 'Retiro'}
        </span>
    </div>
</div>
<div class="space-y-6">
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
            <label for="numeroCuenta" class="block text-lg font-medium text-gray-700">
                Número de cuenta
            </label>
            <input
                id="numeroCuenta"
                type="number"
                bind:value={numeroCuenta}
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-base p-3"
            />
        </div>

        {#if gestion === 'deposito'}
            <div>
                <label for="metodoDeposito" class="block text-lg font-medium text-gray-700">
                    Método de depósito
                </label>
                <select
                    id="metodoDeposito"
                    bind:value={metodoDeposito}
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-base p-3"
                >
                    <option value="">Seleccionar</option>
                    <option value="bancario">Transferencia Bancaria</option>
                    <option value="efectivo">Efectivo</option>
                </select>
            </div>
        {:else if gestion === 'retiro'}
            <div>
                <label for="tipoRetiro" class="block text-lg font-medium text-gray-700">
                    Tipo de retiro
                </label>
                <select
                    id="tipoRetiro"
                    bind:value={tipoRetiro}
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-base p-3"
                >
                    <option value="">Seleccionar</option>
                    <option value="cajero">Cajero Automático</option>
                </select>
            </div>
        {/if}
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
            <label for="monto" class="block text-lg font-medium text-gray-700">
                Monto
            </label>
            <input
                id="monto"
                type="number"
                bind:value={monto}
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-base p-3"
            />
        </div>
    </div>
</div>
<div 
    class="flex justify-center mt-6 button-getsion"
    style:margin-top="5em"
>
    <button
        onclick={() => realizarGestion()}
        class="px-6 py-2 font-bold rounded-md bg-purple-500 text-white hover:bg-purple-600 focus:outline-none"
        disabled={!numeroCuenta || (monto === 0 || !monto) || (gestion === 'deposito' && !metodoDeposito) || (gestion === 'retiro' && !tipoRetiro)}
    >
        Realizar Gestión
    </button>
</div>


<style lang="scss">
    .button-getsion {
        button {

            &:disabled {
                opacity: 0.4;
                cursor: not-allowed;
            }
        }
    }
</style>