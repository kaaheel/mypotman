<script setup>
import { useRouter } from 'vue-router';
import BrandIcon from '../components/BrandIcon.vue';

const router = useRouter();

const spaces = [
    {
        id: 'living-rooms',
        index: '01',
        tag: 'Residential Interiors',
        title: 'Sunlit Living Rooms & Corners',
        description: 'Internally sealed waterproof bases protect fine marble, hardwood, and tiled floors from moisture leaks or mineral staining. Proportioned to anchor statement foliage without visual clutter.',
        image: '/images/lifestyle/space-residence.jpg',
        featuredVessels: [
            { id: 'zuma-tall', name: 'Zuma Tall', slug: 'zuma-tall', finish: 'Ink', price: '₦58,000' },
            { id: 'kano-bowl', name: 'Kano Bowl', slug: 'kano-bowl', finish: 'Sand', price: '₦42,000' },
        ],
        idealPlants: 'Fiddle Leaf Fig, Strelitzia (Bird of Paradise), Olive Tree, Snake Plant',
    },
    {
        id: 'terraces-courtyards',
        index: '02',
        tag: 'Outdoor Living',
        title: 'Patios, Courtyards & Verandas',
        description: 'Cast with weatherproof mineral oxides that never fade or chalk under intense tropical sunlight. Pre-drilled drainage holes ensure heavy rainwater drains freely, keeping roots aerated and healthy.',
        image: '/images/lifestyle/space-courtyard.jpg',
        featuredVessels: [
            { id: 'oko-statement', name: 'Oko Statement', slug: 'oko-statement', finish: 'Clay', price: '₦76,000' },
            { id: 'kano-bowl', name: 'Kano Bowl', slug: 'kano-bowl', finish: 'Sand', price: '₦42,000' },
        ],
        idealPlants: 'Bougainvillea, Agave, Monsteras, Traveller Palms, Fan Palms',
    },
    {
        id: 'commercial-lobbies',
        index: '03',
        tag: 'Hospitality & Commercial',
        title: 'Boutique Lobbies & Reception Corridors',
        description: 'Monumental heights and substantial sculptural mass designed for double-height ceilings, gallery atriums, and hospitality entryways where standard retail planters appear undersized.',
        image: '/images/lifestyle/space-hospitality.jpg',
        featuredVessels: [
            { id: 'zuma-tall', name: 'Zuma Tall (Monumental)', slug: 'zuma-tall', finish: 'Ink', price: '₦78,000' },
            { id: 'oko-statement', name: 'Oko Statement (Colossus)', slug: 'oko-statement', finish: 'Clay', price: '₦100,000' },
        ],
        idealPlants: 'Kentia Palm, Dracaena, Large Schefflera, Bamboo Palm',
    },
];

function navigateToVessel(slug) {
    router.push({ name: 'product-detail', params: { slug } });
}
</script>

<template>
    <div class="bg-pm-ivory min-h-screen py-10 lg:py-16">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Breadcrumbs -->
            <nav class="flex items-center space-x-2 text-xs font-body text-pm-ink-muted mb-6" aria-label="Breadcrumb">
                <router-link to="/" class="hover:text-pm-ink transition-colors">Home</router-link>
                <span>/</span>
                <span class="text-pm-ink font-semibold">Curated Spaces</span>
            </nav>

            <!-- Page Header -->
            <div class="pb-10 border-b border-pm-ink/10 mb-14">
                <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-medium block mb-2">
                    Architectural Lookbook
                </span>
                <h1 class="font-display text-3xl sm:text-4xl lg:text-5xl font-bold text-pm-ink tracking-tight max-w-3xl">
                    Objects for Living Spaces
                </h1>
                <p class="font-body text-base sm:text-lg text-pm-ink-muted mt-4 max-w-2xl leading-relaxed">
                    Explore how POTMAN planters integrate into modern residential residences, courtyards, and boutique commercial environments.
                </p>
            </div>

            <!-- Spaces Editorial Stream -->
            <div class="space-y-24">
                <article 
                    v-for="space in spaces" 
                    :key="space.id" 
                    class="grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-14 items-center"
                >
                    <!-- Space Large Architectural Image (Cols 1-7) -->
                    <div class="lg:col-span-7 relative aspect-[4/3] rounded-3xl overflow-hidden bg-[#EAE6DF] shadow-md border border-pm-ink/10">
                        <img 
                            :src="space.image" 
                            :alt="space.title" 
                            class="w-full h-full object-cover"
                        />
                        <div class="absolute top-5 left-5 bg-pm-ivory/95 backdrop-blur-md text-pm-ink text-[10px] font-bold uppercase tracking-wider px-3.5 py-1.5 rounded-full border border-pm-ink/10">
                            {{ space.tag }}
                        </div>
                    </div>

                    <!-- Space Editorial & Vessels (Cols 8-12) -->
                    <div class="lg:col-span-5 space-y-6">
                        <div class="flex items-baseline space-x-3">
                            <span class="font-mono text-xs text-pm-clay font-bold">{{ space.index }}</span>
                            <span class="text-xs font-bold uppercase tracking-wider text-pm-ink-muted">{{ space.tag }}</span>
                        </div>

                        <h2 class="font-display text-2xl sm:text-3xl font-bold text-pm-ink leading-tight">
                            {{ space.title }}
                        </h2>

                        <p class="font-body text-sm text-pm-ink-muted leading-relaxed">
                            {{ space.description }}
                        </p>

                        <!-- Ideal Plants Callout -->
                        <div class="p-4 bg-[#FAF9F5] border border-pm-ink/10 rounded-2xl text-xs space-y-1">
                            <span class="block font-bold text-pm-ink uppercase tracking-wider text-[10px]">Recommended Botanical Pairings</span>
                            <p class="text-pm-ink-muted">{{ space.idealPlants }}</p>
                        </div>

                        <!-- Featured Vessels In This Space -->
                        <div class="pt-2">
                            <span class="block text-xs font-bold uppercase tracking-wider text-pm-ink mb-3">
                                Featured In This Space
                            </span>
                            <div class="space-y-2.5">
                                <button
                                    v-for="vessel in space.featuredVessels"
                                    :key="vessel.slug"
                                    @click="navigateToVessel(vessel.slug)"
                                    class="w-full p-3.5 bg-white hover:bg-[#FAF9F5] border border-pm-ink/10 hover:border-pm-ink/30 rounded-xl flex items-center justify-between transition-all text-left group"
                                >
                                    <div>
                                        <span class="block text-xs font-bold text-pm-ink group-hover:text-pm-clay transition-colors">{{ vessel.name }}</span>
                                        <span class="block text-[11px] text-pm-ink-muted font-body">Finish: {{ vessel.finish }} · {{ vessel.price }}</span>
                                    </div>
                                    <div class="flex items-center text-xs font-bold uppercase tracking-wider text-pm-ink space-x-1">
                                        <span>Configure</span>
                                        <BrandIcon name="arrow-right" :size="13" />
                                    </div>
                                </button>
                            </div>
                        </div>
                    </div>
                </article>
            </div>

            <!-- Custom Project Inquiries -->
            <div class="mt-24 p-8 sm:p-14 bg-white border border-pm-ink/10 rounded-3xl text-center max-w-3xl mx-auto space-y-4">
                <span class="text-[11px] uppercase tracking-wider text-pm-clay font-bold block">
                    Trade & Architects
                </span>
                <h3 class="font-display text-2xl sm:text-3xl font-bold text-pm-ink">
                    Working on a Residential or Commercial Project?
                </h3>
                <p class="text-xs sm:text-sm text-pm-ink-muted max-w-lg mx-auto leading-relaxed">
                    We partner with interior architects, landscape designers, and property developers for custom scale production, site delivery, and dedicated crating.
                </p>
                <div class="pt-2">
                    <router-link
                        to="/shop"
                        class="inline-block bg-pm-ink hover:bg-pm-clay text-white text-xs font-bold uppercase tracking-widest px-8 py-3.5 rounded-xl transition-all shadow-md"
                    >
                        Explore Complete Collection
                    </router-link>
                </div>
            </div>
        </div>
    </div>
</template>

