<?php

namespace App\Http\Controllers;

use App\Models\InventorySku;
use App\Models\Order;
use App\Models\Transaction;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class PaymentController extends Controller
{
    /**
     * 7. Payment Gateway Engine: Initialize a transaction.
     */
    public function initialize(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'order_number' => 'required|string',
            'email' => 'required|email',
            'amount' => 'required|numeric|min:1',
        ]);

        $order = Order::where('order_number', $validated['order_number'])->first();
        if (!$order) {
            return response()->json(['success' => false, 'message' => 'Order not found'], 404);
        }

        $reference = 'pstk_' . strtoupper(Str::random(12)) . '_' . time();

        $transaction = Transaction::create([
            'order_id' => $order->id,
            'reference' => $reference,
            'gateway' => 'paystack',
            'amount' => $validated['amount'],
            'currency' => 'NGN',
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'reference' => $reference,
            'authorization_url' => "https://checkout.paystack.com/{$reference}",
            'transaction_id' => $transaction->id,
        ]);
    }

    /**
     * 7. Cryptographic HMAC Webhook Verification for Paystack.
     */
    public function handleWebhook(Request $request): JsonResponse
    {
        $signature = $request->header('X-Paystack-Signature');
        $payload = $request->getContent();
        $secretKey = config('services.paystack.secret_key', env('PAYSTACK_SECRET_KEY', 'potman_live_mock_secret_key'));

        // Cryptographic HMAC SHA512 validation
        $calculatedSignature = hash_hmac('sha512', $payload, $secretKey);
        
        // In local/test development, allow verification or matching signature
        $isSignatureValid = ($signature && hash_equals($calculatedSignature, $signature)) || app()->environment('local');

        if (!$isSignatureValid) {
            Log::warning('Paystack webhook HMAC signature failed', [
                'received' => $signature,
                'calculated' => $calculatedSignature,
            ]);
            return response()->json(['error' => 'Invalid HMAC Signature'], 401);
        }

        $data = json_decode($payload, true);
        $event = $data['event'] ?? '';

        if ($event === 'charge.success') {
            $ref = $data['data']['reference'] ?? '';
            $amount = ($data['data']['amount'] ?? 0) / 100;

            DB::transaction(function () use ($ref, $amount, $data) {
                $transaction = Transaction::where('reference', $ref)->first();
                if ($transaction) {
                    $transaction->update([
                        'status' => 'successful',
                        'gateway_response' => $data,
                    ]);

                    $order = $transaction->order;
                    if ($order && $order->payment_status !== 'paid') {
                        $order->update([
                            'payment_status' => 'paid',
                            'payment_reference' => $ref,
                        ]);
                        $order->transitionTo('crated', 'Payment verified via Paystack HMAC Webhook');

                        // Atomically decrement inventory for ordered items
                        foreach ($order->items as $item) {
                            InventorySku::where('product_id', $item->product_id)
                                ->where('finish', $item->finish)
                                ->decrement('stock_quantity', $item->quantity);
                        }
                    }
                }
            });
        }

        return response()->json(['status' => 'success'], 200);
    }
}

