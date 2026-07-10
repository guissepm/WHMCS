{* ============================================================
   syskabs_cart — catalogue catégorisé
   Niveau 1 : Certificats / Sécurité Web (onglets pilules)
   Niveau 2 (Certificats) : onglets par marque + bandeau de marque
   Certificats -> tableau ; Sécurité Web -> cartes
   ============================================================ *}

<link href="{$WEB_ROOT}/templates/syskabs/css/custom.css?v=1.2.0" rel="stylesheet">

<div class="ska-store">

  <div class="ska-store-head">
    <h1>{$productGroup.name}</h1>
    {if $productGroup.tagline}<p>{$productGroup.tagline}</p>{/if}
  </div>

  {* ---------- Onglets de catégories ---------- *}
  <div class="ska-cattabs" id="skaCatTabs">
    <button class="ska-cattab active" data-v="cert">&#128274;&nbsp; Certificats</button>
    <button class="ska-cattab" data-v="websec">&#128737;&nbsp; Sécurité Web</button>
  </div>

  {* ============== VUE CERTIFICATS ============== *}
  <div id="skaViewCert">

    <div class="ska-filters" id="skaBrandTabs">
      <button class="ska-tab active" data-b="all">Toutes les marques</button>
      <button class="ska-tab" data-b="DigiCert">DigiCert</button>
      <button class="ska-tab" data-b="GeoTrust">GeoTrust</button>
      <button class="ska-tab" data-b="Thawte">Thawte</button>
      <button class="ska-tab" data-b="RapidSSL">RapidSSL</button>
      <button class="ska-tab" data-b="Sectigo">Sectigo</button>
      <button class="ska-tab" data-b="Comodo">Comodo</button>
    </div>

    <div class="ska-bhero" id="skaBHero" style="display:none">
      <div>
        <h2 id="skaBHeroTitle"></h2>
        <p>Tarifs revendeur — économisez par rapport aux prix éditeur</p>
      </div>
      <img id="skaBHeroLogo" class="ska-bhero-logo" alt="" src="">
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
        <tbody>
          {foreach $products as $product}
            {assign var=n value=$product.name|lower}

            {* --- catégorie : sécurité web vs certificat --- *}
            {assign var=skaCat value='cert'}
            {if $n|strstr:'sitelock' or $n|strstr:'codeguard' or $n|strstr:'cwatch' or $n|strstr:'hackerguardian' or $n|strstr:'pci'}
              {assign var=skaCat value='websec'}
            {/if}

            {if $skaCat == 'cert'}
              {* --- marque --- *}
              {assign var=skaBrand value='—'}
              {if $n|strstr:'sectigo' or $n|strstr:'positivessl' or $n|strstr:'instantssl' or $n|strstr:'essentialssl'}
                {assign var=skaBrand value='Sectigo'}
              {elseif $n|strstr:'comodo'}
                {assign var=skaBrand value='Comodo'}
              {elseif $n|strstr:'digicert' or $n|strstr:'secure site' or $n|strstr:'basic ev' or $n|strstr:'basic ov'}
                {assign var=skaBrand value='DigiCert'}
              {elseif $n|strstr:'rapidssl'}
                {assign var=skaBrand value='RapidSSL'}
              {elseif $n|strstr:'geotrust' or $n|strstr:'quickssl' or $n|strstr:'businessid'}
                {assign var=skaBrand value='GeoTrust'}
              {elseif $n|strstr:'thawte'}
                {assign var=skaBrand value='Thawte'}
              {/if}

              {* --- validation --- *}
              {assign var=skaVal value='—'}
              {assign var=skaValCls value=''}
              {if $n|strstr:'code sign'}
                {assign var=skaVal value='Code Signing'}{assign var=skaValCls value='ska-v-ov'}
              {elseif $n|strstr:'ev'}
                {assign var=skaVal value='Domaine + Organisation (EV)'}{assign var=skaValCls value='ska-v-ev'}
              {elseif $n|strstr:'wildcard'}
                {assign var=skaVal value='Domaine (Wildcard)'}{assign var=skaValCls value='ska-v-dv'}
              {elseif $n|strstr:' ov' or $n|strstr:'ov ' or $n|strstr:'organization' or $n|strstr:'businessid' or $n|strstr:'instantssl' or $n|strstr:'secure site'}
                {assign var=skaVal value='Domaine + Organisation (OV)'}{assign var=skaValCls value='ska-v-ov'}
              {elseif $n|strstr:'dv' or $n|strstr:'positivessl' or $n|strstr:'rapidssl' or $n|strstr:'quickssl' or $n|strstr:'essentialssl'}
                {assign var=skaVal value='Domaine (DV)'}{assign var=skaValCls value='ska-v-dv'}
              {/if}

              <tr data-brand="{$skaBrand}">
                <td class="ska-col-name">
                  {if isset($product.slug) && isset($productGroup.slug)}
                    <a href="{$WEB_ROOT}/index.php?rp=/store/{$productGroup.slug}/{$product.slug}" class="ska-pname">{$product.name}</a>
                  {else}
                    <span class="ska-pname">{$product.name}</span>
                  {/if}
                </td>
                <td class="ska-col-brand">
                  {if $skaBrand != '—'}
                    <img src="{$WEB_ROOT}/assets/ssl_resources/images/emails/{$skaBrand|lower}-logo.svg"
                         alt="{$skaBrand}" class="ska-blogo"
                         onerror="this.style.display='none';this.nextElementSibling.style.display='inline'">
                    <span class="ska-bfall" style="display:none">{$skaBrand}</span>
                  {else}
                    —
                  {/if}
                </td>
                <td><span class="ska-vbadge {$skaValCls}">{$skaVal}</span></td>
                <td class="ska-col-price">
                  {if isset($product.pricing.minprice)}
                    <b>{$product.pricing.minprice.price}</b>
                    {if $product.pricing.minprice.cycle == 'annually'}<span>/an</span>
                    {elseif $product.pricing.minprice.cycle == 'biennially'}<span>/2 ans</span>
                    {elseif $product.pricing.minprice.cycle == 'triennially'}<span>/3 ans</span>
                    {/if}
                  {elseif isset($product.pricing.totalonetime)}
                    <b>{$product.pricing.totalonetime}</b>
                  {else}
                    —
                  {/if}
                </td>
                <td class="ska-col-cta">
                  {if $product.bid}
                    <a href="{$WEB_ROOT}/cart.php?a=add&amp;bid={$product.bid}" class="ska-addcart">Ajouter au panier</a>
                  {else}
                    <a href="{$WEB_ROOT}/cart.php?a=add&amp;pid={$product.pid}" class="ska-addcart">Ajouter au panier</a>
                  {/if}
                </td>
              </tr>
            {/if}
          {/foreach}
        </tbody>
      </table>
    </div>
  </div>

  {* ============== VUE SÉCURITÉ WEB (cartes) ============== *}
  <div id="skaViewWebsec" style="display:none">
    <div class="ska-grid ska-store-grid ska-websec-grid">
      {foreach $products as $product}
        {assign var=n value=$product.name|lower}
        {if $n|strstr:'sitelock' or $n|strstr:'codeguard' or $n|strstr:'cwatch' or $n|strstr:'hackerguardian' or $n|strstr:'pci'}

          {assign var=skaWBrand value='Comodo'}
          {if $n|strstr:'sitelock'}{assign var=skaWBrand value='SiteLock'}
          {elseif $n|strstr:'codeguard'}{assign var=skaWBrand value='CodeGuard'}
          {/if}

          <article class="ska-card ska-wcard">
            <div class="ska-wcard-logo">
              <img src="{$WEB_ROOT}/assets/ssl_resources/images/emails/{$skaWBrand|lower}-logo.svg"
                   alt="{$skaWBrand}" class="ska-wlogo"
                   onerror="this.style.display='none';this.nextElementSibling.style.display='inline'">
              <span class="ska-bfall" style="display:none">{$skaWBrand}</span>
            </div>
            <h3>
              {if isset($product.slug) && isset($productGroup.slug)}
                <a href="{$WEB_ROOT}/index.php?rp=/store/{$productGroup.slug}/{$product.slug}" class="ska-pname">{$product.name}</a>
              {else}
                {$product.name}
              {/if}
            </h3>
            {if $product.description}
              <div class="ska-desc">{$product.description|strip_tags|truncate:130:"…"}</div>
            {/if}
            <div class="ska-price ska-wprice">
              {if isset($product.pricing.minprice)}
                <b>{$product.pricing.minprice.price}</b>
                {if $product.pricing.minprice.cycle == 'monthly'}<span>/mois</span>
                {elseif $product.pricing.minprice.cycle == 'annually'}<span>/an</span>
                {elseif $product.pricing.minprice.cycle == 'biennially'}<span>/2 ans</span>
                {elseif $product.pricing.minprice.cycle == 'triennially'}<span>/3 ans</span>
                {/if}
              {elseif isset($product.pricing.totalonetime)}
                <b>{$product.pricing.totalonetime}</b>
              {/if}
            </div>
            <div class="ska-card-cta">
              {if $product.bid}
                <a href="{$WEB_ROOT}/cart.php?a=add&amp;bid={$product.bid}" class="ska-btn ska-btn-primary">Commander</a>
              {else}
                <a href="{$WEB_ROOT}/cart.php?a=add&amp;pid={$product.pid}" class="ska-btn ska-btn-primary">Commander</a>
              {/if}
            </div>
          </article>
        {/if}
      {/foreach}
    </div>
  </div>

  {if $products|count == 0}
    <p class="ska-empty">Aucun produit disponible dans cette catégorie pour le moment.</p>
  {/if}

</div>

{literal}
<script>
(function(){
  var logoBase='/assets/ssl_resources/images/emails/';

  // Onglets de catégories : Certificats / Sécurité Web
  var catBar=document.getElementById('skaCatTabs');
  var vCert=document.getElementById('skaViewCert');
  var vSec=document.getElementById('skaViewWebsec');
  if(catBar){
    catBar.addEventListener('click',function(e){
      var t=e.target.closest('.ska-cattab'); if(!t) return;
      catBar.querySelectorAll('.ska-cattab').forEach(function(b){b.classList.remove('active')});
      t.classList.add('active');
      var v=t.getAttribute('data-v');
      vCert.style.display=(v==='cert')?'':'none';
      vSec.style.display=(v==='websec')?'':'none';
    });
  }

  // Onglets marques + bandeau de marque
  var bar=document.getElementById('skaBrandTabs');
  var hero=document.getElementById('skaBHero');
  var heroTitle=document.getElementById('skaBHeroTitle');
  var heroLogo=document.getElementById('skaBHeroLogo');
  if(bar){
    var rows=[].slice.call(document.querySelectorAll('#skaViewCert .ska-ptable tbody tr[data-brand]'));
    bar.addEventListener('click',function(e){
      var t=e.target.closest('.ska-tab'); if(!t) return;
      bar.querySelectorAll('.ska-tab').forEach(function(b){b.classList.remove('active')});
      t.classList.add('active');
      var f=t.getAttribute('data-b');
      rows.forEach(function(r){
        r.style.display=(f==='all'||r.getAttribute('data-brand')===f)?'':'none';
      });
      if(f==='all'){ hero.style.display='none'; }
      else{
        heroTitle.textContent='Certificats SSL ' + f;
        heroLogo.style.display='';
        heroLogo.alt=f;
        heroLogo.onerror=function(){ this.style.display='none'; };
        heroLogo.src=logoBase + f.toLowerCase() + '-logo.svg';
        hero.style.display='';
      }
    });
  }
})();
</script>
{/literal}
