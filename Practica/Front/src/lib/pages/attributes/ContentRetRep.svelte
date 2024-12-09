<script>
	import { user } from "../../stores/auth";
	import AdminRetDep from "../subpages/AdminRetDep.svelte";
	import UserRetDep from "../subpages/UserRetDep.svelte";

</script>

<!-- Content -->
<div class="p-6">
	{#if $user.rol === 1 || $user.rol === 2}
		<AdminRetDep />
	{:else if $user.rol === 3}
		<UserRetDep />
	{/if}
</div>
<!-- End Content -->