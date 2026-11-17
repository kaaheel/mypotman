<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { cartStore } from '../stores/cart';
import BrandIcon from '../components/BrandIcon.vue';

const route = useRoute();
const router = useRouter();

const orderRef = route.params.orderRef;
const order = ref(null);
const timeline = ref([]);
const isLoading = ref(true);
const error = ref('');
const isCopied = ref(false);

async function fetchOrder() {
    isLoading.value = true;
    error.value = '';

    try {
        const [orderRes, timelineRes] = await Promise.all([
            fetch(`/api/orders/${orderRef}`, { headers: { 'Accept': 'application/json' } }),
            fetch(`/api/orders/${orderRef}/timeline`, { headers: { 'Accept': 'application/json' } })
        ]);

        const orderData = await orderRes.json();
        if (!orderRes.ok || !orderData.success) {
            throw new Error(orderData.message || 'Order could not be located.');
        }

        order.value = orderData.order;

        if (timelineRes.ok) {
            const timelineData = await timelineRes.json();
            if (timelineData.success) {
                timeline.value = timelineData.timeline;
            }
        }
    } catch (err) {
        console.error('Fetch order error:', err);
        error.value = err.message || 'Failed to load order details.';
    } finally {
        isLoading.value = false;
    }
}

function copyOrderRef() {
    if (!order.value?.order_number) return;
    navigator.clipboard.writeText(order.value.order_number);
    isCopied.value = true;
    setTimeout(() => {
        isCopied.value = false;
    }, 2000);
}

function printReceipt() {
    window.print();
}

onMounted(() => {
    fetchOrder();
});
</script>

<template>
    <div class="bg-pm-ivory min-h-screen py-12 lg:py-20">
        <div class="max-w-4xl mx-auto px-6 lg:px-8">
            <!-- Loading State -->
            <div v-if="isLoading" class="py-24 text-center">
                <div class="w-12 h-12 border-3 border-pm-ink/20 border-t-pm-ink rounded-full animate-spin mx-auto mb-4"></div>
                <p class="font-display text-sm font-bold text-pm-ink uppercase tracking-wider">Retrieving Order Details...</p>
            </div>

            <!-- Error State -->
            <div v-else-if="error" class="bg-white border border-red-200 rounded-3xl p-8 text-center max-w-lg mx-auto shadow-sm">
                <div class="w-12 h-12 bg-red-100 text-red-600 rounded-full flex items-center justify-center mx-auto mb-4">
                    <BrandIcon name="close" :size="20" />
                </div>
                <h2 class="font-display text-xl font-bold text-pm-ink mb-2">Order Not Found</h2>
                <p class="text-xs text-pm-ink-muted mb-6">{{ error }}</p>
                <router-link to="/" class="inline-block bg-pm-ink text-white px-6 py-3 rounded-xl text-xs font-bold uppercase tracking-wider">
                    Return to Collection
                </router-link>
            </div>

            <!-- Order Confirmation Details -->
            <div v-else class="space-y-8">
                <!-- Hero Badge -->
                <div class="text-center space-y-3">
                    <div class="w-16 h-16 bg-emerald-50 text-emerald-700 border border-emerald-200 rounded-full flex items-center justify-center mx-auto shadow-sm">
                        <BrandIcon name="check" :size="28" />
                    </div>
                    <span class="inline-block text-[11px] font-bold uppercase tracking-[0.2em] text-emerald-800">
                        Payment & Order Authorized
                    </span>
                    <h1 class="font-display text-3xl sm:text-4xl font-bold text-pm-ink">
                        Thank You, {{ order.customer_name ? order.customer_name.split(' ')[0] : 'Valued Collector' }}
                    </h1>
                    <p class="text-sm text-pm-ink-muted max-w-md mx-auto">
                        Your architectural vessels have entered our studio workshop queue. An official invoice has been dispatched to <strong>{{ order.customer_email }}</strong>.
                    </p>
                </div>

                <!-- Order Reference Bar -->
                <div class="bg-white border border-pm-ink/10 rounded-2xl p-5 sm:p-6 shadow-sm flex flex-col sm:flex-row items-center justify-between gap-4">
                    <div>
                        <span class="block text-[11px] uppercase tracking-wider text-pm-ink-muted font-bold">Order Reference</span>
                        <div class="flex items-center space-x-2 mt-1">
                            <span class="font-display text-xl font-bold text-pm-ink tracking-tight">{{ order.order_number }}</span>
                            <button 
                                @click="copyOrderRef"
                                class="text-xs text-pm-clay hover:text-pm-ink font-medium px-2 py-0.5 rounded bg-pm-sand/20 transition-colors"
                            >
                                {{ isCopied ? 'Copied!' : 'Copy' }}
                            </button>
                        </div>
                    </div>

                    <div v-if="order.tracking_waybill" class="text-left sm:text-right">
                        <span class="block text-[11px] uppercase tracking-wider text-pm-ink-muted font-bold">Logistics Waybill</span>
                        <span class="font-mono text-sm font-bold text-pm-ink tracking-wider">{{ order.tracking_waybill }}</span>
                    </div>

                    <div class="flex items-center space-x-3">
                        <button 
                            @click="printReceipt"
                            class="inline-flex items-center space-x-1.5 text-xs font-bold uppercase tracking-wider border border-pm-ink/20 hover:bg-pm-ink hover:text-white px-4 py-2.5 rounded-xl transition-all"
                        >
                            <BrandIcon name="file" :size="14" />
                            <span>Print Receipt</span>
                        </button>
                        <router-link 
                            to="/"
                            class="inline-flex items-center space-x-1.5 text-xs font-bold uppercase tracking-wider bg-pm-ink hover:bg-pm-clay text-white px-5 py-2.5 rounded-xl transition-all shadow-sm"
                        >
                            <span>Back to Store</span>
                        </router-link>
                    </div>
                </div>

                <!-- Fulfillment Progress Pipeline (OMS Engine) -->
                <div class="bg-white border border-pm-ink/10 rounded-2xl p-6 sm:p-8 shadow-sm">
                    <div class="flex items-center justify-between mb-6">
                        <h2 class="text-xs font-bold uppercase tracking-[0.14em] text-pm-ink">Fulfillment & Crating Pipeline</h2>
                        <span class="text-xs font-medium text-pm-clay">{{ order.shipping_zone }}</span>
                    </div>

                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-center">
                        <div 
                            v-for="(step, idx) in timeline" 
                            :key="idx"
                            :class="[
                                'p-3.5 rounded-xl border transition-all text-left flex flex-col justify-between',
                                step.completed 
                                    ? 'bg-emerald-50 border-emerald-200' 
                                    : 'bg-[#FAF9F5] border-pm-ink/10 opacity-70'
                            ]"
                        >
                            <div>
                                <span 
                                    :class="[
                                        'block text-[10px] font-bold uppercase tracking-wider',
                                        step.completed ? 'text-emerald-800' : 'text-pm-ink-muted'
                                    ]"
                                >
                                    Step {{ idx + 1 }}
                                </span>
                                <span class="block text-xs font-bold text-pm-ink mt-1">{{ step.title }}</span>
                                <span class="block text-[10px] text-pm-ink-muted mt-1 leading-normal">{{ step.description }}</span>
                            </div>
                            <span 
                                :class="[
                                    'block text-[10px] font-semibold mt-3 pt-2 border-t',
                                    step.completed ? 'text-emerald-700 border-emerald-200' : 'text-pm-ink-muted border-pm-ink/10'
                                ]"
                            >
                                {{ step.timestamp }}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Items & Cost Breakdown -->
                <div class="bg-white border border-pm-ink/10 rounded-2xl p-6 sm:p-8 shadow-sm">
                    <h2 class="text-xs font-bold uppercase tracking-[0.14em] text-pm-ink mb-4 pb-2 border-b border-pm-ink/10">
                        Vessels & Items
                    </h2>

                    <div class="divide-y divide-pm-ink/10">
                        <div 
                            v-for="item in order.items" 
                            :key="item.id"
                            class="py-4 first:pt-0 flex items-center gap-4"
                        >
                            <div class="w-16 h-20 rounded-xl bg-[#FAF9F5] border border-pm-ink/10 overflow-hidden shrink-0">
                                <img :src="item.image_url" :alt="item.product_name" class="w-full h-full object-cover" />
                            </div>

                            <div class="flex-1 min-w-0">
                                <h3 class="text-sm font-bold text-pm-ink">{{ item.product_name }}</h3>
                                <div class="text-xs text-pm-ink-muted space-x-2 mt-0.5 font-body">
                                    <span>Finish: <strong class="text-pm-ink font-semibold">{{ item.finish }}</strong></span>
                                    <span>·</span>
                                    <span>Size: <strong class="text-pm-ink font-semibold">{{ item.size }}</strong></span>
                                </div>
                                <div class="text-xs text-pm-ink-muted mt-0.5">
                                    <span>Placement: {{ item.drainage }}</span>
                                </div>
                            </div>

                            <div class="text-right shrink-0">
                                <span class="block text-xs text-pm-ink-muted tabular-nums">Qty: {{ item.quantity }}</span>
                                <span class="block text-sm font-bold text-pm-ink tabular-nums mt-0.5">
                                    {{ cartStore.formatNaira(item.total_price) }}
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Totals with Discount -->
                    <div class="mt-6 pt-4 border-t border-pm-ink/10 space-y-2 text-xs">
                        <div class="flex justify-between text-pm-ink-muted">
                            <span>Subtotal</span>
                            <span class="text-pm-ink font-semibold tabular-nums">{{ cartStore.formatNaira(order.subtotal) }}</span>
                        </div>
                        <div v-if="Number(order.discount_amount) > 0" class="flex justify-between text-emerald-700 font-medium">
                            <span>Promotional Discount ({{ order.coupon_code }})</span>
                            <span class="tabular-nums">- {{ cartStore.formatNaira(order.discount_amount) }}</span>
                        </div>
                        <div class="flex justify-between text-pm-ink-muted">
                            <span>Shipping & Crating ({{ order.shipping_state }})</span>
                            <span class="font-semibold tabular-nums">
                                {{ Number(order.shipping_fee) === 0 ? 'FREE' : cartStore.formatNaira(order.shipping_fee) }}
                            </span>
                        </div>
                        <div class="pt-3 border-t border-pm-ink/10 flex justify-between text-base font-bold text-pm-ink">
                            <span class="font-display">Total Paid</span>
                            <span class="text-lg tabular-nums">{{ cartStore.formatNaira(order.total_amount) }}</span>
                        </div>
                    </div>
                </div>

                <!-- Destination & Contact Summary -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="bg-white border border-pm-ink/10 rounded-2xl p-6 shadow-sm">
                        <h2 class="text-xs font-bold uppercase tracking-[0.14em] text-pm-ink mb-3">Delivery Destination</h2>
                        <div class="text-xs text-pm-ink-muted space-y-1 font-body">
                            <p class="font-bold text-pm-ink">{{ order.customer_name }}</p>
                            <p>{{ order.shipping_address }}</p>
                            <p>{{ order.shipping_city }}, {{ order.shipping_state }}</p>
                            <p v-if="order.shipping_notes" class="mt-2 text-pm-clay">
                                Note: {{ order.shipping_notes }}
                            </p>
                        </div>
                    </div>

                    <div class="bg-white border border-pm-ink/10 rounded-2xl p-6 shadow-sm">
                        <h2 class="text-xs font-bold uppercase tracking-[0.14em] text-pm-ink mb-3">Customer Profile & Audit</h2>
                        <div class="text-xs text-pm-ink-muted space-y-1 font-body">
                            <p>Email: <strong class="text-pm-ink font-semibold">{{ order.customer_email }}</strong></p>
                            <p>Phone: <strong class="text-pm-ink font-semibold">{{ order.customer_phone }}</strong></p>
                            <p>Payment: <strong class="text-pm-ink font-semibold uppercase">{{ order.payment_method }} ({{ order.payment_status }})</strong></p>
                            <p>Reference: <span class="font-mono text-[11px]">{{ order.payment_reference }}</span></p>
                            <p v-if="order.customer" class="pt-2 text-emerald-700">
                                Total Collector Orders: <strong>{{ order.customer.total_orders }}</strong>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
