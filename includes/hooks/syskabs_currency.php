<?php
/**
 * Devise par défaut — Sys Kabs Amazone
 * La base WHMCS reste USD (exigée par le module TheSSLStore pour la
 * synchronisation des prix). Pour tout nouveau visiteur non connecté
 * sans devise choisie, on redirige une seule fois vers la même URL
 * avec ?currency=<id XOF> : c'est le mécanisme natif de WHMCS pour
 * fixer la devise de session, il est pris en compte dès le rendu.
 * Sans devise XOF créée dans l'admin (Setup > Currencies), no-op.
 */

use WHMCS\Database\Capsule;

add_hook('ClientAreaPage', 1, function ($vars) {
    // Client connecté : la devise de son compte prime.
    if (!empty($_SESSION['uid'])) {
        return;
    }
    // Devise déjà fixée (session) ou en cours de sélection (?currency=N).
    if (!empty($_SESSION['currency']) || isset($_GET['currency'])) {
        return;
    }
    // Redirection uniquement pour des GET simples (jamais un POST).
    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'GET') {
        return;
    }
    try {
        $xof = Capsule::table('tblcurrencies')->where('code', 'XOF')->value('id');
        if (!$xof) {
            return;
        }
        // Pose aussi la session directement (suffit sur la plupart des pages).
        $_SESSION['currency'] = (int) $xof;

        $uri = $_SERVER['REQUEST_URI'] ?? '/';
        $sep = (strpos($uri, '?') === false) ? '?' : '&';
        header('Location: ' . $uri . $sep . 'currency=' . (int) $xof, true, 302);
        exit;
    } catch (\Throwable $e) {
        // silencieux : ne jamais casser le front pour une histoire de devise
    }
});
