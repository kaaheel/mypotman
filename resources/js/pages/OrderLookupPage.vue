<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import BrandIcon from '../components/BrandIcon.vue';

const router = useRouter();

const orderNumber = ref('');
const email = ref('');
const isLoading = ref(false);
const error = ref('');

async function handleLookup() {
    error.value = '';

    if (!orderNumber.value.trim() || !email.value.trim()) {
        error.value = 'Please provide both your order reference and email address.';
        return;
    }

    isLoading.value = true;

    try {
        const response = await fetch('/api/orders/lookup', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
            },
            body: JSON.stringify({
                order_number: orderNumber.value.trim(),
                email: email.value.trim(),
            }),
        });

        const data = await response.json();

        if (!response.ok || !data.success) {
            throw new Error(data.message || 'No matching order found. Please check your reference number.');
        }

        // Navigate directly to the verified order confirmation/receipt page
        router.push({
            name: 'order-confirmation',
            params: { orderRef: data.order.order_number },
        });
    } catch (err) {
        error.value = err.message || 'Failed to locate order.';
    } finally {
        isLoading.value = false;
    }
}
</script>

<template>
    <div class="bg-pm-ivory min-h-screen py-12 lg:py-20 flex items-center justify-center">
        <div class="max-w-md w-full mx-auto px-6">
            <div class="bg-white border border-pm-ink/10 rounded-3xl p-8 sm:p-10 shadow-sm text-center">
                <div class="w-14 h-14 bg-pm-sand/20 text-pm-ink rounded-full flex items-center justify-center mx-auto mb-5">
                    <BrandIcon name="truck" :size="24" />
                </div>

                <h1 class="font-display text-2xl font-bold text-pm-ink mb-2">Track Your Vessel</h1>
                <p class="text-xs text-pm-ink-muted mb-8 leading-relaxed">
                    Enter your order reference and purchase email to inspect timber crating progress, logistics waybill, and estimated dispatch.
                </p>

                <div v-if="error" class="mb-5 p-3.5 bg-red-50 border border-red-200 text-red-800 rounded-xl text-xs flex items-center space-x-2 text-left">
                    <BrandIcon name="close" :size="14" className="shrink-0" />
                    <span>{{ error }}</span>
                </div>

                <form @submit.prevent="handleLookup" class="space-y-4 text-left">
                    <div>
                        <label class="block text-xs font-semibold uppercase tracking-wider text-pm-ink mb-1.5">
                            Order Reference
                        </label>
                        <input 
                            v-model="orderNumber"
                            type="text" 
                            placeholder="e.g. PM-MPMX-723" 
                            class="w-full bg-[#FAF9F5] border border-pm-ink/15 rounded-xl px-4 py-3 text-sm uppercase font-mono tracking-wider focus:outline-none focus:ring-1 focus:ring-pm-ink focus:bg-white transition-all"
                            required
                        />
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase tracking-wider text-pm-ink mb-1.5">
                            Email Address
                        </label>
                        <input 
                            v-model="email"
                            type="email" 
                            placeholder="e.g. folashade@example.com" 
                            class="w-full bg-[#FAF9F5] border border-pm-ink/15 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-1 focus:ring-pm-ink focus:bg-white transition-all"
                            required
                        />
                    </div>

                    <button 
                        type="submit"
                        :disabled="isLoading"
                        class="w-full bg-pm-ink hover:bg-pm-clay text-white py-3.5 px-6 rounded-xl font-bold uppercase tracking-[0.14em] text-xs transition-all shadow-md active:scale-[0.99] disabled:opacity-50 mt-2"
                    >
                        {{ isLoading ? 'Locating Vessel...' : 'Track Order Progress' }}
                    </button>
                </form>

                <div class="mt-8 pt-6 border-t border-pm-ink/10 text-center">
                    <router-link to="/" class="text-xs text-pm-ink-muted hover:text-pm-ink font-medium">
                        ← Return to Collection
                    </router-link>
                </div>
            </div>
        </div>
    </div>
</template>

