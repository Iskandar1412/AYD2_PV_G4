<script>
	import { navigate, Link } from "svelte-routing";
	import { isAuthenticated, loginUser } from "../stores/auth";
	import { onMount } from "svelte";
	import { PathBackend } from "../stores/host";

	onMount(() => {
		if($isAuthenticated) {
			navigate('/home')
		} else {
			navigate('/')
		}
	})

	$effect.pre(() => {
		if($isAuthenticated === false) {
			navigate('/')
		}
	})
	
	let cui = $state();
	let cuiText = $state();
	let password = $state()
	let passwordText = $state();
	let submit = $state(false);
	let cuiFull = $state(false);

	function clearInputs() {
		cuiText = ''
		passwordText = ''
	}

	function handleInput(event) {
		const value = event.target.value;
		if(value.length > 13) {
			cuiText = value.slice(0, 13);
		} else { cuiText = value.replace(/[^\d]/g, '') }
		if(value.length < 13) { cuiFull = false }
		else if (value.length === 13) { cuiFull = true }
	}

	async function handleLoginForm(event) {
		event.preventDefault();
		submit = true
		// console.log(cuiText, passwordText)
		
		fetch(`${PathBackend}/user/validarUsuario/${cuiText}/${passwordText}`, {
			method: 'GET',
			headers: {
				'Content-Type': 'application/json',
			},
		})
		.then(res => {
			if(!res.ok) {
				throw new Error('Error en la solicitud')
			}
			return res.json()
		})
		.then(data => {
			if(data) {
				loginUser(data)
				navigate('/home')
				clearInputs()
				submit = false
			} else {
				clearInputs()
				submit = false
				throw new Error('Error en el inicio de seción')
			}
		})
		.catch(err => {
			clearInputs()
			submit = false
			alert(err)
			navigate('/')	
		})
		
	}
</script>

<div class="font-[sans-serif]">
	<div class="grid lg:grid-cols-3 md:grid-cols-2 items-center gap-4 h-full">
		<div
			class="max-md:order-1 lg:col-span-2 md:h-screen w-full bg-[#000842] md:rounded-tr-xl md:rounded-br-xl lg:p-12 p-8"
		>
			<img
				src="https://readymadeui.com/signin-image.webp"
				class="lg:w-[70%] w-full h-full object-contain block mx-auto"
				alt="logo"
			/>
		</div>

		<div class="w-full p-6">
			<form
				class="form-login"
				onsubmit={handleLoginForm}
			>
				<div class="mb-8">
					<h3 class="text-gray-800 text-3xl font-extrabold">Inicio de Seción</h3>
					<p class="text-sm mt-4 text-gray-800">
						¿No tiene una cuenta?
						<Link 
							class="text-blue-600 font-semibold hover:underline ml-1 whitespace-nowrap"
							to='/register'
							onclick={clearInputs}
						>
							Regístrese aquí
						</Link>
					</p>
				</div>

				<div>
					<label for='cui' class="text-gray-800 text-[15px] mb-2 block">CUI</label>
					<div class="relative flex items-center">
						<input
							name="cui"
							id='cui'
							type="number"
							required
							class="w-full text-sm text-gray-800 bg-gray-100 focus:bg-transparent px-4 py-3.5 rounded-md outline-blue-600"
							bind:this={cui}
							bind:value={cuiText}
							oninput={handleInput}
							placeholder="Ingrese CUI"
						/>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							fill="#bbb"
							stroke="#bbb"
							class="w-[18px] h-[18px] absolute right-4"
							viewBox="0 0 682.667 682.667"
						>
							<defs>
								<clipPath id="a" clipPathUnits="userSpaceOnUse">
									<path d="M0 512h512V0H0Z" data-original="#000000"></path>
								</clipPath>
							</defs>
							<g clip-path="url(#a)" transform="matrix(1.33 0 0 -1.33 0 682.667)">
								<path
									fill="none"
									stroke-miterlimit="10"
									stroke-width="40"
									d="M452 444H60c-22.091 0-40-17.909-40-40v-39.446l212.127-157.782c14.17-10.54 33.576-10.54 47.746 0L492 364.554V404c0 22.091-17.909 40-40 40Z"
									data-original="#000000"
								></path>
								<path
									d="M472 274.9V107.999c0-11.027-8.972-20-20-20H60c-11.028 0-20 8.973-20 20V274.9L0 304.652V107.999c0-33.084 26.916-60 60-60h392c33.084 0 60 26.916 60 60v196.653Z"
									data-original="#000000"
								></path>
							</g>
						</svg>
					</div>
				</div>

				<div class="mt-4">
					<label for='pass' class="text-gray-800 text-[15px] mb-2 block">Contraseña</label>
					<div class="relative flex items-center">
						<input
							id='pass'
							name="password"
							type="password"
							required
							class="w-full text-sm text-gray-800 bg-gray-100 focus:bg-transparent px-4 py-3.5 rounded-md outline-blue-600"
							bind:this={password}
							bind:value={passwordText}
							placeholder="Ingrese contraseña"
						/>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							fill="#bbb"
							stroke="#bbb"
							class="w-[18px] h-[18px] absolute right-4 cursor-pointer"
							viewBox="0 0 128 128"
						>
							<path
								d="M64 104C22.127 104 1.367 67.496.504 65.943a4 4 0 0 1 0-3.887C1.367 60.504 22.127 24 64 24s62.633 36.504 63.496 38.057a4 4 0 0 1 0 3.887C126.633 67.496 105.873 104 64 104zM8.707 63.994C13.465 71.205 32.146 96 64 96c31.955 0 50.553-24.775 55.293-31.994C114.535 56.795 95.854 32 64 32 32.045 32 13.447 56.775 8.707 63.994zM64 88c-13.234 0-24-10.766-24-24s10.766-24 24-24 24 10.766 24 24-10.766 24-24 24zm0-40c-8.822 0-16 7.178-16 16s7.178 16 16 16 16-7.178 16-16-7.178-16-16-16z"
								data-original="#000000"
							></path>
						</svg>
					</div>
				</div>

				<div class="mt-8">
					<button
						type="submit"
						class="w-full py-3 px-6 text-sm tracking-wide rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none"
						disabled={!cuiFull || !passwordText}
					>
						Ingresar
					</button>
				</div>
			</form>
		</div>
	</div>
</div>

<style lang="scss">
	.form-login {
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