<script setup>
import { ref, computed } from 'vue';
import BrandIcon from './BrandIcon.vue';
import { scrollToTarget } from '../utils/scroll';

const materials = [
    { name: 'Sand', hex: '#C8B9A4', origin: 'Warm travertine limestone finish' },
    { name: 'Ink', hex: '#20231F', origin: 'Deep matte charcoal basalt finish' },
    { name: 'Sage', hex: '#879080', origin: 'Muted sage green mineral finish' },
    { name: 'Clay', hex: '#B8755D', origin: 'Warm terracotta oxide finish' },
];

const activeMaterialName = ref('Sand');
const activeMaterial = computed(() => materials.find(m => m.name === activeMaterialName.value) || materials[0]);

const proofs = [
    { label: '0% Plastic Resin', detail: 'Crushed limestone and natural binders' },
    { label: 'Up to 50% Lighter', detail: 'Easy to lift onto floors and balconies' },
    { label: 'Timber-Crated Transit', detail: 'Insured delivery across all 36 states' },
];

import { useRouter } from 'vue-router';

const router = useRouter();

function scrollToCollection() {
    router.push('/shop');
}
</script>

<template>
    <section id="craft" class="reveal-on-scroll bg-[#EFECE4] py-16 sm:py-24 lg:py-28 transition-colors">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Asymmetric Materiality & Crating Split -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 sm:gap-12 lg:gap-16 items-center">
                <!-- Left Visual Authority (~60%) -->
                <div class="lg:col-span-7 relative group">
                    <div class="relative w-full aspect-[4/5] bg-[#E5E0D7] overflow-hidden">
                        <img 
                            src="/images/craft/mineral-macro-studio.jpg" 
                            alt="Macro view of raw crushed limestone and terracotta clay mineral composite planters" 
                            class="w-full h-full object-cover object-center transform transition-transform duration-1000 ease-out group-hover:scale-[1.025]"
                            loading="lazy"
                        />
                    </div>

                    <!-- Staggered Secondary Inset: Timber Crating Proof (Desktop) -->
                    <div class="hidden sm:block absolute bottom-6 right-6 w-56 bg-pm-ivory p-2.5 shadow-xl">
                        <div class="aspect-[4/3] overflow-hidden bg-[#E5E0D7]">
                            <img 
                                src="/images/craft/crated-packaging-studio.jpg" 
                                alt="Timber-braced protective shipping crate cradling architectural planter" 
                                class="w-full h-full object-cover"
                                loading="lazy"
                            />
                        </div>
                        <div class="pt-2.5 pb-0.5 px-1 flex items-center justify-between text-[11px] font-body uppercase tracking-[0.12em] font-medium text-pm-ink">
                            <span>Timber Crated</span>
                            <span class="text-pm-clay">36 States</span>
                        </div>
                    </div>

                    <!-- Clean Crating Strip on Mobile -->
                    <div class="sm:hidden mt-4 bg-pm-ivory p-3.5 flex items-center gap-4">
                        <img 
                            src="/images/craft/crated-packaging-studio.jpg" 
                            alt="Timber-braced protective shipping crate" 
                            class="w-20 h-16 object-cover shrink-0 bg-[#E5E0D7]"
                            loading="lazy"
                        />
                        <div>
                            <span class="block text-[11px] font-body uppercase tracking-[0.14em] text-pm-clay font-medium">
                                Safe Delivery
                            </span>
                            <span class="block text-xs font-medium text-pm-ink mt-0.5 leading-snug">
                                Timber-crated shipping with breakage replacement across Nigeria
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Right Editorial Column (~40%) -->
                <div class="lg:col-span-5 lg:pl-4">
                    <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-medium block mb-3">
                        Our Material
                    </span>

                    <h2 class="font-display text-3xl sm:text-4xl lg:text-[2.5rem] font-bold text-pm-ink tracking-[-0.025em] leading-[1.12] mb-5">
                        Real stone, half the weight.
                    </h2>

                    <p class="font-body text-sm sm:text-[15px] text-pm-ink-muted leading-relaxed mb-7">
                        Hand-cast in Nigeria from crushed limestone and natural mineral pigments. Built for coastal heat, sunlight, and heavy rain without synthetic plastics.
                    </p>

                    <!-- Interactive Finish Specimen Strip -->
                    <div class="mb-7">
                        <div class="flex items-center justify-between mb-3">
                            <span class="text-[11px] font-body uppercase tracking-[0.14em] text-pm-ink-muted font-medium">
                                Finish Colors
                            </span>
                            <span class="text-xs font-semibold text-pm-ink">
                                {{ activeMaterial.name }}
                            </span>
                        </div>
                        <div class="flex items-center gap-3.5 mb-2.5">
                            <button
                                v-for="mat in materials"
                                :key="mat.name"
                                @click="activeMaterialName = mat.name"
                                :class="[
                                    'w-7 h-7 rounded-full transition-all duration-200 focus:outline-none',
                                    activeMaterialName === mat.name
                                        ? 'ring-1 ring-pm-ink ring-offset-2 ring-offset-[#EFECE4] scale-105'
                                        : 'hover:scale-105'
                                ]"
                                :style="{ backgroundColor: mat.hex }"
                                :aria-label="'Inspect ' + mat.name + ' mineral pigment'"
                            ></button>
                        </div>
                        <p class="text-xs font-body text-pm-ink-muted min-h-[18px]">
                            {{ activeMaterial.origin }}
                        </p>
                    </div>

                    <!-- Verifiable Trust List -->
                    <div class="divide-y divide-pm-ink/10 border-y border-pm-ink/10">
                        <div 
                            v-for="item in proofs" 
                            :key="item.label" 
                            class="py-3.5 flex flex-col sm:flex-row sm:items-baseline sm:justify-between gap-1 sm:gap-4"
                        >
                            <span class="text-xs font-display font-bold text-pm-ink shrink-0">
                                {{ item.label }}
                            </span>
                            <span class="text-xs font-body text-pm-ink-muted sm:text-right">
                                {{ item.detail }}
                            </span>
                        </div>
                    </div>

                    <!-- Understated Editorial Action Anchor -->
                    <div class="mt-7 flex items-center justify-between gap-4">
                        <button 
                            @click="scrollToCollection"
                            class="inline-flex items-center text-xs uppercase tracking-[0.14em] font-bold text-pm-ink hover:text-pm-clay transition-colors group/cta py-2"
                        >
                            <span>Shop All Planters</span>
                            <BrandIcon name="arrow-right" :size="14" className="ml-2 transform group-hover/cta:translate-x-1 transition-transform" />
                        </button>
                        <span class="text-[11px] font-body uppercase tracking-[0.12em] text-pm-ink-muted font-medium">
                            3-Year Warranty
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
