<script>
    
</script>

<div class="bg-white border border-gray-100 shadow-md shadow-black/5 p-6 rounded-md lg:col-span-2">
	<div class="flex justify-between mb-4 items-start">
		<div class="font-medium">Estadísticas</div>
	</div>
	<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-4">
		<div class="rounded-md border border-dashed border-gray-200 p-4">
			<div class="flex items-center mb-0.5">
				<div class="text-xl font-semibold">Depositos</div>
			</div>
			<span
				class="p-1 rounded text-[16px] font-semibold bg-emerald-500/10 text-emerald-500 leading-none ml-1"
			>
				+$250
			</span>
		</div>
		<div class="rounded-md border border-dashed border-gray-200 p-4">
			<div class="flex items-center mb-0.5">
				<div class="text-xl font-semibold">Retiros</div>
			</div>
			<span
				class="p-1 rounded text-[16px] font-semibold bg-rose-500/10 text-rose-500 leading-none ml-1"
			>
				-$250
			</span>
		</div>
		<div class="rounded-md border border-dashed border-gray-200 p-4">
			<div class="flex items-center mb-0.5">
				<div class="text-xl font-semibold">Pago Servicios</div>
				<span
					class="p-1 rounded text-[12px] font-semibold bg-gray-500/10 text-gray-500 leading-none ml-1"
				>
					Cancelado
				</span>
			</div>
			<span
				class="p-1 rounded text-[16px] font-semibold bg-blue-500/10 text-blue-500 leading-none ml-1"
				>$0</span
			>
		</div>
	</div>
</div>
<div class="bg-white border border-gray-100 shadow-md shadow-black/5 p-6 rounded-md mt-8">
	<div class="flex justify-between mb-4 items-start">
		<div class="font-medium">Historial</div>
	</div>
	<div class="overflow-x-auto">
		<table class="w-full min-w-[460px]">
			<thead>
				<tr>
					<th
						class="text-[12px] uppercase tracking-wide font-medium text-gray-400 py-2 px-4 bg-gray-50 text-left rounded-tl-md rounded-bl-md"
						>Service</th
					>
					<th
						class="text-[12px] uppercase tracking-wide font-medium text-gray-400 py-2 px-4 bg-gray-50 text-left"
						>Total</th
					>
					<th
						class="text-[12px] uppercase tracking-wide font-medium text-gray-400 py-2 px-4 bg-gray-50 text-left rounded-tr-md rounded-br-md"
						>Saldo</th
					>
					<th
						class="text-[12px] uppercase tracking-wide font-medium text-gray-400 py-2 px-4 bg-gray-50 text-left rounded-tr-md rounded-br-md"
						>Fecha</th
					>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="py-2 px-4 border-b border-b-gray-50">
						<div class="flex items-center">
							<img
								src="https://placehold.co/32x32"
								alt=""
								class="w-8 h-8 rounded object-cover block"
							/>
							<div class="text-gray-600 text-sm font-medium hover:text-blue-500 ml-2 truncate">
								Deposito
							</div>
						</div>
					</td>
					<td class="py-2 px-4 border-b border-b-gray-50">
						<span class="text-[13px] font-medium text-emerald-500"> +$235 </span>
					</td>
					<td class="py-2 px-4 border-b border-b-gray-50">
						<span
							class="inline-block p-1 rounded bg-blue-500/10 text-blue-500 font-medium text-[12px] leading-none"
						>
							$125
						</span>
					</td>
					<td class="py-2 px-4 border-b border-b-gray-50">
						<span
							class="inline-block p-1 rounded bg-gray-500/10 text-gray-500 font-medium text-[12px] leading-none"
						>
							17/12/2023
						</span>
					</td>
				</tr>
				<tr>
					<td class="py-2 px-4 border-b border-b-gray-50">
						<div class="flex items-center">
							<img
								src="https://placehold.co/32x32"
								alt=""
								class="w-8 h-8 rounded object-cover block"
							/>
							<div class="text-gray-600 text-sm font-medium hover:text-blue-500 ml-2 truncate">
								Pago Luz
							</div>
						</div>
					</td>
					<td class="py-2 px-4 border-b border-b-gray-50">
						<span class="text-[13px] font-medium text-rose-500"> -$235 </span>
					</td>
					<td class="py-2 px-4 border-b border-b-gray-50">
						<span
							class="inline-block p-1 rounded bg-blue-500/10 text-blue-500 font-medium text-[12px] leading-none"
						>
							$125
						</span>
					</td>
					<td class="py-2 px-4 border-b border-b-gray-50">
						<span
							class="inline-block p-1 rounded bg-gray-500/10 text-gray-500 font-medium text-[12px] leading-none"
						>
							17/12/2023
						</span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
