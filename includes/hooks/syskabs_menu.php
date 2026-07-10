<?php
/**
 * Menu principal — Sys Kabs Amazone
 * Ajoute une navigation catalogue type revendeur SSL au thème client.
 * Ajustez gid=1 si votre groupe de produits a un autre ID
 * (visible dans Setup > Products/Services).
 */

use WHMCS\View\Menu\Item as MenuItem;

add_hook('ClientAreaPrimaryNavbar', 1, function (MenuItem $primaryNavbar) {

    $ssl = $primaryNavbar->addChild('certificats-ssl', [
        'label' => 'Certificats SSL',
        'uri'   => 'cart.php?gid=1',
        'order' => 10,
    ]);

    $ssl->addChild('ssl-dv', [
        'label' => 'Validation de domaine (DV)',
        'uri'   => 'cart.php?gid=1',
        'order' => 10,
    ]);
    $ssl->addChild('ssl-ov', [
        'label' => 'Validation d\'organisation (OV)',
        'uri'   => 'cart.php?gid=1',
        'order' => 20,
    ]);
    $ssl->addChild('ssl-ev', [
        'label' => 'Validation étendue (EV)',
        'uri'   => 'cart.php?gid=1',
        'order' => 30,
    ]);
    $ssl->addChild('ssl-wildcard', [
        'label' => 'Wildcard',
        'uri'   => 'cart.php?gid=1',
        'order' => 40,
    ]);
    $ssl->addChild('ssl-san', [
        'label' => 'Multi-domaine (SAN)',
        'uri'   => 'cart.php?gid=1',
        'order' => 50,
    ]);

    $primaryNavbar->addChild('signature-code', [
        'label' => 'Signature de code',
        'uri'   => 'cart.php?gid=1',
        'order' => 20,
    ]);

    $primaryNavbar->addChild('marques', [
        'label' => 'Marques',
        'uri'   => 'cart.php?gid=1',
        'order' => 30,
    ]);
});
