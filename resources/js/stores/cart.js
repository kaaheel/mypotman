import { reactive, computed } from 'vue';

const STORAGE_KEY = 'potman_cart_v1';

// Load and sanitize initial state from LocalStorage
const savedCart = (() => {
    try {
        const item = localStorage.getItem(STORAGE_KEY);
        if (!item) return [];
        const parsed = JSON.parse(item);
        if (!Array.isArray(parsed)) return [];
        // Sanitize every item to guarantee valid numeric price & quantity
        return parsed
            .filter(i => i && (i.productId || i.id))
            .map(i => {
                const price = Number(i.price);
                const quantity = Number(i.quantity);
                return {
                    ...i,
                    productId: i.productId || i.id,
                    price: !isNaN(price) && price > 0 ? price : 42000,
                    quantity: !isNaN(quantity) && quantity > 0 ? Math.floor(quantity) : 1,
                };
            });
    } catch (e) {
        return [];
    }
})();

export const cartState = reactive({
    items: savedCart,
    isOpen: false,
    isCheckoutOpen: false,
    activeCategory: 'all',
    searchQuery: '',
    isSearchOpen: false,
    selectedProductForQuickView: null,
    orderCompleted: null,
    lastAddedItem: null,
    impactPulse: 0,
    isFloatingExpanded: false,
});

let notificationTimer = null;

function persistCart() {
    try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(cartState.items));
    } catch (e) {
        console.error('Failed to save cart to localStorage', e);
    }
}

export const cartStore = {
    state: cartState,

    // Verified Reactive Getters (Strict numeric operations to prevent NaN)
    totalCount: computed(() => {
        return cartState.items.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0);
    }),

    subtotal: computed(() => {
        return cartState.items.reduce((sum, item) => {
            const price = Number(item.price) || 0;
            const qty = Number(item.quantity) || 1;
            return sum + (price * qty);
        }, 0);
    }),

    freeShippingThreshold: 150000,

    isFreeShipping: computed(() => {
        const sub = cartStore.subtotal.value;
        return sub >= 150000;
    }),

    shippingFee: computed(() => {
        if (cartState.items.length === 0) return 0;
        return cartStore.isFreeShipping.value ? 0 : 8500;
    }),

    total: computed(() => {
        return cartStore.subtotal.value + cartStore.shippingFee.value;
    }),

    shippingProgress: computed(() => {
        const sub = cartStore.subtotal.value;
        if (sub <= 0) return 0;
        if (sub >= 150000) return 100;
        return Math.min(100, Math.max(0, Math.round((sub / 150000) * 100)));
    }),

    remainingForFreeShipping: computed(() => {
        const sub = cartStore.subtotal.value;
        return Math.max(0, 150000 - sub);
    }),

    // Actions
    addItem(product, finish = 'Sand', drainage = 'Indoor (Sealed base)', size = 'Standard', quantity = 1, options = {}) {
        const { autoOpenDrawer = false } = options;
        const validQuantity = Math.max(1, Math.floor(Number(quantity) || 1));

        const matchedSize = Array.isArray(product.sizes)
            ? product.sizes.find(s => s.name === size)
            : null;
        const basePrice = Number(product.price) || 42000;
        const addon = Number(matchedSize?.additionalCost) || 0;
        const unitPrice = basePrice + addon;

        const existingIndex = cartState.items.findIndex(i => 
            i.productId === product.id && 
            i.finish === finish && 
            i.drainage === drainage &&
            i.size === size
        );

        if (existingIndex > -1) {
            cartState.items[existingIndex].quantity += validQuantity;
        } else {
            cartState.items.push({
                cartId: `${product.id}-${finish}-${drainage}-${size}-${Date.now()}`,
                productId: product.id,
                name: product.name,
                subtitle: product.subtitle || '',
                image: product.image || '/images/products/kano-bowl-studio.jpg',
                finish,
                drainage,
                size,
                price: unitPrice,
                quantity: validQuantity,
            });
        }
        persistCart();

        // Record last added item for floating island capsule
        cartState.lastAddedItem = {
            id: product.id,
            name: product.name,
            image: product.image || '/images/products/kano-bowl-studio.jpg',
            finish,
            size,
            price: unitPrice,
            formattedPrice: cartStore.formatNaira(unitPrice),
            quantity: validQuantity,
        };

        // Trigger floating capsule expansion
        cartState.isFloatingExpanded = true;
        if (notificationTimer) clearTimeout(notificationTimer);
        notificationTimer = setTimeout(() => {
            cartState.isFloatingExpanded = false;
        }, 3800);

        if (autoOpenDrawer) {
            cartState.isOpen = true;
        }
    },

    triggerImpact() {
        cartState.impactPulse++;
    },

    dismissFloatingNotification() {
        cartState.isFloatingExpanded = false;
        if (notificationTimer) clearTimeout(notificationTimer);
    },

    removeItem(cartId) {
        cartState.items = cartState.items.filter(i => i.cartId !== cartId);
        persistCart();
    },

    updateQuantity(cartId, delta) {
        const item = cartState.items.find(i => i.cartId === cartId);
        if (!item) return;

        const newQty = (Number(item.quantity) || 1) + delta;
        if (newQty <= 0) {
            cartStore.removeItem(cartId);
        } else {
            item.quantity = Math.floor(newQty);
            persistCart();
        }
    },

    clearCart() {
        cartState.items = [];
        persistCart();
    },

    openCart() {
        cartState.isOpen = true;
    },

    closeCart() {
        cartState.isOpen = false;
    },

    openCheckout() {
        cartState.isOpen = false;
        cartState.isCheckoutOpen = true;
    },

    closeCheckout() {
        cartState.isCheckoutOpen = false;
    },

    openQuickView(product) {
        cartState.selectedProductForQuickView = product;
    },

    closeQuickView() {
        cartState.selectedProductForQuickView = null;
    },

    setCategory(category) {
        cartState.activeCategory = category;
    },

    formatNaira(amount) {
        const num = Number(amount);
        if (isNaN(num) || !isFinite(num)) return '₦0';
        return '₦' + Math.round(num).toLocaleString('en-NG');
    }
};
