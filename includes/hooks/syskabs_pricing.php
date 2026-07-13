<?php
/**
 * Sys Kabs Amazone — tarifs multi-annuels pour le catalogue.
 *
 * Fournit au template de la boutique (orderforms/syskabs_cart/products.tpl,
 * réutilisé tel quel par la page d'accueil qui l'importe) une carte
 * $skaYear indexée par ID produit, contenant :
 *   - peryear   : prix PAR AN le plus avantageux (chaîne formatée)
 *   - years     : la durée (1/2/3 ans) qui donne ce meilleur prix/an
 *   - discount  : % d'économie du prix/an multi-annuel vs le tarif 1 an
 *   - multiyear : true si au moins 2 durées sont proposées
 *   - annualref : prix/an du tarif 1 an (barré à l'affichage), si remise
 *
 * Principe (comme thesslstore) : on vend en cycles WHMCS
 * (annually / biennially / triennially) ; le tarif 2 ou 3 ans coûte moins
 * cher RAPPORTÉ À L'ANNÉE -> on met en avant « à partir de X/an » + la remise.
 *
 * Non-destructif : sans tarif 2/3 ans, la carte reste sur 1 an, discount 0,
 * et le template retombe sur son affichage habituel.
 */

use WHMCS\Database\Capsule;

add_hook('ClientAreaPageCart', 1, function ($vars) {
    try {
        $currency = Capsule::table('tblcurrencies')->where('default', 1)->first();
        if (!$currency) {
            $currency = Capsule::table('tblcurrencies')->orderBy('id')->first();
        }
        if (!$currency) {
            return [];
        }

        $fmt = function ($v) use ($currency) {
            $suffix = trim((string) $currency->suffix);
            return $currency->prefix . number_format((float) $v, 2)
                . ($suffix !== '' ? ' ' . $suffix : '');
        };

        // Un seul passage sur les tarifs produits de la devise par défaut.
        $rows = Capsule::table('tblpricing')
            ->where('type', 'product')
            ->where('currency', $currency->id)
            ->get();

        $map = [];
        foreach ($rows as $r) {
            // Durées disponibles = cycles au prix > 0 (WHMCS met -1 si désactivé).
            $terms = [];
            if ($r->annually    !== null && (float) $r->annually    > 0) { $terms[1] = (float) $r->annually; }
            if ($r->biennially  !== null && (float) $r->biennially  > 0) { $terms[2] = (float) $r->biennially; }
            if ($r->triennially !== null && (float) $r->triennially > 0) { $terms[3] = (float) $r->triennially; }
            if (!$terms) {
                continue;
            }

            // Meilleur prix RAPPORTÉ À L'ANNÉE.
            $bestYears = 1;
            $bestPerYear = null;
            foreach ($terms as $years => $total) {
                $perYear = $total / $years;
                if ($bestPerYear === null || $perYear < $bestPerYear - 0.001) {
                    $bestPerYear = $perYear;
                    $bestYears = $years;
                }
            }

            $annual = isset($terms[1]) ? $terms[1] : null; // prix/an de référence (1 an)
            $discount = 0;
            if ($annual !== null && $annual > 0 && $bestPerYear !== null) {
                $discount = (int) round((1 - ($bestPerYear / $annual)) * 100);
                if ($discount < 0) {
                    $discount = 0;
                }
            }

            // Détail de toutes les durées, pour la modale « façon thesslstore ».
            $cycleName = [1 => 'annually', 2 => 'biennially', 3 => 'triennially'];
            $termList = [];
            foreach ($terms as $years => $total) {
                $per  = $total / $years;
                $list = ($annual !== null) ? $annual * $years : 0.0;
                $save = ($list > 0) ? $list - $total : 0.0;
                $pct  = ($list > 0) ? (int) round($save / $list * 100) : 0;
                $termList[] = [
                    'y'    => $years,
                    'c'    => isset($cycleName[$years]) ? $cycleName[$years] : '',
                    't'    => round($total, 2),
                    'per'  => round($per, 2),
                    'list' => round($list, 2),
                    'save' => round(max(0, $save), 2),
                    'pct'  => max(0, $pct),
                ];
            }
            $termsJson = json_encode(
                ['cur' => $currency->prefix, 'sfx' => trim((string) $currency->suffix), 'terms' => $termList],
                JSON_UNESCAPED_UNICODE
            );

            $map[(int) $r->relid] = [
                'peryear'   => $fmt($bestPerYear),
                'years'     => $bestYears,
                'discount'  => $discount,
                'multiyear' => count($terms) > 1,
                'annualref' => ($discount > 0 && $annual !== null) ? $fmt($annual) : '',
                'termsjson' => $termsJson,
            ];
        }

        return ['skaYear' => $map];
    } catch (\Throwable $e) {
        return [];
    }
});
