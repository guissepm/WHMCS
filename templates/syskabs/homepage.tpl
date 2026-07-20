<link href="{$WEB_ROOT}/templates/{$template}/css/custom.css?v=2.7.0" rel="stylesheet">

{* ============================================================
   Accueil boutique — Sys Kabs Amazone
   Hero + catalogue vitrine au format tableau (même rendu que la
   page boutique syskabs_cart), filtrable par type de validation.
   Ajustez gid=1 si votre groupe de produits n'a pas l'ID 1.
   ============================================================ *}

<div class="ska-page">

  {* ---------- HERO ---------- *}
  <section class="ska-slider" id="skaSlider">
    <div class="ska-slides" id="skaSlides">

      {* --- Slide 1 : promesse générale --- *}
      <div class="ska-slide ska-sl-a">
        <div class="ska-slide-inner">
          <div class="ska-slide-copy">
            <span class="ska-eyebrow">Certificats officiels des Autorités de certification mondiales</span>
            <h2>Chaque connexion mérite le <span class="ska-green">cadenas vert</span>.</h2>
            <p>Certificats SSL/TLS, signature de code et sécurité web — émis en quelques minutes, aux meilleurs tarifs.</p>
            <div class="ska-hero-cta">
              <a href="{$WEB_ROOT}/index.php?rp=/store/certificats-ssl" class="ska-btn ska-btn-primary ska-btn-lg">Choisir mon certificat</a>
              <a href="#ska-compare" class="ska-btn ska-btn-ghost ska-btn-lg">Comparer DV / OV / EV</a>
            </div>
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
      </div>

      {* --- Slide 2 : DigiCert --- *}
      <div class="ska-slide ska-sl-b">
        <div class="ska-slide-inner">
          <div class="ska-slide-copy">
            <span class="ska-eyebrow">Le leader mondial de la PKI</span>
            <h2>Certificats DigiCert au meilleur prix.</h2>
            <p>Secure Site, Basic et Multi-domaine — la référence des grandes marques, émise en un temps record.</p>
            <div class="ska-hero-cta">
              <a href="{$WEB_ROOT}/index.php?rp=/store/certificats-ssl" class="ska-btn ska-btn-white ska-btn-lg">Voir les certificats</a>
            </div>
          </div>
          <div class="ska-slide-visual">
            <img src="{$WEB_ROOT}/assets/ssl_resources/images/emails/digicert-logo.svg" alt="DigiCert"
                 onerror="this.style.display='none';this.nextElementSibling.style.display='inline'">
            <span class="ska-bfall-big" style="display:none">DigiCert</span>
          </div>
        </div>
      </div>

      {* --- Slide 3 : Wildcard --- *}
      <div class="ska-slide ska-sl-c">
        <div class="ska-slide-inner">
          <div class="ska-slide-copy">
            <span class="ska-eyebrow">*.votredomaine.com</span>
            <h2>Un Wildcard pour tous vos sous-domaines.</h2>
            <p>Sécurisez le domaine principal et un nombre illimité de sous-domaines avec un seul certificat.</p>
            <div class="ska-hero-cta">
              <a href="{$WEB_ROOT}/index.php?rp=/store/certificats-ssl" class="ska-btn ska-btn-white ska-btn-lg">Découvrir les Wildcard</a>
            </div>
          </div>
          <div class="ska-slide-visual"><span class="ska-wild-mark">*.</span></div>
        </div>
      </div>

      {* --- Slide 4 : Code Signing & PKI --- *}
      <div class="ska-slide ska-sl-d">
        <div class="ska-slide-inner">
          <div class="ska-slide-copy">
            <span class="ska-eyebrow">Entreprises & éditeurs</span>
            <h2>Signature de code &amp; solutions PKI.</h2>
            <p>Signez vos logiciels, gérez vos identités machines et automatisez le cycle de vie de vos certificats.</p>
            <div class="ska-hero-cta">
              <a href="{$WEB_ROOT}/contact.php" class="ska-btn ska-btn-white ska-btn-lg">Parler à un expert</a>
            </div>
          </div>
          <div class="ska-slide-visual"><span class="ska-code-mark">&lt;/&gt;</span></div>
        </div>
      </div>

    </div>

    <button class="ska-sl-arrow ska-sl-prev" id="skaSlPrev" aria-label="Bannière précédente">&#10094;</button>
    <button class="ska-sl-arrow ska-sl-next" id="skaSlNext" aria-label="Bannière suivante">&#10095;</button>
    <div class="ska-sl-dots" id="skaSlDots"></div>
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

    <div id="skaCatalogHost">
    <div class="ska-cattabs" id="skaCatTabs">
      <button class="ska-cattab" data-v="websec">&#128737;&nbsp; Sécurité Web</button>
      <button class="ska-cattab active" data-v="cert">&#128274;&nbsp; Certificats</button>
      <button class="ska-cattab" data-v="pki">&#128273;&nbsp; PKI</button>
    </div>

    <div id="skaViewCert">
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
                <td class="ska-col-name" data-label="Produit">
                  <a href="{$WEB_ROOT}/cart.php?a=add&amp;pid={$sp.pid}" class="ska-pname">{$sp.name}</a>
                </td>
                <td class="ska-col-brand" data-label="Marque">
                  {if $sp.brand != '—'}
                    <img src="{$WEB_ROOT}/assets/ssl_resources/images/emails/{$sp.brandslug}-logo.svg"
                         alt="{$sp.brand}" class="ska-blogo"
                         onerror="this.style.display='none';this.nextElementSibling.style.display='inline'">
                    <span class="ska-bfall" style="display:none">{$sp.brand}</span>
                  {else}
                    —
                  {/if}
                </td>
                <td data-label="Validation"><span class="ska-vbadge {$sp.valcls}">{$sp.val}</span></td>
                <td class="ska-col-price" data-label="Prix le plus bas"><b>{$sp.price}</b><span>{$sp.cycle}</span></td>
                <td class="ska-col-cta" data-label="">
                  <a href="{$WEB_ROOT}/cart.php?a=add&amp;pid={$sp.pid}" class="ska-addcart">Commander</a>
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
    </div>{* /skaViewCert *}

    {* ---------- Vue Sécurité Web (produits réels) ---------- *}
    <div id="skaViewWebsec" style="display:none">
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
    <div id="skaViewPki" style="display:none">
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
    </div>{* /skaCatalogHost *}
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

  {* ---------- SÉCURITÉ APPLICATIVE (Acunetix / Invicti) ---------- *}
  <section class="ska-appsec" id="ska-appsec">
    <div class="ska-appsec-inner">
      <div class="ska-sec-head ska-appsec-head">
        <span class="ska-eyebrow">Audit de vulnérabilités web · DAST</span>
        <h2>Trouvez vos failles <span class="ska-green">avant les attaquants</span></h2>
        <p class="ska-lede">Partenaire <strong>Acunetix (by Invicti)</strong> — le scanner de sécurité
        applicative de référence. Nous auditons vos sites, applications et API, du conseil au
        déploiement clé en main.</p>
      </div>

      <div class="ska-appsec-stats">
        <div><b>99,98&nbsp;%</b><span>de précision — Proof-Based&trade;</span></div>
        <div><b>7&nbsp;000+</b><span>vulnérabilités détectées</span></div>
        <div><b>20+ ans</b><span>d'expertise DAST</span></div>
        <div><b>4&nbsp;000+</b><span>organisations protégées</span></div>
      </div>

      <div class="ska-appsec-grid">
        <article class="ska-appsec-card">
          <span class="ska-appsec-ic">&#127760;</span>
          <h3>Scan applicatif complet</h3>
          <p>Sites web, applications, SPA et API (REST, GraphQL, SOAP) — ce qui n'est pas trouvé ne peut être testé.</p>
        </article>
        <article class="ska-appsec-card">
          <span class="ska-appsec-ic">&#127919;</span>
          <h3>Preuve d'exploitabilité</h3>
          <p>Chaque faille est confirmée par une preuve : quasi zéro faux positif, vous corrigez ce qui compte vraiment.</p>
        </article>
        <article class="ska-appsec-card">
          <span class="ska-appsec-ic">&#128737;</span>
          <h3>OWASP Top 10 &amp; API Top 10</h3>
          <p>Injections SQL, XSS, failles de logique métier, API exposées… couverture approfondie.</p>
        </article>
        <article class="ska-appsec-card">
          <span class="ska-appsec-ic">&#128272;</span>
          <h3>Tests authentifiés</h3>
          <p>Parcours à rôles et scénarios de connexion complexes, pour auditer aussi les zones protégées.</p>
        </article>
        <article class="ska-appsec-card">
          <span class="ska-appsec-ic">&#9881;&#65039;</span>
          <h3>Intégration DevSecOps</h3>
          <p>CI/CD, Jira, GitLab, Jenkins : passez à l'audit continu, intégré à vos pipelines.</p>
        </article>
        <article class="ska-appsec-card">
          <span class="ska-appsec-ic">&#129513;</span>
          <h3>Au-delà du DAST</h3>
          <p>SAST, SCA, conteneurs, IaC et pilotage du risque (ASPM) avec les éditions Core &amp; Platform.</p>
        </article>
      </div>

      <div class="ska-appsec-tiers">
        <div class="ska-tier">
          <h4>Acunetix</h4>
          <p>Le DAST essentiel pour auditer un site ou une application.</p>
          <small>PME, agences, sites vitrines &amp; e-commerce</small>
        </div>
        <div class="ska-tier ska-tier-hot">
          <span class="ska-tier-badge">Le plus complet</span>
          <h4>Invicti Core</h4>
          <p>Tout-en-un : DAST + SAST + SCA + conteneurs + IaC, opérationnel en quelques minutes.</p>
          <small>Équipes dev &amp; sécurité</small>
        </div>
        <div class="ska-tier">
          <h4>Invicti Platform + ASPM</h4>
          <p>Plateforme entreprise : couverture massive, corrélation des résultats et pilotage du risque.</p>
          <small>Banques, administrations, grands comptes</small>
        </div>
      </div>

      <div class="ska-appsec-cta">
        <a href="{$WEB_ROOT}/submitticket.php" class="ska-btn ska-btn-primary ska-btn-lg">Demander un audit</a>
        <a href="{$WEB_ROOT}/contact.php" class="ska-btn ska-btn-ghost ska-btn-lg ska-btn-ghost-dark">Parler à un expert / devis</a>
      </div>
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

<script>var skaStoreUrl='{$WEB_ROOT}/index.php?rp=/store/certificats-ssl';</script>
<script src="{$WEB_ROOT}/templates/syskabs/js/ska-catalog.js?v=1.4.0"></script>
{literal}
<script>
/* Import du catalogue de la boutique : source unique de verite.
   En cas d'echec reseau, le rendu serveur (hook) reste en place. */
(function(){
  if(!window.fetch || !window.DOMParser) return;
  fetch(skaStoreUrl, {credentials:'same-origin'})
    .then(function(r){ if(!r.ok) throw 0; return r.text(); })
    .then(function(html){
      var doc=new DOMParser().parseFromString(html,'text/html');
      var st=doc.getElementById('skaStoreRoot');
      var host=document.getElementById('skaCatalogHost');
      if(!st || !host) return;
      host.classList.add('ska-imported');
      host.innerHTML='';
      host.appendChild(st);
      if(window.skaInitCatalog) window.skaInitCatalog(host);
    })
    .catch(function(){ /* fallback serveur conserve */ });
})();
</script>
<script>
/* Carrousel de bannières : autoplay 6s, fleches, points, swipe.
   Respecte prefers-reduced-motion (pas d'autoplay). */
(function(){
  var wrap=document.getElementById('skaSlides'); if(!wrap) return;
  var slides=wrap.children, n=slides.length, i=0, timer=null;
  var dots=document.getElementById('skaSlDots');
  for(var d=0; d<n; d++){
    var b=document.createElement('button');
    b.className='ska-sl-dot'+(d===0?' active':'');
    b.setAttribute('aria-label','Bannière '+(d+1));
    b.dataset.i=d;
    dots.appendChild(b);
  }
  function go(k){
    i=(k+n)%n;
    wrap.style.transform='translateX(-'+(i*100)+'%)';
    [].forEach.call(dots.children,function(x,j){x.classList.toggle('active',j===i);});
  }
  function next(){ go(i+1); }
  function play(){
    if(matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    stop(); timer=setInterval(next, 6000);
  }
  function stop(){ if(timer){clearInterval(timer); timer=null;} }
  document.getElementById('skaSlNext').addEventListener('click',function(){ next(); play(); });
  document.getElementById('skaSlPrev').addEventListener('click',function(){ go(i-1); play(); });
  dots.addEventListener('click',function(e){
    var t=e.target.closest('.ska-sl-dot'); if(!t) return;
    go(parseInt(t.dataset.i,10)); play();
  });
  var sl=document.getElementById('skaSlider');
  sl.addEventListener('mouseenter',stop);
  sl.addEventListener('mouseleave',play);
  var x0=null;
  sl.addEventListener('touchstart',function(e){ x0=e.touches[0].clientX; stop(); },{passive:true});
  sl.addEventListener('touchend',function(e){
    if(x0===null) return;
    var dx=e.changedTouches[0].clientX-x0;
    if(dx>40) go(i-1); else if(dx<-40) next();
    x0=null; play();
  },{passive:true});
  play();
})();
</script>
{/literal}
