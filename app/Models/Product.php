<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Product extends Model
{
    use HasFactory;

    protected $keyType = 'string';
    public $incrementing = false;
    protected $guarded = [];

    protected $casts = [
        'base_price' => 'decimal:2',
        'rating' => 'decimal:1',
        'review_count' => 'integer',
        'categories' => 'array',
        'gallery_images' => 'array',
        'finishes' => 'array',
        'sizes' => 'array',
        'drainage_options' => 'array',
        'specs' => 'array',
        'is_active' => 'boolean',
    ];

    public function skus(): HasMany
    {
        return $this->hasMany(InventorySku::class, 'product_id', 'id');
    }
}

