<script>
	import { onMount } from "svelte";
	import { isAuthenticated, logoutUser, user } from "../stores/auth";
	import { navigate } from "svelte-routing";
    let menuVisible = $state(false);

    onMount(() => {
        if($isAuthenticated === false) {
            navigate('/')
        }
    })

    $effect.pre(() => {
        if($isAuthenticated === false) {
            navigate('/')
        }
    })

    function toggleMenu() {
        menuVisible = !menuVisible;
    }
</script>

<!-- User Profile -->
<div class='relative'>
    <button
        class="flex flex-col items-center space-y-2 py-4 bg-gray-700 rounded-lg hover:bg-gray-600 focus:outline-none"
        style:width="9vw"
        style:margin-left="auto"
        style:margin-right="auto"
        onclick={toggleMenu}
    >
        <div class="h-16 w-16 rounded-full border border-gray-500 overflow-hidden">
            <img
                src="/Userimage.png"
                alt="Avatar"
                class="h-full w-full object-cover"
            />
        </div>
        <div class="text-sm font-semibold text-gray-100">{$user.nombres.split(' ')[0]}</div>
        <div class="text-xs text-gray-300">Active</div>
    </button>
    {#if menuVisible}
        <div 
            class="absolute bg-gray-700 text-white rounded-md ml-2 shadow-lg"
            style:top="5.7em"
            style:width="9.5vw"
        >
            <ul class="space-y-2 p-2">
                <li>
                    <button
                        class="w-full text-center px-4 py-2 hover:bg-gray-600 focus:outline-none"
                        onclick={logoutUser}
                    >
                        Logout
                    </button>
                </li>
            </ul>
        </div>
    {/if}
</div>