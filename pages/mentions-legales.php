<?php
/**
 * Page « Mentions légales, CGU & Confidentialité » — mit-sec.com
 * Produit édité par Sys Kabs Amazone SAS.
 *
 * Page cliente WHMCS autonome (pattern natif « Creating Custom Pages ») :
 * elle s'appuie sur init.php pour charger WHMCS, puis rend le template
 * templates/<theme>/mentions-legales.tpl DANS l'habillage du thème actif
 * (en-tête, menu, pied de page hérités de twenty-one).
 *
 * URL par défaut : /mentions-legales.php
 * URL propre optionnelle : /mentions-legales (voir la règle nginx documentée
 * dans docker_kit/nginx/whmcs.conf).
 *
 * Déploiement : le fichier vit dans pages/ (repo) et est copié à la RACINE
 * du webroot du conteneur par le pipeline GitHub Actions (voir deploy.yml).
 */

use WHMCS\ClientArea;

define('CLIENTAREA', true);

require __DIR__ . '/init.php';

$ca = new ClientArea();

$ca->setPageTitle('Mentions légales, CGU & Confidentialité');

$ca->addToBreadCrumb('index.php', 'Accueil');
$ca->addToBreadCrumb('mentions-legales.php', 'Mentions légales');

$ca->initPage();

// Rend templates/<theme>/mentions-legales.tpl dans l'habillage du thème.
$ca->setTemplate('mentions-legales');

$ca->output();
