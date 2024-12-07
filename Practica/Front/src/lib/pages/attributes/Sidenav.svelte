<script>
	import { user } from "../../stores/auth";
    let tipo = $state()
    $effect.pre(() => {
        if($user.rol === 1) {
            tipo = "ADMINISTRADOR"
        } else if ($user.rol === 2) {
            tipo = "PERSONAL"
        } else if ($user.rol === 3) {
            tipo = "USUARIO"
        }
    })
    
</script>

<!--sidenav -->
<div class="fixed left-0 top-0 w-64 h-full bg-[#f8f4f3] p-4 z-50 sidebar-menu transition-transform">
	<a href="#" class="flex items-center pb-4 border-b border-b-gray-800">
		<h2 class="font-bold text-2xl">
			AYD <span class="bg-[#f84525] text-white px-2 rounded-md">2</span>
		</h2>
	</a>
	<ul class="mt-4">
        <span class="text-gray-400 font-bold">
            {tipo}
        </span>
        <li class="mb-1 group">
            <a
                href=""
                class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md group-[.active]:bg-gray-800 group-[.active]:text-white group-[.selected]:bg-gray-950 group-[.selected]:text-gray-100"
            >
                <i class="ri-home-2-line mr-3 text-lg"></i>
                <span class="text-sm">Dashboard</span>
            </a>
        </li>
        {#if $user.rol === 1 || $user.rol === 2}
        <li class="mb-1 group">
            <a
                href=""
                class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md group-[.active]:bg-gray-800 group-[.active]:text-white group-[.selected]:bg-gray-950 group-[.selected]:text-gray-100 sidebar-dropdown-toggle"
            >
                <i class="bx bx-user mr-3 text-lg"></i>
                <span class="text-sm">Usuarios</span>
                <i class="ri-arrow-right-s-line ml-auto group-[.selected]:rotate-90"></i>
            </a>
            <ul class="pl-7 mt-2 hidden group-[.selected]:block">
                <li class="mb-4">
                    <a
                        href=""
                        class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >All</a
                    >
                </li>
                <li class="mb-4">
                    <a
                        href=""
                        class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >Roles</a
                    >
                </li>
            </ul>
        </li>
        {/if}
		
		<span class="text-gray-400 font-bold">SERVICIOS</span>
		<li class="mb-1 group">
			<a
				href=""
				class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md group-[.active]:bg-gray-800 group-[.active]:text-white group-[.selected]:bg-gray-950 group-[.selected]:text-gray-100 sidebar-dropdown-toggle"
			>
				<i class="bx bxl-blogger mr-3 text-lg"></i>
				<span class="text-sm">Gestiones</span>
				<i class="ri-arrow-right-s-line ml-auto group-[.selected]:rotate-90"></i>
			</a>
			<ul class="pl-7 mt-2 hidden group-[.selected]:block">
                {#if $user.rol === 1 || $user.rol === 2}
                    <li class="mb-4">
                        <a
                        href="#"
                        class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >
                            Pago de Servicio
                        </a>
                    </li>
                {:else if $user.rol === 3}
                    <li class="mb-4">
                        <a
                            href="#"
                            class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >
                            Pago de Prestamo
                        </a>
                    </li>
                    <li class="mb-4">
                        <a
                            href="#"
                            class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >
                            Mostrar Saldo
                        </a>
                    </li>
                    <li class="mb-4">
                        <a
                            href="#"
                            class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >
                            Retiro/Depósito
                        </a>
                    </li>
                {/if}
			</ul>
		</li>
        {#if $user.rol === 3}
            <li class="mb-1 group">
                <a
                    href=""
                    class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md group-[.active]:bg-gray-800 group-[.active]:text-white group-[.selected]:bg-gray-950 group-[.selected]:text-gray-100"
                >
                    <i class="bx bx-archive mr-3 text-lg"></i>
                    <span class="text-sm">Generación de Comprobante</span>
                </a>
            </li>
        {/if}
	</ul>
</div>
<div class="fixed top-0 left-0 w-full h-full bg-black/50 z-40 md:hidden sidebar-overlay"></div>
<!-- end sidenav -->