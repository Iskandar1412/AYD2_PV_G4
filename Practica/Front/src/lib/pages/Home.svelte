<script>
	import { onMount } from "svelte";
	import SideBar from "./attributes/SideBar.svelte";
	import { isAuthenticated, user } from "../stores/auth";
	import { navigate } from "svelte-routing";

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
    <div class="w-full h-full flex flex-col">
        <main class="flex-1 overflow-y-auto p-4">
        
        </main>
    </div>
</div>
