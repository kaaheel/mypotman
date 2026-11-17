<script setup>
import { computed } from 'vue';
import { products } from '../data/products';
import { cartStore } from '../stores/cart';
import ProductCard from './ProductCard.vue';

const filterTabs = [
    { id: 'all', label: 'All Planters' },
    { id: 'indoor', label: 'Indoor' },
    { id: 'outdoor', label: 'Outdoor' },
    { id: 'statement', label: 'Statement' },
];

const filteredProducts = computed(() => {
    const cat = cartStore.state.activeCategory;
    if (cat === 'all' || !filterTabs.some(t => t.id === cat)) {
        return products;
    }
    return products.filter(p => p.categories.includes(cat));
});

function setFilter(id) {
    cartStore.setCategory(id);
}
</script>

<template>
    <section id="shop" class="reveal-on-scroll bg-pm-ivory py-16 sm:py-24 lg:py-28">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Section Header + Clean Inline Filter Tabs -->
            <div class="flex flex-col lg:flex-row lg:items-end lg:justify-between gap-6 pb-8 mb-10 sm:mb-12 border-b border-pm-ink/10">
                <div class="max-w-xl">
                    <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-medium block mb-2.5">
                        Featured Planters
                    </span>
                    <h2 class="font-display text-3xl sm:text-4xl lg:text-[2.5rem] font-bold text-pm-ink tracking-[-0.025em] leading-[1.12]">
                        The Core Collection
                    </h2>
                    <p class="font-body text-sm sm:text-[15px] text-pm-ink-muted mt-3 leading-relaxed">
                        Cast in lightweight mineral stone with sealed indoor bases or outdoor drainage.
                    </p>
                </div>

                <!-- Filter Controls -->
                <nav aria-label="Collection Filter" class="flex items-center gap-6 sm:gap-8 overflow-x-auto no-scrollbar pb-1">
                    <button
                        v-for="tab in filterTabs"
                        :key="tab.id"
                        @click="setFilter(tab.id)"
                        :class="[
                            'relative py-2 text-xs uppercase tracking-[0.12em] whitespace-nowrap transition-colors duration-200 focus:outline-none',
                            cartStore.state.activeCategory === tab.id || (tab.id === 'all' && !filterTabs.some(t => t.id === cartStore.state.activeCategory))
                                ? 'text-pm-ink font-bold'
                                : 'text-pm-ink-muted hover:text-pm-ink font-medium'
                        ]"
                    >
                        <span>{{ tab.label }}</span>
                        <span
                            :class="[
                                'absolute left-0 right-0 bottom-0 h-[1.5px] bg-pm-ink transition-transform duration-300 origin-left',
                                cartStore.state.activeCategory === tab.id || (tab.id === 'all' && !filterTabs.some(t => t.id === cartStore.state.activeCategory))
                                    ? 'scale-x-100'
                                    : 'scale-x-0'
                            ]"
                        ></span>
                    </button>
                </nav>
            </div>

            <!-- 3-Column Borderless Gallery Product Grid -->
            <TransitionGroup 
                name="gallery-fade" 
                tag="div" 
                class="grid grid-cols-1 md:grid-cols-3 gap-x-8 gap-y-14 lg:gap-x-10"
            >
                <ProductCard 
                    v-for="product in filteredProducts" 
                    :key="product.id" 
                    :product="product" 
                />
            </TransitionGroup>
        </div>
    </section>
</template>

<style scoped>
.no-scrollbar::-webkit-scrollbar {
    display: none;
}
.no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
}

.gallery-fade-enter-active,
.gallery-fade-leave-active {
    transition: opacity 0.35s ease, transform 0.35s ease;
}
.gallery-fade-enter-from,
.gallery-fade-leave-to {
    opacity: 0;
    transform: translateY(8px);
}
</style>
