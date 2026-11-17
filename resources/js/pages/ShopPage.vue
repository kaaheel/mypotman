<script setup>
import { ref, computed } from 'vue';
import { products } from '../data/products';
import { cartStore } from '../stores/cart';
import ProductCard from '../components/ProductCard.vue';
import BrandIcon from '../components/BrandIcon.vue';

const activeCategory = ref('all');
const searchQuery = ref('');
const sortBy = ref('featured');

const categories = [
    { id: 'all', label: 'All Planters' },
    { id: 'indoor', label: 'Indoor Living' },
    { id: 'outdoor', label: 'Outdoor & Terraces' },
    { id: 'statement', label: 'Statement Silhouettes' },
];

const filteredProducts = computed(() => {
    let list = [...products];

    // Category filter
    if (activeCategory.value !== 'all') {
        list = list.filter(p => p.categories.includes(activeCategory.value));
    }

    // Search query filter
    if (searchQuery.value.trim()) {
        const query = searchQuery.value.toLowerCase().trim();
        list = list.filter(p => 
            p.name.toLowerCase().includes(query) ||
            p.subtitle.toLowerCase().includes(query) ||
            p.description.toLowerCase().includes(query)
        );
    }

    // Sorting
    if (sortBy.value === 'price-low') {
        list.sort((a, b) => a.price - b.price);
    } else if (sortBy.value === 'price-high') {
        list.sort((a, b) => b.price - a.price);
    } else if (sortBy.value === 'rating') {
        list.sort((a, b) => b.rating - a.rating);
    }

    return list;
});
</script>

<template>
    <div class="bg-pm-ivory min-h-screen py-10 lg:py-16">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Breadcrumbs -->
            <nav class="flex items-center space-x-2 text-xs font-body text-pm-ink-muted mb-6" aria-label="Breadcrumb">
                <router-link to="/" class="hover:text-pm-ink transition-colors">Home</router-link>
                <span>/</span>
                <span class="text-pm-ink font-semibold">Shop Planters</span>
            </nav>

            <!-- Page Header -->
            <div class="pb-8 border-b border-pm-ink/10 mb-8 sm:mb-12">
                <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-medium block mb-2">
                    Studio Collection
                </span>
                <h1 class="font-display text-3xl sm:text-4xl lg:text-5xl font-bold text-pm-ink tracking-tight">
                    Architectural Planters
                </h1>
                <p class="font-body text-sm sm:text-base text-pm-ink-muted mt-3 max-w-2xl leading-relaxed">
                    Sculptural vessels cast in lightweight limestone composite. Each form is proportioned for contemporary living, with internally sealed bases or outdoor drainage.
                </p>
            </div>

            <!-- Filter & Controls Toolbar -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-6 mb-8 border-b border-pm-ink/10">
                <!-- Category Tabs -->
                <div class="flex items-center space-x-2 sm:space-x-3 overflow-x-auto no-scrollbar pb-1">
                    <button
                        v-for="cat in categories"
                        :key="cat.id"
                        @click="activeCategory = cat.id"
                        :class="[
                            'px-4 py-2 rounded-xl text-xs uppercase tracking-wider font-semibold whitespace-nowrap transition-all',
                            activeCategory === cat.id
                                ? 'bg-pm-ink text-white shadow-sm'
                                : 'bg-white border border-pm-ink/10 text-pm-ink-muted hover:text-pm-ink hover:border-pm-ink/30'
                        ]"
                    >
                        {{ cat.label }}
                    </button>
                </div>

                <!-- Search & Sort Controls -->
                <div class="flex items-center space-x-3 shrink-0">
                    <!-- Search Input -->
                    <div class="relative w-44 sm:w-56">
                        <input
                            v-model="searchQuery"
                            type="text"
                            placeholder="Search vessels..."
                            class="w-full bg-white border border-pm-ink/15 rounded-xl pl-8 pr-3 py-2 text-xs focus:outline-none focus:ring-1 focus:ring-pm-ink transition-all"
                        />
                        <div class="absolute left-2.5 top-1/2 -translate-y-1/2 text-pm-ink-muted">
                            <BrandIcon name="search" :size="13" />
                        </div>
                    </div>

                    <!-- Sort Dropdown -->
                    <select
                        v-model="sortBy"
                        class="bg-white border border-pm-ink/15 rounded-xl px-3 py-2 text-xs font-medium text-pm-ink focus:outline-none focus:ring-1 focus:ring-pm-ink"
                    >
                        <option value="featured">Featured</option>
                        <option value="price-low">Price: Low to High</option>
                        <option value="price-high">Price: High to Low</option>
                        <option value="rating">Highest Rated</option>
                    </select>
                </div>
            </div>

            <!-- Empty Search / Filter State -->
            <div v-if="filteredProducts.length === 0" class="py-20 text-center bg-white border border-pm-ink/10 rounded-2xl p-8">
                <div class="w-12 h-12 rounded-full bg-pm-sand/20 flex items-center justify-center mx-auto mb-3 text-pm-ink-muted">
                    <BrandIcon name="search" :size="20" />
                </div>
                <h3 class="font-display text-lg font-bold text-pm-ink mb-1">No Vessels Match Your Filter</h3>
                <p class="text-xs text-pm-ink-muted mb-4">Try clearing your search query or switching categories.</p>
                <button
                    @click="activeCategory = 'all'; searchQuery = ''"
                    class="bg-pm-ink text-white text-xs font-bold uppercase tracking-wider px-5 py-2.5 rounded-xl"
                >
                    Reset Filters
                </button>
            </div>

            <!-- 3-Column Product Grid -->
            <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-x-8 gap-y-14 lg:gap-x-10">
                <ProductCard 
                    v-for="product in filteredProducts" 
                    :key="product.id" 
                    :product="product" 
                />
            </div>

            <!-- Material Assurance Callout Banner -->
            <div class="mt-20 p-8 sm:p-12 bg-[#FAF9F5] border border-pm-ink/10 rounded-3xl grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
                <div class="space-y-1.5">
                    <div class="w-10 h-10 rounded-full bg-pm-sand/20 text-pm-ink flex items-center justify-center mx-auto mb-3">
                        <BrandIcon name="leaf" :size="18" />
                    </div>
                    <h3 class="font-display text-sm font-bold text-pm-ink">0% Petroleum Resin</h3>
                    <p class="text-xs text-pm-ink-muted max-w-xs mx-auto">Crushed natural limestone and mineral binders. Non-toxic and odorless indoors.</p>
                </div>

                <div class="space-y-1.5 border-y md:border-y-0 md:border-x border-pm-ink/10 py-6 md:py-0">
                    <div class="w-10 h-10 rounded-full bg-pm-sand/20 text-pm-ink flex items-center justify-center mx-auto mb-3">
                        <BrandIcon name="box" :size="18" />
                    </div>
                    <h3 class="font-display text-sm font-bold text-pm-ink">Crated 36 States Delivery</h3>
                    <p class="text-xs text-pm-ink-muted max-w-xs mx-auto">Custom pine timber crating with interior foam pads. Zero-breakage guarantee.</p>
                </div>

                <div class="space-y-1.5">
                    <div class="w-10 h-10 rounded-full bg-pm-sand/20 text-pm-ink flex items-center justify-center mx-auto mb-3">
                        <BrandIcon name="shield" :size="18" />
                    </div>
                    <h3 class="font-display text-sm font-bold text-pm-ink">3-Year Guarantee</h3>
                    <p class="text-xs text-pm-ink-muted max-w-xs mx-auto">Engineered to withstand tropical sun, rain, and interior moisture without cracking.</p>
                </div>
            </div>
        </div>
    </div>
</template>

