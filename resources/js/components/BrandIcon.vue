<script setup>
defineProps({
    name: {
        type: String,
        required: true,
    },
    size: {
        type: [Number, String],
        default: 20,
    },
    strokeWidth: {
        type: [Number, String],
        default: 1.5,
    },
    className: {
        type: String,
        default: '',
    }
});
</script>

<template>
    <svg 
        :width="size" 
        :height="size" 
        viewBox="0 0 24 24" 
        fill="none" 
        stroke="currentColor" 
        :stroke-width="strokeWidth" 
        stroke-linecap="round" 
        stroke-linejoin="round"
        :class="['inline-block transition-transform duration-200', className]"
    >
        <!-- Leaf / Resin Free Mineral -->
        <path v-if="name === 'leaf'" d="M11 20A7 7 0 0 1 4 13C4 8.5 8 3 20 3c0 12-5.5 17-9 17Z M11 20v-7 M11 13l4-3" />

        <!-- Feather / Lightweight & Durable -->
        <path v-else-if="name === 'feather'" d="M20.24 12.24a6 6 0 0 0-8.49-8.49L3 12.5V21h8.5z M16 8L2 22 M17.5 15H9" />

        <!-- Arch / Original Silhouettes (Geometric Arch) -->
        <path v-else-if="name === 'arch'" d="M5 21V9a7 7 0 0 1 14 0v12 M5 21h14" />

        <!-- Globe / Designed in Nigeria -->
        <g v-else-if="name === 'globe'">
            <circle cx="12" cy="12" r="9" />
            <path d="M3.6 9h16.8 M3.6 15h16.8 M12 3a14 14 0 0 1 0 18 M12 3a14 14 0 0 0 0 18" />
        </g>

        <!-- Search -->
        <g v-else-if="name === 'search'">
            <circle cx="11" cy="11" r="7" />
            <path d="m20 20-3.5-3.5" />
        </g>

        <!-- Shopping Bag -->
        <g v-else-if="name === 'bag'">
            <path d="M6 3h12l2 5v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V8l2-5Z" />
            <path d="M4 8h16 M9 11a3 3 0 0 0 6 0" />
        </g>

        <!-- User / Account -->
        <g v-else-if="name === 'user'">
            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
            <circle cx="12" cy="7" r="4" />
        </g>

        <!-- Plus -->
        <path v-else-if="name === 'plus'" d="M12 5v14 M5 12h14" />

        <!-- Minus -->
        <path v-else-if="name === 'minus'" d="M5 12h14" />

        <!-- Close -->
        <path v-else-if="name === 'close'" d="M18 6 6 18 M6 6l12 12" />

        <!-- Check -->
        <path v-else-if="name === 'check'" d="M20 6 9 17l-5-5" />

        <!-- Arrow Right -->
        <path v-else-if="name === 'arrow-right'" d="M5 12h14 M12 5l7 7-7 7" />

        <!-- Arrow Left -->
        <path v-else-if="name === 'arrow-left'" d="M19 12H5 M12 19l-7-7 7-7" />

        <!-- Chevron Down -->
        <path v-else-if="name === 'chevron-down'" d="m6 9 6 6 6-6" />

        <!-- Delivery Truck -->
        <g v-else-if="name === 'truck'">
            <path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2 M14 8h4l3 3v6a1 1 0 0 1-1 1h-2" />
            <circle cx="7" cy="18" r="2" />
            <circle cx="17" cy="18" r="2" />
        </g>

        <!-- Shield / Warranty -->
        <g v-else-if="name === 'shield'">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z" />
            <path d="m9 12 2 2 4-4" />
        </g>

        <!-- Lock -->
        <g v-else-if="name === 'lock'">
            <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
            <path d="M7 11V7a5 5 0 0 1 10 0v4" />
        </g>

        <!-- Box / Packaging -->
        <g v-else-if="name === 'box'">
            <path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z" />
            <path d="m3.3 7 8.7 5 8.7-5 M12 22V12" />
        </g>

        <!-- File / Receipt -->
        <g v-else-if="name === 'file'">
            <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z" />
            <polyline points="14 2 14 8 20 8" />
            <line x1="16" x2="8" y1="13" y2="13" />
            <line x1="16" x2="8" y1="17" y2="17" />
        </g>

        <!-- Menu / Hamburger -->
        <path v-else-if="name === 'menu'" d="M4 6h16 M4 12h16 M4 18h16" />
    </svg>
</template>

