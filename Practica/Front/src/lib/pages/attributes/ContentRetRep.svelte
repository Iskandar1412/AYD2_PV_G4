<script>
	import { user } from "../../stores/auth";
	import AdminRetDep from "../subpages/AdminRetDep.svelte";
	import UserRetDep from "../subpages/UserRetDep.svelte";

</script>

<!-- Content -->
<div class="p-6">
	{#if $user.rol === 'admin' || $user.rol === 'personal'}
		<AdminRetDep />
	{:else if $user.rol === 'usuario'}
		<UserRetDep />
	{/if}
</div>
<!-- End Content -->