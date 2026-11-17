<script setup>
import { cartStore } from '../stores/cart';
import BrandIcon from './BrandIcon.vue';

const categories = [
    { id: 'all', label: 'All Planters' },
    { id: 'indoor', label: 'Indoor' },
    { id: 'outdoor', label: 'Outdoor' },
    { id: 'statement', label: 'Statement' },
    { id: 'troughs', label: 'Troughs' },
];

function selectCategory(id) {
    cartStore.setCategory(id);
}
</script>

<template>
    <!-- Static Editorial Filter Ribbon (Non-sticky: scrolls naturally with the Flagship Collection) -->
    <div class="border-b border-pm-ink/10 bg-pm-ivory relative z-10 transition-colors">
        <div class="max-w-7xl mx-auto px-6 lg:px-8 py-3.5 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <!-- Filter Categories (Matches Attached Mockup) -->
            <div class="flex items-center space-x-2 md:space-x-6 overflow-x-auto no-scrollbar scroll-smooth">
                <button
                    v-for="(cat, idx) in categories"
                    :key="cat.id"
                    @click="selectCategory(cat.id)"
                    :class="[
                        'text-xs md:text-sm uppercase tracking-[0.1em] font-medium transition-all duration-200 whitespace-nowrap py-1 relative focus:outline-none',
                        cartStore.state.activeCategory === cat.id
                            ? 'text-pm-ink font-semibold'
                            : 'text-pm-ink/60 hover:text-pm-ink'
                    ]"
                >
                    {{ cat.label }}
                    <!-- Subtle underline indicator -->
                    <span 
                        v-if="cartStore.state.activeCategory === cat.id" 
                        class="absolute -bottom-3.5 left-0 right-0 h-[2px] bg-pm-ink"
                    ></span>
                </button>
            </div>

            <!-- Right Anchor: Shop All Planters -->
            <button 
                @click="selectCategory('all')"
                class="hidden md:inline-flex items-center text-xs uppercase tracking-[0.12em] font-semibold text-pm-ink/80 hover:text-pm-ink transition-colors group focus:outline-none"
            >
                <span>Shop All Planters</span>
                <BrandIcon name="arrow-right" :size="14" className="ml-2 transform group-hover:translate-x-1 transition-transform" />
            </button>
        </div>
    </div>
</template>

<style scoped>
.no-scrollbar::-webkit-scrollbar {
    display: none;
}
.no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
</style>

