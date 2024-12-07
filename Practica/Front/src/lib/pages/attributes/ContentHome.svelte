<script>
	import { user } from '../../stores/auth';
	import AdminDashboard from '../subpages/AdminDashboard.svelte';
	import UserDashboard from '../subpages/UserDashboard.svelte';
</script>

<!-- Content -->
<div class="p-6">
	{#if $user.rol === 1 || $user.rol === 2}
		<AdminDashboard />
	{:else if $user.rol === 3}
		<UserDashboard />
	{/if}
</div>
<!-- End Content -->
