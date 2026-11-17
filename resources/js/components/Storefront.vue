<script setup>
import AnnouncementBar from './AnnouncementBar.vue';
import HeaderNav from './HeaderNav.vue';
import FooterSection from './FooterSection.vue';
import FloatingCartBar from './FloatingCartBar.vue';
import PreloaderScreen from './PreloaderScreen.vue';
</script>

<template>
    <div class="min-h-screen flex flex-col bg-pm-ivory text-pm-ink selection:bg-pm-clay selection:text-white">
        <!-- Brand Preloader Screen (Rate-limited to 24h) -->
        <PreloaderScreen />

        <!-- Top Announcement Bar -->
        <AnnouncementBar />

        <!-- Sticky Header with Wordmark and Utilities -->
        <HeaderNav />

        <!-- Dynamic Routed Page View -->
        <main class="flex-1">
            <router-view />
        </main>

        <!-- Architectural Footer -->
        <FooterSection />

        <!-- Floating Spatial Cart Tray -->
        <FloatingCartBar />
    </div>
</template>
