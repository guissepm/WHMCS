{* ============================================================
   syskabs_cart — liste des produits en tableau
   Colonnes : Produit / Marque / Validation / Prix le plus bas / CTA
   Hérite de standard_cart pour tout le reste du tunnel.
   ============================================================ *}

<link href="{$WEB_ROOT}/templates/syskabs/css/custom.css?v=1.1.0" rel="stylesheet">

<div class="ska-store">

  <div class="ska-store-head">
    <h1>{$productGroup.name}</h1>
    {if $productGroup.tagline}<p>{$productGroup.tagline}</p>{/if}
  </div>

  <div class="ska-filters" id="skaBrandTabs">
    <button class="ska-tab active" data-b="all">Toutes les marques</button>
    <button class="ska-tab" data-b="DigiCert">DigiCert</button>
    <button class="ska-tab" data-b="GeoTrust">GeoTrust</button>
    <button class="ska-tab" data-b="Thawte">Thawte</button>
    <button class="ska-tab" data-b="RapidSSL">RapidSSL</button>
    <button class="ska-tab" data-b="Sectigo">Sectigo</button>
    <button class="ska-tab" data-b="Comodo">Comodo</button>
    <button class="ska-tab" data-b="SiteLock">SiteLock</button>
    <button class="ska-tab" data-b="CodeGuard">CodeGuard</button>
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

          {* --- marque --- *}
          {assign var=skaBrand value='—'}
          {if $n|strstr:'sectigo' or $n|strstr:'positivessl' or $n|strstr:'instantssl' or $n|strstr:'essentialssl'}
            {assign var=skaBrand value='Sectigo'}
          {elseif $n|strstr:'comodo' or $n|strstr:'cwatch'}
            {assign var=skaBrand value='Comodo'}
          {elseif $n|strstr:'digicert' or $n|strstr:'secure site' or $n|strstr:'basic ev' or $n|strstr:'basic ov'}
            {assign var=skaBrand value='DigiCert'}
          {elseif $n|strstr:'rapidssl'}
            {assign var=skaBrand value='RapidSSL'}
          {elseif $n|strstr:'geotrust' or $n|strstr:'quickssl' or $n|strstr:'businessid'}
            {assign var=skaBrand value='GeoTrust'}
          {elseif $n|strstr:'thawte'}
            {assign var=skaBrand value='Thawte'}
          {elseif $n|strstr:'sitelock'}
            {assign var=skaBrand value='SiteLock'}
          {elseif $n|strstr:'codeguard'}
            {assign var=skaBrand value='CodeGuard'}
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
                {* le logo s'affiche si le fichier <marque>-logo.svg existe ; sinon repli texte *}
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
        {/foreach}
      </tbody>
    </table>
  </div>

  {if $products|count == 0}
    <p class="ska-empty">Aucun produit disponible dans cette catégorie pour le moment.</p>
  {/if}

</div>

{literal}
<script>
(function(){
  var bar=document.getElementById('skaBrandTabs'); if(!bar) return;
  var rows=[].slice.call(document.querySelectorAll('.ska-ptable tbody tr[data-brand]'));
  bar.addEventListener('click',function(e){
    var t=e.target.closest('.ska-tab'); if(!t) return;
    bar.querySelectorAll('.ska-tab').forEach(function(b){b.classList.remove('active')});
    t.classList.add('active');
    var f=t.getAttribute('data-b');
    rows.forEach(function(r){
      r.style.display=(f==='all'||r.getAttribute('data-brand')===f)?'':'none';
    });
  });
})();
</script>
{/literal}
