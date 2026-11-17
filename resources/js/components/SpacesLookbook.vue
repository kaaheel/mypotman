<script setup>
import { useRouter } from 'vue-router';
import { products } from '../data/products';
import { cartStore } from '../stores/cart';
import BrandIcon from './BrandIcon.vue';

const router = useRouter();

const primarySpace = {
    index: '01',
    tag: 'Living Rooms',
    title: 'Bright Interiors & Corners',
    summary: 'Internally sealed bases protect wood, tile, and stone floors from water damage.',
    image: '/images/lifestyle/space-residence.jpg',
    imageAlt: 'Sunlit living room styled with Zuma Tall matte black planter and pale mineral bowl',
    vessels: [
        { id: 'zuma-tall', label: 'Zuma Tall' },
        { id: 'kano-bowl', label: 'Kano Bowl' },
    ],
};

const secondarySpaces = [
    {
        index: '02',
        tag: 'Outdoors',
        title: 'Terraces & Courtyards',
        summary: 'Weatherproof color with pre-drilled drainage for rain.',
        image: '/images/lifestyle/space-courtyard.jpg',
        imageAlt: 'Travertine courtyard terrace with fluted terracotta Oko Statement and Sand Kano Bowl',
        vessels: [
            { id: 'oko-statement', label: 'Oko Statement' },
            { id: 'kano-bowl', label: 'Kano Bowl' },
        ],
    },
    {
        index: '03',
        tag: 'Commercial',
        title: 'Lobbies & Studios',
        summary: 'Tall planters scaled for double-height ceilings and hospitality spaces.',
        image: '/images/lifestyle/space-hospitality.jpg',
        imageAlt: 'Arched boutique reception corridor featuring Zuma Tall and travertine statement planter',
        vessels: [
            { id: 'zuma-tall', label: 'Zuma Tall' },
            { id: 'oko-statement', label: 'Oko Statement' },
        ],
    },
];

function openVessel(productId) {
    router.push({ name: 'product-detail', params: { slug: productId } });
}
</script>

<template>
    <section id="spaces" class="reveal-on-scroll bg-pm-ivory py-16 sm:py-24 lg:py-28">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Section Header -->
            <div class="flex flex-col lg:flex-row lg:items-end lg:justify-between gap-5 pb-8 mb-12 border-b border-pm-ink/10">
                <div class="max-w-xl">
                    <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-medium block mb-2.5">
                        In Your Space
                    </span>
                    <h2 class="font-display text-3xl sm:text-4xl lg:text-[2.5rem] font-bold text-pm-ink tracking-[-0.025em] leading-[1.12]">
                        Styled for every room.
                    </h2>
                </div>
                <p class="font-body text-sm sm:text-[15px] text-pm-ink-muted max-w-md leading-relaxed">
                    See how our planters fit homes, patios, and commercial lobbies. Tap any piece to configure it.
                </p>
            </div>

            <!-- Staggered Asymmetric Grid -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-y-12 lg:gap-x-12 items-start">
                <!-- Left Dominant Feature (7 Columns) -->
                <article 
                    @click="openVessel(primarySpace.vessels[0].id)"
                    class="lg:col-span-7 group flex flex-col cursor-pointer select-none"
                >
                    <div class="relative w-full aspect-[4/4.4] overflow-hidden bg-[#EAE6DF]">
                        <img 
                            :src="primarySpace.image" 
                            :alt="primarySpace.imageAlt" 
                            class="w-full h-full object-cover object-center transform transition-transform duration-700 ease-out group-hover:scale-[1.03]"
                            loading="lazy"
                        />

                        <!-- Hover Prompt -->
                        <div class="hidden lg:flex absolute inset-x-5 bottom-5 items-center justify-between bg-pm-ivory/95 backdrop-blur-xs px-5 py-3.5 opacity-0 translate-y-2 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300 ease-out shadow-sm">
                            <span class="text-[11px] font-medium uppercase tracking-[0.12em] text-pm-ink">
                                View {{ primarySpace.vessels[0].label }}
                            </span>
                            <BrandIcon name="arrow-right" :size="13" className="text-pm-ink" />
                        </div>
                    </div>

                    <div class="pt-5 flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4">
                        <div>
                            <span class="text-[11px] font-body uppercase tracking-[0.14em] text-pm-clay font-medium block">
                                {{ primarySpace.index }} · {{ primarySpace.tag }}
                            </span>
                            <h3 class="font-display text-xl md:text-2xl font-bold tracking-[-0.02em] text-pm-ink mt-1.5 group-hover:text-pm-clay transition-colors">
                                {{ primarySpace.title }}
                            </h3>
                            <p class="font-body text-sm text-pm-ink-muted mt-1.5 max-w-md leading-relaxed">
                                {{ primarySpace.summary }}
                            </p>
                        </div>

                        <!-- Direct In-Room Triggers -->
                        <div class="flex items-center gap-4 shrink-0" @click.stop>
                            <button
                                v-for="v in primarySpace.vessels"
                                :key="v.id"
                                @click="openVessel(v.id)"
                                class="inline-flex items-center text-xs uppercase tracking-[0.12em] font-semibold text-pm-ink hover:text-pm-clay border-b border-pm-ink/30 hover:border-pm-clay py-1 transition-colors"
                            >
                                {{ v.label }}
                            </button>
                        </div>
                    </div>
                </article>

                <!-- Right Offset Pair (5 Columns) -->
                <div class="lg:col-span-5 lg:mt-14 flex flex-col gap-12">
                    <article 
                        v-for="space in secondarySpaces" 
                        :key="space.index"
                        @click="openVessel(space.vessels[0].id)"
                        class="group flex flex-col cursor-pointer select-none"
                    >
                        <div class="relative w-full aspect-[4/3] overflow-hidden bg-[#EAE6DF]">
                            <img 
                                :src="space.image" 
                                :alt="space.imageAlt" 
                                class="w-full h-full object-cover object-center transform transition-transform duration-700 ease-out group-hover:scale-[1.03]"
                                loading="lazy"
                            />
                        </div>

                        <div class="pt-4">
                            <div class="flex flex-wrap items-center justify-between gap-3">
                                <span class="text-[11px] font-body uppercase tracking-[0.14em] text-pm-clay font-medium">
                                    {{ space.index }} · {{ space.tag }}
                                </span>
                                <div class="flex items-center gap-3.5" @click.stop>
                                    <button
                                        v-for="v in space.vessels"
                                        :key="v.id"
                                        @click="openVessel(v.id)"
                                        class="text-[11px] uppercase tracking-[0.12em] font-semibold text-pm-ink hover:text-pm-clay py-1 transition-colors"
                                    >
                                        {{ v.label }}
                                    </button>
                                </div>
                            </div>

                            <h3 class="font-display text-lg md:text-xl font-bold tracking-[-0.02em] text-pm-ink mt-1.5 group-hover:text-pm-clay transition-colors">
                                {{ space.title }}
                            </h3>
                            <p class="font-body text-sm text-pm-ink-muted mt-1 leading-relaxed">
                                {{ space.summary }}
                            </p>
                        </div>
                    </article>
                </div>
            </div>

            <!-- Link to Dedicated Spaces Page -->
            <div class="mt-14 text-center">
                <router-link
                    to="/spaces"
                    class="inline-flex items-center space-x-2 border border-pm-ink/20 hover:border-pm-ink text-pm-ink hover:text-pm-clay px-8 py-3.5 rounded-xl text-xs font-bold uppercase tracking-widest transition-all"
                >
                    <span>Explore Full Spaces Lookbook</span>
                    <BrandIcon name="arrow-right" :size="14" />
                </router-link>
            </div>
        </div>
    </section>
</template>
