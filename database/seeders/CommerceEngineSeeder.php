<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class CommerceEngineSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Seed Products Catalog (PIM)
        $products = [
            [
                'id' => 'kano-bowl',
                'slug' => 'kano-bowl',
                'name' => 'Kano Bowl',
                'subtitle' => 'Low-profile travertine stone composite',
                'description' => 'A wide, low-profile bowl planter cast in lightweight stone composite. Designed to anchor lush greenery cleanly on wood, marble, or tiled floors.',
                'base_price' => 42000,
                'tag' => 'Bestseller',
                'rating' => 4.9,
                'review_count' => 38,
                'categories' => json_encode(['indoor', 'statement']),
                'image_url' => '/images/products/kano-bowl-studio.jpg',
                'gallery_images' => json_encode([
                    '/images/products/kano-bowl-studio.jpg',
                    '/images/craft/mineral-macro-studio.jpg',
                    '/images/lifestyle/space-residence.jpg',
                    '/images/craft/crated-packaging-studio.jpg',
                ]),
                'finishes' => json_encode([
                    ['name' => 'Sand', 'hex' => '#C8B9A4', 'label' => 'Warm Travertine Stone'],
                    ['name' => 'Ink', 'hex' => '#20231F', 'label' => 'Volcanic Basalt Black'],
                    ['name' => 'Sage', 'hex' => '#879080', 'label' => 'Muted Botanical Patina'],
                    ['name' => 'Clay', 'hex' => '#B8755D', 'label' => 'Rich Terracotta Earth'],
                ]),
                'sizes' => json_encode([
                    ['name' => 'Standard (45cm Dia × 28cm H)', 'additionalCost' => 0],
                    ['name' => 'Grande (55cm Dia × 34cm H)', 'additionalCost' => 14000],
                ]),
                'drainage_options' => json_encode([
                    'Indoor (Sealed base)',
                    'Outdoor (Drainage hole)',
                ]),
                'specs' => json_encode([
                    ['label' => 'Material', 'value' => 'Resin-free crushed limestone composite'],
                    ['label' => 'Dimensions', 'value' => '45 cm diameter × 28 cm height'],
                    ['label' => 'Weight', 'value' => '6.2 kg (50% lighter than solid poured concrete)'],
                    ['label' => 'Origin', 'value' => 'Made in Nigeria'],
                    ['label' => 'Warranty', 'value' => '3-year structural guarantee'],
                ]),
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 'zuma-tall',
                'slug' => 'zuma-tall',
                'name' => 'Zuma Tall',
                'subtitle' => 'Sculptural volcanic basalt hourglass',
                'description' => 'A tall hourglass planter proportioned for fiddle leaf figs, olive trees, and statement corners in living rooms, entryways, and patios.',
                'base_price' => 58000,
                'tag' => 'Icon',
                'rating' => 5.0,
                'review_count' => 29,
                'categories' => json_encode(['statement', 'indoor', 'outdoor']),
                'image_url' => '/images/products/zuma-tall-studio.jpg',
                'gallery_images' => json_encode([
                    '/images/products/zuma-tall-studio.jpg',
                    '/images/craft/mineral-macro-studio.jpg',
                    '/images/lifestyle/space-hospitality.jpg',
                    '/images/craft/crated-packaging-studio.jpg',
                ]),
                'finishes' => json_encode([
                    ['name' => 'Ink', 'hex' => '#20231F', 'label' => 'Volcanic Basalt Black'],
                    ['name' => 'Sand', 'hex' => '#C8B9A4', 'label' => 'Warm Travertine Stone'],
                    ['name' => 'Sage', 'hex' => '#879080', 'label' => 'Muted Botanical Patina'],
                    ['name' => 'Clay', 'hex' => '#B8755D', 'label' => 'Rich Terracotta Earth'],
                ]),
                'sizes' => json_encode([
                    ['name' => 'Standard (36cm Dia × 82cm H)', 'additionalCost' => 0],
                    ['name' => 'Monumental (42cm Dia × 100cm H)', 'additionalCost' => 20000],
                ]),
                'drainage_options' => json_encode([
                    'Indoor (Sealed base)',
                    'Outdoor (Drainage hole)',
                ]),
                'specs' => json_encode([
                    ['label' => 'Material', 'value' => 'Resin-free crushed limestone composite'],
                    ['label' => 'Dimensions', 'value' => '36 cm diameter × 82 cm height'],
                    ['label' => 'Weight', 'value' => '9.8 kg'],
                    ['label' => 'Origin', 'value' => 'Made in Nigeria'],
                    ['label' => 'Warranty', 'value' => '3-year structural guarantee'],
                ]),
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 'oko-statement',
                'slug' => 'oko-statement',
                'name' => 'Oko Statement',
                'subtitle' => '32-rib fluted earthen clay cylinder',
                'description' => 'A wide fluted cylinder with 32 clean vertical ribs. Cast in weatherproof stone composite for patios, verandas, and open interiors.',
                'base_price' => 76000,
                'tag' => 'New Release',
                'rating' => 4.9,
                'review_count' => 22,
                'categories' => json_encode(['outdoor', 'statement']),
                'image_url' => '/images/products/oko-statement-studio.jpg',
                'gallery_images' => json_encode([
                    '/images/products/oko-statement-studio.jpg',
                    '/images/craft/mineral-macro-studio.jpg',
                    '/images/lifestyle/space-courtyard.jpg',
                    '/images/craft/crated-packaging-studio.jpg',
                ]),
                'finishes' => json_encode([
                    ['name' => 'Clay', 'hex' => '#B8755D', 'label' => 'Rich Terracotta Earth'],
                    ['name' => 'Sand', 'hex' => '#C8B9A4', 'label' => 'Warm Travertine Stone'],
                    ['name' => 'Ink', 'hex' => '#20231F', 'label' => 'Volcanic Basalt Black'],
                    ['name' => 'Sage', 'hex' => '#879080', 'label' => 'Muted Botanical Patina'],
                ]),
                'sizes' => json_encode([
                    ['name' => 'Standard (48cm Dia × 65cm H)', 'additionalCost' => 0],
                    ['name' => 'Colossus (56cm Dia × 78cm H)', 'additionalCost' => 24000],
                ]),
                'drainage_options' => json_encode([
                    'Indoor (Sealed base)',
                    'Outdoor (Drainage hole)',
                ]),
                'specs' => json_encode([
                    ['label' => 'Material', 'value' => 'Resin-free mineral stone with natural oxides'],
                    ['label' => 'Dimensions', 'value' => '48 cm diameter × 65 cm height'],
                    ['label' => 'Weight', 'value' => '11.4 kg'],
                    ['label' => 'Origin', 'value' => 'Made in Nigeria'],
                    ['label' => 'Warranty', 'value' => '3-year structural guarantee'],
                ]),
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 'mineral-care-wax',
                'slug' => 'mineral-care-wax',
                'name' => 'Organic Mineral Sealant Wax',
                'subtitle' => '100ml stone sealer & patina balm',
                'description' => 'Specially blended natural beeswax and mineral oils formulated to protect and nourish raw composite limestone vessels.',
                'base_price' => 6500,
                'tag' => 'Care Essential',
                'rating' => 4.9,
                'review_count' => 45,
                'categories' => json_encode(['accessory', 'care']),
                'image_url' => '/images/craft/mineral-macro-studio.jpg',
                'gallery_images' => json_encode([
                    '/images/craft/mineral-macro-studio.jpg',
                ]),
                'finishes' => json_encode([
                    ['name' => 'Natural', 'hex' => '#EAE6DF', 'label' => 'Clear Matte'],
                ]),
                'sizes' => json_encode([
                    ['name' => 'Standard (100ml)', 'additionalCost' => 0],
                ]),
                'drainage_options' => json_encode([
                    'Not Applicable',
                ]),
                'specs' => json_encode([
                    ['label' => 'Volume', 'value' => '100 ml tin'],
                    ['label' => 'Application', 'value' => '2-3 applications per year'],
                ]),
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ];

        DB::table('products')->upsert($products, ['id'], [
            'slug', 'name', 'subtitle', 'description', 'base_price', 'tag', 'rating',
            'review_count', 'categories', 'image_url', 'gallery_images', 'finishes',
            'sizes', 'drainage_options', 'specs', 'is_active', 'updated_at'
        ]);

        // 3. Seed Inventory SKUs
        $finishes = ['Sand', 'Ink', 'Sage', 'Clay'];
        $skus = [];
        foreach (['kano-bowl', 'zuma-tall', 'oko-statement'] as $pId) {
            foreach ($finishes as $f) {
                foreach (['Standard', 'Grande'] as $sz) {
                    $skus[] = [
                        'sku' => strtoupper(substr($pId, 0, 2)) . '-' . strtoupper(substr($f, 0, 3)) . '-' . strtoupper(substr($sz, 0, 3)),
                        'product_id' => $pId,
                        'finish' => $f,
                        'size' => $sz,
                        'drainage' => 'Indoor (Sealed base)',
                        'stock_quantity' => 15,
                        'reserved_quantity' => 0,
                        'low_stock_threshold' => 3,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ];
                }
            }
        }
        $skus[] = [
            'sku' => 'WAX-100ML',
            'product_id' => 'mineral-care-wax',
            'finish' => 'Natural',
            'size' => 'Standard (100ml)',
            'drainage' => 'Not Applicable',
            'stock_quantity' => 50,
            'reserved_quantity' => 0,
            'low_stock_threshold' => 10,
            'created_at' => now(),
            'updated_at' => now(),
        ];
        DB::table('inventory_skus')->upsert($skus, ['sku'], ['stock_quantity', 'updated_at']);

        // 2. Seed Promotional Coupons
        $coupons = [
            [
                'code' => 'POTMAN10',
                'type' => 'percent',
                'value' => 10,
                'min_spend' => 30000,
                'usage_limit' => 500,
                'used_count' => 14,
                'expires_at' => now()->addMonths(6),
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'code' => 'WELCOME5K',
                'type' => 'fixed',
                'value' => 5000,
                'min_spend' => 40000,
                'usage_limit' => 200,
                'used_count' => 8,
                'expires_at' => now()->addMonths(3),
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'code' => 'STUDIO20',
                'type' => 'percent',
                'value' => 20,
                'min_spend' => 150000,
                'usage_limit' => 50,
                'used_count' => 2,
                'expires_at' => now()->addMonths(2),
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ];
        DB::table('coupons')->upsert($coupons, ['code'], ['type', 'value', 'min_spend', 'is_active', 'updated_at']);
    }
}

