<script setup>
import { ref, watch, computed } from 'vue';
import { useRouter } from 'vue-router';
import { cartStore, cartState } from '../stores/cart';
import BrandIcon from './BrandIcon.vue';

const router = useRouter();
const isBouncing = ref(false);

watch(() => cartState.impactPulse, () => {
    isBouncing.value = false;
    requestAnimationFrame(() => {
        isBouncing.value = true;
        setTimeout(() => {
            isBouncing.value = false;
        }, 550);
    });
});

const isVisible = computed(() => {
    return cartStore.totalCount.value > 0 || cartState.isFloatingExpanded;
});

function openTray() {
    cartStore.dismissFloatingNotification();
    cartStore.openCart();
}

function closeTray() {
    cartStore.closeCart();
}

function openCheckout() {
    cartStore.dismissFloatingNotification();
    cartStore.closeCart();
    router.push('/checkout');
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
    return cartState.items.some(i => i.productId === careWax.id);
});

function addCareWax() {
    cartStore.addItem(careWax, 'Clear', 'Care Essential', 'Standard', 1, { autoOpenDrawer: false });
    cartStore.triggerImpact();
}
</script>

<template>
    <Teleport to="body">
        <!-- 1. Soft Ambient Backdrop when Spatial Tray is Open -->
        <Transition name="fade-scrim">
            <div 
                v-if="cartState.isOpen"
                @click="closeTray"
                class="fixed inset-0 z-50 bg-pm-ink/40 backdrop-blur-xs transition-opacity"
                aria-hidden="true"
            ></div>
        </Transition>

        <!-- 2. Floating Spatial Tray (Option A) -->
        <Transition name="spatial-tray">
            <aside
                v-if="cartState.isOpen"
                id="floating-cart-tray"
                data-lenis-prevent
                class="fixed z-50 bottom-4 inset-x-4 sm:inset-x-auto sm:right-8 sm:bottom-6 w-auto sm:w-[420px] max-h-[85vh] bg-pm-ivory/95 backdrop-blur-2xl border border-pm-ink/15 shadow-[0_30px_70px_-15px_rgba(32,35,31,0.35)] rounded-3xl flex flex-col overflow-hidden select-none"
                role="dialog"
                aria-label="Shopping Bag Tray"
            >
                <!-- Tray Header -->
                <div class="px-5 py-4 border-b border-pm-ink/10 flex items-center justify-between bg-pm-ivory/80 shrink-0">
                    <div class="flex items-center gap-2">
                        <span class="font-display text-base font-bold text-pm-ink">Your Bag</span>
                        <span class="text-xs font-body font-medium text-pm-ink-muted tabular-nums">
                            ({{ cartStore.totalCount.value }} {{ cartStore.totalCount.value === 1 ? 'vessel' : 'vessels' }})
                        </span>
                    </div>

                    <button 
                        @click="closeTray"
                        class="text-pm-ink hover:text-pm-clay p-1.5 rounded-full hover:bg-pm-ink/5 transition-colors focus:outline-none"
                        aria-label="Close bag"
                    >
                        <BrandIcon name="close" :size="18" />
                    </button>
                </div>

                <!-- Nationwide Free Freight Threshold Progress Bar -->
                <div class="px-5 py-3 bg-[#FAF9F5] border-b border-pm-ink/10 shrink-0">
                    <div class="flex items-center justify-between text-xs text-pm-ink mb-1.5">
                        <span v-if="cartStore.isFreeShipping.value" class="font-semibold text-pm-clay flex items-center gap-1">
                            <BrandIcon name="check" :size="13" />
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

                <!-- Scrollable Items List with FLIP Transitions -->
                <div class="flex-1 overflow-y-auto px-5 py-4 space-y-4 divide-y divide-pm-ink/10">
                    <div v-if="cartState.items.length === 0" class="py-12 text-center">
                        <div class="w-12 h-12 mx-auto mb-3 rounded-full bg-pm-sand/20 flex items-center justify-center text-pm-ink-muted">
                            <BrandIcon name="bag" :size="22" />
                        </div>
                        <p class="font-display text-sm font-bold text-pm-ink">Your bag is empty</p>
                        <p class="text-xs text-pm-ink-muted mt-1 max-w-xs mx-auto">Select any planter from the collection to begin.</p>
                    </div>

                    <TransitionGroup 
                        v-else
                        name="cart-item-flip" 
                        tag="div" 
                        class="space-y-4 divide-y divide-pm-ink/10"
                    >
                        <div 
                            v-for="item in cartState.items" 
                            :key="item.cartId"
                            class="pt-4 first:pt-0 flex gap-3.5"
                        >
                            <!-- Image Thumbnail -->
                            <div class="w-16 h-20 bg-[#FAF9F5] border border-pm-ink/10 rounded-lg shrink-0 overflow-hidden">
                                <img :src="item.image" :alt="item.name" class="w-full h-full object-cover" />
                            </div>

                            <!-- Item Details -->
                            <div class="flex-1 flex flex-col justify-between py-0.5 min-w-0">
                                <div>
                                    <div class="flex items-start justify-between gap-2">
                                        <h4 class="font-display text-sm font-bold text-pm-ink truncate">
                                            {{ item.name }}
                                        </h4>
                                        <button 
                                            @click="cartStore.removeItem(item.cartId)"
                                            class="text-pm-ink-muted hover:text-pm-clay transition-colors p-0.5 shrink-0"
                                            aria-label="Remove item"
                                        >
                                            <BrandIcon name="close" :size="13" />
                                        </button>
                                    </div>

                                    <div class="text-[11px] text-pm-ink-muted space-y-0.5 mt-0.5 font-body">
                                        <div>Finish: <strong class="text-pm-ink font-medium">{{ item.finish }}</strong></div>
                                        <div v-if="item.size && item.size !== 'Standard'">Size: {{ item.size }}</div>
                                        <div class="text-[10px] text-pm-ink-muted">{{ item.drainage }}</div>
                                    </div>
                                </div>

                                <!-- Quantity & Price Row -->
                                <div class="flex items-center justify-between mt-2 pt-1.5">
                                    <div class="flex items-center border border-pm-ink/20 rounded-md bg-pm-ivory/60">
                                        <button 
                                            @click="cartStore.updateQuantity(item.cartId, -1)"
                                            class="px-2 py-0.5 text-pm-ink hover:text-pm-clay transition-colors focus:outline-none active:scale-90"
                                            aria-label="Decrease quantity"
                                        >
                                            <BrandIcon name="minus" :size="11" />
                                        </button>
                                        <span class="px-2 py-0.5 text-xs font-body font-semibold text-pm-ink tabular-nums select-none">
                                            {{ item.quantity }}
                                        </span>
                                        <button 
                                            @click="cartStore.updateQuantity(item.cartId, 1)"
                                            class="px-2 py-0.5 text-pm-ink hover:text-pm-clay transition-colors focus:outline-none active:scale-90"
                                            aria-label="Increase quantity"
                                        >
                                            <BrandIcon name="plus" :size="11" />
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
                        v-if="cartState.items.length > 0 && !hasCareWax"
                        class="mt-4 p-3 bg-[#FAF9F5] border border-pm-ink/10 rounded-xl flex items-center justify-between gap-3 transition-all"
                    >
                        <div class="flex items-center gap-2.5 min-w-0">
                            <div class="w-10 h-10 bg-pm-ivory border border-pm-ink/10 rounded-md overflow-hidden shrink-0">
                                <img :src="careWax.image" :alt="careWax.name" class="w-full h-full object-cover" />
                            </div>
                            <div class="min-w-0">
                                <span class="block text-xs font-semibold text-pm-ink truncate">{{ careWax.name }}</span>
                                <span class="block text-[11px] text-pm-ink-muted">{{ careWax.subtitle }} · ₦6,500</span>
                            </div>
                        </div>
                        <button
                            @click="addCareWax"
                            class="shrink-0 text-[11px] uppercase tracking-wider font-bold text-pm-ink hover:text-white border border-pm-ink/30 hover:bg-pm-ink px-2.5 py-1 rounded-md transition-colors"
                        >
                            + Add
                        </button>
                    </div>
                </div>

                <!-- Tray Footer / Instant Checkout Action -->
                <div v-if="cartState.items.length > 0" class="p-5 border-t border-pm-ink/10 bg-[#FAF9F5] shrink-0">
                    <!-- Pricing Breakdown -->
                    <div class="space-y-1.5 text-xs text-pm-ink-muted mb-3.5 font-body">
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
                        @click="openCheckout"
                        class="w-full bg-pm-ink hover:bg-pm-clay text-white py-3.5 px-5 text-xs uppercase tracking-[0.14em] font-bold rounded-xl transition-all duration-300 shadow-md flex items-center justify-center space-x-2 active:scale-[0.99]"
                    >
                        <span>Proceed to Checkout</span>
                        <BrandIcon name="arrow-right" :size="14" />
                    </button>

                    <!-- Trust Micro-Copy -->
                    <div class="mt-3 flex items-center justify-center space-x-3 text-[10px] uppercase tracking-wider text-pm-ink-muted font-body">
                        <span class="flex items-center"><BrandIcon name="shield" :size="11" className="mr-1 text-pm-clay" /> Paystack Secured</span>
                        <span>·</span>
                        <span>Insured Transit</span>
                        <span>·</span>
                        <span>3-Yr Warranty</span>
                    </div>
                </div>
            </aside>
        </Transition>

        <!-- 3. Resting / Dynamic Pill (When Tray is Closed) -->
        <Transition name="float-slide">
            <aside 
                v-if="isVisible && !cartState.isOpen" 
                id="floating-cart-anchor"
                class="fixed z-40 bottom-4 inset-x-4 sm:inset-x-auto sm:right-8 sm:bottom-7 flex justify-center pointer-events-none select-none"
                aria-label="Floating Shopping Bag"
            >
                <div 
                    id="floating-cart-badge"
                    :class="[
                        'pointer-events-auto bg-pm-ink/95 text-pm-ivory backdrop-blur-md border border-white/15 shadow-2xl rounded-full transition-all duration-400 ease-out',
                        isBouncing ? 'animate-impact-bounce ring-2 ring-pm-clay/60 ring-offset-2 ring-offset-pm-ivory' : '',
                        cartState.isFloatingExpanded ? 'px-3.5 py-2.5 sm:px-4 sm:py-2.5' : 'px-4 py-2.5 sm:px-5 sm:py-3'
                    ]"
                >
                    <!-- Mode A: Dynamic Island Expanded State (Shown for ~3.8s after adding) -->
                    <Transition name="island-fade" mode="out-in">
                        <div 
                            v-if="cartState.isFloatingExpanded && cartState.lastAddedItem" 
                            :key="'expanded-' + cartState.lastAddedItem.id"
                            class="flex items-center gap-2.5 sm:gap-3.5"
                        >
                            <!-- Mini Thumbnail -->
                            <div class="w-8 h-8 rounded-full overflow-hidden bg-[#FAF9F5] border border-white/20 shrink-0">
                                <img 
                                    :src="cartState.lastAddedItem.image" 
                                    :alt="cartState.lastAddedItem.name" 
                                    class="w-full h-full object-cover"
                                />
                            </div>

                            <!-- Item Information -->
                            <div class="flex flex-col text-left pr-1 min-w-0">
                                <div class="flex items-center gap-1.5">
                                    <span class="text-xs font-semibold text-white truncate max-w-[120px] sm:max-w-[160px]">
                                        {{ cartState.lastAddedItem.name }}
                                    </span>
                                    <span class="text-[10px] font-medium text-pm-clay uppercase tracking-wider">
                                        Added
                                    </span>
                                </div>
                                <span class="text-[11px] text-pm-ivory font-body truncate max-w-[140px] sm:max-w-[200px]">
                                    {{ cartState.lastAddedItem.finish }} · {{ cartState.lastAddedItem.formattedPrice }}
                                </span>
                            </div>

                            <div class="h-4 w-[1px] bg-white/20 shrink-0"></div>

                            <!-- Quick Action Buttons -->
                            <div class="flex items-center gap-1.5 shrink-0">
                                <button
                                    @click="openTray"
                                    class="text-[11px] font-semibold uppercase tracking-wider text-pm-ivory hover:text-white px-2.5 py-1.5 transition-colors focus:outline-none"
                                >
                                    Bag
                                </button>
                                <button
                                    @click="openCheckout"
                                    class="bg-pm-ivory hover:bg-white text-pm-ink text-[11px] font-bold uppercase tracking-wider px-3.5 py-1.5 rounded-full transition-all shadow-sm flex items-center gap-1"
                                >
                                    <span>Checkout</span>
                                    <BrandIcon name="arrow-right" :size="12" />
                                </button>
                            </div>
                        </div>

                        <!-- Mode B: Minimalist Resting Floating Capsule -->
                        <div 
                            v-else 
                            key="resting-capsule"
                            @click="openTray"
                            class="flex items-center gap-3 sm:gap-3.5 cursor-pointer group"
                        >
                            <!-- Bag Icon + Live Counter -->
                            <div class="relative flex items-center gap-1.5">
                                <BrandIcon name="bag" :size="17" className="text-white group-hover:scale-110 transition-transform" />
                                <span class="text-xs font-bold text-white tabular-nums">
                                    {{ cartStore.totalCount.value }}
                                </span>
                            </div>

                            <div class="h-3.5 w-[1px] bg-white/20"></div>

                            <!-- Subtotal -->
                            <span class="text-xs font-semibold text-pm-ivory tabular-nums tracking-wide">
                                {{ cartStore.formatNaira(cartStore.subtotal.value) }}
                            </span>

                            <div class="h-3.5 w-[1px] bg-white/20"></div>

                            <!-- View Bag CTA -->
                            <span class="text-[11px] font-bold uppercase tracking-[0.12em] text-white flex items-center gap-1 group-hover:text-pm-sand transition-colors">
                                <span>Bag</span>
                                <BrandIcon name="arrow-right" :size="12" className="transform group-hover:translate-x-0.5 transition-transform" />
                            </span>
                        </div>
                    </Transition>
                </div>
            </aside>
        </Transition>
    </Teleport>
</template>

<style scoped>
@keyframes impactBounce {
    0% { transform: scale(1); }
    30% { transform: scale(1.14); }
    60% { transform: scale(0.96); }
    80% { transform: scale(1.04); }
    100% { transform: scale(1); }
}

.animate-impact-bounce {
    animation: impactBounce 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275) both;
}

/* Floating enter/leave slide */
.float-slide-enter-active,
.float-slide-leave-active {
    transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
}

.float-slide-enter-from,
.float-slide-leave-to {
    opacity: 0;
    transform: translateY(24px) scale(0.92);
}

/* Spatial Tray Transitions (Option A) */
.spatial-tray-enter-active,
.spatial-tray-leave-active {
    transition: all 0.42s cubic-bezier(0.16, 1, 0.3, 1);
}

.spatial-tray-enter-from,
.spatial-tray-leave-to {
    opacity: 0;
    transform: translateY(32px) scale(0.95);
}

/* Scrim fade */
.fade-scrim-enter-active,
.fade-scrim-leave-active {
    transition: opacity 0.3s ease;
}

.fade-scrim-enter-from,
.fade-scrim-leave-to {
    opacity: 0;
}

/* Island morph fade */
.island-fade-enter-active,
.island-fade-leave-active {
    transition: all 0.22s ease-out;
}

.island-fade-enter-from,
.island-fade-leave-to {
    opacity: 0;
    transform: scale(0.95);
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
    transform: translateY(-8px);
}

.cart-item-flip-leave-to {
    opacity: 0;
    transform: translateX(30px);
}
</style>
