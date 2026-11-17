<script setup>
import { ref, onMounted } from 'vue';

const STORAGE_KEY = 'potman_preloader_seen_at';
const TWENTY_FOUR_HOURS = 24 * 60 * 60 * 1000;

const isVisible = ref(false);
const stage = ref('center-idle'); 
// 'center-idle' -> 'smiling' -> 'blooming' -> 'exiting'

function startChoreography() {
    // 1. Initial State: "O" is enlarged & centered in the dead-center of the screen
    stage.value = 'center-idle';

    // 2. The Smile Awakening (Clear, obvious, joyful expression with motion)
    setTimeout(() => {
        stage.value = 'smiling';
    }, 600);

    // 3. Return & Horizontal Accordion Bloom (Smooth glide into place + P-T-M-A-N expansion)
    setTimeout(() => {
        stage.value = 'blooming';
    }, 2200);

    // 4. Smooth curtain dissolve to reveal storefront
    setTimeout(() => {
        stage.value = 'exiting';
        setTimeout(() => {
            isVisible.value = false;
        }, 750);
    }, 3700);
}

onMounted(() => {
    // 24-Hour First Visit Check: only show once every 24 hours (or if ?preloader=true is passed for testing)
    const urlParams = new URLSearchParams(window.location.search);
    const forcePreview = urlParams.get('preloader') === 'true' || urlParams.get('preview') === 'true';

    const lastSeen = localStorage.getItem(STORAGE_KEY);
    const hasSeenRecently = lastSeen && (Date.now() - parseInt(lastSeen, 10)) < TWENTY_FOUR_HOURS;

    if (hasSeenRecently && !forcePreview) {
        isVisible.value = false;
        return;
    }

    // Record timestamp for the 24h cooldown
    localStorage.setItem(STORAGE_KEY, Date.now().toString());
    isVisible.value = true;
    startChoreography();
});
</script>

<template>
    <Teleport to="body">
        <aside 
            v-if="isVisible" 
            :class="[
                'fixed inset-0 z-[100] flex flex-col items-center justify-center bg-pm-ivory select-none transition-all duration-750 ease-luxury',
                stage === 'exiting' ? 'opacity-0 pointer-events-none scale-[1.02] -translate-y-6' : 'opacity-100'
            ]"
            aria-label="POTMAN Brand Preloader"
        >
            <!-- Vector Stage Container -->
            <div class="relative w-full max-w-[340px] sm:max-w-[500px] md:max-w-[620px] px-6 aspect-[649/109] flex items-center justify-center">
                <!-- 
                  SVG ViewBox is 649 x 109. Center of wordmark is X = 324.5.
                  Center of "O" is X = 178.5.
                  Difference is exactly +146px.
                  When stage is 'center-idle' or 'smiling', we shift the entire root group by +146px
                  so the "O" is 100% mathematically and visually centered in the middle of the screen!
                  When stage is 'blooming', it smoothly glides back to 0px!
                -->
                <svg 
                    viewBox="0 0 649 109" 
                    class="w-full h-auto overflow-visible"
                    xmlns="http://www.w3.org/2000/svg"
                >
                    <!-- Main Master Shift Group -->
                    <g 
                        :class="[
                            'master-group transition-transform duration-900 ease-luxury',
                            stage === 'blooming' || stage === 'exiting' 
                                ? 'translate-x-0' 
                                : 'translate-x-[146px]'
                        ]"
                    >
                        <!-- ================= LETTER P ================= -->
                        <!-- Emerging from the left of the O -->
                        <g 
                            :class="[
                                'transition-all duration-800 ease-luxury',
                                stage === 'blooming' || stage === 'exiting' 
                                    ? 'opacity-100 translate-x-0 scale-100' 
                                    : 'opacity-0 translate-x-[110px] scale-75'
                            ]"
                        >
                            <path 
                                d="M 0,3 L 65,3 C 92,3 113,20 113,42 C 114,62 104,73 82,79 C 66,83 48,81 33,78 L 32,108 L 0,108 Z M 33,31 L 81,31 C 81,45 77,52 66,56 C 55,60 42,57 32,52 Z" 
                                fill="#20231F" 
                                fill-rule="evenodd"
                            />
                        </g>

                        <!-- ================= LETTER O (The Star Hero) ================= -->
                        <g 
                            id="hero-o-character"
                            :class="[
                                'origin-[178px_54px] transition-all duration-800 ease-luxury',
                                stage === 'center-idle' ? 'scale-[1.22]' : '',
                                stage === 'smiling' ? 'scale-[1.28] rotate-[2.5deg]' : '',
                                stage === 'blooming' || stage === 'exiting' ? 'scale-100 rotate-0' : ''
                            ]"
                        >
                            <!-- O Outer Black Solid Ring -->
                            <path 
                                d="M 178,0 C 211,0 237,23 237,54 C 237,86 211,109 178,109 C 145,109 120,85 120,54 C 120,23 145,0 178,0 Z" 
                                fill="#20231F" 
                            />

                            <!-- 
                              Playful Happy Eyes (Active during the Smile phase to make it unmistakably human & joyful!)
                              Two subtle upturned smiling arc eyes matching the brand line-weight.
                            -->
                            <g 
                                :class="[
                                    'transition-all duration-500 ease-out',
                                    stage === 'smiling' ? 'opacity-100 scale-100' : 'opacity-0 scale-75'
                                ]"
                                transform="translate(0, -2)"
                            >
                                <!-- Left Eye Arc -->
                                <path 
                                    d="M 152,32 C 156,26 166,26 170,32" 
                                    stroke="#F5F2EB" 
                                    stroke-width="5" 
                                    stroke-linecap="round" 
                                    fill="none"
                                />
                                <!-- Right Eye Arc -->
                                <path 
                                    d="M 186,32 C 190,26 200,26 204,32" 
                                    stroke="#F5F2EB" 
                                    stroke-width="5" 
                                    stroke-linecap="round" 
                                    fill="none"
                                />
                            </g>

                            <!-- 
                              The Obvious Smile Mouth (Ivory cutout):
                              In smiling phase: Deep upturned grin with high corners (137, 40) and deep curved chin (178, 88).
                              In blooming phase: Smoothly transitions into the exact architectural planter bowl (141, 49 -> 178, 84).
                            -->
                            <path 
                                :d="stage === 'smiling' 
                                    ? 'M 137,42 C 156,56 200,56 219,42 C 218,72 199,89 178,89 C 157,89 138,72 137,42 Z' 
                                    : 'M 141,49 H 213 C 212,69 198,84 178,84 C 158,84 144,70 141,49 Z'"
                                fill="#F5F2EB" 
                                class="transition-all duration-600 ease-luxury"
                            />
                        </g>

                        <!-- ================= LETTER T ================= -->
                        <g 
                            :class="[
                                'transition-all duration-750 ease-luxury',
                                stage === 'blooming' || stage === 'exiting' 
                                    ? 'opacity-100 translate-x-0 scale-100 delay-[40ms]' 
                                    : 'opacity-0 -translate-x-[60px] scale-75'
                            ]"
                        >
                            <path 
                                d="M 236,3 H 319 V 29 H 291 V 108 H 260 V 29 H 236 Z" 
                                fill="#20231F" 
                            />
                        </g>

                        <!-- ================= LETTER M ================= -->
                        <g 
                            :class="[
                                'transition-all duration-800 ease-luxury',
                                stage === 'blooming' || stage === 'exiting' 
                                    ? 'opacity-100 translate-x-0 scale-100 delay-[90ms]' 
                                    : 'opacity-0 -translate-x-[120px] scale-75'
                            ]"
                        >
                            <path 
                                d="M 326,3 V 108 H 354 L 355,66 L 379,102 H 387 L 409,66 L 410,108 H 440 V 3 H 412 L 382,49 L 352,3 Z" 
                                fill="#20231F" 
                            />
                        </g>

                        <!-- ================= LETTER A ================= -->
                        <g 
                            :class="[
                                'transition-all duration-850 ease-luxury',
                                stage === 'blooming' || stage === 'exiting' 
                                    ? 'opacity-100 translate-x-0 scale-100 delay-[140ms]' 
                                    : 'opacity-0 -translate-x-[180px] scale-75'
                            ]"
                        >
                            <path 
                                d="M 487,3 L 444,108 H 474 L 482,90 H 515 L 523,108 H 552 L 509,3 Z M 499,44 L 508,66 L 490,67 Z" 
                                fill="#20231F" 
                                fill-rule="evenodd"
                            />
                        </g>

                        <!-- ================= LETTER N ================= -->
                        <g 
                            :class="[
                                'transition-all duration-900 ease-luxury',
                                stage === 'blooming' || stage === 'exiting' 
                                    ? 'opacity-100 translate-x-0 scale-100 delay-[190ms]' 
                                    : 'opacity-0 -translate-x-[240px] scale-75'
                            ]"
                        >
                            <path 
                                d="M 557,3 V 108 H 585 L 586,63 L 620,108 H 648 V 4 L 619,3 V 50 L 617,51 L 584,3 Z" 
                                fill="#20231F" 
                            />
                        </g>
                    </g>
                </svg>
            </div>

            <!-- Brand Tagline Fade-In (Tight architectural lockup directly below wordmark) -->
            <div 
                :class="[
                    'mt-3 sm:mt-3.5 text-center transition-all duration-700 ease-luxury',
                    stage === 'blooming' || stage === 'exiting' 
                        ? 'opacity-100 translate-y-0 delay-200' 
                        : 'opacity-0 translate-y-2'
                ]"
            >
                <span class="text-[11px] sm:text-xs font-body uppercase tracking-[0.06em] text-pm-ink-muted font-medium">
                    Made for spaces that grow
                </span>
            </div>
        </aside>
    </Teleport>
</template>

<style scoped>
/* Masterclass cubic-bezier luxury curve (smooth spring with generous fluid deceleration) */
.ease-luxury {
    transition-timing-function: cubic-bezier(0.16, 1, 0.3, 1);
}
</style>
