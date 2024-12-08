<script>
	import { Link } from "svelte-routing";
import { isAuthenticated, user } from "../../stores/auth";
	import { onMount } from "svelte";
	import { sidebarOpen } from "../../stores/sidevar";
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
	
    let isSidebarOpen = $state();
	sidebarOpen.subscribe((value) => {
		isSidebarOpen = value;
	});

    let activeMenu = $state(null);
	function toggleMenu(menu) {
		activeMenu = activeMenu === menu ? null : menu;
	}
</script>

<!--sidenav -->
{#if $user && $isAuthenticated}
<div
	class="fixed left-0 top-0 w-64 h-full bg-[#f8f4f3] p-4 z-50 sidebar-menu transition-transform"
	class:-translate-x-full={!isSidebarOpen}
>
	<!-- Contenido del sidebar -->
	<Link to="/home" class="flex items-center pb-4 border-b border-b-gray-800">
		<h2 class="font-bold text-2xl">
			AYD <span class="bg-[#f84525] text-white px-2 rounded-md">2</span>
		</h2>
	</Link>
	<ul class="mt-4">
        <span class="text-gray-400 font-bold">
            {tipo}
        </span>
        <li class="mb-1 group">
            <Link
                to="/home"
                class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md group-[.active]:bg-gray-800 group-[.active]:text-white group-[.selected]:bg-gray-950 group-[.selected]:text-gray-100"
            >
                <i class="ri-home-2-line mr-3 text-lg"></i>
                <span class="text-sm">Dashboard</span>
            </Link>
        </li>
        {#if $user.rol === 1 || $user.rol === 2}
        <li class="mb-1 group">
            <button
                class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md"
                class:selected={activeMenu === 'usuarios'}
                style:width="100%"
                onclick={() => toggleMenu('usuarios')}
            >
                <i class="bx bx-user mr-3 text-lg"></i>
                <span class="text-sm">Usuarios</span>
                <i class="ri-arrow-right-s-line ml-auto" class:rotate-90={activeMenu === 'usuarios'}></i>
            </button>
            <ul class="pl-7 mt-2" class:hidden={activeMenu !== 'usuarios'}>
                <li class="mb-4">
                    <Link
                        to="/allusers"
                        class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                    >
                        Busqueda usuario
                    </Link>
                </li>
            </ul>
        </li>
        {/if}
		
		<span class="text-gray-400 font-bold">SERVICIOS</span>
		<li class="mb-1 group">
            <button
                class="flex font-semibold items-center py-2 px-4 text-gray-900 hover:bg-gray-950 hover:text-gray-100 rounded-md"
                class:selected={activeMenu === 'gestiones'}
                style:width="100%"
                onclick={() => toggleMenu('gestiones')}
            >
                <i class="bx bxl-blogger mr-3 text-lg"></i>
                <span class="text-sm">Gestiones</span>
                <i class="ri-arrow-right-s-line ml-auto" class:rotate-90={activeMenu === 'gestiones'}></i>
            </button>
            <ul class="pl-7 mt-2" class:hidden={activeMenu !== 'gestiones'}>
                {#if $user.rol === 1 || $user.rol === 2}
                    <li class="mb-4">
                        <Link
                            to="/servicios"
                            class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >
                            Pago de Servicio
                        </Link>
                    </li>
                    <!-- <li class="mb-4">
                        <Link
                            to="/saldo"
                            class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >
                            Mostrar Saldo
                        </Link>
                    </li> -->
                    <li class="mb-4">
                        <Link
                            to="/prestamos"
                            class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >
                            Prestamos
                        </Link>
                    </li>
                    <li class="mb-4">
                        <Link
                            to="/retirodeposito"
                            class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >
                            Retiro/Depósito
                        </Link>
                    </li>
                {:else if $user.rol === 3}
                    <li class="mb-4">
                        <Link
                            to="/prestamos"
                            class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >
                            Prestamos
                        </Link>
                    </li>
                    <li class="mb-4">
                        <Link
                            to="/retirodeposito"
                            class="text-gray-900 text-sm flex items-center hover:text-[#f84525] before:contents-[''] before:w-1 before:h-1 before:rounded-full before:bg-gray-300 before:mr-3"
                        >
                            Retiro/Depósito
                        </Link>
                    </li>
                {/if}
            </ul>
        </li>
	</ul>
</div>
<div class="fixed top-0 left-0 w-full h-full bg-black/50 z-40 md:hidden sidebar-overlay"></div>
{/if}
<!-- end sidenav -->