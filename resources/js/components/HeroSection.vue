<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import BrandIcon from './BrandIcon.vue';
import { scrollToTarget } from '../utils/scroll';

const router = useRouter();
const canvasRef = ref(null);
const isWebGLActive = ref(false);

const slides = [
    {
        url: '/images/lifestyle/hero-living-spaces.jpg',
        focal: [0.65, 0.5], // Terrace: planters centered around 65%
    },
    {
        url: '/images/lifestyle/hero-interior-atrium.jpg',
        focal: [0.78, 0.5], // Interior: planters centered around 78%
    },
    {
        url: '/images/lifestyle/hero-courtyard-patio.jpg',
        focal: [0.68, 0.5], // Courtyard: planters centered around 68%
    },
];

let gl = null;
let program = null;
let textures = [];
let animFrameId = null;

let currentSlideIndex = 0;
let slideStartTime = 0;
let isTransitioning = false;
let transitionStartTime = 0;

const slideDuration = 8000; // 8 seconds per slide
const transitionDuration = 2000; // 2 seconds silky smooth crossfade

const vsSource = `
    attribute vec2 a_position;
    varying vec2 v_uv;
    void main() {
        v_uv = (a_position + 1.0) * 0.5;
        v_uv.y = 1.0 - v_uv.y;
        gl_Position = vec4(a_position, 0.0, 1.0);
    }
`;

const fsSource = `
    precision mediump float;
    uniform sampler2D u_current;
    uniform sampler2D u_next;
    uniform float u_progress;
    uniform float u_zoom_current;
    uniform float u_zoom_next;
    uniform vec2 u_focal_current;
    uniform vec2 u_focal_next;
    uniform vec2 u_resolution;
    uniform vec2 u_img_resolution;
    varying vec2 v_uv;

    vec2 getCoverUV(vec2 uv, vec2 screenRes, vec2 imgRes, vec2 focal, float zoom) {
        float screenAspect = screenRes.x / screenRes.y;
        float imgAspect = imgRes.x / imgRes.y;
        vec2 scale = vec2(1.0);
        
        if (screenAspect > imgAspect) {
            // Widescreen desktop
            scale = vec2(1.0, imgAspect / screenAspect);
        } else {
            // Mobile portrait: scale X down to fit height
            scale = vec2(screenAspect / imgAspect, 1.0);
        }
        
        // Smart Mobile Responsive Centering:
        // On portrait mobile (screenAspect < 1.0), shift the visible slice directly to the pots!
        float isPortrait = 1.0 - smoothstep(0.75, 1.15, screenAspect);
        float halfWidth = 0.5 * scale.x;
        float clampedFocalX = clamp(focal.x, halfWidth, 1.0 - halfWidth);
        float targetCenterX = mix(0.5, clampedFocalX, isPortrait);
        
        vec2 targetCenter = vec2(targetCenterX, 0.5);

        vec2 centered = (uv - 0.5) * scale;
        // Subtle independent zoom
        centered *= (1.0 - zoom * 0.05);
        return clamp(centered + targetCenter, 0.001, 0.999);
    }

    void main() {
        vec2 uv1 = getCoverUV(v_uv, u_resolution, u_img_resolution, u_focal_current, u_zoom_current);
        vec2 uv2 = getCoverUV(v_uv, u_resolution, u_img_resolution, u_focal_next, u_zoom_next);
        
        vec4 c1 = texture2D(u_current, uv1);
        vec4 c2 = texture2D(u_next, uv2);
        
        float t = smoothstep(0.0, 1.0, u_progress);
        gl_FragColor = mix(c1, c2, t);
    }
`;

function createShader(glContext, type, source) {
    const shader = glContext.createShader(type);
    glContext.shaderSource(shader, source);
    glContext.compileShader(shader);
    if (!glContext.getShaderParameter(shader, glContext.COMPILE_STATUS)) {
        console.error('Shader compile error:', glContext.getShaderInfoLog(shader));
        glContext.deleteShader(shader);
        return null;
    }
    return shader;
}

function loadTexture(glContext, url) {
    return new Promise((resolve) => {
        const tex = glContext.createTexture();
        const img = new Image();
        img.crossOrigin = 'anonymous';
        img.onload = () => {
            glContext.bindTexture(glContext.TEXTURE_2D, tex);
            glContext.pixelStorei(glContext.UNPACK_FLIP_Y_WEBGL, false);
            glContext.texImage2D(glContext.TEXTURE_2D, 0, glContext.RGBA, glContext.RGBA, glContext.UNSIGNED_BYTE, img);
            glContext.texParameteri(glContext.TEXTURE_2D, glContext.TEXTURE_WRAP_S, glContext.CLAMP_TO_EDGE);
            glContext.texParameteri(glContext.TEXTURE_2D, glContext.TEXTURE_WRAP_T, glContext.CLAMP_TO_EDGE);
            glContext.texParameteri(glContext.TEXTURE_2D, glContext.TEXTURE_MIN_FILTER, glContext.LINEAR);
            glContext.texParameteri(glContext.TEXTURE_2D, glContext.TEXTURE_MAG_FILTER, glContext.LINEAR);
            resolve({ texture: tex, width: img.naturalWidth || 1376, height: img.naturalHeight || 768 });
        };
        img.onerror = () => {
            resolve(null);
        };
        img.src = url;
    });
}

function resizeCanvas() {
    if (!canvasRef.value || !gl) return;
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    const width = canvasRef.value.clientWidth;
    const height = canvasRef.value.clientHeight;
    
    if (canvasRef.value.width !== width * dpr || canvasRef.value.height !== height * dpr) {
        canvasRef.value.width = width * dpr;
        canvasRef.value.height = height * dpr;
        gl.viewport(0, 0, canvasRef.value.width, canvasRef.value.height);
    }
}

function render(now) {
    if (!gl || !program || textures.length < 2) return;

    if (!slideStartTime) slideStartTime = now;
    const nextIndex = (currentSlideIndex + 1) % textures.length;

    const timeSinceSlideStart = now - slideStartTime;
    const isTimeToTransition = timeSinceSlideStart >= (slideDuration - transitionDuration);

    let progress = 0.0;
    let nextZoom = 0.0;

    if (isTimeToTransition) {
        if (!isTransitioning) {
            isTransitioning = true;
            transitionStartTime = now;
        }
        progress = Math.min(1.0, (now - transitionStartTime) / transitionDuration);
        nextZoom = ((now - transitionStartTime) / slideDuration);
        
        if (progress >= 1.0) {
            isTransitioning = false;
            currentSlideIndex = nextIndex;
            slideStartTime = transitionStartTime;
            progress = 0.0;
        }
    } else {
        isTransitioning = false;
        progress = 0.0;
        nextZoom = 0.0;
    }

    const currentZoom = Math.min(1.0, (now - slideStartTime) / slideDuration);

    resizeCanvas();

    gl.useProgram(program);

    // Current texture (Unit 0)
    gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, textures[currentSlideIndex].texture);
    gl.uniform1i(gl.getUniformLocation(program, 'u_current'), 0);

    // Next texture (Unit 1)
    gl.activeTexture(gl.TEXTURE1);
    gl.bindTexture(gl.TEXTURE_2D, textures[nextIndex].texture);
    gl.uniform1i(gl.getUniformLocation(program, 'u_next'), 1);

    // Uniforms with smart focal coordinates
    gl.uniform1f(gl.getUniformLocation(program, 'u_progress'), progress);
    gl.uniform1f(gl.getUniformLocation(program, 'u_zoom_current'), currentZoom);
    gl.uniform1f(gl.getUniformLocation(program, 'u_zoom_next'), nextZoom);
    gl.uniform2f(gl.getUniformLocation(program, 'u_focal_current'), slides[currentSlideIndex].focal[0], slides[currentSlideIndex].focal[1]);
    gl.uniform2f(gl.getUniformLocation(program, 'u_focal_next'), slides[nextIndex].focal[0], slides[nextIndex].focal[1]);
    gl.uniform2f(gl.getUniformLocation(program, 'u_resolution'), canvasRef.value.width, canvasRef.value.height);
    gl.uniform2f(
        gl.getUniformLocation(program, 'u_img_resolution'), 
        textures[currentSlideIndex].width, 
        textures[currentSlideIndex].height
    );

    gl.drawArrays(gl.TRIANGLES, 0, 6);

    animFrameId = requestAnimationFrame(render);
}

onMounted(async () => {
    if (!canvasRef.value) return;

    gl = canvasRef.value.getContext('webgl', { antialias: false, alpha: false, preserveDrawingBuffer: false }) || 
         canvasRef.value.getContext('experimental-webgl');

    if (!gl) {
        console.warn('WebGL not supported, falling back to static background');
        return;
    }

    const vs = createShader(gl, gl.VERTEX_SHADER, vsSource);
    const fs = createShader(gl, gl.FRAGMENT_SHADER, fsSource);

    if (!vs || !fs) return;

    program = gl.createProgram();
    gl.attachShader(program, vs);
    gl.attachShader(program, fs);
    gl.linkProgram(program);

    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
        console.error('Program link error:', gl.getProgramInfoLog(program));
        return;
    }

    const quad = new Float32Array([
        -1, -1,
         1, -1,
        -1,  1,
        -1,  1,
         1, -1,
         1,  1,
    ]);

    const posBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, posBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, quad, gl.STATIC_DRAW);

    const posAttr = gl.getAttribLocation(program, 'a_position');
    gl.enableVertexAttribArray(posAttr);
    gl.vertexAttribPointer(posAttr, 2, gl.FLOAT, false, 0, 0);

    const loaded = await Promise.all(slides.map(s => loadTexture(gl, s.url)));
    textures = loaded.filter(Boolean);

    if (textures.length > 0) {
        isWebGLActive.value = true;
        animFrameId = requestAnimationFrame(render);
    }

    window.addEventListener('resize', resizeCanvas);
});

onUnmounted(() => {
    if (animFrameId) cancelAnimationFrame(animFrameId);
    window.removeEventListener('resize', resizeCanvas);
});

function scrollToShop() {
    router.push('/shop');
}
</script>

<template>
    <section class="relative w-full overflow-hidden bg-pm-ink min-h-[calc(100svh-96px)] sm:min-h-[640px] md:min-h-[700px] lg:min-h-[780px] flex items-end pb-14 pt-24 sm:items-center sm:py-20 lg:py-28 select-none">
        <!-- Background Layer: WebGL GPU Responsive Focal Canvas -->
        <div class="absolute inset-0 z-0">
            <!-- GPU WebGL Canvas -->
            <canvas 
                ref="canvasRef" 
                class="absolute inset-0 w-full h-full object-cover"
                :class="isWebGLActive ? 'opacity-100' : 'opacity-0'"
            ></canvas>

            <!-- Fallback Static Image -->
            <img 
                v-if="!isWebGLActive"
                src="/images/lifestyle/hero-living-spaces.jpg" 
                alt="POTMAN architectural planters in a bright living room" 
                class="absolute inset-0 w-full h-full object-cover object-center"
                loading="eager"
            />

            <!-- Architectural Readability Gradient Overlay -->
            <div class="absolute inset-0 z-10 bg-gradient-to-r from-pm-ink/80 via-pm-ink/40 to-transparent pointer-events-none hidden md:block"></div>
            <!-- Mobile Optimized Bottom-to-Top Gradient -->
            <div class="absolute inset-0 z-10 bg-gradient-to-t from-pm-ink/85 via-pm-ink/35 to-pm-ink/15 md:hidden pointer-events-none"></div>
        </div>

        <!-- Hero Content (Full Mobile Viewport + Responsive Desktop) -->
        <div class="relative z-20 max-w-7xl mx-auto px-6 lg:px-8 w-full">
            <div class="max-w-xl lg:max-w-2xl">
                <!-- Eyebrow -->
                <span class="block text-[11px] sm:text-xs font-medium uppercase tracking-[0.16em] text-pm-sand mb-3 sm:mb-4">
                    Mineral Planter Collection
                </span>

                <!-- Primary Statement Headline -->
                <h1 class="font-display text-[2.5rem] sm:text-6xl lg:text-[4.5rem] font-bold text-white tracking-[-0.03em] leading-[1.04] mb-4 sm:mb-5">
                    Objects for living spaces.
                </h1>

                <!-- Concise Retail Subtitle -->
                <p class="font-body text-base sm:text-lg lg:text-xl text-pm-ivory leading-relaxed max-w-lg mb-7 sm:mb-9 font-normal">
                    Lightweight stone planters crafted in Nigeria for homes, patios, and modern interiors.
                </p>

                <!-- Primary Action Button -->
                <div class="flex items-center">
                    <button 
                        @click="scrollToShop"
                        class="group inline-flex items-center justify-center bg-pm-ivory text-pm-ink hover:bg-white px-7 sm:px-9 py-4 text-xs font-bold tracking-[0.14em] uppercase transition-all duration-300 shadow-md hover:shadow-xl hover:-translate-y-0.5 active:translate-y-0"
                    >
                        <span>Shop Planters</span>
                        <BrandIcon name="arrow-right" :size="15" className="ml-3 transform group-hover:translate-x-1.5 transition-transform" />
                    </button>
                </div>
            </div>
        </div>

        <!-- Bottom Right Badge -->
        <div class="absolute bottom-6 right-6 lg:right-12 z-20 hidden md:flex items-center space-x-3 bg-pm-ink/85 backdrop-blur-md px-5 py-2.5 border border-white/15 text-pm-ivory shadow-xl">
            <span class="text-[11px] font-body tracking-[0.16em] uppercase font-medium">
                Made in Nigeria
            </span>
            <span class="text-pm-sand text-xs select-none">/</span>
            <span class="text-[11px] font-body tracking-[0.16em] uppercase font-medium">
                Resin-Free Stone
            </span>
        </div>
    </section>
</template>
