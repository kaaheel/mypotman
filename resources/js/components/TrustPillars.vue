<script setup>
import { trustPillars } from '../data/products';
import BrandIcon from './BrandIcon.vue';
</script>

<template>
    <section class="border-y border-pm-ink/10 bg-[#FAF9F5] py-20 lg:py-24">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Section Header: Left-Aligned Editorial Hierarchy with Tension -->
            <div class="flex flex-col md:flex-row md:items-end md:justify-between mb-16 gap-6">
                <div class="max-w-2xl">
                    <span class="text-xs uppercase tracking-[0.18em] text-pm-clay font-semibold block mb-3 font-mono">
                        The Manufacturing Benchmark · 2026
                    </span>
                    <h2 class="font-display text-3xl sm:text-4xl lg:text-5xl font-semibold text-pm-ink tracking-tight leading-[1.15]">
                        Cast for permanence. <br />
                        Sculpted for living spaces.
                    </h2>
                </div>
                <p class="font-body text-xs sm:text-sm text-pm-ink/70 max-w-md leading-relaxed">
                    Engineered from natural mineral stone and non-toxic earthen binders. An uncompromising material composition designed to eclipse mass-market fiberglass, brittle ceramics, and solid poured concrete.
                </p>
            </div>

            <!-- Architectural 4-Column Hairline Grid (No Cheap Floating Boxes) -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 border-t border-b border-pm-ink/10 divide-y sm:divide-y-0 sm:divide-x divide-pm-ink/10">
                <div 
                    v-for="pillar in trustPillars" 
                    :key="pillar.title"
                    class="group flex flex-col justify-between p-6 sm:p-8 lg:p-10 transition-colors duration-300 hover:bg-pm-ivory/60"
                >
                    <!-- Top Row: Index + Outline Icon -->
                    <div>
                        <div class="flex items-center justify-between mb-8">
                            <span class="font-mono text-xs text-pm-ink/40 tracking-wider font-semibold">
                                {{ pillar.index }} / 04
                            </span>
                            <div class="text-pm-ink group-hover:text-pm-clay transition-colors duration-300">
                                <BrandIcon :name="pillar.icon" :size="22" :strokeWidth="1.5" />
                            </div>
                        </div>

                        <!-- Micro Tag -->
                        <span class="text-[10px] font-mono uppercase tracking-[0.18em] text-pm-clay font-semibold block mb-2">
                            {{ pillar.tag }}
                        </span>

                        <!-- Pillar Title -->
                        <h3 class="font-display text-base sm:text-lg font-semibold tracking-tight text-pm-ink mb-3 leading-snug">
                            {{ pillar.title }}
                        </h3>

                        <!-- Body Copy: Left-aligned for effortless readability -->
                        <p class="font-body text-xs sm:text-[13px] text-pm-ink/70 leading-relaxed font-normal">
                            {{ pillar.description }}
                        </p>
                    </div>

                    <!-- Bottom Technical Metric -->
                    <div class="pt-8 mt-6 border-t border-pm-ink/8 flex items-center justify-between">
                        <span class="text-[11px] font-mono text-pm-ink/50 tracking-wider uppercase">
                            {{ pillar.stat }}
                        </span>
                        <span class="w-1.5 h-1.5 rounded-full bg-pm-clay opacity-0 group-hover:opacity-100 transition-opacity"></span>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
