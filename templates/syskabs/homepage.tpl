<link href="{$WEB_ROOT}/templates/{$template}/css/custom.css?v=1.0.0" rel="stylesheet">

{* ============================================================
   Accueil boutique — Sys Kabs Amazone
   Catalogue type revendeur SSL : hero, marques, filtres, cartes
   produits (marque / badge validation / note / prix barré / CTA).
   Les liens pointent vers le panier WHMCS ; ajustez gid= si votre
   groupe de produits n'a pas l'ID 1 (visible dans l'admin).
   ============================================================ *}

<div class="ska-page">

  {* ---------- HERO ---------- *}
  <section class="ska-hero">
    <div class="ska-hero-inner">
      <div class="ska-hero-copy">
        <span class="ska-eyebrow">Revendeur agréé — Autorités de certification mondiales</span>
        <h1>Chaque connexion mérite le <span class="ska-green">cadenas vert</span>.</h1>
        <p class="ska-lede">Certificats SSL/TLS, signature de code et sécurité web — émis en quelques minutes, aux tarifs revendeur, avec installation automatique.</p>
        <div class="ska-hero-cta">
          <a href="{$WEB_ROOT}/cart.php?gid=1" class="ska-btn ska-btn-primary ska-btn-lg">Choisir mon certificat</a>
          <a href="#ska-compare" class="ska-btn ska-btn-ghost ska-btn-lg">Comparer DV / OV / EV</a>
        </div>
        <ul class="ska-trust">
          <li>Émission dès 5 minutes</li>
          <li>Garantie jusqu'à 1,75&nbsp;M$</li>
          <li>Support 24/7</li>
        </ul>
      </div>
      <div class="ska-hero-card">
        <div class="ska-urlbar"><span class="ska-lock">&#128274;</span><span class="ska-url"><b>https://</b>votredomaine.com</span></div>
        <div class="ska-cert">
          <div class="ska-cert-head">
            <span class="ska-shield">&#10003;</span>
            <div><strong>Certificat validé</strong><small>TLS 1.3 · RSA 2048 / ECC</small></div>
          </div>
          <div class="ska-cert-rows">
            <div><span>Autorité</span><b>Sectigo</b></div>
            <div><span>Chiffrement</span><b>256 bits</b></div>
            <div><span>Statut</span><b class="ska-ok">ACTIF</b></div>
          </div>
        </div>
      </div>
    </div>
  </section>

  {* ---------- BANDEAU MARQUES ---------- *}
  <section class="ska-brands">
    <span class="ska-brands-label">Partenaire officiel</span>
    <span>Sectigo</span><span>DigiCert</span><span>RapidSSL</span>
    <span>GeoTrust</span><span>Thawte</span><span>Comodo&nbsp;CA</span>
  </section>

  {* ---------- CATALOGUE ---------- *}
  <section class="ska-catalog-sec" id="ska-catalog-sec">
    <div class="ska-sec-head">
      <span class="ska-eyebrow">Catalogue</span>
      <h2>Trouvez le certificat qu'il vous faut</h2>
      <p>Filtrez par type de validation, comparez marques et garanties, commandez en quelques clics.</p>
    </div>

    <div class="ska-filters" id="skaFilters">
      <button class="ska-tab active" data-f="all">Tous</button>
      <button class="ska-tab" data-f="dv">DV — Domaine</button>
      <button class="ska-tab" data-f="ov">OV — Organisation</button>
      <button class="ska-tab" data-f="ev">EV — Étendue</button>
      <button class="ska-tab" data-f="wc">Wildcard</button>
      <button class="ska-tab" data-f="san">Multi-domaine</button>
      <button class="ska-tab" data-f="cs">Code Signing</button>
    </div>

    <div class="ska-grid" id="skaGrid">

      <article class="ska-card" data-cat="dv">
        <header><span class="ska-brand"><i class="ska-dot ska-dot-sectigo"></i>Sectigo</span><span class="ska-badge ska-b-dv">DV</span></header>
        <h3>PositiveSSL</h3>
        <div class="ska-stars">&#9733;&#9733;&#9733;&#9733;&#9733; <em>4.9</em></div>
        <div class="ska-price"><b>8,50&nbsp;$</b><span>/an</span><s>12,00&nbsp;$</s><i class="ska-save">-29%</i></div>
        <ul><li>Émission ~5 min</li><li>Garantie 10&nbsp;k$</li><li>Réémissions gratuites</li></ul>
        <div class="ska-card-cta"><a class="ska-btn ska-btn-primary" href="{$WEB_ROOT}/cart.php?gid=1">Acheter</a></div>
      </article>

      <article class="ska-card" data-cat="dv">
        <header><span class="ska-brand"><i class="ska-dot ska-dot-rapid"></i>RapidSSL</span><span class="ska-badge ska-b-dv">DV</span></header>
        <h3>RapidSSL Standard</h3>
        <div class="ska-stars">&#9733;&#9733;&#9733;&#9733;&#9733; <em>4.7</em></div>
        <div class="ska-price"><b>13,00&nbsp;$</b><span>/an</span><s>17,00&nbsp;$</s><i class="ska-save">-24%</i></div>
        <ul><li>Émission ~10 min</li><li>Garantie 10&nbsp;k$</li><li>Sceau statique inclus</li></ul>
        <div class="ska-card-cta"><a class="ska-btn ska-btn-primary" href="{$WEB_ROOT}/cart.php?gid=1">Acheter</a></div>
      </article>

      <article class="ska-card" data-cat="ov">
        <header><span class="ska-brand"><i class="ska-dot ska-dot-sectigo"></i>Sectigo</span><span class="ska-badge ska-b-ov">OV</span></header>
        <h3>Sectigo OV SSL</h3>
        <div class="ska-stars">&#9733;&#9733;&#9733;&#9733;&#9733; <em>4.8</em></div>
        <div class="ska-price"><b>42,00&nbsp;$</b><span>/an</span><s>60,00&nbsp;$</s><i class="ska-save">-30%</i></div>
        <ul><li>Émission 1–3 j</li><li>Garantie 1,25&nbsp;M$</li><li>Organisation vérifiée</li></ul>
        <div class="ska-card-cta"><a class="ska-btn ska-btn-primary" href="{$WEB_ROOT}/cart.php?gid=1">Acheter</a></div>
      </article>

      <article class="ska-card" data-cat="ev">
        <header><span class="ska-brand"><i class="ska-dot ska-dot-sectigo"></i>Sectigo</span><span class="ska-badge ska-b-ev">EV</span></header>
        <h3>Sectigo EV SSL</h3>
        <div class="ska-stars">&#9733;&#9733;&#9733;&#9733;&#9733; <em>4.9</em></div>
        <div class="ska-price"><b>88,00&nbsp;$</b><span>/an</span><s>120,00&nbsp;$</s><i class="ska-save">-27%</i></div>
        <ul><li>Émission 1–5 j</li><li>Garantie 1,75&nbsp;M$</li><li>Validation étendue</li></ul>
        <div class="ska-card-cta"><a class="ska-btn ska-btn-primary" href="{$WEB_ROOT}/cart.php?gid=1">Acheter</a></div>
      </article>

      <article class="ska-card" data-cat="wc">
        <header><span class="ska-brand"><i class="ska-dot ska-dot-sectigo"></i>Sectigo</span><span class="ska-badge ska-b-dv">DV · Wildcard</span></header>
        <h3>PositiveSSL Wildcard</h3>
        <div class="ska-stars">&#9733;&#9733;&#9733;&#9733;&#9733; <em>4.8</em></div>
        <div class="ska-price"><b>95,00&nbsp;$</b><span>/an</span><s>130,00&nbsp;$</s><i class="ska-save">-27%</i></div>
        <ul><li>Sous-domaines illimités</li><li>Émission ~5 min</li><li>Serveurs illimités</li></ul>
        <div class="ska-card-cta"><a class="ska-btn ska-btn-primary" href="{$WEB_ROOT}/cart.php?gid=1">Acheter</a></div>
      </article>

      <article class="ska-card" data-cat="ov">
        <header><span class="ska-brand"><i class="ska-dot ska-dot-digicert"></i>DigiCert</span><span class="ska-badge ska-b-ov">OV</span></header>
        <h3>Secure Site OV</h3>
        <div class="ska-stars">&#9733;&#9733;&#9733;&#9733;&#9733; <em>5.0</em></div>
        <div class="ska-price"><b>195,00&nbsp;$</b><span>/an</span><s>268,00&nbsp;$</s><i class="ska-save">-27%</i></div>
        <ul><li>Garantie 1,75&nbsp;M$</li><li>Scan malware inclus</li><li>Sceau premium</li></ul>
        <div class="ska-card-cta"><a class="ska-btn ska-btn-primary" href="{$WEB_ROOT}/cart.php?gid=1">Acheter</a></div>
      </article>

      <article class="ska-card" data-cat="san">
        <header><span class="ska-brand"><i class="ska-dot ska-dot-sectigo"></i>Sectigo</span><span class="ska-badge ska-b-dv">DV · SAN</span></header>
        <h3>PositiveSSL Multi-Domain</h3>
        <div class="ska-stars">&#9733;&#9733;&#9733;&#9733;&#9733; <em>4.7</em></div>
        <div class="ska-price"><b>45,00&nbsp;$</b><span>/an</span><s>62,00&nbsp;$</s><i class="ska-save">-27%</i></div>
        <ul><li>Jusqu'à 250 domaines</li><li>3 domaines inclus</li><li>Émission ~5 min</li></ul>
        <div class="ska-card-cta"><a class="ska-btn ska-btn-primary" href="{$WEB_ROOT}/cart.php?gid=1">Acheter</a></div>
      </article>

      <article class="ska-card" data-cat="ev">
        <header><span class="ska-brand"><i class="ska-dot ska-dot-digicert"></i>DigiCert</span><span class="ska-badge ska-b-ev">EV</span></header>
        <h3>Secure Site EV</h3>
        <div class="ska-stars">&#9733;&#9733;&#9733;&#9733;&#9733; <em>5.0</em></div>
        <div class="ska-price"><b>340,00&nbsp;$</b><span>/an</span><s>449,00&nbsp;$</s><i class="ska-save">-24%</i></div>
        <ul><li>Garantie 2,00&nbsp;M$</li><li>Validation prioritaire</li><li>Confiance maximale</li></ul>
        <div class="ska-card-cta"><a class="ska-btn ska-btn-primary" href="{$WEB_ROOT}/cart.php?gid=1">Acheter</a></div>
      </article>

      <article class="ska-card" data-cat="cs">
        <header><span class="ska-brand"><i class="ska-dot ska-dot-sectigo"></i>Sectigo</span><span class="ska-badge ska-b-ov">Code</span></header>
        <h3>Code Signing</h3>
        <div class="ska-stars">&#9733;&#9733;&#9733;&#9733;&#9733; <em>4.8</em></div>
        <div class="ska-price"><b>210,00&nbsp;$</b><span>/an</span><s>289,00&nbsp;$</s><i class="ska-save">-27%</i></div>
        <ul><li>Supprime « éditeur inconnu »</li><li>Réputation SmartScreen</li><li>Timestamping inclus</li></ul>
        <div class="ska-card-cta"><a class="ska-btn ska-btn-primary" href="{$WEB_ROOT}/cart.php?gid=1">Acheter</a></div>
      </article>

    </div>
    <p class="ska-empty" id="skaEmpty" style="display:none">Aucun produit dans cette catégorie.</p>
    <div class="ska-more">
      <a href="{$WEB_ROOT}/cart.php?gid=1" class="ska-btn ska-btn-ghost">Voir les 100+ certificats du catalogue &rarr;</a>
    </div>
  </section>

  {* ---------- COMPARATIF ---------- *}
  <section class="ska-compare" id="ska-compare">
    <div class="ska-sec-head">
      <span class="ska-eyebrow">Comparatif</span>
      <h2>Quelle validation choisir&nbsp;?</h2>
    </div>
    <div class="ska-table-wrap">
      <table class="ska-table">
        <thead><tr><th>Caractéristique</th><th>DV — Domaine</th><th>OV — Organisation</th><th>EV — Étendue</th></tr></thead>
        <tbody>
          <tr><td>Cadenas &amp; HTTPS</td><td class="y">Oui</td><td class="y">Oui</td><td class="y">Oui</td></tr>
          <tr><td>Délai d'émission</td><td>~5 min</td><td>1–3 j</td><td>1–5 j</td></tr>
          <tr><td>Identité vérifiée</td><td class="n">—</td><td class="y">Oui</td><td class="y">Renforcée</td></tr>
          <tr><td>Garantie</td><td>10 k$</td><td>1,25 M$</td><td>1,75 M$</td></tr>
          <tr><td>Recommandé pour</td><td>Blogs, vitrines</td><td>E-commerce, SaaS</td><td>Banques, marques</td></tr>
        </tbody>
      </table>
    </div>
  </section>

  {* ---------- CTA ---------- *}
  <section class="ska-cta">
    <div>
      <h2>Prêt à afficher le cadenas vert&nbsp;?</h2>
      <p>Trouvez le certificat idéal en moins de deux minutes.</p>
    </div>
    <a href="{$WEB_ROOT}/cart.php?gid=1" class="ska-btn ska-btn-white ska-btn-lg">Démarrer maintenant</a>
  </section>

</div>

{literal}
<script>
(function(){
  var bar=document.getElementById('skaFilters'); if(!bar) return;
  var cards=[].slice.call(document.querySelectorAll('#skaGrid .ska-card'));
  var empty=document.getElementById('skaEmpty');
  bar.addEventListener('click',function(e){
    var t=e.target.closest('.ska-tab'); if(!t) return;
    bar.querySelectorAll('.ska-tab').forEach(function(b){b.classList.remove('active')});
    t.classList.add('active');
    var f=t.getAttribute('data-f'), n=0;
    cards.forEach(function(c){
      var ok=(f==='all'||c.getAttribute('data-cat')===f);
      c.style.display=ok?'':'none'; if(ok)n++;
    });
    empty.style.display=n?'none':'block';
  });
})();
</script>
{/literal}
