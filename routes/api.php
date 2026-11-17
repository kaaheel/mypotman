<?php

use App\Http\Controllers\CatalogController;
use App\Http\Controllers\CheckoutController;
use App\Http\Controllers\InventoryController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\PromotionController;
use App\Http\Controllers\ShippingController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| POTMAN eCommerce Engine API Routes (The 10 Core Engines)
|--------------------------------------------------------------------------
*/

// 1. Catalog & PIM Engine
Route::get('/products', [CatalogController::class, 'index']);
Route::get('/products/{slug}', [CatalogController::class, 'show']);

// 2. Pricing & Promotions Engine
Route::post('/checkout/coupon/validate', [PromotionController::class, 'validateCoupon']);

// 3. Inventory & Stock Allocation Engine
Route::post('/cart/validate-stock', [InventoryController::class, 'validateStock']);

// 8. Logistics & Freight Engine
Route::post('/shipping/quote', [ShippingController::class, 'quote']);

// 5 & 6. Checkout & Idempotency Engine
Route::post('/checkout/order', [CheckoutController::class, 'createOrder']);
Route::get('/orders/{orderNumber}', [CheckoutController::class, 'getOrder']);
Route::get('/orders/{orderNumber}/timeline', [CheckoutController::class, 'getTimeline']);

// 10. Customer & Account Self-Service Lookup
Route::post('/orders/lookup', [CheckoutController::class, 'lookupOrder']);

// 7. Payment Gateway & Webhook Engine
Route::post('/checkout/initialize-payment', [PaymentController::class, 'initialize']);
Route::post('/webhooks/paystack', [PaymentController::class, 'handleWebhook']);
