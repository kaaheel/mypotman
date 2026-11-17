<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Catalog & PIM Engine
        Schema::create('products', function (Blueprint $table) {
            $table->string('id')->primary(); // e.g. 'kano-bowl'
            $table->string('slug')->unique()->index();
            $table->string('name');
            $table->string('subtitle')->nullable();
            $table->text('description')->nullable();
            $table->decimal('base_price', 12, 2);
            $table->string('tag')->nullable();
            $table->decimal('rating', 3, 1)->default(4.9);
            $table->integer('review_count')->default(25);
            $table->json('categories')->nullable();
            $table->string('image_url');
            $table->json('gallery_images')->nullable();
            $table->json('finishes')->nullable();
            $table->json('sizes')->nullable();
            $table->json('drainage_options')->nullable();
            $table->json('specs')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // 3. Inventory & Stock Allocation Engine
        Schema::create('inventory_skus', function (Blueprint $table) {
            $table->id();
            $table->string('sku')->unique()->index();
            $table->string('product_id')->index();
            $table->string('finish');
            $table->string('size');
            $table->string('drainage');
            $table->integer('stock_quantity')->default(15);
            $table->integer('reserved_quantity')->default(0);
            $table->integer('low_stock_threshold')->default(3);
            $table->timestamps();

            $table->foreign('product_id')->references('id')->on('products')->onDelete('cascade');
        });

        // 2. Pricing & Promotions Engine (Coupons)
        Schema::create('coupons', function (Blueprint $table) {
            $table->id();
            $table->string('code')->unique()->index();
            $table->string('type')->default('fixed'); // 'fixed' or 'percent'
            $table->decimal('value', 12, 2); // e.g. 5000 or 10.00 (%)
            $table->decimal('min_spend', 12, 2)->default(0);
            $table->integer('usage_limit')->nullable();
            $table->integer('used_count')->default(0);
            $table->dateTime('expires_at')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // 10. Customer, Address & Account Engine
        Schema::create('customers', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique()->index();
            $table->string('phone')->nullable()->index();
            $table->text('saved_address')->nullable();
            $table->string('saved_city')->nullable();
            $table->string('saved_state')->nullable();
            $table->integer('total_orders')->default(0);
            $table->decimal('total_spent', 12, 2)->default(0);
            $table->timestamps();
        });

        // 5 & 7. Order State Machine Logs & Transactions
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained('orders')->onDelete('cascade');
            $table->string('reference')->unique()->index();
            $table->string('gateway')->default('paystack');
            $table->decimal('amount', 12, 2);
            $table->string('currency', 3)->default('NGN');
            $table->string('status')->default('pending'); // 'pending', 'successful', 'failed'
            $table->json('gateway_response')->nullable();
            $table->timestamps();
        });

        Schema::create('order_status_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained('orders')->onDelete('cascade');
            $table->string('from_status')->nullable();
            $table->string('to_status');
            $table->text('note')->nullable();
            $table->timestamps();
        });

        // Add additional tracking fields to orders table
        Schema::table('orders', function (Blueprint $table) {
            $table->foreignId('customer_id')->nullable()->constrained('customers')->nullOnDelete();
            $table->string('coupon_code')->nullable();
            $table->string('shipping_zone')->default('Zone 1 (Lagos)');
            $table->string('tracking_waybill')->nullable()->index();
            $table->integer('lock_version')->default(0);
        });
    }

    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropForeign(['customer_id']);
            $table->dropColumn(['customer_id', 'coupon_code', 'shipping_zone', 'tracking_waybill', 'lock_version']);
        });

        Schema::dropIfExists('order_status_logs');
        Schema::dropIfExists('transactions');
        Schema::dropIfExists('customers');
        Schema::dropIfExists('coupons');
        Schema::dropIfExists('inventory_skus');
        Schema::dropIfExists('products');
    }
};

