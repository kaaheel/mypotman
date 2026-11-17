<?php

use Illuminate\Support\Facades\Route;

// Catch-all route to serve the Vue SPA across all eCommerce routes
Route::get('/{any}', function () {
    return view('welcome');
})->where('any', '.*');

