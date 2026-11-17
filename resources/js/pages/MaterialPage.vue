<script setup>
import { ref } from 'vue';
import BrandIcon from '../components/BrandIcon.vue';

const finishes = [
    {
        name: 'Sand',
        tag: 'Warm Travertine Stone',
        hex: '#C8B9A4',
        description: 'Warm crushed limestone with delicate beige and cream veining reminiscent of desert travertine.',
    },
    {
        name: 'Ink',
        tag: 'Volcanic Basalt Black',
        hex: '#20231F',
        description: 'Deep matte charcoal black infused with natural carbon mineral oxides. Absorbs light cleanly in bright interiors.',
    },
    {
        name: 'Sage',
        tag: 'Muted Botanical Patina',
        hex: '#879080',
        description: 'Earthy grey-green derived from oxidized iron and silicate deposits. Complements leafy foliage and wood tones.',
    },
    {
        name: 'Clay',
        tag: 'Rich Terracotta Earth',
        hex: '#B8755D',
        description: 'Warm terracotta earth pigmented with natural red iron oxide. Designed for sunlit verandas and open courtyards.',
    },
];

const selectedFinish = ref(finishes[0]);
</script>

<template>
    <div class="bg-pm-ivory min-h-screen py-10 lg:py-16">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Breadcrumbs -->
            <nav class="flex items-center space-x-2 text-xs font-body text-pm-ink-muted mb-6" aria-label="Breadcrumb">
                <router-link to="/" class="hover:text-pm-ink transition-colors">Home</router-link>
                <span>/</span>
                <span class="text-pm-ink font-semibold">Material & Craft</span>
            </nav>

            <!-- Page Header -->
            <div class="pb-10 border-b border-pm-ink/10 mb-12">
                <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-medium block mb-2">
                    Material Architecture
                </span>
                <h1 class="font-display text-3xl sm:text-4xl lg:text-5xl font-bold text-pm-ink tracking-tight max-w-3xl">
                    Resin-Free Mineral Matrix
                </h1>
                <p class="font-body text-base sm:text-lg text-pm-ink-muted mt-4 max-w-2xl leading-relaxed">
                    Most contemporary decorative pots rely on synthetic polyester resins that off-gas VOCs, yellow in sunlight, and crack under heat. POTMAN planters are cast from 100% natural crushed limestone and mineral binders.
                </p>
            </div>

            <!-- Material Split Feature -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-14 items-center pb-16 border-b border-pm-ink/10">
                <div class="lg:col-span-6 relative aspect-[4/3] rounded-3xl overflow-hidden bg-[#EAE6DF] shadow-md border border-pm-ink/10">
                    <img 
                        src="/images/craft/mineral-macro-studio.jpg" 
                        alt="Macro close-up texture of POTMAN limestone composite surface" 
                        class="w-full h-full object-cover"
                    />
                    <div class="absolute bottom-4 left-4 bg-pm-ink/80 backdrop-blur-md text-white text-[11px] font-medium px-3.5 py-1.5 rounded-full">
                        Macro Detail · Crushed Limestone Texture
                    </div>
                </div>

                <div class="lg:col-span-6 space-y-6">
                    <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-semibold block">
                        The Core Difference
                    </span>
                    <h2 class="font-display text-2xl sm:text-3xl font-bold text-pm-ink leading-snug">
                        50% Lighter Than Concrete. 100% Free From Plastic Resins.
                    </h2>
                    <p class="font-body text-sm text-pm-ink-muted leading-relaxed">
                        By formulating high-purity calcium carbonate with proprietary lightweight cellular aggregates, our composite vessels achieve the enduring physical mass and tactile cold-stone feel of solid masonry, while weighing half as much as traditional poured cement.
                    </p>

                    <!-- Technical Comparison Table -->
                    <div class="p-5 bg-[#FAF9F5] border border-pm-ink/10 rounded-2xl space-y-3 text-xs">
                        <div class="flex justify-between py-1.5 border-b border-pm-ink/10">
                            <span class="text-pm-ink-muted font-medium">Synthetic Petroleum Resins</span>
                            <span class="text-emerald-700 font-bold">0% (Zero Plastic Matrix)</span>
                        </div>
                        <div class="flex justify-between py-1.5 border-b border-pm-ink/10">
                            <span class="text-pm-ink-muted font-medium">Mass Reduction vs Concrete</span>
                            <span class="text-pm-ink font-bold">Up to 50% Lighter Weight</span>
                        </div>
                        <div class="flex justify-between py-1.5 border-b border-pm-ink/10">
                            <span class="text-pm-ink-muted font-medium">VOC & Chemical Off-Gassing</span>
                            <span class="text-emerald-700 font-bold">None (Safe for Living Rooms)</span>
                        </div>
                        <div class="flex justify-between py-1.5">
                            <span class="text-pm-ink-muted font-medium">Weather & UV Resistance</span>
                            <span class="text-pm-ink font-bold">Inert Mineral Pigments (Never Fades)</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Natural Earthen Oxides Section -->
            <div class="py-16 border-b border-pm-ink/10">
                <div class="text-center max-w-2xl mx-auto mb-12">
                    <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-semibold block mb-2">
                        Organic Patinas
                    </span>
                    <h2 class="font-display text-3xl font-bold text-pm-ink">
                        Color From The Earth, Not Synthetic Paint
                    </h2>
                    <p class="font-body text-sm text-pm-ink-muted mt-2">
                        POTMAN colors are not spray-painted coats that chip or peel. Natural earthen oxides are thoroughly blended throughout the entire vessel matrix during casting.
                    </p>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div 
                        v-for="finish in finishes" 
                        :key="finish.name"
                        class="p-6 bg-white border border-pm-ink/10 rounded-2xl space-y-4 hover:shadow-md transition-shadow"
                    >
                        <div 
                            class="w-12 h-12 rounded-full shadow-inner border border-black/10" 
                            :style="{ backgroundColor: finish.hex }"
                        ></div>
                        <div>
                            <h3 class="font-display text-base font-bold text-pm-ink">{{ finish.name }}</h3>
                            <span class="text-xs text-pm-clay font-medium block mt-0.5">{{ finish.tag }}</span>
                        </div>
                        <p class="text-xs text-pm-ink-muted leading-relaxed font-body">
                            {{ finish.description }}
                        </p>
                    </div>
                </div>
            </div>

            <!-- Provenance & Workshop CTA -->
            <div class="mt-16 bg-[#20231F] text-white rounded-3xl p-8 sm:p-14 text-center max-w-4xl mx-auto space-y-6">
                <span class="text-[11px] uppercase tracking-[0.2em] text-pm-sand font-semibold block">
                    Provenence & Integrity
                </span>
                <h2 class="font-display text-3xl sm:text-4xl font-bold tracking-tight">
                    Crafted in Nigeria. Proportioned for Modern Spaces.
                </h2>
                <p class="text-xs sm:text-sm text-pm-ivory/80 max-w-xl mx-auto leading-relaxed">
                    Every vessel is sculpted in our Lagos studio workshop, cured under controlled humidity, and inspected for structural density before being crated for delivery nationwide.
                </p>
                <div class="pt-2">
                    <router-link 
                        to="/shop" 
                        class="inline-block bg-pm-ivory text-pm-ink hover:bg-white font-bold text-xs uppercase tracking-widest px-8 py-4 rounded-xl transition-all shadow-md"
                    >
                        Explore The Planters
                    </router-link>
                </div>
            </div>
        </div>
    </div>
</template>

