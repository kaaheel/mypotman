<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ShippingController extends Controller
{
    /**
     * Zone definition matrix for Nigeria.
     */
    protected array $zone2States = [
        'abuja (fct)', 'fct', 'rivers', 'oyo', 'edo', 'ogun',
    ];

    /**
     * 8. Logistics & Nationwide Freight Engine: Calculate shipping rate & delivery timeline.
     */
    public function quote(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'state' => 'required|string',
            'subtotal' => 'required|numeric|min:0',
        ]);

        $state = strtolower(trim($validated['state']));
        $subtotal = (float) $validated['subtotal'];

        if (str_contains($state, 'lagos')) {
            $isFree = $subtotal >= 120000;
            return response()->json([
                'success' => true,
                'zone' => 'Zone 1 (Lagos Metro)',
                'rate' => $isFree ? 0 : 8500,
                'is_free' => $isFree,
                'threshold_for_free' => 120000,
                'packaging' => 'Dedicated White-Glove Fragile Cargo Van',
                'estimated_days' => '24 to 48 hours',
                'zero_breakage_guarantee' => true,
            ]);
        }

        $isZone2 = false;
        foreach ($this->zone2States as $z2) {
            if (str_contains($state, $z2)) {
                $isZone2 = true;
                break;
            }
        }

        if ($isZone2) {
            return response()->json([
                'success' => true,
                'zone' => 'Zone 2 (Regional Hubs)',
                'rate' => 14500,
                'is_free' => false,
                'threshold_for_free' => null,
                'packaging' => 'Custom Timber Shock-Absorbing Crate',
                'estimated_days' => '2 to 4 business days',
                'zero_breakage_guarantee' => true,
            ]);
        }

        // Zone 3: Nationwide All Other States
        return response()->json([
            'success' => true,
            'zone' => 'Zone 3 (Nationwide All 36 States)',
            'rate' => 18500,
            'is_free' => false,
            'threshold_for_free' => null,
            'packaging' => 'Heavy Timber Freight Crate with Interior Foam Anchors',
            'estimated_days' => '3 to 5 business days',
            'zero_breakage_guarantee' => true,
        ]);
    }
}

