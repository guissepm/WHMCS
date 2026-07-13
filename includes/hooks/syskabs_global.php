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

    // NB : la page panier/commande WHMCS est laissée dans son rendu d'origine
    // (pas d'habillage cart.css ni de conversion du menu en cartes). Le choix
    // de la durée se fait désormais dans la modale de commande rapide ci-dessous.
    $out =
        '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">'
        . '<link rel="stylesheet" href="' . $css . '">'
        // Modale de commande rapide (façon thesslstore) : catalogue accueil + boutique.
        . '<link rel="stylesheet" href="' . $root . '/templates/syskabs/css/ska-modal.css?v=1.2.0">'
        . '<script src="' . $root . '/templates/syskabs/js/ska-cart-modal.js?v=2.1.0" defer></script>';

    return $out;
});
