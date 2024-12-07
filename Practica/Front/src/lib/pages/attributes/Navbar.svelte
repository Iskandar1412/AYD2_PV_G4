<script>
	import { onMount, onDestroy } from "svelte";
	import { isAuthenticated, logoutUser, user } from "../../stores/auth";
	import { navigate } from "svelte-routing";
	import { sidebarOpen } from "../../stores/sidevar";
    import { createPopper } from '@popperjs/core';

    onMount(() => {
        if($isAuthenticated === false) {
            navigate('/')
        }
    })

    const toggleSidebar = () => {
		sidebarOpen.update((open) => !open);
	};

    let isFullscreen = $state(false);

	function toggleFullscreen() {
		if (document.fullscreenElement) {
			document.exitFullscreen();
			isFullscreen = false;
		} else {
			document.documentElement.requestFullscreen();
			isFullscreen = true;
		}
	}

    let isSearchOpen = $state(false);
	let isUserMenuOpen = $state(false);
    let searchButton = $state()
    let searchMenu = $state()
    let userButton = $state()
    let userMenu = $state();

	onMount(() => {
		if (searchButton && searchMenu) {
			createPopper(searchButton, searchMenu, { placement: 'bottom-end' });
		}
		if (userButton && userMenu) {
			createPopper(userButton, userMenu, { placement: 'bottom-end' });
		}
	});

	function handleClickOutside(event) {
		if (!searchMenu.contains(event.target) && !searchButton.contains(event.target)) {
			isSearchOpen = false;
		}
		if (!userMenu.contains(event.target) && !userButton.contains(event.target)) {
			isUserMenuOpen = false;
		}
	}
	document.addEventListener('click', handleClickOutside);

	onDestroy(() => {
		document.removeEventListener('click', handleClickOutside);
	});
</script>

{#if $user && $isAuthenticated}
<!-- navbar -->
<div
	class="py-2 px-6 bg-[#f8f4f3] flex items-center shadow-md shadow-black/5 sticky top-0 left-0 z-30"
>
    <button
        type="button"
        aria-label="boton-sidebar"
        class="text-lg text-gray-900 font-semibold"
        onclick={toggleSidebar}
    >
    <i class="ri-menu-line"></i>
    </button>

	<ul class="ml-auto flex items-center">
        <!-- Menú de Búsqueda -->
        {#if $user.rol === 1 || $user.rol === 2}
            <li class="mr-1 dropdown">
                <button
                    bind:this={searchButton}
                    type="button"
                    class="dropdown-toggle text-gray-400 mr-4 w-8 h-8 rounded flex items-center justify-center hover:text-gray-600"
                    aria-label="botom-toggle"
                    onclick={() => (isSearchOpen = !isSearchOpen)}
                >
                    <svg
                        xmlns="http://www.w3.org/2000/svg"
                        width="24"
                        height="24"
                        class="hover:bg-gray-100 rounded-full"
                        viewBox="0 0 24 24"
                        style="fill: gray;"
                    >
                        <path
                            d="M19.023 16.977a35.13 35.13 0 0 1-1.367-1.384c-.372-.378-.596-.653-.596-.653l-2.8-1.337A6.962 6.962 0 0 0 16 9c0-3.859-3.14-7-7-7S2 5.141 2 9s3.14 7 7 7c1.763 0 3.37-.66 4.603-1.739l1.337 2.8s.275.224.653.596c.387.363.896.854 1.384 1.367l1.358 1.392.604.646 2.121-2.121-.646-.604c-.379-.372-.885-.866-1.391-1.36zM9 14c-2.757 0-5-2.243-5-5s2.243-5 5-5 5 2.243 5 5-2.243 5-5 5z"
                        />
                    </svg>
                </button>
                <div
                    bind:this={searchMenu}
                    class="dropdown-menu shadow-md shadow-black/5 z-30 py-4 max-w-xs w-full bg-white rounded-md border border-gray-100"
                    class:hidden={!isSearchOpen}
                >
                    <form class="p-4 border-b border-b-gray-100">
                        <div class="relative w-full">
                            <input
                                type="text"
                                class="py-2 pr-4 pl-10 bg-gray-50 w-full outline-none border border-gray-100 rounded-md text-sm focus:border-blue-500"
                                placeholder="Search..."
                            />
                            <i class="ri-search-line absolute top-1/2 left-4 -translate-y-1/2 text-gray-900"></i>
                        </div>
                    </form>
                </div>
            </li>
        {/if}
    
        <!-- Pantalla Completa -->
        <button
            aria-label="button-full-screen"
            class="p-2 rounded-full hover:bg-gray-100"
            onclick={toggleFullscreen}
        >
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: gray;">
                {#if isFullscreen}
                    <path d="M3 3h7v2H5v5H3zm14 0h4v4h-2V5h-2zm0 14h2v2h2v4h-7zm-14 0h2v2h2v2H3zm7-7h2v2H7v2H5v-4zm4 2h2v2h-4v-4z"></path>
                {:else}
                    <path d="M5 5h5V3H3v7h2zm5 14H5v-5H3v7h7zm11-5h-2v5h-5v2h7zm-2-4h2V3h-7v2h5z"></path>
                {/if}
            </svg>
        </button>
    
        <!-- Menú de Usuario -->
        <li class="dropdown ml-3">
            <button
                bind:this={userButton}
                type="button"
                class="dropdown-toggle flex items-center"
                onclick={() => (isUserMenuOpen = !isUserMenuOpen)}
            >
                <div class="flex-shrink-0 w-10 h-10 relative">
                    <img class="w-8 h-8 rounded-full" src="/Userimage.png" alt="" />
                    <div class="top-0 left-7 absolute w-3 h-3 bg-lime-400 border-2 border-white rounded-full animate-ping"></div>
                    <div class="top-0 left-7 absolute w-3 h-3 bg-lime-500 border-2 border-white rounded-full"></div>
                </div>
                <div class="p-2 md:block text-left">
                    <h2 class="text-sm font-semibold text-gray-800">{$user.nombres}</h2>
                    <p class="text-xs text-gray-500">
                        {#if $user.rol === 1} Administrador
                        {:else if $user.rol === 2} Personal
                        {:else if $user.rol === 3} Usuario {/if}
                    </p>
                </div>
            </button>
            <ul
                bind:this={userMenu}
                class="dropdown-menu shadow-md shadow-black/5 z-30 py-1.5 rounded-md bg-white border border-gray-100 w-full max-w-[140px]"
                class:hidden={!isUserMenuOpen}
            >
                <li>
                    <a href="#" class="flex items-center text-[13px] py-1.5 px-4 text-gray-600 hover:text-[#f84525] hover:bg-gray-50">
                        Profile
                    </a>
                </li>
                <li>
                    <form>
                        <button
                            class="flex items-center text-[13px] py-1.5 px-4 text-gray-600 hover:text-[#f84525] hover:bg-gray-50 cursor-pointer"
                            onclick={logoutUser}
                        >
                            Log Out
                        </button>
                    </form>
                </li>
            </ul>
        </li>
    </ul>
</div>
<!-- end navbar -->
{/if}
