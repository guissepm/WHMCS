<?php
/**
 * Sys Kabs Amazone — responsive global sur TOUT l'espace client.
 * Injecte la balise viewport (sinon Safari mobile rend à 980px virtuels)
 * et une feuille de garde-fous responsive dans l'en-tête de chaque page
 * client (accueil, boutique, panier, commande, espace client, factures…).
 */

add_hook('ClientAreaHeadOutput', 1, function ($vars) {
    $root = rtrim($vars['WEB_ROOT'] ?? '', '/');
    $css  = $root . '/templates/syskabs/css/global-responsive.css?v=1.1.0';

    return
        '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">'
        . '<link rel="stylesheet" href="' . $css . '">';
});
