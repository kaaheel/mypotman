<script setup>
import HeroSection from '../components/HeroSection.vue';
import ProductGrid from '../components/ProductGrid.vue';
import CraftShowcase from '../components/CraftShowcase.vue';
import SpacesLookbook from '../components/SpacesLookbook.vue';
import AssuranceStrip from '../components/AssuranceStrip.vue';
</script>

<template>
    <div>
        <!-- 01. Hero Banner: 'Objects for living spaces' -->
        <HeroSection />

        <!-- 02. Studio Collection & Inline Filter -->
        <ProductGrid />

        <!-- 03. Materiality & Crated Transit Split -->
        <CraftShowcase />

        <!-- 04. Curated Spaces Lookbook -->
        <SpacesLookbook />

        <!-- 05. Studio Guarantees & Assurance Index -->
        <AssuranceStrip />
    </div>
</template>

