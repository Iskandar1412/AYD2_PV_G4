<script>
	let cui = $state();
    let cuiText = $state();
    let name = $state();
    let nameText = $state();
    let last = $state();
    let lastText = $state();
    let password = $state();
    let passwordText = $state();
    let submit = $state(false);
    let disableAdding = $state(false);

    function clearInputs() {
        cuiText = '';
        nameText = '';
        lastText = '';
        passwordText = '';
    }

    async function handleSubmitUser (event) {
        event.preventDefault();
        submit = true;
        console.log(cuiText, nameText, lastText, passwordText);
        clearInputs();
        submit = false;
    }
</script>

<div class="font-[sans-serif] bg-white max-w-10xl flex items-center mx-auto md:h-screen p-4">
	<div
		class="grid md:grid-cols-3 items-center shadow-[0_2px_10px_-3px_rgba(6,81,237,0.3)] rounded-xl overflow-hidden"
	>
		<div
			class="max-md:order-1 flex flex-col justify-center space-y-16 max-md:mt-16 min-h-full bg-gradient-to-r from-gray-900 to-gray-700 lg:px-8 px-4 py-4"
		>
			<div>
				<h4 class="text-white text-lg font-semibold">Crea tu cuenta nueva</h4>
				<p class="text-[13px] text-gray-300 mt-3 leading-relaxed">
					Bienvenido a nuestra pagina de registro! empieza creando tu cuenta.
				</p>
			</div>
			<div>
				<h4 class="text-white text-lg font-semibold">Simple & Seguro de registrar</h4>
				<p class="text-[13px] text-gray-300 mt-3 leading-relaxed">
					Nuestro proceso de registro esta diseñado para ser sencillo y seguro. Nuestra prioridad es tu seguridad y privacidad.
				</p>
			</div>
		</div>

		<form 
            class="md:col-span-2 w-full py-6 px-6 sm:px-16"
            onsubmit={handleSubmitUser}
        >
			<div class="mb-6">
				<h3 class="text-gray-800 text-2xl font-bold">Crea tu cuenta</h3>
			</div>

			<div class="space-y-6">
				<div>
					<label class="text-gray-800 text-sm mb-2 block">Nombre</label>
					<div class="relative flex items-center">
						<input
							name="name"
							type="text"
							required
							class="text-gray-800 bg-white border border-gray-300 w-full text-sm px-4 py-2.5 rounded-md outline-blue-500"
                            bind:this={name}
                            bind:value={nameText}
							placeholder="Ingrese nombres"
						/>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							fill="#bbb"
							stroke="#bbb"
							class="w-4 h-4 absolute right-4"
							viewBox="0 0 24 24"
						>
							<circle cx="10" cy="7" r="6" data-original="#000000"></circle>
							<path
								d="M14 15H6a5 5 0 0 0-5 5 3 3 0 0 0 3 3h12a3 3 0 0 0 3-3 5 5 0 0 0-5-5zm8-4h-2.59l.3-.29a1 1 0 0 0-1.42-1.42l-2 2a1 1 0 0 0 0 1.42l2 2a1 1 0 0 0 1.42 0 1 1 0 0 0 0-1.42l-.3-.29H22a1 1 0 0 0 0-2z"
								data-original="#000000"
							/>
						</svg>
					</div>
				</div>

				<div>
					<label class="text-gray-800 text-sm mb-2 block">Last Name</label>
					<div class="relative flex items-center">
						<input
							name="last"
							type="text"
							required
							class="text-gray-800 bg-white border border-gray-300 w-full text-sm px-4 py-2.5 rounded-md outline-blue-500"
							bind:this={last}
                            bind:value={lastText}
                            placeholder="Ingrese apellidos"
						/>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							fill="#bbb"
							stroke="#bbb"
							class="w-4 h-4 absolute right-4"
							viewBox="0 0 24 24"
						>
							<circle cx="10" cy="7" r="6" data-original="#000000"></circle>
							<path
								d="M14 15H6a5 5 0 0 0-5 5 3 3 0 0 0 3 3h12a3 3 0 0 0 3-3 5 5 0 0 0-5-5zm8-4h-2.59l.3-.29a1 1 0 0 0-1.42-1.42l-2 2a1 1 0 0 0 0 1.42l2 2a1 1 0 0 0 1.42 0 1 1 0 0 0 0-1.42l-.3-.29H22a1 1 0 0 0 0-2z"
								data-original="#000000"
							/>
						</svg>
					</div>
				</div>

				<div>
					<label class="text-gray-800 text-sm mb-2 block">CUI</label>
					<div class="relative flex items-center">
						<input
							name="cui"
							type="number"
                            maxlength="13"
							required
							class="text-gray-800 bg-white border border-gray-300 w-full text-sm px-4 py-2.5 rounded-md outline-blue-500"
                            bind:this={cui}
                            bind:value={cuiText}
							placeholder="Enter CUI"
						/>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							fill="#bbb"
							stroke="#bbb"
							class="w-4 h-4 absolute right-4"
							viewBox="0 0 24 24"
						>
							<circle cx="10" cy="7" r="6" data-original="#000000"></circle>
							<path
								d="M14 15H6a5 5 0 0 0-5 5 3 3 0 0 0 3 3h12a3 3 0 0 0 3-3 5 5 0 0 0-5-5zm8-4h-2.59l.3-.29a1 1 0 0 0-1.42-1.42l-2 2a1 1 0 0 0 0 1.42l2 2a1 1 0 0 0 1.42 0 1 1 0 0 0 0-1.42l-.3-.29H22a1 1 0 0 0 0-2z"
								data-original="#000000"
							/>
						</svg>
					</div>
				</div>

				<div>
					<label class="text-gray-800 text-sm mb-2 block">Password</label>
					<div class="relative flex items-center">
						<input
							name="password"
							type="password"
							required
							class="text-gray-800 bg-white border border-gray-300 w-full text-sm px-4 py-2.5 rounded-md outline-blue-500"
                            bind:this={password}
                            bind:value={passwordText}
                            placeholder="Enter password"
						/>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							fill="#bbb"
							stroke="#bbb"
							class="w-4 h-4 absolute right-4 cursor-pointer"
							viewBox="0 0 128 128"
						>
							<path
								d="M64 104C22.127 104 1.367 67.496.504 65.943a4 4 0 0 1 0-3.887C1.367 60.504 22.127 24 64 24s62.633 36.504 63.496 38.057a4 4 0 0 1 0 3.887C126.633 67.496 105.873 104 64 104zM8.707 63.994C13.465 71.205 32.146 96 64 96c31.955 0 50.553-24.775 55.293-31.994C114.535 56.795 95.854 32 64 32 32.045 32 13.447 56.775 8.707 63.994zM64 88c-13.234 0-24-10.766-24-24s10.766-24 24-24 24 10.766 24 24-10.766 24-24 24zm0-40c-8.822 0-16 7.178-16 16s7.178 16 16 16 16-7.178 16-16-7.178-16-16-16z"
								data-original="#000000"
							></path>
						</svg>
					</div>
				</div>

			</div>

			<div class="!mt-12">
				<button
					type="button"
					class="w-full py-3 px-4 tracking-wider text-sm rounded-md text-white bg-gray-700 hover:bg-gray-800 focus:outline-none"
                    disabled={disableAdding || !cuiText || !nameText || !lastText || !passwordText}
				>
					Create an account
				</button>
			</div>
			<p class="text-gray-800 text-sm mt-6 text-center">
				Already have an account?
                <a
					href="javascript:void(0);"
					class="text-blue-600 font-semibold hover:underline ml-1"
                >
                    Login here
                </a>
			</p>
		</form>
	</div>
</div>

<style lang="scss">
    form {
        div {
            button {
                &:disabled {
                    opacity: 0.4;
                    cursor: not-allowed;
                }
            }
        }
    }
</style>