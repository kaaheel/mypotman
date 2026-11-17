<script setup>
import { useRouter } from 'vue-router';
import { cartStore } from '../stores/cart';
import BrandIcon from './BrandIcon.vue';

const router = useRouter();

function goToShop() {
    router.push('/shop');
}

function goToCheckout() {
    router.push('/checkout');
}
</script>

<template>
    <section id="assurance" class="reveal-on-scroll bg-[#EFECE4] py-16 sm:py-24 lg:py-28">
        <div class="max-w-3xl mx-auto px-6 lg:px-8 text-center">
            <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-medium block mb-3">
                Ready to Order
            </span>

            <h2 class="font-display text-3xl sm:text-4xl lg:text-5xl font-bold text-pm-ink tracking-[-0.025em] leading-[1.1]">
                Find the right planter for your space.
            </h2>

            <div class="mt-8 sm:mt-10 flex flex-col sm:flex-row items-center justify-center gap-4">
                <button
                    @click="goToShop"
                    class="w-full sm:w-auto inline-flex items-center justify-center bg-pm-ink hover:bg-pm-clay text-pm-ivory text-xs uppercase tracking-[0.14em] font-bold px-9 py-4 transition-colors duration-200 cursor-pointer"
                >
                    <span>Shop Planters</span>
                    <BrandIcon name="arrow-right" :size="14" className="ml-2.5" />
                </button>

                <button
                    v-if="cartStore.totalCount.value > 0"
                    @click="goToCheckout"
                    class="w-full sm:w-auto inline-flex items-center justify-center border border-pm-ink/30 hover:border-pm-ink text-pm-ink text-xs uppercase tracking-[0.14em] font-semibold px-8 py-4 transition-colors duration-200 cursor-pointer"
                >
                    <span>Checkout ({{ cartStore.totalCount.value }})</span>
                </button>
            </div>

            <p class="mt-7 text-[11px] font-body uppercase tracking-[0.12em] text-pm-ink-muted font-medium">
                24 to 48h Lagos dispatch · Crated nationwide delivery · 3-year warranty
            </p>
        </div>
    </section>
</template>
