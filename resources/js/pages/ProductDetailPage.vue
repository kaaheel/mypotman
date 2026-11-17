<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { products } from '../data/products';
import { cartStore } from '../stores/cart';
import BrandIcon from '../components/BrandIcon.vue';
import { flyToCart } from '../utils/flyToCart';

const route = useRoute();
const router = useRouter();

const product = computed(() => {
    const slug = route.params.slug;
    return products.find(p => p.slug === slug || p.id === slug) || products[0];
});

// Gallery images per product
const galleryImages = computed(() => {
    const baseImg = product.value.image;
    let lifestyleImg = '/images/lifestyle/space-residence.jpg';
    if (product.value.slug === 'oko-statement') {
        lifestyleImg = '/images/lifestyle/space-courtyard.jpg';
    } else if (product.value.slug === 'zuma-tall') {
        lifestyleImg = '/images/lifestyle/space-hospitality.jpg';
    }

    return [
        { url: baseImg, label: 'Studio Silhouette' },
        { url: '/images/craft/mineral-macro-studio.jpg', label: 'Mineral Texture' },
        { url: lifestyleImg, label: 'In-Situ Living Space' },
        { url: '/images/craft/crated-packaging-studio.jpg', label: 'Crated Packaging' },
    ];
});

const activeImageIndex = ref(0);
const selectedFinish = ref(product.value.defaultFinish || 'Sand');
const selectedDrainage = ref('Indoor (Sealed base)');
const selectedSize = ref(product.value.sizes?.[0]?.name || 'Standard');
const quantity = ref(1);
const isAdding = ref(false);
const activeTab = ref('specs');
const mainImageRef = ref(null);

watch(() => product.value, (newProd) => {
    if (newProd) {
        selectedFinish.value = newProd.defaultFinish || 'Sand';
        selectedSize.value = newProd.sizes?.[0]?.name || 'Standard';
        activeImageIndex.value = 0;
        quantity.value = 1;
    }
}, { immediate: true });

const unitPrice = computed(() => {
    const sizeObj = product.value.sizes?.find(s => s.name === selectedSize.value);
    const addon = Number(sizeObj?.additionalCost) || 0;
    const base = Number(product.value.price) || 42000;
    return base + addon;
});

const currentPrice = computed(() => {
    const qty = Math.max(1, Number(quantity.value) || 1);
    return unitPrice.value * qty;
});

function handleAddToCart(e) {
    isAdding.value = true;
    const originEl = mainImageRef.value || e?.currentTarget;
    if (originEl) {
        flyToCart(originEl, galleryImages.value[activeImageIndex.value].url, () => {
            cartStore.triggerImpact();
        });
    }

    cartStore.addItem(
        product.value,
        selectedFinish.value,
        selectedDrainage.value,
        selectedSize.value,
        quantity.value,
        { autoOpenDrawer: false }
    );

    setTimeout(() => {
        isAdding.value = false;
    }, 600);
}

function handleBuyNow(e) {
    handleAddToCart(e);
    setTimeout(() => {
        router.push('/checkout');
    }, 250);
}

function incrementQty() {
    quantity.value++;
}

function decrementQty() {
    if (quantity.value > 1) quantity.value--;
}

// JSON-LD structured data
onMounted(() => {
    const scriptId = 'potman-product-jsonld';
    let scriptEl = document.getElementById(scriptId);
    if (!scriptEl) {
        scriptEl = document.createElement('script');
        scriptEl.id = scriptId;
        scriptEl.type = 'application/ld+json';
        document.head.appendChild(scriptEl);
    }
    scriptEl.textContent = JSON.stringify({
        '@context': 'https://schema.org/',
        '@type': 'Product',
        'name': product.value.name,
        'image': [window.location.origin + product.value.image],
        'description': product.value.description,
        'brand': {
            '@type': 'Brand',
            'name': 'POTMAN'
        },
        'offers': {
            '@type': 'Offer',
            'priceCurrency': 'NGN',
            'price': unitPrice.value,
            'availability': 'https://schema.org/InStock',
            'itemCondition': 'https://schema.org/NewCondition'
        }
    });
});
</script>

<template>
    <div class="bg-pm-ivory min-h-screen py-8 lg:py-14">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Breadcrumbs -->
            <nav class="flex items-center space-x-2 text-xs font-body text-pm-ink-muted mb-8" aria-label="Breadcrumb">
                <router-link to="/" class="hover:text-pm-ink transition-colors">Home</router-link>
                <span>/</span>
                <router-link to="/#shop" class="hover:text-pm-ink transition-colors">Collection</router-link>
                <span>/</span>
                <span class="text-pm-ink font-semibold">{{ product.name }}</span>
            </nav>

            <!-- Main Product Layout Grid -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-14">
                <!-- Left: Multi-Angle Architectural Gallery (Cols 1-7) -->
                <div class="lg:col-span-7 space-y-4">
                    <!-- Main Large Display View -->
                    <div class="relative w-full aspect-[4/5] bg-[#EAE6DF] overflow-hidden rounded-2xl shadow-sm border border-pm-ink/10">
                        <img 
                            ref="mainImageRef"
                            :src="galleryImages[activeImageIndex].url" 
                            :alt="product.name + ' - ' + galleryImages[activeImageIndex].label" 
                            class="w-full h-full object-cover object-center transition-all duration-500 ease-out"
                        />
                        <span 
                            v-if="product.tag"
                            class="absolute top-5 left-5 bg-pm-ivory/95 backdrop-blur-xs text-pm-ink text-[10px] font-semibold tracking-[0.14em] uppercase px-3 py-1.5 rounded-full border border-pm-ink/10"
                        >
                            {{ product.tag }}
                        </span>
                        <div class="absolute bottom-4 left-4 bg-pm-ink/80 backdrop-blur-md text-white text-[11px] font-medium px-3 py-1.5 rounded-full">
                            {{ galleryImages[activeImageIndex].label }}
                        </div>
                    </div>

                    <!-- Gallery Thumbnails -->
                    <div class="grid grid-cols-4 gap-3 sm:gap-4">
                        <button
                            v-for="(img, idx) in galleryImages"
                            :key="idx"
                            @click="activeImageIndex = idx"
                            :class="[
                                'relative aspect-square rounded-xl overflow-hidden border-2 transition-all bg-[#EAE6DF]',
                                activeImageIndex === idx 
                                    ? 'border-pm-clay ring-2 ring-pm-clay/20 scale-[0.98]' 
                                    : 'border-transparent opacity-75 hover:opacity-100 hover:border-pm-ink/20'
                            ]"
                        >
                            <img :src="img.url" :alt="img.label" class="w-full h-full object-cover" />
                        </button>
                    </div>

                    <!-- Material Proof Strip -->
                    <div class="mt-8 p-5 bg-[#FAF9F5] border border-pm-ink/10 rounded-2xl grid grid-cols-3 gap-4 text-center">
                        <div>
                            <span class="block text-[10px] uppercase tracking-wider font-semibold text-pm-clay">Composite</span>
                            <span class="block text-xs font-bold text-pm-ink mt-0.5">Resin-Free Limestone</span>
                        </div>
                        <div class="border-x border-pm-ink/10">
                            <span class="block text-[10px] uppercase tracking-wider font-semibold text-pm-clay">Weight Mass</span>
                            <span class="block text-xs font-bold text-pm-ink mt-0.5">50% Lighter Concrete</span>
                        </div>
                        <div>
                            <span class="block text-[10px] uppercase tracking-wider font-semibold text-pm-clay">Transit</span>
                            <span class="block text-xs font-bold text-pm-ink mt-0.5">Custom Timber Crate</span>
                        </div>
                    </div>
                </div>

                <!-- Right: Configuration & Purchasing Engine (Cols 8-12) -->
                <div class="lg:col-span-5 flex flex-col justify-between">
                    <div>
                        <!-- Header & Title -->
                        <div class="border-b border-pm-ink/10 pb-5">
                            <h1 class="font-display text-3xl sm:text-4xl font-bold tracking-tight text-pm-ink">
                                {{ product.name }}
                            </h1>
                            <p class="font-body text-sm text-pm-ink-muted mt-2">
                                {{ product.subtitle }}
                            </p>
                            <div class="mt-4 flex items-baseline justify-between">
                                <div class="flex items-baseline space-x-2">
                                    <span class="text-2xl sm:text-3xl font-display font-bold text-pm-ink tabular-nums">
                                        {{ cartStore.formatNaira(unitPrice) }}
                                    </span>
                                    <span class="text-xs text-pm-ink-muted">per vessel</span>
                                </div>
                                <span class="inline-flex items-center text-xs font-medium text-emerald-700 bg-emerald-50 px-2.5 py-1 rounded-full border border-emerald-200">
                                    In Stock · Lagos 24–48h
                                </span>
                            </div>
                        </div>

                        <!-- 01. Finish Selector -->
                        <div class="py-5 border-b border-pm-ink/10">
                            <div class="flex items-center justify-between mb-3">
                                <label class="text-xs font-bold uppercase tracking-wider text-pm-ink">
                                    Finish / Patina
                                </label>
                                <span class="text-xs text-pm-clay font-medium">
                                    {{ selectedFinish }}
                                </span>
                            </div>
                            <div class="grid grid-cols-2 gap-2.5">
                                <button
                                    v-for="finish in product.finishes"
                                    :key="finish.name"
                                    @click="selectedFinish = finish.name"
                                    :class="[
                                        'flex items-center space-x-3 p-3 rounded-xl border text-left transition-all',
                                        selectedFinish === finish.name
                                            ? 'border-pm-ink bg-white shadow-sm ring-1 ring-pm-ink'
                                            : 'border-pm-ink/10 hover:border-pm-ink/30 bg-[#FAF9F5]'
                                    ]"
                                >
                                    <span 
                                        class="w-5 h-5 rounded-full shrink-0 shadow-inner border border-black/10" 
                                        :style="{ backgroundColor: finish.hex }"
                                    ></span>
                                    <div class="min-w-0">
                                        <span class="block text-xs font-bold text-pm-ink truncate">{{ finish.name }}</span>
                                        <span class="block text-[10px] text-pm-ink-muted truncate">{{ finish.label }}</span>
                                    </div>
                                </button>
                            </div>
                        </div>

                        <!-- 02. Scale / Size Selector -->
                        <div class="py-5 border-b border-pm-ink/10">
                            <div class="flex items-center justify-between mb-3">
                                <label class="text-xs font-bold uppercase tracking-wider text-pm-ink">
                                    Scale & Dimensions
                                </label>
                                <span class="text-xs text-pm-ink-muted">
                                    Standard or Monumental
                                </span>
                            </div>
                            <div class="space-y-2">
                                <button
                                    v-for="sz in product.sizes"
                                    :key="sz.name"
                                    @click="selectedSize = sz.name"
                                    :class="[
                                        'w-full flex items-center justify-between p-3.5 rounded-xl border text-left transition-all',
                                        selectedSize === sz.name
                                            ? 'border-pm-ink bg-white shadow-sm ring-1 ring-pm-ink'
                                            : 'border-pm-ink/10 hover:border-pm-ink/30 bg-[#FAF9F5]'
                                    ]"
                                >
                                    <span class="text-xs font-bold text-pm-ink">{{ sz.name }}</span>
                                    <span class="text-xs font-semibold tabular-nums text-pm-clay">
                                        {{ sz.additionalCost > 0 ? '+ ' + cartStore.formatNaira(sz.additionalCost) : 'Included' }}
                                    </span>
                                </button>
                            </div>
                        </div>

                        <!-- 03. Drainage & Base Configuration -->
                        <div class="py-5 border-b border-pm-ink/10">
                            <label class="block text-xs font-bold uppercase tracking-wider text-pm-ink mb-3">
                                Placement & Drainage
                            </label>
                            <div class="grid grid-cols-2 gap-2.5">
                                <button
                                    v-for="opt in product.drainageOptions"
                                    :key="opt"
                                    @click="selectedDrainage = opt"
                                    :class="[
                                        'p-3 rounded-xl border text-left transition-all',
                                        selectedDrainage === opt
                                            ? 'border-pm-ink bg-white shadow-sm ring-1 ring-pm-ink'
                                            : 'border-pm-ink/10 hover:border-pm-ink/30 bg-[#FAF9F5]'
                                    ]"
                                >
                                    <span class="block text-xs font-bold text-pm-ink">{{ opt }}</span>
                                    <span class="block text-[10px] text-pm-ink-muted mt-0.5">
                                        {{ opt.includes('Indoor') ? 'Waterproof plug for fine floors' : 'Pre-drilled hole for rain runoff' }}
                                    </span>
                                </button>
                            </div>
                        </div>

                        <!-- 04. Quantity Stepper & Cart Action -->
                        <div class="py-6 space-y-4">
                            <div class="flex items-center space-x-4">
                                <div class="flex items-center border border-pm-ink/20 rounded-xl bg-white p-1">
                                    <button 
                                        @click="decrementQty"
                                        class="w-9 h-9 flex items-center justify-center text-pm-ink hover:text-pm-clay transition-colors"
                                        aria-label="Decrease quantity"
                                    >
                                        <BrandIcon name="minus" :size="14" />
                                    </button>
                                    <span class="w-10 text-center text-sm font-bold tabular-nums text-pm-ink">{{ quantity }}</span>
                                    <button 
                                        @click="incrementQty"
                                        class="w-9 h-9 flex items-center justify-center text-pm-ink hover:text-pm-clay transition-colors"
                                        aria-label="Increase quantity"
                                    >
                                        <BrandIcon name="plus" :size="14" />
                                    </button>
                                </div>

                                <button 
                                    @click="handleAddToCart"
                                    :disabled="isAdding"
                                    class="flex-1 bg-pm-ink hover:bg-pm-clay text-white py-3.5 px-6 rounded-xl font-bold uppercase tracking-[0.14em] text-xs transition-all shadow-md flex items-center justify-center space-x-2 active:scale-[0.99] disabled:opacity-50"
                                >
                                    <BrandIcon :name="isAdding ? 'check' : 'bag'" :size="15" />
                                    <span>{{ isAdding ? 'Added to Bag' : 'Add to Bag' }}</span>
                                    <span class="tabular-nums">· {{ cartStore.formatNaira(currentPrice) }}</span>
                                </button>
                            </div>

                            <button 
                                @click="handleBuyNow"
                                class="w-full bg-pm-clay hover:bg-pm-ink text-white py-3.5 px-6 rounded-xl font-bold uppercase tracking-[0.14em] text-xs transition-all shadow-md active:scale-[0.99]"
                            >
                                Instant Checkout
                            </button>
                        </div>
                    </div>

                    <!-- Technical Specs Accordion -->
                    <div class="mt-6 border-t border-pm-ink/10 pt-4">
                        <div class="flex border-b border-pm-ink/10 mb-4">
                            <button 
                                @click="activeTab = 'specs'"
                                :class="[
                                    'py-2 px-4 text-xs font-bold uppercase tracking-wider transition-colors border-b-2',
                                    activeTab === 'specs' ? 'border-pm-ink text-pm-ink' : 'border-transparent text-pm-ink-muted hover:text-pm-ink'
                                ]"
                            >
                                Specifications
                            </button>
                            <button 
                                @click="activeTab = 'shipping'"
                                :class="[
                                    'py-2 px-4 text-xs font-bold uppercase tracking-wider transition-colors border-b-2',
                                    activeTab === 'shipping' ? 'border-pm-ink text-pm-ink' : 'border-transparent text-pm-ink-muted hover:text-pm-ink'
                                ]"
                            >
                                Shipping & Crating
                            </button>
                            <button 
                                @click="activeTab = 'care'"
                                :class="[
                                    'py-2 px-4 text-xs font-bold uppercase tracking-wider transition-colors border-b-2',
                                    activeTab === 'care' ? 'border-pm-ink text-pm-ink' : 'border-transparent text-pm-ink-muted hover:text-pm-ink'
                                ]"
                            >
                                Care Guide
                            </button>
                        </div>

                        <div v-if="activeTab === 'specs'" class="space-y-2.5 text-xs">
                            <div v-for="spec in product.specs" :key="spec.label" class="flex justify-between py-1.5 border-b border-pm-ink/5">
                                <span class="text-pm-ink-muted">{{ spec.label }}</span>
                                <span class="font-medium text-pm-ink text-right">{{ spec.value }}</span>
                            </div>
                        </div>

                        <div v-else-if="activeTab === 'shipping'" class="space-y-3 text-xs text-pm-ink leading-relaxed">
                            <p><strong>Lagos Deliveries:</strong> Dispatched in 24 to 48 hours via dedicated fragile cargo transport.</p>
                            <p><strong>Nationwide Deliveries:</strong> Transported inside bespoke shock-absorbing timber crates with interior foam supports across all 36 states.</p>
                            <p><strong>Zero Breakage Guarantee:</strong> If any vessel arrives with transit damage, we replace it at no charge.</p>
                        </div>

                        <div v-else-if="activeTab === 'care'" class="space-y-3 text-xs text-pm-ink leading-relaxed">
                            <p><strong>Cleaning:</strong> Wipe with a damp microfiber cloth and lukewarm water. Avoid abrasive cleansers or harsh acids.</p>
                            <p><strong>Sealant Maintenance:</strong> Apply organic mineral sealant wax twice a year to preserve stone depth and repel hard water spots.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sticky Mobile Bottom Bar -->
        <div class="lg:hidden fixed bottom-0 inset-x-0 bg-white/95 backdrop-blur-md border-t border-pm-ink/10 p-4 z-30 shadow-lg flex items-center justify-between gap-4">
            <div>
                <span class="block text-[11px] text-pm-ink-muted font-medium">{{ product.name }}</span>
                <span class="block text-base font-bold text-pm-ink tabular-nums">{{ cartStore.formatNaira(unitPrice) }}</span>
            </div>
            <button 
                @click="handleAddToCart"
                :disabled="isAdding"
                class="bg-pm-ink text-white px-6 py-3 rounded-xl font-bold uppercase tracking-wider text-xs shadow-md active:scale-95 disabled:opacity-50"
            >
                {{ isAdding ? 'Added' : 'Add to Bag' }}
            </button>
        </div>
    </div>
</template>

