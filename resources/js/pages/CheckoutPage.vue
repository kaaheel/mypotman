<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { cartStore, cartState } from '../stores/cart';
import BrandIcon from '../components/BrandIcon.vue';

const router = useRouter();

// Idempotency key generated per checkout session
const idempotencyKey = ref('');

onMounted(() => {
    if (typeof crypto !== 'undefined' && crypto.randomUUID) {
        idempotencyKey.value = 'pm_idem_' + crypto.randomUUID();
    } else {
        idempotencyKey.value = 'pm_idem_' + Date.now() + '_' + Math.random().toString(36).substring(2, 9);
    }
    fetchShippingQuote();
});

const nigerianStates = [
    'Lagos', 'Abuja (FCT)', 'Abia', 'Adamawa', 'Akwa Ibom', 'Anambra', 'Bauchi',
    'Bayelsa', 'Benue', 'Borno', 'Cross River', 'Delta', 'Ebonyi', 'Edo',
    'Ekiti', 'Enugu', 'Gombe', 'Imo', 'Jigawa', 'Kaduna', 'Kano',
    'Katsina', 'Kebbi', 'Kogi', 'Kwara', 'Nasarawa', 'Niger', 'Ogun',
    'Ondo', 'Osun', 'Oyo', 'Plateau', 'Rivers', 'Sokoto', 'Taraba',
    'Yobe', 'Zamfara'
];

const form = ref({
    customer_name: '',
    customer_email: '',
    customer_phone: '',
    shipping_address: '',
    shipping_city: 'Lagos',
    shipping_state: 'Lagos',
    shipping_notes: '',
    payment_method: 'paystack',
});

// Shipping Engine State
const shippingDetails = ref({
    zone: 'Zone 1 (Lagos Metro)',
    rate: 8500,
    is_free: false,
    packaging: 'Dedicated White-Glove Fragile Cargo Van',
    estimated_days: '24 to 48 hours',
});

// Coupon & Pricing Engine State
const couponInput = ref('');
const appliedCoupon = ref(null);
const discountAmount = ref(0);
const couponMessage = ref('');
const couponError = ref('');
const isApplyingCoupon = ref(false);

const isSubmitting = ref(false);
const errorMessage = ref('');

// Dynamic Shipping Engine Quote via API
async function fetchShippingQuote() {
    if (cartState.items.length === 0) return;
    try {
        const response = await fetch('/api/shipping/quote', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
            },
            body: JSON.stringify({
                state: form.value.shipping_state,
                subtotal: cartStore.subtotal.value,
            }),
        });
        const data = await response.json();
        if (data.success) {
            shippingDetails.value = data;
        }
    } catch (e) {
        console.error('Shipping quote fetch error:', e);
    }
}

watch(() => form.value.shipping_state, () => {
    fetchShippingQuote();
});

watch(() => cartStore.subtotal.value, () => {
    fetchShippingQuote();
});

// Coupon Validation Engine
async function applyCoupon() {
    couponError.value = '';
    couponMessage.value = '';

    if (!couponInput.value.trim()) {
        couponError.value = 'Please enter a voucher code.';
        return;
    }

    isApplyingCoupon.value = true;

    try {
        const response = await fetch('/api/checkout/coupon/validate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
            },
            body: JSON.stringify({
                code: couponInput.value.trim(),
                subtotal: cartStore.subtotal.value,
            }),
        });

        const data = await response.json();

        if (!response.ok || !data.success) {
            couponError.value = data.message || 'Invalid promotional code.';
            appliedCoupon.value = null;
            discountAmount.value = 0;
        } else {
            appliedCoupon.value = data.code;
            discountAmount.value = data.discount_amount;
            couponMessage.value = data.message;
        }
    } catch (err) {
        couponError.value = 'Unable to validate code at this time.';
    } finally {
        isApplyingCoupon.value = false;
    }
}

function removeCoupon() {
    appliedCoupon.value = null;
    discountAmount.value = 0;
    couponInput.value = '';
    couponMessage.value = '';
    couponError.value = '';
}

const orderTotal = computed(() => {
    const sub = Number(cartStore.subtotal.value) || 0;
    const disc = Number(discountAmount.value) || 0;
    const netSubtotal = Math.max(0, sub - disc);
    const ship = Number(shippingDetails.value?.rate) || 0;
    return netSubtotal + ship;
});

async function handleCompleteOrder() {
    errorMessage.value = '';

    if (cartState.items.length === 0) {
        errorMessage.value = 'Your shopping bag is empty.';
        return;
    }

    if (!form.value.customer_name || !form.value.customer_email || !form.value.customer_phone || !form.value.shipping_address) {
        errorMessage.value = 'Please fill in all required shipping and contact fields.';
        return;
    }

    isSubmitting.value = true;

    try {
        const payload = {
            idempotency_key: idempotencyKey.value,
            customer_name: form.value.customer_name,
            customer_email: form.value.customer_email,
            customer_phone: form.value.customer_phone,
            shipping_address: form.value.shipping_address,
            shipping_city: form.value.shipping_city,
            shipping_state: form.value.shipping_state,
            shipping_notes: form.value.shipping_notes,
            coupon_code: appliedCoupon.value,
            payment_method: form.value.payment_method,
            items: cartState.items.map(item => ({
                product_id: item.productId,
                product_name: item.name,
                finish: item.finish,
                drainage: item.drainage,
                size: item.size,
                quantity: item.quantity,
            })),
        };

        const response = await fetch('/api/checkout/order', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-Idempotency-Key': idempotencyKey.value,
            },
            body: JSON.stringify(payload),
        });

        const data = await response.json();

        if (!response.ok || !data.success) {
            throw new Error(data.message || 'Failed to place order. Please try again.');
        }

        // Successfully placed order
        const createdOrder = data.order;
        cartStore.clearCart();

        // Redirect to full-page order confirmation
        router.push({
            name: 'order-confirmation',
            params: { orderRef: createdOrder.order_number },
        });
    } catch (err) {
        console.error('Checkout error:', err);
        errorMessage.value = err.message || 'An unexpected error occurred while placing your order.';
    } finally {
        isSubmitting.value = false;
    }
}
</script>

<template>
    <div class="bg-pm-ivory min-h-screen py-10 lg:py-16">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Breadcrumbs / Top Navigation -->
            <div class="flex items-center justify-between mb-8 pb-4 border-b border-pm-ink/10">
                <router-link to="/" class="inline-flex items-center text-xs font-semibold uppercase tracking-wider text-pm-ink hover:text-pm-clay transition-colors space-x-1.5">
                    <BrandIcon name="arrow-left" :size="14" />
                    <span>Return to Store</span>
                </router-link>

                <div class="flex items-center space-x-2 text-xs text-pm-ink-muted">
                    <BrandIcon name="shield" :size="15" className="text-emerald-700" />
                    <span>256-Bit Encrypted Commerce Engine</span>
                </div>
            </div>

            <!-- Empty State Warning if no items in bag -->
            <div v-if="cartState.items.length === 0" class="max-w-xl mx-auto py-16 text-center bg-[#FAF9F5] border border-pm-ink/10 rounded-3xl p-8">
                <div class="w-14 h-14 mx-auto mb-4 rounded-full bg-pm-sand/20 flex items-center justify-center text-pm-ink">
                    <BrandIcon name="bag" :size="24" />
                </div>
                <h2 class="font-display text-2xl font-bold text-pm-ink mb-2">Your Bag is Empty</h2>
                <p class="text-sm text-pm-ink-muted mb-6">Explore our curated collection of architectural planters to begin your order.</p>
                <router-link 
                    to="/#shop"
                    class="inline-block bg-pm-ink hover:bg-pm-clay text-white text-xs uppercase tracking-widest font-bold py-3.5 px-8 rounded-xl transition-all shadow-md"
                >
                    Explore Collection
                </router-link>
            </div>

            <!-- Full Checkout Grid (2-Column Architecture) -->
            <div v-else class="grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-14">
                <!-- Left: Shipping & Payment Information (Cols 1-7) -->
                <div class="lg:col-span-7 space-y-8">
                    <!-- Error Banner -->
                    <div v-if="errorMessage" class="p-4 bg-red-50 border border-red-200 text-red-800 rounded-xl text-xs flex items-center space-x-2">
                        <BrandIcon name="close" :size="14" className="shrink-0" />
                        <span>{{ errorMessage }}</span>
                    </div>

                    <!-- Step 1: Customer Details -->
                    <div class="bg-white border border-pm-ink/10 rounded-2xl p-6 sm:p-8 shadow-sm">
                        <div class="flex items-center space-x-3 mb-6">
                            <span class="w-7 h-7 rounded-full bg-pm-ink text-white text-xs font-bold flex items-center justify-center">1</span>
                            <h2 class="font-display text-lg font-bold text-pm-ink">Customer & Contact</h2>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div class="sm:col-span-2">
                                <label class="block text-xs font-semibold uppercase tracking-wider text-pm-ink mb-1.5">
                                    Full Name <span class="text-pm-clay">*</span>
                                </label>
                                <input 
                                    v-model="form.customer_name"
                                    type="text" 
                                    placeholder="e.g. Adeola Daniels" 
                                    class="w-full bg-[#FAF9F5] border border-pm-ink/15 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-1 focus:ring-pm-ink focus:bg-white transition-all"
                                    required
                                />
                            </div>

                            <div>
                                <label class="block text-xs font-semibold uppercase tracking-wider text-pm-ink mb-1.5">
                                    Email Address (Receipt & Waybill) <span class="text-pm-clay">*</span>
                                </label>
                                <input 
                                    v-model="form.customer_email"
                                    type="email" 
                                    placeholder="adeola@example.com" 
                                    class="w-full bg-[#FAF9F5] border border-pm-ink/15 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-1 focus:ring-pm-ink focus:bg-white transition-all"
                                    required
                                />
                            </div>

                            <div>
                                <label class="block text-xs font-semibold uppercase tracking-wider text-pm-ink mb-1.5">
                                    Phone Number (Courier Dispatch) <span class="text-pm-clay">*</span>
                                </label>
                                <input 
                                    v-model="form.customer_phone"
                                    type="tel" 
                                    placeholder="+234 803 123 4567" 
                                    class="w-full bg-[#FAF9F5] border border-pm-ink/15 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-1 focus:ring-pm-ink focus:bg-white transition-all"
                                    required
                                />
                            </div>
                        </div>
                    </div>

                    <!-- Step 2: Shipping Destination -->
                    <div class="bg-white border border-pm-ink/10 rounded-2xl p-6 sm:p-8 shadow-sm">
                        <div class="flex items-center space-x-3 mb-6">
                            <span class="w-7 h-7 rounded-full bg-pm-ink text-white text-xs font-bold flex items-center justify-center">2</span>
                            <h2 class="font-display text-lg font-bold text-pm-ink">Delivery Destination (Nigeria)</h2>
                        </div>

                        <div class="space-y-4">
                            <div>
                                <label class="block text-xs font-semibold uppercase tracking-wider text-pm-ink mb-1.5">
                                    Street Address / Apartment <span class="text-pm-clay">*</span>
                                </label>
                                <textarea 
                                    v-model="form.shipping_address"
                                    rows="2" 
                                    placeholder="House number, street name, estate or building name" 
                                    class="w-full bg-[#FAF9F5] border border-pm-ink/15 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-1 focus:ring-pm-ink focus:bg-white transition-all resize-none"
                                    required
                                ></textarea>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-xs font-semibold uppercase tracking-wider text-pm-ink mb-1.5">
                                        City / Area <span class="text-pm-clay">*</span>
                                    </label>
                                    <input 
                                        v-model="form.shipping_city"
                                        type="text" 
                                        placeholder="e.g. Ikoyi, Victoria Island, Ikeja" 
                                        class="w-full bg-[#FAF9F5] border border-pm-ink/15 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-1 focus:ring-pm-ink focus:bg-white transition-all"
                                        required
                                    />
                                </div>

                                <div>
                                    <label class="block text-xs font-semibold uppercase tracking-wider text-pm-ink mb-1.5">
                                        State (36 States + FCT) <span class="text-pm-clay">*</span>
                                    </label>
                                    <select 
                                        v-model="form.shipping_state"
                                        class="w-full bg-[#FAF9F5] border border-pm-ink/15 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-1 focus:ring-pm-ink focus:bg-white transition-all"
                                    >
                                        <option v-for="state in nigerianStates" :key="state" :value="state">
                                            {{ state }}
                                        </option>
                                    </select>
                                </div>
                            </div>

                            <div>
                                <label class="block text-xs font-semibold uppercase tracking-wider text-pm-ink mb-1.5">
                                    Delivery Instructions (Optional)
                                </label>
                                <input 
                                    v-model="form.shipping_notes"
                                    type="text" 
                                    placeholder="e.g. Call security on arrival, estate gate code 4022" 
                                    class="w-full bg-[#FAF9F5] border border-pm-ink/15 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-1 focus:ring-pm-ink focus:bg-white transition-all"
                                />
                            </div>

                            <!-- Live Logistics Engine Feedback -->
                            <div class="mt-2 p-4 bg-[#FAF9F5] border border-pm-ink/10 rounded-xl text-xs text-pm-ink space-y-1">
                                <div class="flex items-center justify-between font-bold">
                                    <div class="flex items-center space-x-2">
                                        <BrandIcon name="truck" :size="16" className="text-pm-clay shrink-0" />
                                        <span>{{ shippingDetails.zone }}</span>
                                    </div>
                                    <span class="tabular-nums">
                                        {{ shippingDetails.rate === 0 ? 'FREE' : cartStore.formatNaira(shippingDetails.rate) }}
                                    </span>
                                </div>
                                <p class="text-pm-ink-muted text-[11px] font-body">
                                    Packaging: {{ shippingDetails.packaging }} · Estimated: {{ shippingDetails.estimated_days }}
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Step 3: Payment Method -->
                    <div class="bg-white border border-pm-ink/10 rounded-2xl p-6 sm:p-8 shadow-sm">
                        <div class="flex items-center space-x-3 mb-6">
                            <span class="w-7 h-7 rounded-full bg-pm-ink text-white text-xs font-bold flex items-center justify-center">3</span>
                            <h2 class="font-display text-lg font-bold text-pm-ink">Payment Gateway (Paystack)</h2>
                        </div>

                        <div class="space-y-3">
                            <label class="flex items-center justify-between p-4 rounded-xl border border-pm-ink bg-[#FAF9F5] cursor-pointer">
                                <div class="flex items-center space-x-3">
                                    <input type="radio" v-model="form.payment_method" value="paystack" class="text-pm-ink" />
                                    <div>
                                        <span class="block text-xs font-bold text-pm-ink">Paystack Instant Authorization</span>
                                        <span class="block text-[11px] text-pm-ink-muted">Debit/Credit Card, Bank Transfer, USSD, Apple Pay</span>
                                    </div>
                                </div>
                                <span class="text-[10px] font-bold uppercase tracking-wider text-emerald-700 bg-emerald-50 px-2.5 py-1 rounded-md border border-emerald-200">
                                    HMAC Verified
                                </span>
                            </label>

                            <label class="flex items-center justify-between p-4 rounded-xl border border-pm-ink/10 hover:border-pm-ink/30 bg-white cursor-pointer transition-colors">
                                <div class="flex items-center space-x-3">
                                    <input type="radio" v-model="form.payment_method" value="direct_transfer" class="text-pm-ink" />
                                    <div>
                                        <span class="block text-xs font-bold text-pm-ink">Studio Wire Transfer / Proforma Invoice</span>
                                        <span class="block text-[11px] text-pm-ink-muted">Official proforma invoice issued upon order confirmation</span>
                                    </div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Place Order Button -->
                    <button 
                        @click="handleCompleteOrder"
                        :disabled="isSubmitting"
                        class="w-full bg-pm-ink hover:bg-pm-clay text-white py-4 px-8 rounded-2xl font-bold uppercase tracking-[0.16em] text-xs transition-all shadow-lg flex items-center justify-center space-x-2 active:scale-[0.99] disabled:opacity-50"
                    >
                        <BrandIcon v-if="!isSubmitting" name="lock" :size="15" />
                        <span>{{ isSubmitting ? 'Securing & Authorizing Order...' : 'Confirm & Authorize Order' }}</span>
                        <span class="tabular-nums" v-if="!isSubmitting">· {{ cartStore.formatNaira(orderTotal) }}</span>
                    </button>
                </div>

                <!-- Right: Order Summary Sidebar (Cols 8-12) -->
                <div class="lg:col-span-5">
                    <div class="bg-white border border-pm-ink/10 rounded-2xl p-6 sm:p-8 shadow-sm sticky top-28 space-y-6">
                        <div class="flex items-center justify-between border-b border-pm-ink/10 pb-4">
                            <h3 class="font-display text-base font-bold text-pm-ink">Order Summary</h3>
                            <span class="text-xs text-pm-ink-muted tabular-nums">({{ cartStore.totalCount.value }} vessels)</span>
                        </div>

                        <!-- Items List -->
                        <div class="space-y-4 max-h-72 overflow-y-auto pr-1 divide-y divide-pm-ink/5">
                            <div 
                                v-for="item in cartState.items" 
                                :key="item.cartId" 
                                class="pt-3 first:pt-0 flex items-center gap-3.5"
                            >
                                <div class="w-14 h-16 rounded-lg bg-[#FAF9F5] border border-pm-ink/10 overflow-hidden shrink-0">
                                    <img :src="item.image" :alt="item.name" class="w-full h-full object-cover" />
                                </div>
                                <div class="flex-1 min-w-0">
                                    <h4 class="text-xs font-bold text-pm-ink truncate">{{ item.name }}</h4>
                                    <div class="text-[11px] text-pm-ink-muted space-x-1.5 mt-0.5 font-body">
                                        <span>{{ item.finish }}</span>
                                        <span>·</span>
                                        <span>{{ item.size }}</span>
                                    </div>
                                    <div class="text-[11px] text-pm-ink-muted mt-0.5">
                                        Qty: <strong class="text-pm-ink font-semibold">{{ item.quantity }}</strong>
                                    </div>
                                </div>
                                <div class="text-right shrink-0">
                                    <span class="text-xs font-bold text-pm-ink tabular-nums">
                                        {{ cartStore.formatNaira(item.price * item.quantity) }}
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- 2. Promotions & Voucher Engine Input -->
                        <div class="border-t border-pm-ink/10 pt-4">
                            <label class="block text-xs font-semibold uppercase tracking-wider text-pm-ink mb-2">
                                Promotional Voucher
                            </label>
                            <div v-if="!appliedCoupon" class="flex gap-2">
                                <input 
                                    v-model="couponInput"
                                    type="text" 
                                    placeholder="e.g. POTMAN10 or WELCOME5K" 
                                    class="flex-1 bg-[#FAF9F5] border border-pm-ink/15 rounded-xl px-3 py-2 text-xs uppercase font-mono tracking-wider focus:outline-none focus:ring-1 focus:ring-pm-ink"
                                    @keyup.enter="applyCoupon"
                                />
                                <button 
                                    @click="applyCoupon"
                                    :disabled="isApplyingCoupon"
                                    class="bg-pm-ink hover:bg-pm-clay text-white px-4 py-2 rounded-xl text-xs font-bold uppercase tracking-wider transition-colors disabled:opacity-50"
                                >
                                    {{ isApplyingCoupon ? '...' : 'Apply' }}
                                </button>
                            </div>
                            <div v-else class="flex items-center justify-between p-2.5 bg-emerald-50 border border-emerald-200 rounded-xl text-xs text-emerald-900">
                                <div class="flex items-center space-x-2">
                                    <BrandIcon name="check" :size="14" className="text-emerald-700" />
                                    <span>Code <strong>{{ appliedCoupon }}</strong> applied</span>
                                </div>
                                <button @click="removeCoupon" class="text-red-600 hover:text-red-800 text-[11px] underline font-medium">
                                    Remove
                                </button>
                            </div>

                            <p v-if="couponMessage" class="text-xs text-emerald-700 mt-1.5 font-medium">{{ couponMessage }}</p>
                            <p v-if="couponError" class="text-xs text-red-600 mt-1.5 font-medium">{{ couponError }}</p>
                        </div>

                        <!-- Cost Calculations -->
                        <div class="border-t border-pm-ink/10 pt-4 space-y-2 text-xs">
                            <div class="flex justify-between text-pm-ink-muted">
                                <span>Subtotal</span>
                                <span class="text-pm-ink font-semibold tabular-nums">{{ cartStore.formatNaira(cartStore.subtotal.value) }}</span>
                            </div>
                            <div v-if="discountAmount > 0" class="flex justify-between text-emerald-700 font-medium">
                                <span>Promotional Discount</span>
                                <span class="tabular-nums">- {{ cartStore.formatNaira(discountAmount) }}</span>
                            </div>
                            <div class="flex justify-between text-pm-ink-muted">
                                <span>Freight & Timber Crating ({{ form.shipping_state }})</span>
                                <span class="tabular-nums font-semibold">
                                    <span v-if="shippingDetails.rate === 0" class="text-emerald-700">FREE</span>
                                    <span v-else class="text-pm-ink">{{ cartStore.formatNaira(shippingDetails.rate) }}</span>
                                </span>
                            </div>
                            <div class="border-t border-pm-ink/10 pt-3 flex justify-between text-base font-bold text-pm-ink">
                                <span class="font-display">Total</span>
                                <span class="text-lg tabular-nums">{{ cartStore.formatNaira(orderTotal) }}</span>
                            </div>
                        </div>

                        <!-- Guarantees & Assurance -->
                        <div class="bg-[#FAF9F5] border border-pm-ink/10 rounded-xl p-4 space-y-2 text-[11px] text-pm-ink-muted">
                            <div class="flex items-center space-x-2 text-pm-ink font-semibold">
                                <BrandIcon name="box" :size="14" className="text-pm-clay" />
                                <span>Zero-Breakage Crated Guarantee</span>
                            </div>
                            <p>Every order is dispatched in bespoke timber crates. Any transit incident is replaced within 48 hours at zero cost.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
