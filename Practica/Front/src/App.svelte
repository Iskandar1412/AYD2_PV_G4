<script>
	import { Router, Route, Link, navigate } from "svelte-routing";
    import { isAuthenticated, getUser } from "./lib/stores/auth";
	import Login from "./lib/pages/Login.svelte";
	import Register from "./lib/pages/Register.svelte";

    let authenticated = false;
    isAuthenticated.subscribe(value => {
        authenticated = value
    });

    const protectedRoutes = () => {
        if(!isAuthenticated || !getUser()) {
            navigate('/');
        }
    };
</script>

<Router>

    <Route path='/' component={Login} />
    <!-- <Route path='/register' component={Register} /> -->
</Router>

