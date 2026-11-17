<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { products } from '../data/products';
import { cartStore } from '../stores/cart';
import BrandIcon from './BrandIcon.vue';
import { scrollToTarget } from '../utils/scroll';

const router = useRouter();
const newsletterEmail = ref('');
const newsletterSuccess = ref(false);

function subscribeNewsletter() {
    if (!newsletterEmail.value) return;
    newsletterSuccess.value = true;
    setTimeout(() => {
        newsletterEmail.value = '';
        newsletterSuccess.value = false;
    }, 4000);
}

function openProductPage(slug) {
    router.push({ name: 'product-detail', params: { slug } });
}

function viewAllCollection() {
    cartStore.setCategory('all');
    router.push('/shop');
}
</script>

<template>
    <footer class="bg-pm-ink text-pm-ivory pt-16 pb-10">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <!-- Streamlined Architectural Footer Grid -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 pb-12 border-b border-white/10">
                <!-- Brand Wordmark (Cols 1-4) -->
                <div class="lg:col-span-4 space-y-4">
                    <img 
                        src="/brand/logos/POTMAN_Wordmark_White.svg" 
                        alt="POTMAN" 
                        class="h-5 w-auto"
                    />
                    <p class="font-body text-xs text-pm-sand leading-relaxed max-w-xs">
                        Lightweight mineral planters cast in Nigeria.
                    </p>
                </div>

                <!-- Clean 2-Column Navigation (Cols 5-8) -->
                <div class="lg:col-span-4 grid grid-cols-2 gap-8">
                    <div>
                        <h4 class="font-body text-[11px] font-semibold uppercase tracking-[0.14em] text-pm-sand mb-4">
                            Shop
                        </h4>
                        <ul class="space-y-3 text-xs text-pm-ivory font-body">
                            <li>
                                <button @click="openProductPage('kano-bowl')" class="hover:text-pm-sand transition-colors text-left py-0.5">
                                    Kano Bowl
                                </button>
                            </li>
                            <li>
                                <button @click="openProductPage('zuma-tall')" class="hover:text-pm-sand transition-colors text-left py-0.5">
                                    Zuma Tall
                                </button>
                            </li>
                            <li>
                                <button @click="openProductPage('oko-statement')" class="hover:text-pm-sand transition-colors text-left py-0.5">
                                    Oko Statement
                                </button>
                            </li>
                            <li>
                                <button @click="viewAllCollection" class="hover:text-pm-sand transition-colors text-left py-0.5">
                                    All Planters
                                </button>
                            </li>
                        </ul>
                    </div>

                    <div>
                        <h4 class="font-body text-[11px] font-semibold uppercase tracking-[0.14em] text-pm-sand mb-4">
                            Company
                        </h4>
                        <ul class="space-y-3 text-xs text-pm-ivory font-body">
                            <li><router-link to="/material" class="hover:text-pm-sand transition-colors text-left py-0.5 block">Our Material</router-link></li>
                            <li><router-link to="/spaces" class="hover:text-pm-sand transition-colors text-left py-0.5 block">Spaces Lookbook</router-link></li>
                            <li><router-link to="/delivery" class="hover:text-pm-sand transition-colors text-left py-0.5 block">Delivery & Warranty</router-link></li>
                            <li><router-link to="/track-order" class="hover:text-pm-sand transition-colors text-left py-0.5 block">Track Order & Waybill</router-link></li>
                        </ul>
                    </div>
                </div>

                <!-- Product Updates (Cols 9-12) -->
                <div class="lg:col-span-4">
                    <h4 class="font-body text-[11px] font-semibold uppercase tracking-[0.14em] text-pm-sand mb-3">
                        Product Updates
                    </h4>
                    <p class="text-xs text-pm-sand leading-relaxed mb-4">
                        Get notified on new planter sizes and finishes.
                    </p>

                    <form @submit.prevent="subscribeNewsletter">
                        <div class="flex border border-white/25 focus-within:border-pm-sand transition-colors">
                            <input 
                                v-model="newsletterEmail" 
                                type="email" 
                                required 
                                placeholder="Email address" 
                                class="flex-1 bg-transparent text-white placeholder-pm-sand/70 text-xs px-4 py-3 focus:outline-none min-w-0"
                            />
                            <button 
                                type="submit" 
                                class="bg-pm-ivory text-pm-ink hover:bg-white text-[11px] uppercase tracking-[0.14em] font-bold px-5 py-3 transition-colors shrink-0"
                            >
                                <span v-if="newsletterSuccess">Joined</span>
                                <span v-else>Join</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Minimal Legal & Payment Bar -->
            <div class="pt-7 flex flex-col sm:flex-row items-center justify-between text-xs text-pm-sand font-body gap-3">
                <span>© 2026 POTMAN</span>
                <span class="inline-flex items-center font-body text-[11px] uppercase tracking-[0.12em] text-pm-ivory font-medium">
                    <BrandIcon name="shield" :size="12" className="mr-1.5 text-pm-clay" />
                    Secured by Paystack
                </span>
            </div>
        </div>
    </footer>
</template>
