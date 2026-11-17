<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import BrandIcon from './BrandIcon.vue';

const messages = [
    'Made in Nigeria · Delivered to all 36 states',
    'Free crated delivery on orders over ₦150,000',
    'Resin-free mineral planters · 3-year warranty'
];

const currentIndex = ref(0);
let timer = null;

function nextMessage() {
    currentIndex.value = (currentIndex.value + 1) % messages.length;
}

function prevMessage() {
    currentIndex.value = (currentIndex.value - 1 + messages.length) % messages.length;
}

onMounted(() => {
    timer = setInterval(nextMessage, 5000);
});

onUnmounted(() => {
    if (timer) clearInterval(timer);
});
</script>

<template>
    <aside aria-label="Announcement" class="bg-pm-ink text-pm-ivory text-[11px] sm:text-xs tracking-[0.08em] uppercase py-2 px-4 font-body select-none">
        <div class="max-w-7xl mx-auto flex items-center justify-between gap-2">
            <button 
                @click="prevMessage" 
                class="text-pm-ivory hover:text-pm-sand transition-colors p-2 focus:outline-none"
                aria-label="Previous announcement"
            >
                <BrandIcon name="arrow-left" :size="12" />
            </button>

            <div class="overflow-hidden text-center flex-1 px-2">
                <Transition name="fade" mode="out-in">
                    <span :key="currentIndex" class="font-medium inline-block text-pm-ivory truncate max-w-full">
                        {{ messages[currentIndex] }}
                    </span>
                </Transition>
            </div>

            <button 
                @click="nextMessage" 
                class="text-pm-ivory hover:text-pm-sand transition-colors p-2 focus:outline-none"
                aria-label="Next announcement"
            >
                <BrandIcon name="arrow-right" :size="12" />
            </button>
        </div>
    </aside>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-enter-from {
    opacity: 0;
    transform: translateY(4px);
}

.fade-leave-to {
    opacity: 0;
    transform: translateY(-4px);
}
</style>

