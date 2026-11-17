<!DOCTYPE html>
<html lang="en" class="h-full scroll-smooth">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="POTMAN makes architectural mineral planters in Nigeria. Lightweight, waterproof, and built for modern homes and commercial spaces.">
        
        <!-- Open Graph / Meta -->
        <meta property="og:type" content="website">
        <meta property="og:title" content="POTMAN | Objects for living spaces">
        <meta property="og:description" content="Architectural mineral planters crafted in Nigeria for modern interiors and outdoor spaces.">
        <meta property="og:image" content="{{ asset('images/lifestyle/hero-living-spaces.jpg') }}">

        <title>POTMAN | Architectural Mineral Planters</title>

        <!-- Favicons -->
        <link rel="icon" type="image/svg+xml" href="{{ asset('brand/icons/favicon.svg') }}">
        <link rel="icon" type="image/x-icon" href="{{ asset('favicon.ico') }}">

        <!-- Fontshare: Satoshi -->
        <link rel="preconnect" href="https://api.fontshare.com" crossorigin>
        <link href="https://api.fontshare.com/v2/css?f[]=satoshi@300,400,500,700,900&display=swap" rel="stylesheet">

        <!-- Vite Compiled Assets -->
        @vite(['resources/css/app.css', 'resources/js/app.js'])
    </head>
    <body class="bg-pm-ivory text-pm-ink font-body antialiased selection:bg-pm-clay selection:text-white min-h-full flex flex-col">
        <div id="app" class="flex-1 flex flex-col"></div>
    </body>
</html>
