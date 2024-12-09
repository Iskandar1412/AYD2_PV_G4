<script>
    let numeroPrestamo = $state();
    let monto = $state();

    function GestionEmpezar() {
        console.log(`Número de préstamo: ${numeroPrestamo}`);
        console.log(`Monto a pagar: ${monto}`);
    }
</script>

<div class="gap-6 mb-6">
    <div
        class="p-6 relative flex flex-col min-w-0 mb-4 lg:mb-0 break-words bg-gray-50 dark:bg-gray-800 w-full shadow-lg rounded"
    >
        <div class="rounded-t mb-0 px-0 border-0">
            <div class="flex flex-wrap items-center px-4 py-2">
                <div class="relative w-full max-w-full flex-grow flex-1">
                    <h3 class="font-semibold text-base text-gray-900 dark:text-gray-50">Préstamos</h3>
                </div>
            </div>

            <div class="block w-full overflow-x-auto">
                    <div class="grid grid-cols-2 gap-6">
                        <div>
                            <label for="numeroPrestamo" class="block text-lg font-medium text-gray-700">
                                Número de préstamo
                            </label>
                            <input
                                id="numeroPrestamo"
                                type="text"
                                bind:value={numeroPrestamo}
                                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-base p-3"
                            />
                        </div>
                        <div>
                            <label for="monto" class="block text-lg font-medium text-gray-700">
                                Monto a pagar
                            </label>
                            <input
                                id="monto"
                                type="number"
                                bind:value={monto}
                                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-base p-3"
                            />
                        </div>
                    </div>
                <div class="mt-6 flex justify-center">
                    <button
                        onclick={GestionEmpezar}
                        class="px-6 py-2 font-bold rounded-md bg-purple-500 text-white hover:bg-purple-600 focus:outline-none"
                    >
                        Realizar Gestion
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
