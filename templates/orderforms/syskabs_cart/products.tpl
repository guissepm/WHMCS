{* ============================================================
   syskabs_cart — override de la liste des produits (grille cartes)
   Hérite de standard_cart pour tout le reste. Détecte marque et
   type de validation depuis le nom du produit pour les badges.
   ============================================================ *}

<link href="{$WEB_ROOT}/templates/syskabs/css/custom.css?v=1.0.0" rel="stylesheet">

<div class="ska-store">

  <div class="ska-store-head">
    <h1>{$productGroup.name}</h1>
    {if $productGroup.tagline}<p>{$productGroup.tagline}</p>{/if}
  </div>

  <div class="ska-grid ska-store-grid">
    {foreach $products as $product}
      {assign var=n value=$product.name|lower}

      {* --- marque --- *}
      {assign var=skaBrand value=''}
      {assign var=skaDot value='ska-dot-sectigo'}
      {if $n|strstr:'sectigo' or $n|strstr:'positivessl' or $n|strstr:'instantssl' or $n|strstr:'essentialssl'}
        {assign var=skaBrand value='Sectigo'}
      {elseif $n|strstr:'comodo' or $n|strstr:'cwatch'}
        {assign var=skaBrand value='Comodo'}
      {elseif $n|strstr:'digicert' or $n|strstr:'secure site'}
        {assign var=skaBrand value='DigiCert'}{assign var=skaDot value='ska-dot-digicert'}
      {elseif $n|strstr:'rapidssl'}
        {assign var=skaBrand value='RapidSSL'}{assign var=skaDot value='ska-dot-rapid'}
      {elseif $n|strstr:'geotrust' or $n|strstr:'quickssl' or $n|strstr:'true businessid'}
        {assign var=skaBrand value='GeoTrust'}{assign var=skaDot value='ska-dot-digicert'}
      {elseif $n|strstr:'thawte'}
        {assign var=skaBrand value='Thawte'}{assign var=skaDot value='ska-dot-digicert'}
      {elseif $n|strstr:'sitelock'}
        {assign var=skaBrand value='SiteLock'}
      {elseif $n|strstr:'codeguard'}
        {assign var=skaBrand value='CodeGuard'}
      {/if}

      {* --- type de validation --- *}
      {assign var=skaBadge value=''}
      {assign var=skaBadgeCls value='ska-b-dv'}
      {if $n|strstr:'code sign'}
        {assign var=skaBadge value='Code'}{assign var=skaBadgeCls value='ska-b-ov'}
      {elseif $n|strstr:' ev' or $n|strstr:'ev ' or $n|strstr:'extended'}
        {assign var=skaBadge value='EV'}{assign var=skaBadgeCls value='ska-b-ev'}
      {elseif $n|strstr:'wildcard'}
        {assign var=skaBadge value='Wildcard'}
      {elseif $n|strstr:'multi' or $n|strstr:'ucc' or $n|strstr:'san'}
        {assign var=skaBadge value='Multi-domaine'}
      {elseif $n|strstr:' ov' or $n|strstr:'ov ' or $n|strstr:'organization' or $n|strstr:'businessid' or $n|strstr:'instantssl'}
        {assign var=skaBadge value='OV'}{assign var=skaBadgeCls value='ska-b-ov'}
      {elseif $n|strstr:'dv' or $n|strstr:'positivessl' or $n|strstr:'rapidssl' or $n|strstr:'quickssl' or $n|strstr:'essentialssl'}
        {assign var=skaBadge value='DV'}
      {/if}

      <article class="ska-card">
        <header>
          {if $skaBrand}
            <span class="ska-brand"><i class="ska-dot {$skaDot}"></i>{$skaBrand}</span>
          {else}
            <span class="ska-brand"><i class="ska-dot ska-dot-sectigo"></i>SSL</span>
          {/if}
          {if $skaBadge}<span class="ska-badge {$skaBadgeCls}">{$skaBadge}</span>{/if}
        </header>

        <h3>{$product.name}</h3>

        {if $product.description}
          <div class="ska-desc">{$product.description|strip_tags|truncate:150:"…"}</div>
        {/if}

        <div class="ska-price">
          {if $product.pricing.hasconfigoptions || $product.pricing.minprice.cycle}
            <span class="ska-from">à partir de</span>
          {/if}
          {if isset($product.pricing.minprice)}
            <b>{$product.pricing.minprice.price}</b>
            {if $product.pricing.minprice.cycle == 'annually'}<span>/an</span>
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
    {/foreach}
  </div>

  {if $products|count == 0}
    <p class="ska-empty">Aucun produit disponible dans cette catégorie pour le moment.</p>
  {/if}

</div>
