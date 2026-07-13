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

    $out =
        '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">'
        . '<link rel="stylesheet" href="' . $css . '">'
        // Modale de commande rapide (façon thesslstore) : catalogue accueil + boutique.
        . '<link rel="stylesheet" href="' . $root . '/templates/syskabs/css/ska-modal.css?v=1.0.0">'
        . '<script src="' . $root . '/templates/syskabs/js/ska-cart-modal.js?v=1.0.0" defer></script>';

    // Habillage pro du tunnel de commande : chargé UNIQUEMENT sur cart.php
    // (panier, configuration, checkout, confirmation). Scoppé sous
    // [id^="order-"] dans la feuille -> n'affecte pas le reste du site.
    $script = $_SERVER['SCRIPT_NAME'] ?? ($_SERVER['PHP_SELF'] ?? '');
    if (preg_match('#/cart\.php$#', (string) $script)) {
        $out .= '<link rel="stylesheet" href="' . $root
              . '/templates/syskabs/css/cart.css?v=1.1.0">'
              . '<script src="' . $root
              . '/templates/syskabs/js/ska-configure.js?v=1.0.0" defer></script>';
    }

    return $out;
});
