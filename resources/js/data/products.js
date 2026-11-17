export const products = [
    {
        id: 'kano-bowl',
        slug: 'kano-bowl',
        name: 'Kano Bowl',
        subtitle: 'Low-profile travertine stone composite',
        dimensionsSummary: '45 × 28 cm · 6.2 kg',
        tag: 'Bestseller',
        price: 42000,
        formattedPrice: '₦42,000',
        categories: ['indoor', 'statement'],
        rating: 4.9,
        reviewCount: 38,
        image: '/images/products/kano-bowl-studio.jpg',
        defaultFinish: 'Sand',
        finishes: [
            { name: 'Sand', hex: '#C8B9A4', label: 'Warm Travertine Stone' },
            { name: 'Ink', hex: '#20231F', label: 'Volcanic Basalt Black' },
            { name: 'Sage', hex: '#879080', label: 'Muted Botanical Patina' },
            { name: 'Clay', hex: '#B8755D', label: 'Rich Terracotta Earth' },
        ],
        sizes: [
            { name: 'Standard (45cm Dia × 28cm H)', additionalCost: 0 },
            { name: 'Grande (55cm Dia × 34cm H)', additionalCost: 14000 },
        ],
        drainageOptions: [
            'Indoor (Sealed base)',
            'Outdoor (Drainage hole)',
        ],
        leadTime: 'In Stock · Ships in 24 to 48 hours',
        description: 'A wide, low-profile bowl planter cast in lightweight stone composite. Designed to anchor lush greenery cleanly on wood, marble, or tiled floors.',
        specs: [
            { label: 'Material', value: 'Resin-free crushed limestone composite' },
            { label: 'Dimensions', value: '45 cm diameter × 28 cm height' },
            { label: 'Weight', value: '6.2 kg (50% lighter than poured concrete)' },
            { label: 'Origin', value: 'Made in Nigeria' },
            { label: 'Warranty', value: '3-year structural guarantee' }
        ]
    },
    {
        id: 'zuma-tall',
        slug: 'zuma-tall',
        name: 'Zuma Tall',
        subtitle: 'Sculptural volcanic basalt hourglass',
        dimensionsSummary: '36 × 82 cm · 9.8 kg',
        tag: 'Icon',
        price: 58000,
        formattedPrice: '₦58,000',
        categories: ['statement', 'indoor', 'outdoor'],
        rating: 5.0,
        reviewCount: 29,
        image: '/images/products/zuma-tall-studio.jpg',
        defaultFinish: 'Ink',
        finishes: [
            { name: 'Ink', hex: '#20231F', label: 'Volcanic Basalt Black' },
            { name: 'Sand', hex: '#C8B9A4', label: 'Warm Travertine Stone' },
            { name: 'Sage', hex: '#879080', label: 'Muted Botanical Patina' },
            { name: 'Clay', hex: '#B8755D', label: 'Rich Terracotta Earth' },
        ],
        sizes: [
            { name: 'Standard (36cm Dia × 82cm H)', additionalCost: 0 },
            { name: 'Monumental (42cm Dia × 100cm H)', additionalCost: 20000 },
        ],
        drainageOptions: [
            'Indoor (Sealed base)',
            'Outdoor (Drainage hole)',
        ],
        leadTime: 'In Stock · Ships in 24 to 48 hours',
        description: 'A tall hourglass planter proportioned for fiddle leaf figs, olive trees, and statement corners in living rooms, entryways, and patios.',
        specs: [
            { label: 'Material', value: 'Resin-free crushed limestone composite' },
            { label: 'Dimensions', value: '36 cm diameter × 82 cm height' },
            { label: 'Weight', value: '9.8 kg' },
            { label: 'Origin', value: 'Made in Nigeria' },
            { label: 'Warranty', value: '3-year structural guarantee' }
        ]
    },
    {
        id: 'oko-statement',
        slug: 'oko-statement',
        name: 'Oko Statement',
        subtitle: '32-rib fluted earthen clay cylinder',
        dimensionsSummary: '48 × 65 cm · 11.4 kg',
        tag: 'New Release',
        price: 76000,
        formattedPrice: '₦76,000',
        categories: ['outdoor', 'statement'],
        rating: 4.9,
        reviewCount: 22,
        image: '/images/products/oko-statement-studio.jpg',
        defaultFinish: 'Clay',
        finishes: [
            { name: 'Clay', hex: '#B8755D', label: 'Rich Terracotta Earth' },
            { name: 'Sand', hex: '#C8B9A4', label: 'Warm Travertine Stone' },
            { name: 'Ink', hex: '#20231F', label: 'Volcanic Basalt Black' },
            { name: 'Sage', hex: '#879080', label: 'Muted Botanical Patina' },
        ],
        sizes: [
            { name: 'Standard (48cm Dia × 65cm H)', additionalCost: 0 },
            { name: 'Colossus (56cm Dia × 78cm H)', additionalCost: 24000 },
        ],
        drainageOptions: [
            'Indoor (Sealed base)',
            'Outdoor (Drainage hole)',
        ],
        leadTime: 'In Stock · Ships in 24 to 48 hours',
        description: 'A wide fluted cylinder with 32 clean vertical ribs. Cast in weatherproof stone composite for patios, verandas, and open interiors.',
        specs: [
            { label: 'Material', value: 'Resin-free mineral stone with natural oxides' },
            { label: 'Dimensions', value: '48 cm diameter × 65 cm height' },
            { label: 'Weight', value: '11.4 kg' },
            { label: 'Origin', value: 'Made in Nigeria' },
            { label: 'Warranty', value: '3-year structural guarantee' }
        ]
    }
];

export const trustPillars = [
    {
        index: '01',
        tag: 'MATERIAL COMPOSITION',
        icon: 'leaf',
        title: 'Resin-Free Mineral Matrix',
        description: 'Crushed natural limestone, silica, and mineral binders. 100% free from synthetic petroleum resins, microplastics, and VOC emissions.',
        stat: '0% Resins · Non-Toxic'
    },
    {
        index: '02',
        tag: 'STRUCTURAL WEIGHT',
        icon: 'feather',
        title: 'Engineered Lightweight Mass',
        description: 'Up to 50% lighter than solid poured concrete, with multi-axis tensile strength for effortless placement on luxury timber and stone floors.',
        stat: '50% Mass Reduction'
    },
    {
        index: '03',
        tag: 'SCULPTURAL PURITY',
        icon: 'arch',
        title: 'Proprietary Original Forms',
        description: 'Vessels sculpted in-house with considered architectural proportions and natural earthen oxide pigmentation. Never generic molds or mass imports.',
        stat: 'Original Silhouettes'
    },
    {
        index: '04',
        tag: 'PROVENANCE & LOGISTICS',
        icon: 'globe',
        title: 'Crafted & Crated in Nigeria',
        description: 'Manufactured locally to world-class tolerances. Delivered nationwide in custom timber shock-absorbing crating with zero-breakage guarantee.',
        stat: '36 States Crated Transit'
    }
];

