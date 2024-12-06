<script>
	import { onMount } from "svelte";
	import SideBar from "./attributes/SideBar.svelte";
	import { isAuthenticated, user } from "../stores/auth";
	import { navigate } from "svelte-routing";

    onMount(() => {
        console.log($user.id)
    })

    $effect.pre(() => {
        if($isAuthenticated === false) {
            navigate('/')
        }
    })
</script>

<svelte:head>
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <title>Home {$user.nombres}</title>
</svelte:head>

<div class="h-screen w-full bg-white flex overflow-hidden">
    <SideBar  />
    <div class="w-full h-full flex flex-col">
        <main class="flex-1 overflow-y-auto p-4">
            <!-- Renderizado de Dashboard, Creators, Settings -->
            
        </main>
    </div>
</div>
