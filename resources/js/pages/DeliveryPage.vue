<script setup>
import BrandIcon from '../components/BrandIcon.vue';

const zones = [
    {
        title: 'Zone 1: Lagos Metropolitan',
        timeline: '24 to 48 Hours Dispatch',
        cost: '₦8,500 (Free over ₦120,000)',
        packaging: 'White-Glove Fragile Cargo Van',
        description: 'Dedicated studio transport directly to your doorstep in Ikoyi, Victoria Island, Lekki, Ikeja, and all mainland/island addresses. Unboxed and placed in position.',
    },
    {
        title: 'Zone 2: Regional Hubs',
        timeline: '2 to 4 Business Days',
        cost: '₦14,500 Flat Rate',
        packaging: 'Custom Timber Shock-Absorbing Crate',
        description: 'Fast-track freight service to Abuja FCT, Port Harcourt, Ibadan, Benin City, and Abeokuta. Anchored inside heavy wooden crates with internal foam cushioning.',
    },
    {
        title: 'Zone 3: Nationwide All 36 States',
        timeline: '3 to 5 Business Days',
        cost: '₦18,500 Flat Rate',
        packaging: 'Heavy Timber Reinforced Crate',
        description: 'Delivered to every state capital and commercial city across Nigeria (Kano, Kaduna, Enugu, Calabar, Jos, Asaba, Warri, Akure, etc.) with tracked waybill dispatch.',
    },
];

const faqs = [
    {
        q: 'What happens if a vessel is damaged during transit?',
        a: 'We offer an unconditional zero-breakage replacement guarantee. If a crate sustains impact and damages your vessel during transit, simply notify us with a photo within 48 hours of delivery and we will dispatch an identical replacement at zero charge.',
    },
    {
        q: 'Can POTMAN planters be placed on luxury hardwood or marble floors?',
        a: 'Yes. When ordering, select the Indoor (Sealed Base) option. The base is cast solid and treated with waterproof sealant, preventing moisture or soil runoff from reaching your floor.',
    },
    {
        q: 'How do I maintain the stone finish over time?',
        a: 'Clean with a soft microfiber cloth and lukewarm water. For optimal protection against hard water deposits and dust, apply Organic Mineral Sealant Wax every 6 months to nourish the stone patina.',
    },
    {
        q: 'What does the 3-Year Structural Guarantee cover?',
        a: 'It covers material integrity, structural cracking, seam separation, and weather-induced degradation under normal residential or commercial botanical use.',
    },
];
</script>

<template>
    <div class="bg-pm-ivory min-h-screen py-10 lg:py-16">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Breadcrumbs -->
            <nav class="flex items-center space-x-2 text-xs font-body text-pm-ink-muted mb-6" aria-label="Breadcrumb">
                <router-link to="/" class="hover:text-pm-ink transition-colors">Home</router-link>
                <span>/</span>
                <span class="text-pm-ink font-semibold">Delivery & Care</span>
            </nav>

            <!-- Page Header -->
            <div class="pb-10 border-b border-pm-ink/10 mb-14">
                <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-medium block mb-2">
                    Nationwide Logistics & Assurance
                </span>
                <h1 class="font-display text-3xl sm:text-4xl lg:text-5xl font-bold text-pm-ink tracking-tight max-w-3xl">
                    Delivered & Crated in Nigeria
                </h1>
                <p class="font-body text-base sm:text-lg text-pm-ink-muted mt-4 max-w-2xl leading-relaxed">
                    Every vessel is crated in bespoke shock-absorbing timber boxes to ensure safe arrival in all 36 Nigerian states. Backed by our zero-breakage transit replacement guarantee.
                </p>
            </div>

            <!-- Crating Photography & Feature -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-14 items-center pb-16 border-b border-pm-ink/10">
                <div class="lg:col-span-6 relative aspect-[4/3] rounded-3xl overflow-hidden bg-[#EAE6DF] shadow-md border border-pm-ink/10">
                    <img 
                        src="/images/craft/crated-packaging-studio.jpg" 
                        alt="Bespoke timber shock-absorbing crating used for nationwide POTMAN deliveries" 
                        class="w-full h-full object-cover"
                    />
                    <div class="absolute bottom-4 left-4 bg-pm-ink/80 backdrop-blur-md text-white text-[11px] font-medium px-3.5 py-1.5 rounded-full">
                        Custom Timber Shock-Absorbing Crate
                    </div>
                </div>

                <div class="lg:col-span-6 space-y-5">
                    <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-semibold block">
                        Transit Security
                    </span>
                    <h2 class="font-display text-2xl sm:text-3xl font-bold text-pm-ink leading-snug">
                        Zero Breakage Guarantee Across All 36 States
                    </h2>
                    <p class="font-body text-sm text-pm-ink-muted leading-relaxed">
                        Fine composite stone vessels require thoughtful logistical engineering. Rather than generic cardboard boxes, our workshop builds custom pine timber crates lined with high-density polyurethane foam corners to isolate the vessel from multi-axis road vibration.
                    </p>

                    <div class="pt-2 flex flex-wrap gap-4">
                        <router-link
                            to="/track-order"
                            class="inline-flex items-center space-x-2 bg-pm-ink hover:bg-pm-clay text-white px-6 py-3 rounded-xl text-xs font-bold uppercase tracking-wider transition-all shadow-md"
                        >
                            <BrandIcon name="truck" :size="15" />
                            <span>Track An Existing Order</span>
                        </router-link>
                        <router-link
                            to="/shop"
                            class="inline-flex items-center space-x-2 border border-pm-ink/20 hover:border-pm-ink text-pm-ink px-6 py-3 rounded-xl text-xs font-bold uppercase tracking-wider transition-all"
                        >
                            <span>Browse Collection</span>
                        </router-link>
                    </div>
                </div>
            </div>

            <!-- Shipping Zones Matrix -->
            <div class="py-16 border-b border-pm-ink/10">
                <div class="text-center max-w-2xl mx-auto mb-12">
                    <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-semibold block mb-2">
                        Delivery Pricing & Cadence
                    </span>
                    <h2 class="font-display text-3xl font-bold text-pm-ink">
                        Transparent Nationwide Rates
                    </h2>
                    <p class="font-body text-sm text-pm-ink-muted mt-2">
                        Calculated automatically in the checkout engine based on your selected state.
                    </p>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div 
                        v-for="zone in zones" 
                        :key="zone.title"
                        class="p-6 sm:p-8 bg-white border border-pm-ink/10 rounded-2xl flex flex-col justify-between space-y-4 hover:shadow-md transition-shadow"
                    >
                        <div>
                            <span class="text-[10px] font-bold uppercase tracking-wider text-pm-clay block mb-1">
                                {{ zone.timeline }}
                            </span>
                            <h3 class="font-display text-lg font-bold text-pm-ink">{{ zone.title }}</h3>
                            <span class="text-base font-bold text-pm-ink tabular-nums block mt-2 text-pm-clay">
                                {{ zone.cost }}
                            </span>
                            <p class="text-xs text-pm-ink-muted leading-relaxed font-body mt-3">
                                {{ zone.description }}
                            </p>
                        </div>

                        <div class="pt-4 border-t border-pm-ink/10 text-[11px] text-pm-ink-muted font-medium flex items-center space-x-1.5">
                            <BrandIcon name="box" :size="13" className="text-pm-clay shrink-0" />
                            <span>{{ zone.packaging }}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- FAQs Section -->
            <div class="py-16 max-w-3xl mx-auto">
                <div class="text-center mb-10">
                    <span class="text-[11px] font-body uppercase tracking-[0.16em] text-pm-clay font-semibold block mb-2">
                        Assurance Details
                    </span>
                    <h2 class="font-display text-2xl sm:text-3xl font-bold text-pm-ink">
                        Frequently Asked Questions
                    </h2>
                </div>

                <div class="space-y-4">
                    <div 
                        v-for="faq in faqs" 
                        :key="faq.q"
                        class="p-6 bg-white border border-pm-ink/10 rounded-2xl space-y-2"
                    >
                        <h3 class="font-display text-sm font-bold text-pm-ink">{{ faq.q }}</h3>
                        <p class="text-xs text-pm-ink-muted leading-relaxed font-body">{{ faq.a }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

