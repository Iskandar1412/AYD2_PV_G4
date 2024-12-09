<script>
	import { user } from '../../stores/auth';
	import AdminDashboard from '../subpages/AdminDashboard.svelte';
	import UserDashboard from '../subpages/UserDashboard.svelte';
</script>

<!-- Content -->
<div class="p-6">
	{#if $user.rol === 'admin' || $user.rol === 'personal'}
		<AdminDashboard />
	{:else if $user.rol === 'usuario'}
		<UserDashboard />
	{/if}
</div>
<!-- End Content -->
