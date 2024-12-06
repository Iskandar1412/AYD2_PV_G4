<script>
	import { onMount } from "svelte";
	import SideBar from "./SideBar.svelte";
	import { isAuthenticated, user } from "../stores/auth";
	import { navigate, Route } from "svelte-routing";
    
    onMount(() => {
        console.log($user.id)
    })

    $effect.pre(() => {
        if($isAuthenticated) {
            
        } else {
            navigate('/')
        }
    })

</script>

<div class="h-screen w-full bg-white flex overflow-hidden">
    <SideBar  />

    <!-- Main Content -->
    <div class="w-full h-full flex flex-col">
        <main class="flex-1 overflow-y-auto p-4">
            <div class="w-full h-40 bg-gray-400 rounded-lg flex items-center justify-center">
                asdf
            </div>
            <Route path='/home/dashboard'></Route>
            <Route path='/home/settings'></Route>
            <Route path='/home/creators'></Route>
        </main>
    </div>
</div>
