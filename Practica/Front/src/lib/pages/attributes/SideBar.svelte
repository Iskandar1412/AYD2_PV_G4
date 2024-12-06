<script>
    import { onMount } from "svelte";
	import Head from "./Head.svelte";
	import ProfileUs from "./ProfileUs.svelte";
	import { isAuthenticated, user } from "../../stores/auth";
	import { Link, navigate } from "svelte-routing";

    onMount(() => {
        if($isAuthenticated) { }
        else {
            navigate('/')
        }
    })

    $effect.pre(() => {
        if($isAuthenticated === false) {
            navigate('/')
        }
    })
</script>


<!-- Sidebar -->
<nav 
    class="h-full flex flex-col justify-between bg-gray-800 text-white py-4"
    style:width="12vw"
>
    <Head />        

    <!-- Navigation Buttons -->
    <div class="flex flex-col items-center space-y-4">
        {#if $user.rol === 1 || $user.rol === 2}
            asdf    
        {:else if $user.rol === 3}
            <Link 
                class="h-16 w-16 flex items-center justify-center rounded-lg cursor-pointer hover:text-gray-800 hover:bg-white focus:bg-white"
                to="/home"
            >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M7.2 3h9.6C19.425 3 21 4.575 21 6.8v6.4c0 2.225-1.575 3.8-3.8 3.8h-3.383l-3.43 2.736c-.703.56-1.687.053-1.687-.83v-1.906H7.2C4.975 17 3.4 15.425 3.4 13.2V6.8C3.4 4.575 4.975 3 7.2 3z"/>
                </svg>
            </Link>

            <Link 
                class="h-16 w-16 flex items-center justify-center rounded-lg cursor-pointer hover:text-gray-800 hover:bg-white focus:bg-white"
                to="/home/creators"
            >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path d="M15 14c2.21 0 4 1.79 4 4v1c0 .55-.45 1-1 1H6c-.55 0-1-.45-1-1v-1c0-2.21 1.79-4 4-4h6zm-6-1.9a3 3 0 100-6 3 3 0 000 6zm7.2-5.9a2.2 2.2 0 11-.001 4.4 2.2 2.2 0 01.001-4.4zM6.8 9a2.2 2.2 0 100-4.4 2.2 2.2 0 000 4.4z"/>
                </svg>
            </Link>

            <Link 
                class="h-16 w-16 flex items-center justify-center rounded-lg cursor-pointer hover:text-gray-800 hover:bg-white focus:bg-white"
                to="/home/settings"
            >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
            </Link>
        {/if}
    </div>

    <ProfileUs />
</nav>