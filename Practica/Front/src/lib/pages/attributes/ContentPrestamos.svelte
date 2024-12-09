<script>
	import { user } from "../../stores/auth";
	import AdminPrestamo from "../subpages/AdminPrestamo.svelte";
	import UserPrestamo from "../subpages/UserPrestamo.svelte";

</script>

<!-- Content -->
<div class="p-6">
	{#if $user.rol === 'admin' || $user.rol === 'personal'}
		<AdminPrestamo />
	{:else if $user.rol === 'usuario'}
		<UserPrestamo />
	{/if}
</div>
<!-- End Content -->