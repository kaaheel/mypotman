/**
 * Fly-to-Cart Parabolic Motion Engine
 * Animates a cloned visual thumbnail along an arched path directly into the floating cart or header bag.
 */
export function flyToCart(originElement, imageSrc, onImpact) {
    if (typeof window === 'undefined' || !originElement) return;

    // Detect target: prefer the floating cart capsule, fallback to header bag button
    const targetElement = document.querySelector('#floating-cart-badge') || 
                          document.querySelector('#floating-cart-anchor') || 
                          document.querySelector('#header-cart-button');

    if (!targetElement) {
        if (typeof onImpact === 'function') onImpact();
        return;
    }

    const originRect = originElement.getBoundingClientRect();
    const targetRect = targetElement.getBoundingClientRect();

    // Create the flying proxy element
    const flyer = document.createElement('div');
    flyer.setAttribute('aria-hidden', 'true');
    flyer.className = 'fly-to-cart-proxy';

    const flyerWidth = Math.min(originRect.width, 140);
    const flyerHeight = Math.min(originRect.height, 175);

    // Initial position matching the clicked card's visual center
    const startX = originRect.left + (originRect.width - flyerWidth) / 2;
    const startY = originRect.top + (originRect.height - flyerHeight) / 2;

    Object.assign(flyer.style, {
        position: 'fixed',
        zIndex: '99999',
        left: `${startX}px`,
        top: `${startY}px`,
        width: `${flyerWidth}px`,
        height: `${flyerHeight}px`,
        pointerEvents: 'none',
        borderRadius: '12px',
        overflow: 'hidden',
        boxShadow: '0 25px 50px -12px rgba(32, 35, 31, 0.35)',
        backgroundColor: '#EFECE4',
        border: '1px solid rgba(32, 35, 31, 0.15)',
        transformOrigin: 'center center',
        willChange: 'transform, opacity',
    });

    // Populate with product image
    const img = document.createElement('img');
    img.src = imageSrc;
    img.alt = '';
    Object.assign(img.style, {
        width: '100%',
        height: '100%',
        objectFit: 'cover',
    });
    flyer.appendChild(img);
    document.body.appendChild(flyer);

    // Destination coordinates (centered on target cart badge)
    const targetCenterX = targetRect.left + targetRect.width / 2;
    const targetCenterY = targetRect.top + targetRect.height / 2;

    const deltaX = targetCenterX - (startX + flyerWidth / 2);
    const deltaY = targetCenterY - (startY + flyerHeight / 2);

    // Arched peak point: generous upward loft curve to simulate weightless fluid lift
    const midX = deltaX * 0.48;
    const midY = Math.min(deltaY * 0.35, -110);

    const animation = flyer.animate(
        [
            {
                transform: 'translate3d(0, 0, 0) scale(1) rotate(0deg)',
                opacity: 1,
                boxShadow: '0 20px 40px -10px rgba(32, 35, 31, 0.3)',
            },
            {
                transform: 'translate3d(0, -24px, 0) scale(1.04) rotate(-1.5deg)',
                opacity: 1,
                boxShadow: '0 35px 70px -14px rgba(32, 35, 31, 0.45)',
                offset: 0.22,
            },
            {
                transform: `translate3d(${midX}px, ${midY}px, 0) scale(0.72) rotate(-3.5deg)`,
                opacity: 0.95,
                offset: 0.64,
            },
            {
                transform: `translate3d(${deltaX * 0.92}px, ${deltaY * 0.92}px, 0) scale(0.32) rotate(2deg)`,
                opacity: 0.65,
                offset: 0.88,
            },
            {
                transform: `translate3d(${deltaX}px, ${deltaY}px, 0) scale(0.1) rotate(3deg)`,
                opacity: 0.05,
            },
        ],
        {
            duration: 1250,
            easing: 'cubic-bezier(0.22, 1, 0.36, 1)',
            fill: 'forwards',
        }
    );

    animation.onfinish = () => {
        flyer.remove();
        if (typeof onImpact === 'function') {
            onImpact();
        }
    };
}

