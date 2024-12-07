<script>
	import { navigate } from 'svelte-routing';
	import { isAuthenticated } from '../../stores/auth';
	import Home from '../Home.svelte';
    export let component;

    if ($isAuthenticated === false) {
        navigate('/');
    }
</script>

{#if $isAuthenticated}
    <svelte:component this={component} />
{:else}
    { navigate('/') }
{/if}
