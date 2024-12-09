<script>
	import { onMount } from 'svelte';
	// import SideBar from "./attributes/SideBar.svelte";
	import { isAuthenticated, user } from '../stores/auth';
	import { navigate } from 'svelte-routing';
	import Sidenav from './attributes/Sidenav.svelte';
	import Navbar from './attributes/Navbar.svelte';
	import { sidebarOpen } from '../stores/sidevar';
	import ContentSeeUser from './subpages/ContentSeeUser.svelte';
	onMount(() => {
		console.log($user.id);
		
	});

	$effect.pre(() => {
		if ($isAuthenticated === false) {
			navigate('/');
		}
	});

    let isSidebarOpen = $state();
	sidebarOpen.subscribe((value) => {
		isSidebarOpen = value;
	});
</script>

<svelte:head>
	<link rel="preconnect" href="https://fonts.bunny.net" />
	<link
		href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap"
		rel="stylesheet"
	/>
	<link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
	<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet" />
	<script src="https://cdn.tailwindcss.com"></script>
	<title>Usuarios</title>
</svelte:head>

{#if $user && $isAuthenticated}
<main 
    class="transition-all bg-gray-200 min-h-screen"
    class:ml-64={isSidebarOpen}
    class:ml-0={!isSidebarOpen}
>
	<Sidenav />
	<Navbar />

	<ContentSeeUser />
</main>
{/if}
