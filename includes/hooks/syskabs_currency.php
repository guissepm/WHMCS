<?php
/**
 * Devise par défaut — Sys Kabs Amazone
 * La base WHMCS reste USD (exigée par le module TheSSLStore pour la
 * synchronisation des prix). Ce hook sélectionne le franc CFA (XOF)
 * comme devise d'AFFICHAGE par défaut pour tout nouveau visiteur non
 * connecté qui n'a pas encore choisi de devise. Le visiteur peut
 * toujours changer via le sélecteur de devise du panier.
 * Sans devise XOF créée dans l'admin (Setup > Currencies), le hook est
 * un no-op inoffensif.
 */

use WHMCS\Database\Capsule;

add_hook('ClientAreaPage', 1, function ($vars) {
    // Client connecté : sa devise de compte prime, on ne touche à rien.
    if (!empty($_SESSION['uid'])) {
        return;
    }
    // Devise déjà choisie (session) ou forcée par l'URL (?currency=N).
    if (!empty($_SESSION['currency']) || isset($_GET['currency'])) {
        return;
    }
    try {
        $xof = Capsule::table('tblcurrencies')->where('code', 'XOF')->value('id');
        if ($xof) {
            $_SESSION['currency'] = (int) $xof;
        }
    } catch (\Throwable $e) {
        // silencieux : ne jamais casser le front pour une histoire de devise
    }
});
