import { createRouter, createWebHistory } from 'vue-router';
import HomePage from '../pages/HomePage.vue';
import ShopPage from '../pages/ShopPage.vue';
import MaterialPage from '../pages/MaterialPage.vue';
import SpacesPage from '../pages/SpacesPage.vue';
import DeliveryPage from '../pages/DeliveryPage.vue';
import ProductDetailPage from '../pages/ProductDetailPage.vue';
import CheckoutPage from '../pages/CheckoutPage.vue';
import OrderConfirmationPage from '../pages/OrderConfirmationPage.vue';
import OrderLookupPage from '../pages/OrderLookupPage.vue';

const routes = [
    {
        path: '/',
        name: 'home',
        component: HomePage,
    },
    {
        path: '/shop',
        name: 'shop',
        component: ShopPage,
    },
    {
        path: '/material',
        name: 'material',
        component: MaterialPage,
    },
    {
        path: '/spaces',
        name: 'spaces',
        component: SpacesPage,
    },
    {
        path: '/delivery',
        name: 'delivery',
        component: DeliveryPage,
    },
    {
        path: '/products/:slug',
        name: 'product-detail',
        component: ProductDetailPage,
        props: true,
    },
    {
        path: '/checkout',
        name: 'checkout',
        component: CheckoutPage,
    },
    {
        path: '/order-confirmation/:orderRef',
        name: 'order-confirmation',
        component: OrderConfirmationPage,
        props: true,
    },
    {
        path: '/track-order',
        name: 'track-order',
        component: OrderLookupPage,
    },
    {
        path: '/:pathMatch(.*)*',
        redirect: '/',
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
    scrollBehavior(to, from, savedPosition) {
        if (to.hash) {
            return {
                el: to.hash,
                behavior: 'smooth',
                top: 84,
            };
        }
        if (savedPosition) {
            return savedPosition;
        }
        return { top: 0, behavior: 'smooth' };
    },
});

export default router;
