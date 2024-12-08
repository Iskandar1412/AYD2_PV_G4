<script>
	// import { Router, Route, navigate } from 'svelte-routing';
	import { navigate, Route, Router } from 'svelte-routing';
	import { onMount } from 'svelte';
	import Login from './lib/pages/Login.svelte';
	import Home from './lib/pages/Home.svelte';
	import Register from './lib/pages/Register.svelte';
	import { isAuthenticated } from './lib/stores/auth';
	import ProtectedRoute from './lib/pages/attributes/ProtectedRoute.svelte';
	import Servicio from './lib/pages/Servicio.svelte';
	import Prestamo from './lib/pages/Prestamo.svelte';
	import Saldo from './lib/pages/Saldo.svelte';
	import RetDep from './lib/pages/RetDep.svelte';
	import MostrarUsuarios from './lib/pages/MostrarUsuarios.svelte';
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
    <Route path="/home" >
        <ProtectedRoute component={Home} />
    </Route>
    <Route path="/allusers" >
        <ProtectedRoute component={MostrarUsuarios} />
    </Route>
    <Route path="/servicios" >
        <ProtectedRoute component={Servicio} />
    </Route>
    <Route path="/prestamos" >
        <ProtectedRoute component={Prestamo} />
    </Route>
    <Route path="/saldo" >
        <ProtectedRoute component={Saldo} />
    </Route>
    <Route path="/retirodeposito" >
        <ProtectedRoute component={RetDep} />
    </Route>
</Router>
