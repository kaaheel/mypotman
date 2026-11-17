<?php

namespace App\Http\Controllers;

use App\Models\Coupon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PromotionController extends Controller
{
    /**
     * 2. Pricing & Promotions Engine: Validate coupon code & calculate discount.
     */
    public function validateCoupon(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'code' => 'required|string',
            'subtotal' => 'required|numeric|min:0',
        ]);

        $code = strtoupper(trim($validated['code']));
        $subtotal = (float) $validated['subtotal'];

        $coupon = Coupon::where('code', $code)->first();

        if (!$coupon) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid promotional voucher code',
            ], 404);
        }

        if (!$coupon->is_active) {
            return response()->json([
                'success' => false,
                'message' => 'This voucher has expired or is no longer active',
            ], 422);
        }

        if ($coupon->expires_at && $coupon->expires_at->isPast()) {
            return response()->json([
                'success' => false,
                'message' => 'This promotional code expired on ' . $coupon->expires_at->format('M d, Y'),
            ], 422);
        }

        if ($coupon->usage_limit !== null && $coupon->used_count >= $coupon->usage_limit) {
            return response()->json([
                'success' => false,
                'message' => 'This promotional code has reached its maximum redemptions',
            ], 422);
        }

        if ($subtotal < $coupon->min_spend) {
            return response()->json([
                'success' => false,
                'message' => 'Minimum order value of ₦' . number_format($coupon->min_spend) . ' required for this code',
            ], 422);
        }

        $discount = $coupon->calculateDiscount($subtotal);

        return response()->json([
            'success' => true,
            'code' => $coupon->code,
            'type' => $coupon->type,
            'value' => (float) $coupon->value,
            'discount_amount' => $discount,
            'new_subtotal' => max(0, $subtotal - $discount),
            'message' => $coupon->type === 'percent'
                ? "Applied {$coupon->value}% discount"
                : "Applied ₦" . number_format($discount) . " discount",
        ]);
    }
}

