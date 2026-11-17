<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { cartStore } from '../stores/cart';
import BrandIcon from './BrandIcon.vue';
import { flyToCart } from '../utils/flyToCart';

const router = useRouter();

const props = defineProps({
    product: {
        type: Object,
        required: true,
    }
});

const selectedFinish = ref(props.product.defaultFinish || 'Sand');
const isAdding = ref(false);
const imageRef = ref(null);

function selectFinish(finishName) {
    selectedFinish.value = finishName;
}

function handleQuickAdd(e) {
    e.stopPropagation();
    isAdding.value = true;

    // Trigger Parabolic Fly-to-Cart Animation
    const originEl = imageRef.value || e.currentTarget;
    flyToCart(originEl, props.product.image, () => {
        cartStore.triggerImpact();
    });

    cartStore.addItem(props.product, selectedFinish.value, 'Indoor (Sealed base)', 'Standard', 1, { autoOpenDrawer: false });
    
    setTimeout(() => {
        isAdding.value = false;
    }, 650);
}

function handleCardClick() {
    router.push({ name: 'product-detail', params: { slug: props.product.slug } });
}
</script>

<template>
    <article 
        @click="handleCardClick"
        class="group relative flex flex-col cursor-pointer select-none"
    >
        <!-- Full-Bleed Architectural Portrait Gallery Frame (3:4 Ratio, Borderless) -->
        <div class="relative w-full aspect-[3/4] overflow-hidden bg-[#EAE6DF]">
            <img 
                ref="imageRef"
                :src="product.image" 
                :alt="product.name + ' architectural mineral composite planter'" 
                class="w-full h-full object-cover object-center transform transition-transform duration-700 ease-out group-hover:scale-[1.035]"
                loading="lazy"
            />

            <!-- Subtle Studio Highlight Pill -->
            <span 
                v-if="product.tag" 
                class="absolute top-4 left-4 bg-pm-ivory/95 backdrop-blur-xs text-pm-ink text-[10px] font-medium tracking-[0.14em] uppercase px-2.5 py-1 pointer-events-none"
            >
                {{ product.tag }}
            </span>

            <!-- Frosted Gallery Hover Action Bar (Desktop Hover Reveal) -->
            <div 
                class="hidden lg:flex absolute inset-x-4 bottom-4 items-center gap-2 opacity-0 translate-y-2 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300 ease-out"
                @click.stop
            >
                <button
                    @click="handleCardClick"
                    class="flex-1 bg-pm-ivory/95 hover:bg-white text-pm-ink text-[11px] font-medium uppercase tracking-[0.12em] py-3 px-4 transition-colors text-center shadow-sm"
                >
                    Configure
                </button>
                <button
                    @click="handleQuickAdd"
                    class="bg-pm-ink hover:bg-pm-clay text-pm-ivory text-[11px] font-medium uppercase tracking-[0.12em] py-3 px-4 transition-colors flex items-center justify-center gap-1.5 shadow-sm min-w-[116px]"
                    :aria-label="'Quick add ' + product.name"
                >
                    <BrandIcon :name="isAdding ? 'check' : 'plus'" :size="13" />
                    <span>{{ isAdding ? 'Added' : 'Quick Add' }}</span>
                </button>
            </div>
        </div>

        <!-- Clean Unboxed Editorial Metadata -->
        <div class="pt-4 flex flex-col">
            <!-- Row 1: Title + Price Aligned on Single Baseline -->
            <div class="flex items-baseline justify-between gap-4">
                <h3 class="font-display text-lg font-bold tracking-[-0.02em] text-pm-ink group-hover:text-pm-clay transition-colors duration-200">
                    {{ product.name }}
                </h3>
                <span class="font-body text-sm sm:text-base font-medium text-pm-ink tabular-nums shrink-0">
                    {{ product.formattedPrice }}
                </span>
            </div>

            <!-- Row 2: Scale & Weight Proof -->
            <p class="font-body text-xs text-pm-ink-muted mt-1 leading-normal">
                {{ product.dimensionsSummary }} · Indoor or outdoor
            </p>

            <!-- Row 3: Finish Swatches + Mobile Quick Action -->
            <div class="mt-3.5 flex items-center justify-between gap-3" @click.stop>
                <div class="flex items-center gap-2.5">
                    <div class="flex items-center gap-2.5">
                        <button
                            v-for="finish in product.finishes"
                            :key="finish.name"
                            @click="selectFinish(finish.name)"
                            :title="finish.label"
                            :class="[
                                'w-4 h-4 rounded-full transition-all duration-200 focus:outline-none',
                                selectedFinish === finish.name
                                    ? 'ring-1 ring-pm-ink ring-offset-2 ring-offset-pm-ivory scale-105'
                                    : 'hover:scale-105'
                            ]"
                            :style="{ backgroundColor: finish.hex }"
                            :aria-label="'Select ' + finish.name + ' finish'"
                        ></button>
                    </div>
                    <span class="text-xs text-pm-ink-muted font-body">
                        {{ selectedFinish }}
                    </span>
                </div>

                <!-- Touch-Friendly Quick Add (Visible below lg breakpoint) -->
                <button
                    @click="handleQuickAdd"
                    class="lg:hidden inline-flex items-center gap-1.5 text-[11px] uppercase tracking-[0.12em] font-medium text-pm-ink border border-pm-ink/25 px-3.5 py-2 hover:bg-pm-ink hover:text-pm-ivory transition-colors"
                    :aria-label="'Add ' + product.name + ' to bag'"
                >
                    <BrandIcon :name="isAdding ? 'check' : 'plus'" :size="12" />
                    <span>{{ isAdding ? 'Added' : 'Add' }}</span>
                </button>
            </div>
        </div>
    </article>
</template>
