<?php
/**
 * Accueil Sys Kabs Amazone — fournit au template homepage.tpl les vrais
 * produits Certificats SSL (gid=1) avec leur prix le plus bas dans la
 * devise par défaut. Variable exposée : $skaProducts.
 */

use WHMCS\Database\Capsule;

add_hook('ClientAreaPageHome', 1, function ($vars) {
    try {
        $currency = Capsule::table('tblcurrencies')->where('default', 1)->first();
        if (!$currency) {
            $currency = Capsule::table('tblcurrencies')->orderBy('id')->first();
        }
        if (!$currency) {
            return ['skaProducts' => []];
        }

        $cycles = [
            'monthly'      => '/mois',
            'quarterly'    => '/trim.',
            'semiannually' => '/6 mois',
            'annually'     => '/an',
            'biennially'   => '/2 ans',
            'triennially'  => '/3 ans',
        ];

        $products = Capsule::table('tblproducts')
            ->where('gid', 1)
            ->where('hidden', 0)
            ->orderBy('order')
            ->orderBy('id')
            ->get();

        $list = [];
        foreach ($products as $p) {
            $n = mb_strtolower($p->name);

            // La vitrine accueil ne montre que les certificats
            if (preg_match('/sitelock|codeguard|cwatch|hackerguardian|pci/', $n)) {
                continue;
            }

            $pricing = Capsule::table('tblpricing')
                ->where('type', 'product')
                ->where('relid', $p->id)
                ->where('currency', $currency->id)
                ->first();
            if (!$pricing) {
                continue;
            }

            $best = null;
            $bestCycle = '';
            if ($p->paytype === 'onetime') {
                if ($pricing->monthly !== null && $pricing->monthly >= 0) {
                    $best = (float) $pricing->monthly;
                }
            } else {
                foreach ($cycles as $col => $label) {
                    $v = $pricing->$col;
                    if ($v !== null && $v >= 0 && ($best === null || (float) $v < $best)) {
                        $best = (float) $v;
                        $bestCycle = $label;
                    }
                }
            }
            if ($best === null) {
                continue;
            }

            // Marque (même logique que la page boutique)
            $brand = '—';
            if (preg_match('/sectigo|positivessl|instantssl|essentialssl/', $n)) {
                $brand = 'Sectigo';
            } elseif (strpos($n, 'comodo') !== false) {
                $brand = 'Comodo';
            } elseif (preg_match('/digicert|secure site|basic ev|basic ov/', $n)) {
                $brand = 'DigiCert';
            } elseif (strpos($n, 'rapidssl') !== false) {
                $brand = 'RapidSSL';
            } elseif (preg_match('/geotrust|quickssl|businessid/', $n)) {
                $brand = 'GeoTrust';
            } elseif (strpos($n, 'thawte') !== false) {
                $brand = 'Thawte';
            }

            // Validation + catégorie de filtre
            if (strpos($n, 'code sign') !== false) {
                $val = 'Code Signing';            $vcls = 'ska-v-ov'; $cat = 'cs';
            } elseif (preg_match('/\bev\b|extended/', $n)) {
                $val = 'Domaine + Organisation (EV)'; $vcls = 'ska-v-ev'; $cat = 'ev';
            } elseif (strpos($n, 'wildcard') !== false) {
                $val = 'Domaine (Wildcard)';      $vcls = 'ska-v-dv'; $cat = 'wc';
            } elseif (preg_match('/multi|ucc|\bsan\b/', $n)) {
                $val = 'Multi-domaine (SAN)';     $vcls = 'ska-v-dv'; $cat = 'san';
            } elseif (preg_match('/\bov\b|organization|businessid|instantssl|secure site/', $n)) {
                $val = 'Domaine + Organisation (OV)'; $vcls = 'ska-v-ov'; $cat = 'ov';
            } else {
                $val = 'Domaine (DV)';            $vcls = 'ska-v-dv'; $cat = 'dv';
            }

            $list[] = [
                'pid'       => $p->id,
                'name'      => $p->name,
                'brand'     => $brand,
                'brandslug' => strtolower($brand),
                'val'       => $val,
                'valcls'    => $vcls,
                'cat'       => $cat,
                'price'     => $currency->prefix . number_format($best, 2) . ' ' . $currency->suffix,
                'cycle'     => $bestCycle,
            ];

            if (count($list) >= 10) {
                break;
            }
        }

        return ['skaProducts' => $list];
    } catch (\Throwable $e) {
        return ['skaProducts' => []];
    }
});
