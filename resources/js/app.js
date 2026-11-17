import '../css/app.css';
import { createApp, nextTick } from 'vue';
import Storefront from './components/Storefront.vue';
import router from './router';
import { initSmoothScroll } from './utils/scroll';

const appElement = document.getElementById('app');
if (appElement) {
    const app = createApp(Storefront);
    app.use(router);

    router.isReady().then(() => {
        app.mount('#app');
        nextTick(() => {
            initSmoothScroll();
        });
    });

    router.afterEach(() => {
        nextTick(() => {
            initSmoothScroll();
        });
    });
}
