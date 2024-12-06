<script>
	import { Router, Route, navigate } from 'svelte-routing';
	import { onMount } from 'svelte';
	import Login from './lib/pages/Login.svelte';
	import Home from './lib/pages/Home.svelte';
	import Register from './lib/pages/Register.svelte';
	import { isAuthenticated } from './lib/stores/auth';

    onMount(() => {})    
    $effect.pre(() => {     
        if($isAuthenticated) {
            navigate('/home')
        } else {
            navigate('/')
        }
    })
</script>

<Router>
    <Route path="/" ><Login /></Route>
    <Route path="/register" ><Register /></Route>
    <Route path="/home" ><Home /></Route>
</Router>
