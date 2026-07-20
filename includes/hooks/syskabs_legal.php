<?php
/**
 * Liens légaux — Sys Kabs Amazone / mit-sec.com
 * Ajoute une ligne de liens (Mentions légales · CGU · Confidentialité)
 * dans le pied de page de tout l'espace client, sans modifier le thème
 * parent : on injecte proprement la ligne DANS l'élément <footer> existant
 * (repli sur <body> si le thème n'a pas de footer). Non-destructif.
 */

add_hook('ClientAreaFooterOutput', 1, function ($vars) {
    $root = rtrim($vars['WEB_ROOT'] ?? '', '/');
    $url  = $root . '/mentions-legales.php';

    // Année courante pour la ligne de copyright.
    $year = date('Y');

    return <<<HTML
<style>
.ska-legal-links{margin:0;padding:14px 12px;text-align:center;font-size:.85rem;color:#8a97a6;line-height:1.7}
.ska-legal-links a{color:#8a97a6;text-decoration:none;margin:0 .35em}
.ska-legal-links a:hover{color:#1e90ff;text-decoration:underline}
.ska-legal-links .sep{opacity:.5}
</style>
<div class="ska-legal-links" id="skaLegalLinks">
  &copy; {$year} Sys Kabs Amazone SAS &nbsp;·&nbsp;
  <a href="{$url}#mentions">Mentions légales</a>
  <span class="sep">·</span>
  <a href="{$url}#cgu">Conditions générales</a>
  <span class="sep">·</span>
  <a href="{$url}#confidentialite">Confidentialité</a>
</div>
<script>
(function(){
  var bar = document.getElementById('skaLegalLinks');
  if (!bar) return;
  var f = document.querySelector('footer');
  if (f && f !== bar.parentNode) { f.appendChild(bar); }
})();
</script>
HTML;
});
