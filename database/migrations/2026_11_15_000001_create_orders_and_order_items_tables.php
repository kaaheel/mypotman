<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('order_number')->unique()->index();
            $table->string('idempotency_key')->unique()->nullable()->index();
            $table->string('customer_name');
            $table->string('customer_email')->index();
            $table->string('customer_phone');
            $table->text('shipping_address');
            $table->string('shipping_city');
            $table->string('shipping_state');
            $table->text('shipping_notes')->nullable();
            $table->decimal('subtotal', 12, 2);
            $table->decimal('shipping_fee', 12, 2)->default(0);
            $table->decimal('discount_amount', 12, 2)->default(0);
            $table->decimal('total_amount', 12, 2);
            $table->string('payment_status')->default('paid'); // 'pending', 'paid', 'failed'
            $table->string('payment_method')->default('paystack');
            $table->string('payment_reference')->nullable();
            $table->string('fulfillment_status')->default('packing'); // 'packing', 'crated', 'dispatched', 'delivered'
            $table->timestamps();
        });

        Schema::create('order_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained('orders')->onDelete('cascade');
            $table->string('product_id');
            $table->string('product_name');
            $table->string('finish')->default('Sand');
            $table->string('drainage')->default('Indoor (Sealed base)');
            $table->string('size')->default('Standard');
            $table->decimal('unit_price', 12, 2);
            $table->integer('quantity')->default(1);
            $table->decimal('total_price', 12, 2);
            $table->string('image_url')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('order_items');
        Schema::dropIfExists('orders');
    }
};

