<script>
	import { onMount } from 'svelte';
	// import SideBar from "./attributes/SideBar.svelte";
	import { isAuthenticated, user } from '../stores/auth';
	import { navigate } from 'svelte-routing';
	import Sidenav from './attributes/Sidenav.svelte';
	import Navbar from './attributes/Navbar.svelte';
	import ContentHome from './attributes/ContentHome.svelte';
	onMount(() => {
		console.log($user.id);
		
	});


	$effect.pre(() => {
		if ($isAuthenticated === false) {
			navigate('/');
		}
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
	<title>Home {$user.nombres}</title>
</svelte:head>

<main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-gray-200 min-h-screen transition-all main">
	<Sidenav />
	<Navbar />

	<ContentHome />
</main>
