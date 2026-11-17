<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { cartStore } from '../stores/cart';
import BrandIcon from './BrandIcon.vue';
import { scrollToTarget } from '../utils/scroll';

const router = useRouter();
const route = useRoute();

const isScrolled = ref(false);
const isMobileMenuOpen = ref(false);

function handleScroll() {
    isScrolled.value = window.scrollY > 20;
}

onMounted(() => {
    window.addEventListener('scroll', handleScroll, { passive: true });
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});

function scrollTo(id) {
    isMobileMenuOpen.value = false;
    if (route.path !== '/') {
        router.push({ path: '/', hash: '#' + id });
    } else {
        scrollToTarget(id, -84);
    }
}

function goToCheckout() {
    isMobileMenuOpen.value = false;
    router.push('/checkout');
}
</script>

<template>
    <header 
        :class="[
            'sticky top-0 z-40 transition-all duration-300 border-b',
            isScrolled 
                ? 'bg-pm-ivory/95 backdrop-blur-md border-pm-ink/10 shadow-sm py-3.5' 
                : 'bg-pm-ivory border-pm-ink/5 py-5'
        ]"
    >
        <div class="max-w-7xl mx-auto px-6 lg:px-8 flex items-center justify-between">
            <!-- Mobile Menu Trigger -->
            <button 
                @click="isMobileMenuOpen = !isMobileMenuOpen" 
                class="lg:hidden text-pm-ink p-2 -ml-2 focus:outline-none"
                aria-label="Toggle Navigation"
            >
                <BrandIcon :name="isMobileMenuOpen ? 'close' : 'menu'" :size="22" />
            </button>

            <!-- Brand Wordmark Logo -->
            <router-link to="/" class="inline-flex items-center group focus:outline-none" aria-label="POTMAN Homepage">
                <img 
                    src="/brand/logos/POTMAN_Wordmark_Ink.svg" 
                    alt="POTMAN" 
                    class="h-5 md:h-6 w-auto transition-opacity duration-300 group-hover:opacity-80"
                />
            </router-link>

            <!-- Desktop Nav Links -->
            <nav class="hidden lg:flex items-center space-x-8">
                <router-link 
                    to="/shop" 
                    class="text-[13px] font-medium tracking-[0.04em] uppercase text-pm-ink hover:text-pm-clay transition-colors relative py-1 after:absolute after:bottom-0 after:left-0 after:w-0 after:h-[1px] after:bg-pm-ink hover:after:w-full after:transition-all after:duration-300"
                    active-class="text-pm-clay font-bold after:w-full"
                >
                    Shop
                </router-link>
                <router-link 
                    to="/material" 
                    class="text-[13px] font-medium tracking-[0.04em] uppercase text-pm-ink hover:text-pm-clay transition-colors relative py-1 after:absolute after:bottom-0 after:left-0 after:w-0 after:h-[1px] after:bg-pm-ink hover:after:w-full after:transition-all after:duration-300"
                    active-class="text-pm-clay font-bold after:w-full"
                >
                    Material
                </router-link>
                <router-link 
                    to="/spaces" 
                    class="text-[13px] font-medium tracking-[0.04em] uppercase text-pm-ink hover:text-pm-clay transition-colors relative py-1 after:absolute after:bottom-0 after:left-0 after:w-0 after:h-[1px] after:bg-pm-ink hover:after:w-full after:transition-all after:duration-300"
                    active-class="text-pm-clay font-bold after:w-full"
                >
                    Spaces
                </router-link>
                <router-link 
                    to="/delivery" 
                    class="text-[13px] font-medium tracking-[0.04em] uppercase text-pm-ink hover:text-pm-clay transition-colors relative py-1 after:absolute after:bottom-0 after:left-0 after:w-0 after:h-[1px] after:bg-pm-ink hover:after:w-full after:transition-all after:duration-300"
                    active-class="text-pm-clay font-bold after:w-full"
                >
                    Delivery
                </router-link>
            </nav>

            <!-- Right Utilities -->
            <div class="flex items-center space-x-3 md:space-x-5">
                <!-- Search Trigger -->
                <button 
                    @click="cartStore.state.isSearchOpen = !cartStore.state.isSearchOpen"
                    class="text-pm-ink hover:text-pm-clay transition-colors p-2 focus:outline-none"
                    aria-label="Search Collection"
                >
                    <BrandIcon name="search" :size="20" />
                </button>

                <!-- Customer Account / Track Order -->
                <router-link 
                    to="/track-order"
                    class="hidden md:inline-flex text-pm-ink hover:text-pm-clay transition-colors p-2 focus:outline-none"
                    aria-label="Track Order & Account"
                    title="Track Order & Account"
                >
                    <BrandIcon name="user" :size="20" />
                </router-link>

                <!-- Cart Button with Live Badge -->
                <button 
                    id="header-cart-button"
                    @click="cartStore.openCart()" 
                    class="text-pm-ink hover:text-pm-clay transition-colors p-2 -mr-2 flex items-center space-x-1.5 group focus:outline-none"
                    aria-label="View Shopping Bag"
                >
                    <div class="relative">
                        <BrandIcon name="bag" :size="20" className="group-hover:scale-105 transition-transform" />
                        <span 
                            v-if="cartStore.totalCount.value > 0" 
                            class="absolute -top-1.5 -right-2 bg-pm-clay text-white text-[10px] font-bold w-4 h-4 rounded-full flex items-center justify-center animate-scaleIn"
                        >
                            {{ cartStore.totalCount.value }}
                        </span>
                    </div>
                    <span class="text-xs font-medium text-pm-ink tabular-nums">
                        ({{ cartStore.totalCount.value }})
                    </span>
                </button>
            </div>
        </div>

        <!-- Mobile Slide-Down Menu -->
        <Transition name="expand">
            <div v-if="isMobileMenuOpen" class="lg:hidden border-t border-pm-ink/10 bg-pm-ivory px-6 py-6 shadow-lg">
                <nav class="flex flex-col space-y-1">
                    <router-link 
                        to="/shop" 
                        @click="isMobileMenuOpen = false"
                        class="text-left text-base font-display font-medium tracking-wide uppercase text-pm-ink py-3 border-b border-pm-ink/10"
                    >
                        Shop Planters
                    </router-link>
                    <router-link 
                        to="/material" 
                        @click="isMobileMenuOpen = false"
                        class="text-left text-base font-display font-medium tracking-wide uppercase text-pm-ink py-3 border-b border-pm-ink/10"
                    >
                        Material & Craft
                    </router-link>
                    <router-link 
                        to="/spaces" 
                        @click="isMobileMenuOpen = false"
                        class="text-left text-base font-display font-medium tracking-wide uppercase text-pm-ink py-3 border-b border-pm-ink/10"
                    >
                        Spaces
                    </router-link>
                    <router-link 
                        to="/delivery" 
                        @click="isMobileMenuOpen = false"
                        class="text-left text-base font-display font-medium tracking-wide uppercase text-pm-ink py-3"
                    >
                        Delivery & Care
                    </router-link>
                </nav>
                <div class="mt-5 pt-4 border-t border-pm-ink/10 flex items-center justify-between text-xs text-pm-ink-muted">
                    <span>Made in Nigeria · Delivered Nationwide</span>
                    <button @click="goToCheckout" class="font-medium underline text-pm-ink py-1">
                        Checkout
                    </button>
                </div>
            </div>
        </Transition>
    </header>
</template>

<style scoped>
.expand-enter-active,
.expand-leave-active {
    transition: all 0.3s ease-out;
    max-height: 350px;
    overflow: hidden;
}

.expand-enter-from,
.expand-leave-to {
    max-height: 0;
    opacity: 0;
}

@keyframes scaleIn {
    0% { transform: scale(0.6); }
    100% { transform: scale(1); }
}

.animate-scaleIn {
    animation: scaleIn 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
</style>

