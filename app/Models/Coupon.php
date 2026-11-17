<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Coupon extends Model
{
    use HasFactory;

    protected $guarded = [];

    protected $casts = [
        'value' => 'decimal:2',
        'min_spend' => 'decimal:2',
        'usage_limit' => 'integer',
        'used_count' => 'integer',
        'expires_at' => 'datetime',
        'is_active' => 'boolean',
    ];

    public function isValidFor(float $subtotal): bool
    {
        if (!$this->is_active) return false;
        if ($this->expires_at && $this->expires_at->isPast()) return false;
        if ($this->usage_limit !== null && $this->used_count >= $this->usage_limit) return false;
        if ($subtotal < $this->min_spend) return false;
        return true;
    }

    public function calculateDiscount(float $subtotal): float
    {
        if (!$this->isValidFor($subtotal)) return 0;

        if ($this->type === 'percent') {
            return round(($subtotal * ($this->value / 100)), 2);
        }

        return min($subtotal, (float) $this->value);
    }
}

