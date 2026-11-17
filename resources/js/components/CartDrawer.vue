<script setup>
import { computed } from 'vue';
import { cartStore } from '../stores/cart';
import BrandIcon from './BrandIcon.vue';

function closeCart() {
    cartStore.closeCart();
}

function handleCheckout() {
    cartStore.openCheckout();
}

const careWax = {
    id: 'mineral-care-wax',
    name: 'Natural Mineral Care Wax',
    subtitle: '100ml stone sealer & patina balm',
    price: 6500,
    image: '/images/craft/mineral-macro-studio.jpg',
    sizes: [{ name: 'Standard', additionalCost: 0 }],
    finishes: [{ name: 'Clear', hex: '#EAE6DF' }],
    drainageOptions: ['Care Essential'],
};

const hasCareWax = computed(() => {
    return cartStore.state.items.some(i => i.productId === careWax.id);
});

function addCareWax() {
    cartStore.addItem(careWax, 'Clear', 'Care Essential', 'Standard', 1, { autoOpenDrawer: false });
    cartStore.triggerImpact();
}
</script>

<template>
    <!-- Teleport to body for top-level stacking -->
    <Teleport to="body">
        <Transition name="fade">
            <div 
                v-if="cartStore.state.isOpen" 
                class="fixed inset-0 z-50 overflow-hidden"
                aria-labelledby="slide-over-title" 
                role="dialog" 
                aria-modal="true"
            >
                <!-- Backdrop -->
                <div 
                    @click="closeCart"
                    class="fixed inset-0 bg-pm-ink/60 backdrop-blur-xs transition-opacity duration-300"
                ></div>

                <div class="fixed inset-y-0 right-0 max-w-full flex pl-10">
                    <Transition name="slide">
                        <div 
                            v-if="cartStore.state.isOpen"
                            data-lenis-prevent
                            class="w-screen max-w-md bg-pm-ivory flex flex-col shadow-2xl border-l border-pm-ink/15"
                        >
                            <!-- Cart Header -->
                            <div class="p-6 border-b border-pm-ink/10 flex items-center justify-between bg-pm-ivory">
                                <div class="flex items-center space-x-2">
                                    <h3 class="font-display text-lg font-bold tracking-[-0.01em] text-pm-ink" id="slide-over-title">
                                        Your Bag
                                    </h3>
                                    <span class="text-xs font-body text-pm-ink-muted tabular-nums">
                                        ({{ cartStore.totalCount.value }} {{ cartStore.totalCount.value === 1 ? 'item' : 'items' }})
                                    </span>
                                </div>
                                <button 
                                    @click="closeCart" 
                                    class="text-pm-ink hover:text-pm-clay p-2 focus:outline-none transition-colors"
                                    aria-label="Close cart"
                                >
                                    <BrandIcon name="close" :size="20" />
                                </button>
                            </div>

                            <!-- Nationwide Free Freight Threshold Progress Bar -->
                            <div class="px-6 py-3.5 bg-[#FAF9F5] border-b border-pm-ink/10">
                                <div class="flex items-center justify-between text-xs text-pm-ink mb-1.5">
                                    <span v-if="cartStore.isFreeShipping.value" class="font-semibold text-pm-clay flex items-center">
                                        <BrandIcon name="check" :size="14" className="mr-1" />
                                        Free crated delivery unlocked
                                    </span>
                                    <span v-else class="text-pm-ink-muted">
                                        Add <strong class="font-semibold text-pm-ink tabular-nums">{{ cartStore.formatNaira(cartStore.remainingForFreeShipping.value) }}</strong> for free delivery
                                    </span>
                                    <span class="font-body text-[11px] font-medium text-pm-ink-muted tabular-nums">{{ cartStore.shippingProgress.value }}%</span>
                                </div>
                                <div class="w-full h-1.5 bg-pm-ink/10 rounded-full overflow-hidden">
                                    <div 
                                        class="h-full bg-pm-clay transition-all duration-500 rounded-full"
                                        :style="{ width: cartStore.shippingProgress.value + '%' }"
                                    ></div>
                                </div>
                            </div>

                            <!-- Cart Items List -->
                            <div class="flex-1 overflow-y-auto p-6 space-y-6">
                                <div v-if="cartStore.state.items.length === 0" class="py-16 text-center">
                                    <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-pm-sand/20 flex items-center justify-center text-pm-ink-muted">
                                        <BrandIcon name="bag" :size="28" />
                                    </div>
                                    <p class="font-display text-base font-bold text-pm-ink">Your bag is empty</p>
                                    <p class="text-xs text-pm-ink-muted mt-1 max-w-xs mx-auto">Browse our mineral planters for indoor rooms and outdoor spaces.</p>
                                    <button 
                                        @click="closeCart"
                                        class="mt-6 inline-block bg-pm-ink text-white text-xs uppercase tracking-[0.14em] px-6 py-3 font-semibold hover:bg-pm-clay transition-colors"
                                    >
                                        Browse Planters
                                    </button>
                                </div>

                                <!-- FLIP Animated Item List -->
                                <TransitionGroup 
                                    v-else
                                    name="cart-item-flip" 
                                    tag="div" 
                                    class="space-y-6 divide-y divide-pm-ink/10"
                                >
                                    <div 
                                        v-for="item in cartStore.state.items" 
                                        :key="item.cartId"
                                        class="pt-6 first:pt-0 flex space-x-4"
                                    >
                                        <!-- Image Thumbnail -->
                                        <div class="w-20 h-24 bg-[#FAF9F5] border border-pm-ink/10 shrink-0 overflow-hidden">
                                            <img :src="item.image" :alt="item.name" class="w-full h-full object-cover" />
                                        </div>

                                        <!-- Item Details -->
                                        <div class="flex-1 flex flex-col justify-between">
                                            <div>
                                                <div class="flex items-start justify-between">
                                                    <h4 class="font-display text-sm font-bold text-pm-ink">
                                                        {{ item.name }}
                                                    </h4>
                                                    <button 
                                                        @click="cartStore.removeItem(item.cartId)"
                                                        class="text-pm-ink-muted hover:text-pm-clay transition-colors p-1"
                                                        aria-label="Remove item"
                                                    >
                                                        <BrandIcon name="close" :size="14" />
                                                    </button>
                                                </div>

                                                <div class="text-xs text-pm-ink-muted space-y-0.5 mt-0.5 font-body">
                                                    <div>Finish: <strong class="text-pm-ink font-medium">{{ item.finish }}</strong></div>
                                                    <div v-if="item.size && item.size !== 'Standard'">Size: {{ item.size }}</div>
                                                    <div class="text-[11px] text-pm-ink-muted">{{ item.drainage }}</div>
                                                </div>
                                            </div>

                                            <!-- Quantity & Price Row -->
                                            <div class="flex items-center justify-between mt-3 pt-2">
                                                <div class="flex items-center border border-pm-ink/20 bg-pm-ivory">
                                                    <button 
                                                        @click="cartStore.updateQuantity(item.cartId, -1)"
                                                        class="px-2.5 py-1 text-pm-ink hover:text-pm-clay transition-colors focus:outline-none active:scale-90"
                                                        aria-label="Decrease quantity"
                                                    >
                                                        <BrandIcon name="minus" :size="12" />
                                                    </button>
                                                    <span class="px-2.5 py-1 text-xs font-body font-semibold text-pm-ink tabular-nums select-none">
                                                        {{ item.quantity }}
                                                    </span>
                                                    <button 
                                                        @click="cartStore.updateQuantity(item.cartId, 1)"
                                                        class="px-2.5 py-1 text-pm-ink hover:text-pm-clay transition-colors focus:outline-none active:scale-90"
                                                        aria-label="Increase quantity"
                                                    >
                                                        <BrandIcon name="plus" :size="12" />
                                                    </button>
                                                </div>

                                                <div class="font-display text-sm font-bold text-pm-ink tabular-nums">
                                                    {{ cartStore.formatNaira(item.price * item.quantity) }}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </TransitionGroup>

                                <!-- Curated 1-Tap Mineral Care Companion -->
                                <div 
                                    v-if="cartStore.state.items.length > 0 && !hasCareWax"
                                    class="mt-4 p-3.5 bg-[#FAF9F5] border border-pm-ink/10 flex items-center justify-between gap-3 transition-all"
                                >
                                    <div class="flex items-center gap-3 min-w-0">
                                        <div class="w-11 h-11 bg-pm-ivory border border-pm-ink/10 overflow-hidden shrink-0">
                                            <img :src="careWax.image" :alt="careWax.name" class="w-full h-full object-cover" />
                                        </div>
                                        <div class="min-w-0">
                                            <span class="block text-xs font-semibold text-pm-ink truncate">{{ careWax.name }}</span>
                                            <span class="block text-[11px] text-pm-ink-muted">{{ careWax.subtitle }} · ₦6,500</span>
                                        </div>
                                    </div>
                                    <button
                                        @click="addCareWax"
                                        class="shrink-0 text-[11px] uppercase tracking-wider font-bold text-pm-ink hover:text-white border border-pm-ink/30 hover:bg-pm-ink px-3 py-1.5 transition-colors"
                                    >
                                        + Add
                                    </button>
                                </div>
                            </div>

                            <!-- Cart Footer / Checkout Trigger -->
                            <div v-if="cartStore.state.items.length > 0" class="p-6 border-t border-pm-ink/10 bg-[#FAF9F5]">
                                <!-- Pricing Breakdown -->
                                <div class="space-y-2 text-xs text-pm-ink-muted mb-4 font-body">
                                    <div class="flex justify-between">
                                        <span>Subtotal</span>
                                        <span class="text-pm-ink font-semibold tabular-nums">{{ cartStore.formatNaira(cartStore.subtotal.value) }}</span>
                                    </div>
                                    <div class="flex justify-between items-center">
                                        <span>Crated Nationwide Delivery</span>
                                        <span class="tabular-nums font-medium">
                                            <span v-if="cartStore.isFreeShipping.value" class="text-pm-clay uppercase tracking-wider font-semibold">Free</span>
                                            <span v-else class="text-pm-ink">{{ cartStore.formatNaira(cartStore.shippingFee.value) }}</span>
                                        </span>
                                    </div>
                                    <div class="pt-2 border-t border-pm-ink/10 flex justify-between text-sm font-bold text-pm-ink">
                                        <span class="font-display uppercase tracking-wide">Total</span>
                                        <span class="text-base tabular-nums">{{ cartStore.formatNaira(cartStore.total.value) }}</span>
                                    </div>
                                </div>

                                <!-- Checkout Button -->
                                <button 
                                    @click="handleCheckout"
                                    class="w-full bg-pm-ink hover:bg-pm-clay text-white py-4 px-6 text-xs uppercase tracking-[0.14em] font-bold transition-all duration-300 shadow-md flex items-center justify-center space-x-2 active:scale-[0.99]"
                                >
                                    <span>Proceed to Checkout</span>
                                    <BrandIcon name="arrow-right" :size="14" />
                                </button>

                                <!-- Trust Micro-Copy -->
                                <div class="mt-4 flex items-center justify-center space-x-3 text-[11px] uppercase tracking-wider text-pm-ink-muted font-body">
                                    <span class="flex items-center"><BrandIcon name="shield" :size="12" className="mr-1 text-pm-clay" /> Paystack Secured</span>
                                    <span>·</span>
                                    <span>Insured Transit</span>
                                    <span>·</span>
                                    <span>3-Yr Warranty</span>
                                </div>
                            </div>
                        </div>
                    </Transition>
                </div>
            </div>
        </Transition>
    </Teleport>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}

.slide-enter-active,
.slide-leave-active {
    transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1);
}
.slide-enter-from,
.slide-leave-to {
    transform: translateX(100%);
}

/* FLIP List Transitions for items */
.cart-item-flip-move {
    transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1);
}

.cart-item-flip-enter-active,
.cart-item-flip-leave-active {
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.cart-item-flip-enter-from {
    opacity: 0;
    transform: translateY(-10px);
}

.cart-item-flip-leave-to {
    opacity: 0;
    transform: translateX(35px);
}
</style>

