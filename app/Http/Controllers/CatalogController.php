<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CatalogController extends Controller
{
    /**
     * 1. Catalog & PIM Engine: List products with category/search filters.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Product::where('is_active', true);

        if ($request->filled('category') && $request->category !== 'all') {
            $cat = $request->category;
            $query->whereJsonContains('categories', $cat);
        }

        if ($request->filled('search')) {
            $term = '%' . $request->search . '%';
            $query->where(function ($q) use ($term) {
                $q->where('name', 'like', $term)
                  ->orWhere('subtitle', 'like', $term)
                  ->orWhere('description', 'like', $term);
            });
        }

        $products = $query->with('skus')->get();

        return response()->json([
            'success' => true,
            'products' => $products,
        ]);
    }

    /**
     * 1. Catalog & PIM Engine: Single Product Detail by slug or ID.
     */
    public function show(string $slug): JsonResponse
    {
        $product = Product::where('slug', $slug)
            ->orWhere('id', $slug)
            ->where('is_active', true)
            ->with('skus')
            ->first();

        if (!$product) {
            return response()->json([
                'success' => false,
                'message' => 'Product not found in catalog',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'product' => $product,
        ]);
    }
}

