<link href="{$WEB_ROOT}/templates/{$template}/css/custom.css?v=1.1.0" rel="stylesheet">

{* ============================================================
   Accueil boutique — Sys Kabs Amazone
   Hero + catalogue vitrine au format tableau (même rendu que la
   page boutique syskabs_cart), filtrable par type de validation.
   Ajustez gid=1 si votre groupe de produits n'a pas l'ID 1.
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
    {* chaque marque affiche son logo si <marque>-logo.svg existe, sinon repli texte *}
    {foreach ['DigiCert','GeoTrust','Thawte','RapidSSL','Sectigo','Comodo','SiteLock','CodeGuard'] as $skaB}
      <span class="ska-brand-slot">
        <img src="{$WEB_ROOT}/assets/ssl_resources/images/emails/{$skaB|lower}-logo.svg"
             alt="{$skaB}" class="ska-brandlogo"
             onerror="this.style.display='none';this.nextElementSibling.style.display='inline'">
        <span class="ska-bfall" style="display:none">{$skaB}</span>
      </span>
    {/foreach}
  </section>

  {* ---------- CATALOGUE (tableau) ---------- *}
  <section class="ska-catalog-sec" id="ska-catalog-sec">
    <div class="ska-sec-head">
      <span class="ska-eyebrow">Catalogue</span>
      <h2>Trouvez le certificat qu'il vous faut</h2>
      <p>Filtrez par type de validation, comparez marques et garanties, commandez en quelques clics.</p>
    </div>

    <div class="ska-cattabs" id="skaHomeTabs">
      <button class="ska-cattab" data-v="websec">&#128737;&nbsp; Sécurité Web</button>
      <button class="ska-cattab active" data-v="cert">&#128274;&nbsp; Certificats</button>
      <button class="ska-cattab" data-v="pki">&#128273;&nbsp; PKI</button>
    </div>

    <div id="skaHomeCert">
    <div class="ska-filters" id="skaFilters">
      <button class="ska-tab active" data-f="all">Tous</button>
      <button class="ska-tab" data-f="dv">DV — Domaine</button>
      <button class="ska-tab" data-f="ov">OV — Organisation</button>
      <button class="ska-tab" data-f="ev">EV — Étendue</button>
      <button class="ska-tab" data-f="wc">Wildcard</button>
      <button class="ska-tab" data-f="san">Multi-domaine</button>
      <button class="ska-tab" data-f="cs">Code Signing</button>
    </div>

    <div class="ska-ptable-wrap">
      <table class="ska-ptable">
        <thead>
          <tr>
            <th class="ska-col-name">Produits</th>
            <th>Marque</th>
            <th>Validation</th>
            <th class="ska-col-price">Prix le plus bas</th>
            <th class="ska-col-cta"></th>
          </tr>
        </thead>
        <tbody id="skaGrid">
          {if isset($skaProducts) && $skaProducts|count > 0}
            {foreach $skaProducts as $sp}
              <tr data-cat="{$sp.cat}">
                <td class="ska-col-name">
                  <a href="{$WEB_ROOT}/cart.php?a=add&amp;pid={$sp.pid}" class="ska-pname">{$sp.name}</a>
                </td>
                <td class="ska-col-brand">
                  {if $sp.brand != '—'}
                    <img src="{$WEB_ROOT}/assets/ssl_resources/images/emails/{$sp.brandslug}-logo.svg"
                         alt="{$sp.brand}" class="ska-blogo"
                         onerror="this.style.display='none';this.nextElementSibling.style.display='inline'">
                    <span class="ska-bfall" style="display:none">{$sp.brand}</span>
                  {else}
                    —
                  {/if}
                </td>
                <td><span class="ska-vbadge {$sp.valcls}">{$sp.val}</span></td>
                <td class="ska-col-price"><b>{$sp.price}</b><span>{$sp.cycle}</span></td>
                <td class="ska-col-cta">
                  <a href="{$WEB_ROOT}/cart.php?a=add&amp;pid={$sp.pid}" class="ska-addcart">Ajouter au panier</a>
                </td>
              </tr>
            {/foreach}
          {else}
            <tr><td colspan="5" style="text-align:center;padding:28px;color:#54657E">
              Consultez le <a href="{$WEB_ROOT}/index.php?rp=/store/certificats-ssl">catalogue complet</a> pour découvrir nos certificats.
            </td></tr>
          {/if}
        </tbody>
      </table>
    </div>
    <p class="ska-empty" id="skaEmpty" style="display:none">Aucun produit dans cette catégorie.</p>
    <div class="ska-more">
      <a href="{$WEB_ROOT}/index.php?rp=/store/certificats-ssl" class="ska-btn ska-btn-ghost">Voir les 100+ certificats du catalogue &rarr;</a>
    </div>
    </div>{* /skaHomeCert *}

    {* ---------- Vue Sécurité Web (produits réels) ---------- *}
    <div id="skaHomeWebsec" style="display:none">
      {if isset($skaWebsecProducts) && $skaWebsecProducts|count > 0}
        <div class="ska-grid ska-store-grid ska-websec-grid">
          {foreach $skaWebsecProducts as $wp}
            <article class="ska-card ska-wcard">
              <div class="ska-wcard-logo">
                <img src="{$WEB_ROOT}/assets/ssl_resources/images/emails/{$wp.brandslug}-logo.svg"
                     alt="{$wp.brand}" class="ska-wlogo"
                     onerror="this.style.display='none';this.nextElementSibling.style.display='inline'">
                <span class="ska-bfall" style="display:none">{$wp.brand}</span>
              </div>
              <h3><a href="{$WEB_ROOT}/cart.php?a=add&amp;pid={$wp.pid}" class="ska-pname">{$wp.name}</a></h3>
              {if $wp.desc}<div class="ska-desc">{$wp.desc}&hellip;</div>{/if}
              <div class="ska-price ska-wprice"><b>{$wp.price}</b><span>{$wp.cycle}</span></div>
              <div class="ska-card-cta">
                <a href="{$WEB_ROOT}/cart.php?a=add&amp;pid={$wp.pid}" class="ska-btn ska-btn-primary">Commander</a>
              </div>
            </article>
          {/foreach}
        </div>
      {else}
        <p class="ska-empty">Les produits Sécurité Web arrivent bientôt &mdash; consultez le <a href="{$WEB_ROOT}/index.php?rp=/store/certificats-ssl">catalogue</a>.</p>
      {/if}
    </div>

    {* ---------- Vue PKI (solutions sur devis) ---------- *}
    <div id="skaHomePki" style="display:none">
      <div class="ska-grid ska-store-grid ska-websec-grid">
        {foreach [
          ['b' => 'DigiCert', 't' => 'DigiCert CertCentral', 'd' => "Plateforme centralisée pour émettre, déployer et renouveler tous vos certificats à grande échelle."],
          ['b' => 'DigiCert', 't' => 'DigiCert ONE',         'd' => "Gestion PKI moderne et conteneurisée pour un déploiement rapide dans les environnements complexes."],
          ['b' => 'DigiCert', 't' => 'Trust Lifecycle Manager', 'd' => "Inventoriez, émettez et automatisez le cycle de vie des certificats publics et privés."],
          ['b' => 'Sectigo',  't' => 'Sectigo Certificate Manager', 'd' => "Pilotez de gros volumes de certificats, réduisez les coûts et évitez les interruptions."],
          ['b' => 'Sectigo',  't' => 'Sectigo IoT Manager',  'd' => "Sécurité des objets connectés : chiffrement, authentification des équipements, démarrage sécurisé."],
          ['b' => 'Venafi',   't' => 'Venafi',               'd' => "Gestion de référence des identités machines : clés privées et certificats à l'échelle."],
          ['b' => 'KeyFactor','t' => 'KeyFactor',            'd' => "La confiance des identités machines pour équipements, applications et charges de travail critiques."],
          ['b' => 'AppViewX', 't' => 'AppViewX',             'd' => "Automatisation de bout en bout de la PKI et orchestration des certificats multi-équipes."]
        ] as $pk}
          <article class="ska-card ska-wcard">
            <div class="ska-wcard-logo">
              <img src="{$WEB_ROOT}/assets/ssl_resources/images/emails/{$pk.b|lower}-logo.svg"
                   alt="{$pk.b}" class="ska-wlogo"
                   onerror="this.style.display='none';this.nextElementSibling.style.display='inline'">
              <span class="ska-bfall" style="display:none">{$pk.b}</span>
            </div>
            <h3>{$pk.t}</h3>
            <div class="ska-desc">{$pk.d}</div>
            <div class="ska-card-cta">
              <a href="{$WEB_ROOT}/contact.php" class="ska-btn ska-btn-ghost">Nous contacter</a>
            </div>
          </article>
        {/foreach}
      </div>
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
  var tabs=document.getElementById('skaHomeTabs');
  if(tabs){
    var views={cert:'skaHomeCert', websec:'skaHomeWebsec', pki:'skaHomePki'};
    tabs.addEventListener('click',function(e){
      var t=e.target.closest('.ska-cattab'); if(!t) return;
      tabs.querySelectorAll('.ska-cattab').forEach(function(b){b.classList.remove('active')});
      t.classList.add('active');
      var v=t.getAttribute('data-v');
      Object.keys(views).forEach(function(k){
        var el=document.getElementById(views[k]);
        if(el) el.style.display=(k===v)?'':'none';
      });
    });
  }
})();

(function(){
  var bar=document.getElementById('skaFilters'); if(!bar) return;
  var rows=[].slice.call(document.querySelectorAll('#skaGrid tr[data-cat]'));
  var empty=document.getElementById('skaEmpty');
  bar.addEventListener('click',function(e){
    var t=e.target.closest('.ska-tab'); if(!t) return;
    bar.querySelectorAll('.ska-tab').forEach(function(b){b.classList.remove('active')});
    t.classList.add('active');
    var f=t.getAttribute('data-f'), n=0;
    rows.forEach(function(r){
      var ok=(f==='all'||r.getAttribute('data-cat')===f);
      r.style.display=ok?'':'none'; if(ok)n++;
    });
    empty.style.display=n?'none':'block';
  });
})();
</script>
{/literal}
