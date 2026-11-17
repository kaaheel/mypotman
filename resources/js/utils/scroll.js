import Lenis from 'lenis';

let lenisInstance = null;
let rafId = null;

/**
 * Initialize inertia smooth scrolling and progressive reveal observer.
 */
export function initSmoothScroll() {
    if (typeof window === 'undefined') return null;

    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (!prefersReducedMotion && !lenisInstance) {
        lenisInstance = new Lenis({
            duration: 1.15,
            easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
            smoothWheel: true,
            touchMultiplier: 1.5,
        });

        const raf = (time) => {
            lenisInstance?.raf(time);
            rafId = requestAnimationFrame(raf);
        };
        rafId = requestAnimationFrame(raf);
    }

    initScrollReveals(prefersReducedMotion);
    return lenisInstance;
}

/**
 * Smoothly glide to an element by DOM id.
 */
export function scrollToTarget(id, offset = -84) {
    const el = document.getElementById(id);
    if (!el) return;

    if (lenisInstance) {
        lenisInstance.scrollTo(el, {
            offset,
            duration: 1.1,
        });
        return;
    }

    const top = el.getBoundingClientRect().top + window.scrollY + offset;
    window.scrollTo({
        top: Math.max(0, top),
        behavior: 'smooth',
    });
}

/**
 * Reveal sections smoothly as they enter the viewport.
 */
function initScrollReveals(prefersReducedMotion) {
    const elements = document.querySelectorAll('.reveal-on-scroll');
    if (!elements.length) return;

    elements.forEach((el) => el.classList.add('is-visible'));

    if (lenisInstance) {
        lenisInstance.resize();
    }
}

export function destroySmoothScroll() {
    if (rafId) cancelAnimationFrame(rafId);
    if (lenisInstance) {
        lenisInstance.destroy();
        lenisInstance = null;
    }
}

