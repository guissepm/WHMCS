{*
 * AutoInstall SSL — Client Area Template
 * File: modules/servers/autoinstallssl/templates/clientarea.tpl
 *
 * WHMCS calls autoinstallssl_ClientArea() which returns:
 *   ['templatefile' => 'clientarea', 'vars' => ['order' => $order]]
 * WHMCS then renders THIS file with $order available.
 *}

{* ── Resolve single canonical status ── *}
{assign var=aisStatus    value=$order.status.text|lower}
{assign var=isExpired    value=$order.is_expired}
{assign var=isInstalled  value=($order.installation_status|lower == 'installed')}
{assign var=isIssued     value=($order.issuance_status == 'Issued')}
{assign var=isFailed     value=($order.installation_status|lower == 'error' || $order.installation_status|lower == 'failed')}
{assign var=isPending    value=($order.issuance_status|lower == 'pending' || $order.issuance_status|lower == 'awaiting ca')}

{* ── Google Fonts ── *}
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">

{*
 ┌──────────────────────────────────────────────────────────────┐
 │  HIDE the default WHMCS product-detail chrome that renders   │
 │  above the module output (billing box, Domain/Resource tabs) │
 └──────────────────────────────────────────────────────────────┘
*}
<style>
/* ── Suppress standard WHMCS product-detail page chrome ── */
.product-details-header,
.product-details-info,
.product-info-block,
.service-info-sidebar,
#clientareaproductdetails .servicetabs,
#clientareaproductdetails .col-sm-4,
#clientareaproductdetails .col-md-4,
body .servicetabs,
body #tabs-servicetabs,
.clientarea-module-output + .row { display: none !important; }
</style>

<div class="ais-page">

    {* ── BACK LINK ── *}
    <a href="clientarea.php?action=services" class="ais-back">
        <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M9 2L4 7l5 5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>
        Back to My Certificates
    </a>

    {* ── SINGLE STATUS BANNER (only one, highest-priority wins) ── *}
    {if $isExpired}
    <div class="ais-banner ais-banner--expired">
        <div class="ais-banner__icon">
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><path d="M11 2L2 19h18L11 2Z" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/><line x1="11" y1="9" x2="11" y2="13" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/><circle cx="11" cy="16" r="0.8" fill="currentColor"/></svg>
        </div>
        <div class="ais-banner__body">
            <strong>Certificate Expired</strong>
            {if $order.expiry_date} — expired {$order.expiry_date|date_format:"%B %e, %Y"}{if $order.days_past_expiry} ({$order.days_past_expiry} days ago){/if}{/if}
            <div class="ais-banner__sub">Your site may show security warnings to visitors. Contact support to renew.</div>
        </div>
        <a href="submitticket.php" class="ais-btn ais-btn--danger ais-btn--sm">Renew Certificate</a>
    </div>
    {elseif $isFailed}
    <div class="ais-banner ais-banner--error">
        <div class="ais-banner__icon">
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><circle cx="11" cy="11" r="9" stroke="currentColor" stroke-width="1.8"/><line x1="7.5" y1="7.5" x2="14.5" y2="14.5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/><line x1="14.5" y1="7.5" x2="7.5" y2="14.5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>
        </div>
        <div class="ais-banner__body">
            <strong>Installation Failed</strong>
            <div class="ais-banner__sub">The system will retry automatically on the next cron cycle.</div>
        </div>
    </div>
    {elseif $isInstalled && $isIssued}
    <div class="ais-banner ais-banner--success">
        <div class="ais-banner__icon">
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><circle cx="11" cy="11" r="9" stroke="currentColor" stroke-width="1.8"/><path d="M7 11l3 3 5-5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </div>
        <div class="ais-banner__body">
            <strong>SSL Certificate Active &amp; Installed</strong>
            {if $order.expiry_warning == 'critical'}
            <div class="ais-banner__sub">⚠ Expires in {$order.certificate_info.days_remaining} days — renew soon.</div>
            {elseif $order.expiry_warning == 'warning'}
            <div class="ais-banner__sub">Expires in {$order.certificate_info.days_remaining} days.</div>
            {/if}
        </div>
    </div>
    {elseif $isPending}
    <div class="ais-banner ais-banner--info">
        <div class="ais-banner__icon ais-spin-wrap">
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none" class="ais-spin"><circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="2" stroke-dasharray="30 20" stroke-linecap="round"/></svg>
        </div>
        <div class="ais-banner__body">
            {if $order.cert_type == 'DV'}
                <strong>Domain Validation In Progress</strong>
                <div class="ais-banner__sub">Certificate will install automatically once validation completes.</div>
            {else}
                <strong>Validation In Progress</strong>
                <div class="ais-banner__sub">AutoInstall is on hold until the organization validation is passed.</div>
            {/if}
        </div>
    </div>
    {else}
    <div class="ais-banner ais-banner--info">
        <div class="ais-banner__icon ais-spin-wrap">
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none" class="ais-spin"><circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="2" stroke-dasharray="30 20" stroke-linecap="round"/></svg>
        </div>
        <div class="ais-banner__body">
            <strong>Processing Certificate Request</strong>
            <div class="ais-banner__sub">This order is being processed automatically.</div>
        </div>
    </div>
    {/if}

    {* ── PAGE HEADER ── *}
    <div class="ais-header{if $isExpired} ais-header--expired{/if}">
        <div class="ais-header__left">
            <div class="ais-header__lock">
                {if $isExpired}
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none"><rect x="4" y="9" width="12" height="9" rx="2" stroke="currentColor" stroke-width="1.7"/><path d="M7 9V6a3 3 0 0 1 5.12-2.12" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/></svg>
                {else}
                <svg width="20" height="20" viewBox="0 0 20 20" fill="none"><rect x="4" y="9" width="12" height="9" rx="2" stroke="currentColor" stroke-width="1.7"/><path d="M7 9V6a3 3 0 0 1 6 0v3" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/></svg>
                {/if}
            </div>
            <div>
                <div class="ais-header__domain">{$order.domain}</div>
                <div class="ais-header__meta">Service #{$order.service_id}</div>
            </div>
        </div>
        <div class="ais-header__right">
            <span class="ais-status-chip ais-status-chip--{$order.status.color}">{$order.autoinstall_status}</span>
        </div>
    </div>

    {* ── TOP GRID: 3 cards ── *}
    <div class="ais-top-grid">

        {* Card 1 — State *}
        <div class="ais-card ais-state-card">
            {if $isExpired}
                <div class="ais-state-icon ais-state-icon--danger">
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><path d="M16 3L2 28h28L16 3Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/><line x1="16" y1="13" x2="16" y2="20" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><circle cx="16" cy="23.5" r="1.2" fill="currentColor"/></svg>
                </div>
                <div class="ais-state-label ais-state-label--danger">Expired</div>
                {if $order.expiry_date}<div class="ais-state-sub">{$order.expiry_date|date_format:"%b %e, %Y"}</div>{/if}
                <a href="submitticket.php" class="ais-btn ais-btn--danger ais-btn--sm" style="margin-top:12px">Renew Now</a>
            {elseif $isIssued && $isInstalled}
                <div class="ais-state-icon ais-state-icon--success">
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="13" stroke="currentColor" stroke-width="2"/><path d="M10 16l4.5 4.5L22 10" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </div>
                <div class="ais-state-label ais-state-label--success">Active &amp; Installed</div>
                <a href="https://{$order.domain|replace:'*.':''}" target="_blank" class="ais-btn ais-btn--success ais-btn--sm" style="margin-top:12px">View Site ↗</a>
            {elseif $order.issuance_status == 'Rejected'}
                <div class="ais-state-icon ais-state-icon--danger">
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="13" stroke="currentColor" stroke-width="2"/><line x1="11" y1="11" x2="21" y2="21" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"/><line x1="21" y1="11" x2="11" y2="21" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"/></svg>
                </div>
                <div class="ais-state-label ais-state-label--danger">Rejected</div>
            {elseif $isPending}
                <div class="ais-state-icon ais-state-icon--warning">
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="13" stroke="currentColor" stroke-width="2"/><line x1="16" y1="10" x2="16" y2="17" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"/><circle cx="16" cy="21" r="1.2" fill="currentColor"/></svg>
                </div>
                <div class="ais-state-label ais-state-label--warning">Pending Validation</div>
            {else}
                <div class="ais-state-icon ais-state-icon--info">
                    <svg width="32" height="32" viewBox="0 0 32 32" fill="none" class="ais-spin"><circle cx="16" cy="16" r="12" stroke="currentColor" stroke-width="2" stroke-dasharray="44 28" stroke-linecap="round"/></svg>
                </div>
                <div class="ais-state-label ais-state-label--info">Processing</div>
            {/if}
        </div>

        {* Card 2 — Certificate Details *}
        <div class="ais-card">
            <div class="ais-card__title">Certificate Details</div>
            {if $order.certificate_info}
            <div class="ais-kv-list">
                <div class="ais-kv">
                    <span class="ais-kv__k">Serial</span>
                    <span class="ais-kv__v"><code class="ais-mono">{$order.certificate_info.serial_number}</code></span>
                </div>
                <div class="ais-kv">
                    <span class="ais-kv__k">Expires</span>
                    <span class="ais-kv__v">
                        <span class="ais-expiry-date">{$order.certificate_info.expiry_date|date_format:"%b %e, %Y"}</span>
                        {if $isExpired}
                            <span class="ais-chip ais-chip--danger">Expired {if $order.days_past_expiry}{$order.days_past_expiry}d ago{/if}</span>
                        {elseif $isIssued}
                            {if $order.expiry_warning == 'critical'}
                                <span class="ais-chip ais-chip--danger">{$order.certificate_info.days_remaining}d left</span>
                            {elseif $order.expiry_warning == 'warning'}
                                <span class="ais-chip ais-chip--warning">{$order.certificate_info.days_remaining}d left</span>
                            {elseif $order.certificate_info.days_remaining !== null}
                                <span class="ais-chip ais-chip--ok">{$order.certificate_info.days_remaining}d left</span>
                            {/if}
                        {/if}
                    </span>
                </div>
            </div>
            {else}
            <p class="ais-muted">Certificate not yet issued.</p>
            {/if}
        </div>

        {* Card 3 — Downloads *}
        <div class="ais-card">
            <div class="ais-card__title">Download</div>
            {if $isExpired}
                <p class="ais-muted" style="font-size:12px;margin-bottom:12px;">Downloads unavailable — certificate expired.</p>
                <a href="submitticket.php" class="ais-btn ais-btn--danger ais-btn--block">Renew Certificate</a>
            {elseif $order.can_download}
                <a href="clientarea.php?action=productdetails&doit=download_certificate&order_id={$order.order_id}&id={$order.service_id}" class="ais-btn ais-btn--primary ais-btn--block ais-dl-btn">
                    <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><path d="M7 2v7M4 6l3 3 3-3" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/><path d="M2 11h10" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/></svg>
                    Certificate (.zip)
                </a>
                <a href="clientarea.php?action=productdetails&doit=download_key&order_id={$order.order_id}&id={$order.service_id}" class="ais-btn ais-btn--secondary ais-btn--block ais-dl-btn">
                    <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><circle cx="5.5" cy="6" r="3" stroke="currentColor" stroke-width="1.5"/><path d="M8 7.5l4.5 4.5M10.5 10l1.5 1.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                    Private Key (.key)
                </a>
            {else}
                <p class="ais-muted">Available after certificate issuance.</p>
            {/if}
        </div>

    </div>{* /ais-top-grid *}


    {* ── TABS ── *}
    <div class="ais-tabs-wrap">

        <div class="ais-tabs" role="tablist">
            <button class="ais-tab ais-tab--active" data-tab="overview" role="tab">Overview</button>
            {if $order.certificate_history|@count > 0}
            <button class="ais-tab" data-tab="history" role="tab">
                History
                {if $isExpired}<span class="ais-tab-badge">Expired</span>{/if}
            </button>
            {/if}
            {* Activity Log tab temporarily disabled *}
            {* <button class="ais-tab" data-tab="activity" role="tab">Activity Log</button> *}
        </div>

        {* ── TAB: OVERVIEW ── *}
        <div class="ais-tab-panel ais-tab-panel--active" id="tab-overview">

            <div class="ais-grid-2">

                {* Order Info *}
                <div class="ais-section-card">
                    <div class="ais-section-card__title">Order Information</div>
                    <table class="ais-table">
                        <tr><td>SSL Order ID</td>    <td>#{$order.ssl_order_info->TheSSLStoreOrderID}</td></tr>
                        <tr><td>Vendor Order ID</td> <td>#{$order.ssl_order_info->VendorOrderID}</td></tr>
                        <tr>
                            <td>Order Status</td>
                            <td>{$order.ssl_order_info->OrderStatus->MajorStatus}
                                <span class="ais-muted">({$order.ssl_order_info->OrderStatus->MinorStatus})</span>
                            </td>
                        </tr>
                        <tr><td>Type</td>      <td>{$order.cert_type}</td></tr>
                        <tr><td>Wildcard</td>  <td>{if $order.is_wildcard}Yes{else}No{/if}</td></tr>
                        <tr><td>Purchased</td> <td>{$order.ssl_order_info->PurchaseDateInUTC|date_format:"%b %e, %Y"}</td></tr>
                        {if $isExpired}
                        <tr>
                            <td><strong>Certificate</strong></td>
                            <td><span class="ais-chip ais-chip--danger">Expired{if $order.expiry_date} {$order.expiry_date|date_format:"%b %e, %Y"}{/if}</span></td>
                        </tr>
                        {/if}
                    </table>
                </div>

                {* Org Info — shown when org data is available *}
                {if $order.org_info}
                <div class="ais-section-card ais-org-card">
                    <div class="ais-section-card__title">
                        Organization
                        {if $order.org_info.is_digicert}
                            <span class="ais-org-vendor-badge">DigiCert</span>
                        {/if}
                        {if $order.org_info.Status}
                            <span class="ais-chip {if $order.org_info.isActive}ais-chip--ok{else}ais-chip--danger{/if}" style="margin-left:6px">
                                {$order.org_info.Status|capitalize}
                            </span>
                        {/if}
                    </div>

                    {if $order.org_info.is_digicert}

                        {* ══ DigiCert — rich layout ══════════════════════════════════ *}

                        <table class="ais-table">
                            <tr><td>TSS Org ID</td>       <td>#{$order.org_info.TSSOrganizationId}</td></tr>
                            {if $order.org_info.OrganizationId}
                            <tr><td>Org ID</td>            <td>#{$order.org_info.OrganizationId}</td></tr>
                            {/if}
                            {if $order.org_info.VendorOrganizationId}
                            <tr><td>Vendor Org ID</td>     <td>#{$order.org_info.VendorOrganizationId}</td></tr>
                            {/if}
                            <tr><td>Name</td>              <td><strong>{$order.org_info.Organization}</strong></td></tr>
                            {if $order.org_info.AssumedName}
                            <tr><td>Assumed Name</td>      <td>{$order.org_info.AssumedName}</td></tr>
                            {/if}
                            {if $order.org_info.OrganizationAddress}
                            <tr><td>Address</td>           <td>{$order.org_info.OrganizationAddress}</td></tr>
                            {/if}
                            {if $order.org_info.City}
                            <tr><td>City</td>              <td>{$order.org_info.City}</td></tr>
                            {/if}
                            {if $order.org_info.State}
                            <tr><td>State</td>             <td>{$order.org_info.State}</td></tr>
                            {/if}
                            {if $order.org_info.Country}
                            <tr><td>Country</td>           <td>{$order.org_info.Country}</td></tr>
                            {/if}
                            {if $order.org_info.OrganizationPostalcode}
                            <tr><td>Postcode</td>          <td>{$order.org_info.OrganizationPostalcode}</td></tr>
                            {/if}
                            {if $order.org_info.OrganizationPhone}
                            <tr><td>Phone</td>             <td>{$order.org_info.OrganizationPhone}</td></tr>
                            {/if}
                        </table>

                        {* ── Contact ── *}
                        {if $order.org_info.contact}
                        <div class="ais-org-sub-title">Primary Contact</div>
                        <table class="ais-table">
                            {if $order.org_info.contact.job_title}
                            <tr><td>Title</td>   <td>{$order.org_info.contact.job_title}</td></tr>
                            {/if}
                            <tr><td>Name</td>    <td>{$order.org_info.contact.first_name} {$order.org_info.contact.last_name}</td></tr>
                            <tr><td>Email</td>   <td><a href="mailto:{$order.org_info.contact.email}" class="ais-link">{$order.org_info.contact.email}</a></td></tr>
                            {if $order.org_info.contact.phone}
                            <tr><td>Phone</td>   <td>{$order.org_info.contact.phone}</td></tr>
                            {/if}
                        </table>
                        {/if}

                        {* ── Validation records ── *}
                        {if $order.org_info.validation_details|@count gt 0}
                        <div class="ais-org-sub-title">Validation Records</div>
                        <div class="ais-table-scroll">
                            <table class="ais-table ais-table--bordered" style="margin-top:0">
                                <thead>
                                    <tr>
                                        <th>Type</th>
                                        <th>Description</th>
                                        <th>Validated Until</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                {foreach from=$order.org_info.validation_details item=vd}
                                <tr>
                                    <td><code class="ais-mono" style="font-size:10.5px">{$vd.type|upper}</code></td>
                                    <td style="font-size:12px">{$vd.description}</td>
                                    <td style="white-space:nowrap;font-size:12px">
                                        {if $vd.validated_until}{$vd.validated_until|date_format:"%b %e, %Y"}{else}—{/if}
                                    </td>
                                    <td>
                                        <span class="ais-chip {if $vd.status == 'active'}ais-chip--ok{elseif $vd.status == 'expired'}ais-chip--danger{else}ais-chip--neutral{/if}">
                                            {$vd.status|capitalize}
                                        </span>
                                    </td>
                                </tr>
                                {/foreach}
                                </tbody>
                            </table>
                        </div>
                        {/if}

                    {else}

                        {* ══ Sectigo / Comodo / all other vendors — original simple layout ══ *}

                        <table class="ais-table">
                            {if $order.org_info.TSSOrganizationId}
                            <tr><td>TSS Org ID</td>  <td>#{$order.org_info.TSSOrganizationId}</td></tr>
                            {/if}
                            <tr><td>Name</td>         <td>{$order.org_info.Organization}</td></tr>
                            {if $order.org_info.OrganizationalUnit}
                            <tr><td>Unit</td>         <td>{$order.org_info.OrganizationalUnit}</td></tr>
                            {/if}
                            {if $order.org_info.OrganizationAddress}
                            <tr><td>Address</td>      <td>{$order.org_info.OrganizationAddress}</td></tr>
                            {/if}
                            {if $order.org_info.OrganizationPhone}
                            <tr><td>Phone</td>        <td>{$order.org_info.OrganizationPhone}</td></tr>
                            {/if}
                            {if $order.org_info.OrganizationPostalcode}
                            <tr><td>Postcode</td>     <td>{$order.org_info.OrganizationPostalcode}</td></tr>
                            {/if}
                        </table>

                    {/if}

                </div>
                {/if}

            </div>

            {* Expired renewal CTA *}
            {if $isExpired}
            <div class="ais-renewal-panel">
                <div class="ais-renewal-panel__head">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M14 8A6 6 0 1 1 8 2" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/><polyline points="12,1 14,3 12,5" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/></svg>
                    Renewal Required
                </div>
                <p>
                    Certificate expired
                    {if $order.expiry_date}on <strong>{$order.expiry_date|date_format:"%B %e, %Y"}</strong>{if $order.days_past_expiry} ({$order.days_past_expiry} days ago){/if}{/if}.
                    Visitors to <strong>{$order.domain}</strong> may see browser security warnings until a new certificate is installed.
                </p>
                <ul class="ais-checklist">
                    <li class="ais-checklist__item ais-checklist__item--bad">Certificate is expired and no longer trusted by browsers</li>
                    <li class="ais-checklist__item ais-checklist__item--bad">HTTPS connections may fail or show security warnings</li>
                    <li class="ais-checklist__item ais-checklist__item--good">Your domain and hosting account remain active</li>
                    <li class="ais-checklist__item ais-checklist__item--good">A new certificate can be issued quickly</li>
                </ul>
                <a href="submitticket.php" class="ais-btn ais-btn--danger">Contact Support to Renew</a>
            </div>
            {/if}

            {* DCV Table *}
            <div class="ais-section-card" style="margin-top:20px">
                <div class="ais-section-card__title">Validation Details</div>
                <div class="ais-table-scroll">
                    <table class="ais-table ais-table--bordered ais-table--dcv">
                        <thead>
                            <tr>
                                <th>Domain</th>
                                <th>Method</th>
                                <th>Status</th>
                                <th>Name / File</th>
                                <th>Content / Entry</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$order.dcv_info.dcvInfo item=dcv}
                            <tr>
                                <td class="ais-domain-cell">{$dcv.domain}</td>
                                <td>
                                    <span class="ais-chip ais-chip--neutral">
                                        {if $dcv.dcvMethod == 'CNAME_CSR_HASH' || $dcv.dcvMethod == 'DNS_CNAME_TOKEN' || $dcv.dcvMethod == 'DNS'}DNS
                                        {elseif $dcv.dcvMethod == 'HTTP_CSR_HASH' || $dcv.dcvMethod == 'HTTPS_CSR_HASH' || $dcv.dcvMethod == 'FILE' || $dcv.dcvMethod == 'HTTPS'}FILE
                                        {else}EMAIL{/if}
                                    </span>
                                </td>
                                <td>
                                    <span class="ais-chip {if $dcv.dcvStatus == 'Approved'}ais-chip--ok{else}ais-chip--warning{/if}">
                                        {$dcv.dcvStatus|capitalize}
                                    </span>
                                </td>
                                {if $dcv.dcvMethod == 'CNAME_CSR_HASH' || $dcv.dcvMethod == 'DNS_CNAME_TOKEN' || $dcv.dcvMethod == 'DNS'}
                                    {if $dcv.DNSName}
                                    <td class="ais-code-cell">
                                        <code class="ais-mono ais-mono--wrap">{$dcv.DNSName}</code>
                                        <button class="ais-copy" data-copy="{$dcv.DNSName}" title="Copy">
                                            <svg width="12" height="12" viewBox="0 0 12 12" fill="none"><rect x="4" y="4" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.3"/><path d="M8 4V2H1v7h2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                        </button>
                                    </td>
                                    {else}
                                     <td class="ais-muted">N/A</td>
                                    {/if}
                                    <td class="ais-code-cell">
                                        <code class="ais-mono ais-mono--wrap">{$dcv.DNSEntry}</code>
                                        <button class="ais-copy" data-copy="{$dcv.DNSEntry}" title="Copy">
                                            <svg width="12" height="12" viewBox="0 0 12 12" fill="none"><rect x="4" y="4" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.3"/><path d="M8 4V2H1v7h2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                        </button>
                                    </td>
                                {elseif $dcv.dcvMethod == 'HTTP_CSR_HASH' || $dcv.dcvMethod == 'HTTPS_CSR_HASH' || $dcv.dcvMethod == 'FILE' || $dcv.dcvMethod == 'HTTPS'}
                                    <td class="ais-code-cell">
                                        <code class="ais-mono ais-mono--wrap">{$dcv.FileName}</code>
                                        <button class="ais-copy" data-copy="{$dcv.FileName}" title="Copy">
                                            <svg width="12" height="12" viewBox="0 0 12 12" fill="none"><rect x="4" y="4" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.3"/><path d="M8 4V2H1v7h2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                        </button>
                                    </td>
                                    <td class="ais-code-cell">
                                        <code class="ais-mono ais-mono--wrap">{$dcv.FileContents}</code>
                                        <button class="ais-copy" data-copy="{$dcv.FileContents}" title="Copy">
                                            <svg width="12" height="12" viewBox="0 0 12 12" fill="none"><rect x="4" y="4" width="7" height="7" rx="1" stroke="currentColor" stroke-width="1.3"/><path d="M8 4V2H1v7h2" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                        </button>
                                    </td>
                                {else}
                                    <td class="ais-muted">N/A</td>
                                    <td class="ais-muted">N/A</td>
                                {/if}
                            </tr>
                            {/foreach}
                            {if $order.dcv_info.email}
                            <tr class="ais-table__row--accent">
                                <td colspan="2"><strong>Approval Email</strong></td>
                                <td colspan="3">{$order.dcv_info.email}</td>
                            </tr>
                            {/if}
                        </tbody>
                    </table>
                </div>
            </div>

        </div>{* /tab-overview *}


        {* ── TAB: HISTORY ── *}
        <div class="ais-tab-panel" id="tab-history">
            {if !empty($order.certificate_history)}
            <table class="ais-table ais-table--striped">
                <thead>
                    <tr>
                        <th>Serial Number</th>
                        <th>Domain</th>
                        <th>Expires</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$order.certificate_history item=cert}
                    <tr>
                        <td><code class="ais-mono ais-mono--wrap">{$cert->serial_number}</code></td>
                        <td>{$cert->domains}</td>
                        <td style="white-space:nowrap">{$cert->expiration_date|date_format:"%b %e, %Y"}</td>
                        <td>
                            <span class="ais-chip {if $cert->installation_status|lower == 'expired'}ais-chip--danger{elseif $cert->installation_status|lower == 'installed'}ais-chip--ok{else}ais-chip--neutral{/if}">
                                {$cert->installation_status|capitalize}
                            </span>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
            {else}
            <div class="ais-empty">
                <svg width="40" height="40" viewBox="0 0 40 40" fill="none"><rect x="6" y="8" width="28" height="24" rx="4" stroke="currentColor" stroke-width="1.8"/><line x1="12" y1="16" x2="28" y2="16" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/><line x1="12" y1="21" x2="22" y2="21" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/><line x1="12" y1="26" x2="18" y2="26" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>
                <div class="ais-empty__title">No History Yet</div>
                <div class="ais-empty__sub">Certificate history appears here after issuance or renewal.</div>
            </div>
            {/if}
        </div>{* /tab-history *}


        {* ── TAB: ACTIVITY ── *}
        <div class="ais-tab-panel" id="tab-activity">

        {if !empty($order.ais_logs)}

            {* Count by level *}
            {assign var=errCount  value=0}
            {assign var=warnCount value=0}
            {assign var=okCount   value=0}
            {foreach from=$order.ais_logs item=log}
                {if $log.level eq 'ERROR'}{assign var=errCount value=$errCount+1}
                {elseif $log.level eq 'WARN' || $log.level eq 'WARNING'}{assign var=warnCount value=$warnCount+1}
                {else}{assign var=okCount value=$okCount+1}{/if}
            {/foreach}

            <div class="ais-log-toolbar">
                <div class="ais-log-pills">
                    <span class="ais-pill ais-pill--total">{$order.ais_logs|@count} events</span>
                    {if $errCount gt 0}<span class="ais-pill ais-pill--error">{$errCount} error{if $errCount neq 1}s{/if}</span>{/if}
                    {if $warnCount gt 0}<span class="ais-pill ais-pill--warn">{$warnCount} warning{if $warnCount neq 1}s{/if}</span>{/if}
                    {if $okCount gt 0}<span class="ais-pill ais-pill--info">{$okCount} info</span>{/if}
                </div>
                <div class="ais-log-filter">
                    <select id="ais-level-filter" class="ais-select">
                        <option value="ALL">All levels</option>
                        <option value="ERROR">Errors</option>
                        <option value="WARN">Warnings</option>
                        <option value="INFO">Info</option>
                        <option value="SUCCESS">Success</option>
                    </select>
                </div>
            </div>

            <div class="ais-timeline" id="ais-log-list">
                {foreach from=$order.ais_logs item=log name=lp}
                {assign var=lvl value=$log.level|upper}
                {assign var=dotClass value='info'}
                {if $lvl eq 'ERROR'}{assign var=dotClass value='error'}
                {elseif $lvl eq 'WARN' || $lvl eq 'WARNING'}{assign var=dotClass value='warn'}
                {elseif $lvl eq 'SUCCESS'}{assign var=dotClass value='success'}{/if}

                <div class="ais-log-row ais-log-row--{$dotClass}" data-level="{$lvl}">
                    <div class="ais-log-spine">
                        <div class="ais-log-dot ais-log-dot--{$dotClass}"></div>
                        {if not $smarty.foreach.lp.last}<div class="ais-log-line"></div>{/if}
                    </div>
                    <div class="ais-log-card ais-log-card--{$dotClass}">
                        <div class="ais-log-head">
                            <span class="ais-log-badge ais-log-badge--{$dotClass}">{$log.badge.text}</span>
                            <code class="ais-log-event">{$log.event}</code>
                            {if $log.occurrences gt 1}
                            <span class="ais-log-repeat" title="Occurred {$log.occurrences} times">×{$log.occurrences}</span>
                            {/if}
                            <span class="ais-log-time">
                                {$log.created_at|date_format:"%b %e, %H:%M"}
                                {if $log.occurrences gt 1 && $log.first_seen_at}
                                    <span class="ais-log-time-range"> – {$log.first_seen_at|date_format:"%H:%M"}</span>
                                {/if}
                            </span>
                        </div>
                        <p class="ais-log-msg">{$log.summary}</p>
                        {if $log.context}
                        <div class="ais-ctx">
                            <button class="ais-ctx__toggle" type="button" onclick="aisCtxToggle(this)">
                                <svg class="ais-ctx__chevron" width="11" height="11" viewBox="0 0 11 11" fill="none"><polyline points="2,3.5 5.5,7 9,3.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                Details
                            </button>
                            <pre class="ais-ctx__pre" hidden>{$log.context|@json_encode:128}</pre>
                        </div>
                        {/if}
                    </div>
                </div>
                {/foreach}
            </div>

            {if $order.ais_logs|@count gte 50}
            <p class="ais-log-limit">Showing the 50 most recent events.</p>
            {/if}

        {else}
            <div class="ais-empty">
                <svg width="40" height="40" viewBox="0 0 40 40" fill="none"><rect x="6" y="8" width="28" height="24" rx="4" stroke="currentColor" stroke-width="1.8"/><line x1="12" y1="16" x2="28" y2="16" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/><line x1="12" y1="21" x2="22" y2="21" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/><line x1="12" y1="26" x2="18" y2="26" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>
                <div class="ais-empty__title">No Activity Yet</div>
                <div class="ais-empty__sub">AutoInstall SSL events will appear here once the cron processes this order.</div>
            </div>
        {/if}

        </div>{* /tab-activity *}

    </div>{* /ais-tabs-wrap *}

</div>{* /ais-page *}


<style>
/* ═══════════════════════════════════════════════════════════
   ORG CARD EXTRAS
   ═══════════════════════════════════════════════════════════ */
.ais-org-card .ais-section-card__title {
    display: flex; align-items: center; gap: 8px; flex-wrap: wrap;
}
.ais-org-vendor-badge {
    font-size: 10px; font-weight: 700; letter-spacing: .05em;
    background: #1d4ed8; color: #fff; padding: 2px 8px;
    border-radius: 4px; text-transform: uppercase;
}
.ais-org-sub-title {
    font-size: 11px; font-weight: 700; text-transform: uppercase;
    letter-spacing: .07em; color: var(--ais-text-muted);
    margin: 16px 0 8px; padding-top: 14px;
    border-top: 1px solid var(--ais-border-light);
}
.ais-link { color: var(--ais-info); text-decoration: none; }
.ais-link:hover { text-decoration: underline; }
/* ═══════════════════════════════════════════════════════════
   RESET — prevent WHMCS theme bleed-in
   ═══════════════════════════════════════════════════════════ */
.ais-page *, .ais-page *::before, .ais-page *::after { box-sizing: border-box; }
.ais-page a  { text-decoration: none; }
.ais-page ul, .ais-page ol { margin: 0; padding: 0; list-style: none; }
.ais-page p  { margin: 0; }
.ais-page button { font-family: inherit; }
.ais-page table  { border-spacing: 0; }

/* ═══════════════════════════════════════════════════════════
   CSS CUSTOM PROPERTIES
   ═══════════════════════════════════════════════════════════ */
:root {
    --ais-bg:             #f5f6f8;
    --ais-surface:        #ffffff;
    --ais-border:         #e4e7ec;
    --ais-border-light:   #eef0f4;
    --ais-text:           #1a1f2e;
    --ais-text-muted:     #7c8494;
    --ais-text-sub:       #9aa0ae;
    --ais-radius:         10px;
    --ais-radius-sm:      6px;
    --ais-shadow:         0 1px 4px rgba(0,0,0,.07), 0 0 0 1px rgba(0,0,0,.04);
    --ais-shadow-sm:      0 1px 3px rgba(0,0,0,.06);
    --ais-success:        #16a34a;
    --ais-success-bg:     #f0fdf4;
    --ais-success-bd:     #bbf7d0;
    --ais-warning:        #d97706;
    --ais-warning-bg:     #fffbeb;
    --ais-warning-bd:     #fde68a;
    --ais-danger:         #dc2626;
    --ais-danger-bg:      #fef2f2;
    --ais-danger-bd:      #fecaca;
    --ais-info:           #2563eb;
    --ais-info-bg:        #eff6ff;
    --ais-info-bd:        #bfdbfe;
    --ais-header-bg:      #1e293b;
    --ais-header-expired: #7f1d1d;
    --ais-font:           'DM Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    --ais-mono:           'JetBrains Mono', 'Fira Code', ui-monospace, monospace;
}

/* ═══════════════════════════════════════════════════════════
   PAGE SHELL
   ═══════════════════════════════════════════════════════════ */
.ais-page {
    font-family: var(--ais-font);
    color: var(--ais-text);
    max-width: 1100px;
    margin: 0 auto;
    padding: 8px 0 40px;
}
.ais-back {
    display: inline-flex; align-items: center; gap: 6px;
    color: var(--ais-text-muted); font-size: 13px; font-weight: 500;
    text-decoration: none; margin-bottom: 18px; transition: color .15s;
}
.ais-back:hover { color: var(--ais-info); }

/* ═══════════════════════════════════════════════════════════
   STATUS BANNER
   ═══════════════════════════════════════════════════════════ */
.ais-banner {
    display: flex; align-items: flex-start; gap: 14px;
    padding: 14px 18px; border-radius: var(--ais-radius);
    border: 1px solid; margin-bottom: 20px; font-size: 14px; line-height: 1.5;
}
.ais-banner__icon { flex-shrink: 0; padding-top: 1px; }
.ais-banner__body { flex: 1; }
.ais-banner__body strong { display: block; font-weight: 700; margin-bottom: 2px; }
.ais-banner__sub { font-size: 13px; opacity: .8; margin-top: 2px; }
.ais-banner--expired { background: var(--ais-danger-bg);  border-color: var(--ais-danger-bd);  color: var(--ais-danger); }
.ais-banner--error   { background: var(--ais-danger-bg);  border-color: var(--ais-danger-bd);  color: var(--ais-danger); }
.ais-banner--success { background: var(--ais-success-bg); border-color: var(--ais-success-bd); color: var(--ais-success); }
.ais-banner--warning { background: var(--ais-warning-bg); border-color: var(--ais-warning-bd); color: var(--ais-warning); }
.ais-banner--info    { background: var(--ais-info-bg);    border-color: var(--ais-info-bd);    color: var(--ais-info); }

/* ═══════════════════════════════════════════════════════════
   PAGE HEADER BAR
   ═══════════════════════════════════════════════════════════ */
.ais-header {
    display: flex; align-items: center; justify-content: space-between;
    background: var(--ais-header-bg); color: #fff;
    padding: 18px 24px; border-radius: var(--ais-radius);
    margin-bottom: 20px; gap: 16px; flex-wrap: wrap;
}
.ais-header--expired { background: var(--ais-header-expired); }
.ais-header__left  { display: flex; align-items: center; gap: 14px; }
.ais-header__lock  { opacity: .7; flex-shrink: 0; }
.ais-header__domain { font-size: 18px; font-weight: 700; letter-spacing: -.02em; word-break: break-all; }
.ais-header__meta  { font-size: 12px; opacity: .55; margin-top: 2px; }
.ais-header__right { flex-shrink: 0; }
.ais-status-chip {
    display: inline-block; font-size: 12px; font-weight: 600;
    padding: 5px 14px; border-radius: 20px; letter-spacing: .02em; white-space: nowrap;
}
.ais-status-chip--success   { background: rgba(22,163,74,.2);   color: #86efac; }
.ais-status-chip--warning   { background: rgba(217,119,6,.2);   color: #fcd34d; }
.ais-status-chip--danger    { background: rgba(220,38,38,.2);   color: #fca5a5; }
.ais-status-chip--info      { background: rgba(37,99,235,.2);   color: #93c5fd; }
.ais-status-chip--secondary { background: rgba(255,255,255,.1); color: rgba(255,255,255,.7); }

/* ═══════════════════════════════════════════════════════════
   TOP 3-CARD GRID
   ═══════════════════════════════════════════════════════════ */
.ais-top-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-bottom: 20px; }
@media (max-width: 768px) { .ais-top-grid { grid-template-columns: 1fr; } }
.ais-card {
    background: var(--ais-surface); border: 1px solid var(--ais-border);
    border-radius: var(--ais-radius); padding: 20px; box-shadow: var(--ais-shadow);
}
.ais-card__title {
    font-size: 11px; font-weight: 700; text-transform: uppercase;
    letter-spacing: .08em; color: var(--ais-text-muted); margin-bottom: 14px;
}
.ais-state-card { display: flex; flex-direction: column; align-items: center; text-align: center; padding: 28px 20px; }
.ais-state-icon { margin-bottom: 10px; }
.ais-state-icon--success { color: var(--ais-success); }
.ais-state-icon--danger  { color: var(--ais-danger); }
.ais-state-icon--warning { color: var(--ais-warning); }
.ais-state-icon--info    { color: var(--ais-info); }
.ais-state-label { font-size: 15px; font-weight: 700; margin-bottom: 4px; }
.ais-state-label--success { color: var(--ais-success); }
.ais-state-label--danger  { color: var(--ais-danger); }
.ais-state-label--warning { color: var(--ais-warning); }
.ais-state-label--info    { color: var(--ais-info); }
.ais-state-sub { font-size: 12px; color: var(--ais-text-muted); }
.ais-kv-list { display: flex; flex-direction: column; gap: 12px; }
.ais-kv { display: flex; flex-direction: column; gap: 3px; }
.ais-kv__k { font-size: 11px; font-weight: 600; color: var(--ais-text-muted); text-transform: uppercase; letter-spacing: .05em; }
.ais-kv__v { font-size: 13px; color: var(--ais-text); min-width: 0; }
.ais-dl-btn { margin-bottom: 8px !important; }

/* ═══════════════════════════════════════════════════════════
   BUTTONS
   ═══════════════════════════════════════════════════════════ */
.ais-btn {
    display: inline-flex; align-items: center; justify-content: center; gap: 7px;
    font-family: var(--ais-font); font-size: 13px; font-weight: 600;
    padding: 9px 18px; border-radius: var(--ais-radius-sm); border: none;
    cursor: pointer; text-decoration: none;
    transition: filter .15s, opacity .15s; white-space: nowrap; line-height: 1;
}
.ais-btn:hover { filter: brightness(1.08); text-decoration: none; }
.ais-btn:active { opacity: .9; }
.ais-btn--primary   { background: var(--ais-info);    color: #fff; }
.ais-btn--secondary { background: #f1f5f9; color: var(--ais-text); border: 1px solid var(--ais-border); }
.ais-btn--success   { background: var(--ais-success); color: #fff; }
.ais-btn--danger    { background: var(--ais-danger);  color: #fff; }
.ais-btn--sm        { font-size: 12px; padding: 7px 14px; }
.ais-btn--block     { display: flex; width: 100%; }

/* ── Summary bar ─────────────────────────────────────────── */
.ais-summary-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 10px;
    padding: 12px 0 14px;
    margin-bottom: 6px;
    border-bottom: 1px solid #e8e8e8;
}
.ais-chip--ok      { background: var(--ais-success-bg); color: var(--ais-success); border: 1px solid var(--ais-success-bd); }
.ais-chip--danger  { background: var(--ais-danger-bg);  color: var(--ais-danger);  border: 1px solid var(--ais-danger-bd); }
.ais-chip--warning { background: var(--ais-warning-bg); color: var(--ais-warning); border: 1px solid var(--ais-warning-bd); }
.ais-chip--neutral { background: #f1f5f9; color: var(--ais-text-muted); border: 1px solid var(--ais-border); }
.ais-expiry-date { display: block; font-size: 13px; }

/* ═══════════════════════════════════════════════════════════
   TABS
   ═══════════════════════════════════════════════════════════ */
.ais-tabs-wrap {
    background: var(--ais-surface); border: 1px solid var(--ais-border);
    border-radius: var(--ais-radius); box-shadow: var(--ais-shadow); overflow: hidden;
}
.ais-tabs {
    display: flex; border-bottom: 1px solid var(--ais-border);
    background: #f8fafc; padding: 0 16px; gap: 2px; overflow-x: auto;
}
.ais-tab {
    font-family: var(--ais-font); font-size: 13px; font-weight: 600;
    color: var(--ais-text-muted); background: transparent;
    border: none; border-bottom: 2px solid transparent;
    padding: 14px 16px 12px; cursor: pointer; white-space: nowrap;
    transition: color .15s, border-color .15s;
    display: inline-flex; align-items: center; gap: 7px; margin-bottom: -1px;
}
.ais-tab:hover { color: var(--ais-text); }
.ais-tab--active { color: var(--ais-info); border-bottom-color: var(--ais-info); }
.ais-tab-badge {
    font-size: 10px; font-weight: 700;
    background: var(--ais-danger-bg); color: var(--ais-danger);
    border: 1px solid var(--ais-danger-bd); padding: 1px 6px; border-radius: 10px;
}
.ais-tab-panel { display: none; padding: 24px; }
.ais-tab-panel--active { display: block; }

/* ═══════════════════════════════════════════════════════════
   SECTION CARDS & TABLES
   ═══════════════════════════════════════════════════════════ */
.ais-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
@media (max-width: 768px) { .ais-grid-2 { grid-template-columns: 1fr; } }
.ais-section-card {
    background: #fafbfc; border: 1px solid var(--ais-border-light);
    border-radius: var(--ais-radius-sm); padding: 16px 18px;
}
.ais-section-card__title {
    font-size: 11px; font-weight: 700; text-transform: uppercase;
    letter-spacing: .08em; color: var(--ais-text-muted);
    margin-bottom: 12px; padding-bottom: 10px; border-bottom: 1px solid var(--ais-border-light);
}
.ais-table { width: 100%; border-collapse: collapse; font-size: 13px; }
.ais-table td, .ais-table th { padding: 8px 10px; vertical-align: top; color: var(--ais-text); border: none; }
.ais-table td:first-child, .ais-table th { color: var(--ais-text-muted); font-weight: 600; font-size: 12px; white-space: nowrap; width: 42%; }
.ais-table thead th { background: #f1f5f9; border-bottom: 1px solid var(--ais-border); text-transform: uppercase; letter-spacing: .05em; font-size: 11px; color: var(--ais-text-muted); width: auto; white-space: nowrap; }
.ais-table--striped tbody tr:nth-child(even) td { background: #fafbfc; }
.ais-table--bordered { border: 1px solid var(--ais-border); border-radius: var(--ais-radius-sm); overflow: hidden; }
.ais-table--bordered td, .ais-table--bordered th { border-bottom: 1px solid var(--ais-border-light); }
.ais-table--bordered tbody tr:last-child td { border-bottom: none; }
.ais-table--dcv { table-layout: fixed; }
.ais-table-scroll { overflow-x: auto; -webkit-overflow-scrolling: touch; }
.ais-domain-cell { font-weight: 600 !important; color: var(--ais-text) !important; }
.ais-code-cell { word-break: break-all; overflow-wrap: break-word; }
.ais-code-cell .ais-copy { margin-left: 6px; vertical-align: middle; }
.ais-table__row--accent td { background: #f8fafc; font-style: italic; }

.ais-renewal-panel {
    background: var(--ais-danger-bg); border: 1px solid var(--ais-danger-bd);
    border-radius: var(--ais-radius-sm); padding: 18px 20px; margin-bottom: 16px;
}
.ais-renewal-panel__head { display: flex; align-items: center; gap: 8px; font-weight: 700; color: var(--ais-danger); font-size: 14px; margin-bottom: 10px; }
.ais-renewal-panel p { font-size: 13px; color: #7f1d1d; margin-bottom: 12px; line-height: 1.6; }
.ais-checklist { list-style: none; padding: 0; margin: 0 0 16px; display: flex; flex-direction: column; gap: 6px; }
.ais-checklist__item { display: flex; align-items: flex-start; gap: 8px; font-size: 13px; line-height: 1.5; }
.ais-checklist__item::before { content: ''; flex-shrink: 0; width: 16px; height: 16px; border-radius: 50%; margin-top: 1px; background-size: 10px; background-repeat: no-repeat; background-position: center; }
.ais-checklist__item--bad { color: #7f1d1d; }
.ais-checklist__item--bad::before { background-color: var(--ais-danger-bd); background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='10' viewBox='0 0 10 10' fill='none'%3E%3Cline x1='2.5' y1='2.5' x2='7.5' y2='7.5' stroke='%23dc2626' stroke-width='1.5' stroke-linecap='round'/%3E%3Cline x1='7.5' y1='2.5' x2='2.5' y2='7.5' stroke='%23dc2626' stroke-width='1.5' stroke-linecap='round'/%3E%3C/svg%3E"); }
.ais-checklist__item--good { color: #14532d; }
.ais-checklist__item--good::before { background-color: var(--ais-success-bd); background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='10' viewBox='0 0 10 10' fill='none'%3E%3Cpath d='M2 5l2.5 2.5L8 3' stroke='%2316a34a' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E"); }

/* ═══════════════════════════════════════════════════════════
   ACTIVITY LOG TIMELINE
   ═══════════════════════════════════════════════════════════ */
.ais-log-toolbar {
    display: flex; align-items: center; justify-content: space-between;
    flex-wrap: wrap; gap: 10px; padding-bottom: 16px; margin-bottom: 16px;
    border-bottom: 1px solid var(--ais-border);
}
.ais-log-pills { display: flex; align-items: center; flex-wrap: wrap; gap: 6px; }
.ais-log-filter { display: flex; align-items: center; gap: 8px; }
.ais-pill {
    display: inline-flex; align-items: center; gap: 5px;
    font-size: 11px; font-weight: 600; padding: 4px 10px; border-radius: 20px; line-height: 1;
}
.ais-pill--total { background: #f1f5f9; color: var(--ais-text-muted); border: 1px solid var(--ais-border); }
.ais-pill--error { background: var(--ais-danger-bg);  color: var(--ais-danger);  border: 1px solid var(--ais-danger-bd); }
.ais-pill--warn  { background: var(--ais-warning-bg); color: var(--ais-warning); border: 1px solid var(--ais-warning-bd); }
.ais-pill--info  { background: var(--ais-info-bg);    color: var(--ais-info);    border: 1px solid var(--ais-info-bd); }
.ais-select {
    height: 32px; padding: 0 28px 0 10px; font-family: var(--ais-font);
    font-size: 12px; font-weight: 500; border: 1px solid var(--ais-border);
    border-radius: var(--ais-radius-sm);
    background: #fff url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'%3E%3Cpolyline points='1,1 5,5 9,1' stroke='%23888' stroke-width='1.5' fill='none' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E") no-repeat right 8px center;
    -webkit-appearance: none; appearance: none;
    color: var(--ais-text); cursor: pointer; outline: none;
}
.ais-select:focus { border-color: var(--ais-info); box-shadow: 0 0 0 2px rgba(37,99,235,.12); }

.ais-timeline { display: flex; flex-direction: column; }
.ais-log-row  { display: flex; gap: 0; }
.ais-log-row.ais-hidden { display: none !important; }
.ais-log-spine { display: flex; flex-direction: column; align-items: center; width: 32px; flex-shrink: 0; padding-top: 13px; }
.ais-log-dot { width: 11px; height: 11px; border-radius: 50%; flex-shrink: 0; position: relative; z-index: 1; }
.ais-log-dot--error   { background: var(--ais-danger);  box-shadow: 0 0 0 3px rgba(220,38,38,.15); }
.ais-log-dot--warn    { background: var(--ais-warning); box-shadow: 0 0 0 3px rgba(217,119,6,.15); }
.ais-log-dot--success { background: var(--ais-success); box-shadow: 0 0 0 3px rgba(22,163,74,.15); }
.ais-log-dot--info    { background: var(--ais-info);    box-shadow: 0 0 0 3px rgba(37,99,235,.15); }
.ais-log-line { width: 1px; flex: 1; background: var(--ais-border); margin: 5px 0 0; min-height: 16px; }
.ais-log-card {
    flex: 1; min-width: 0; margin: 6px 0 14px 10px;
    background: var(--ais-surface); border: 1px solid var(--ais-border);
    border-radius: var(--ais-radius-sm); padding: 11px 14px;
    box-shadow: var(--ais-shadow-sm); transition: box-shadow .15s;
}
.ais-log-card:hover { box-shadow: 0 2px 8px rgba(0,0,0,.08); }
.ais-log-card--error   { border-left: 3px solid var(--ais-danger); }
.ais-log-card--warn    { border-left: 3px solid var(--ais-warning); }
.ais-log-card--success { border-left: 3px solid var(--ais-success); }
.ais-log-card--info    { border-left: 3px solid var(--ais-info); }
.ais-log-head { display: flex; align-items: center; flex-wrap: wrap; gap: 7px; margin-bottom: 7px; }
.ais-log-badge { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: .06em; padding: 2px 7px; border-radius: 4px; flex-shrink: 0; }
.ais-log-badge--error   { background: var(--ais-danger-bg);  color: var(--ais-danger);  border: 1px solid var(--ais-danger-bd); }
.ais-log-badge--warn    { background: var(--ais-warning-bg); color: var(--ais-warning); border: 1px solid var(--ais-warning-bd); }
.ais-log-badge--success { background: var(--ais-success-bg); color: var(--ais-success); border: 1px solid var(--ais-success-bd); }
.ais-log-badge--info    { background: var(--ais-info-bg);    color: var(--ais-info);    border: 1px solid var(--ais-info-bd); }
.ais-log-event { font-family: var(--ais-mono); font-size: 10.5px; color: #4b5563; background: #f3f4f6; padding: 2px 7px; border-radius: 4px; border: 1px solid var(--ais-border); word-break: break-all; }
.ais-log-time { font-size: 11px; color: var(--ais-text-sub); margin-left: auto; white-space: nowrap; font-variant-numeric: tabular-nums; }
.ais-log-time-range { opacity: .7; font-size: 10px; }
.ais-log-msg { font-size: 13px; color: var(--ais-text); line-height: 1.6; margin: 0 0 6px; word-break: break-word; }
.ais-log-repeat {
    display: inline-flex; align-items: center; justify-content: center;
    font-size: 10px; font-weight: 700; min-width: 22px; height: 18px; padding: 0 6px;
    border-radius: 20px; background: rgba(220,38,38,.12); color: var(--ais-danger);
    border: 1px solid rgba(220,38,38,.2); letter-spacing: .02em; flex-shrink: 0;
}
.ais-log-limit { font-size: 11px; color: var(--ais-text-sub); margin-top: 4px; padding-left: 32px; }

/* ── Context toggle (pretty JSON) ── */
.ais-ctx { display: flex; flex-direction: column; gap: 5px; margin-top: 4px; }
.ais-ctx__toggle {
    display: inline-flex; align-items: center; gap: 5px;
    font-family: var(--ais-font); font-size: 11px; font-weight: 600;
    color: var(--ais-text-muted); background: #f9fafb;
    border: 1px solid var(--ais-border); border-radius: 5px;
    padding: 5px 11px; cursor: pointer;
    transition: background .12s, color .12s; width: fit-content; line-height: 1;
}
.ais-ctx__toggle:hover { background: #f1f5f9; color: var(--ais-text); }
.ais-ctx__chevron { transition: transform .2s ease; flex-shrink: 0; }
.ais-ctx__chevron.open { transform: rotate(180deg); }
.ais-ctx__pre {
    font-family: var(--ais-mono); font-size: 11px; line-height: 1.6;
    background: #1e1e2e; color: #cdd6f4; border: 1px solid #2a2a3c;
    border-radius: 6px; padding: 12px 14px; max-height: 220px;
    overflow-y: auto; white-space: pre-wrap; word-break: break-all; margin: 0;
    animation: aisSlideDown .18s ease forwards;
}
.ais-ctx__pre::-webkit-scrollbar { width: 5px; }
.ais-ctx__pre::-webkit-scrollbar-track { background: #2a2a3c; }
.ais-ctx__pre::-webkit-scrollbar-thumb { background: #45475a; border-radius: 3px; }
@keyframes aisSlideDown { from { opacity: 0; transform: translateY(-4px); } to { opacity: 1; transform: translateY(0); } }

/* ═══════════════════════════════════════════════════════════
   MONO / COPY
   ═══════════════════════════════════════════════════════════ */
.ais-mono {
    font-family: var(--ais-mono); font-size: 11.5px; color: #374151;
    background: #f3f4f6; padding: 2px 6px; border-radius: 4px;
    border: 1px solid #e5e7eb; display: inline-block;
    max-width: 100%; word-break: break-all; white-space: normal; line-height: 1.5;
}
.ais-mono--wrap { white-space: pre-wrap; }
.ais-copy {
    display: inline-flex; align-items: center; justify-content: center;
    width: 24px; height: 24px; background: #f3f4f6;
    border: 1px solid var(--ais-border); border-radius: 4px;
    cursor: pointer; color: var(--ais-text-muted);
    vertical-align: middle; transition: background .12s, color .12s; flex-shrink: 0;
}
.ais-copy:hover { background: var(--ais-info-bg); color: var(--ais-info); border-color: var(--ais-info-bd); }
.ais-copy--done { background: var(--ais-success-bg); color: var(--ais-success); border-color: var(--ais-success-bd); }

/* ═══════════════════════════════════════════════════════════
   MISC
   ═══════════════════════════════════════════════════════════ */
.ais-muted { color: var(--ais-text-muted); font-size: 13px; }
.ais-empty {
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    padding: 48px 20px; text-align: center; background: #fafbfc;
    border: 1px dashed var(--ais-border); border-radius: var(--ais-radius-sm); color: #c0c0c0;
}
.ais-empty__title { font-size: 14px; font-weight: 600; color: var(--ais-text-muted); margin: 10px 0 6px; }
.ais-empty__sub { font-size: 12px; color: var(--ais-text-sub); max-width: 340px; line-height: 1.5; margin: 0; }
@keyframes ais-spin { to { transform: rotate(360deg); } }
.ais-spin { animation: ais-spin 1.4s linear infinite; transform-origin: center; }
.ais-spin-wrap { display: flex; align-items: center; justify-content: center; }

@media (max-width: 600px) {
    .ais-log-toolbar { flex-direction: column; align-items: flex-start; }
    .ais-log-filter  { width: 100%; }
    .ais-select      { flex: 1; }
    .ais-log-time    { margin-left: 0; width: 100%; margin-top: 2px; }
    .ais-log-head    { flex-direction: row; flex-wrap: wrap; }
    .ais-header      { flex-direction: column; align-items: flex-start; }
}
</style>

<script>
/* ═══════════════════════════════════════════════════════════
   1. TAB SWITCHING
   ═══════════════════════════════════════════════════════════ */
(function () {
    var tabs   = document.querySelectorAll('.ais-tab');
    var panels = document.querySelectorAll('.ais-tab-panel');
    if (!tabs.length) return;
    tabs.forEach(function (tab) {
        tab.addEventListener('click', function () {
            var target = this.dataset.tab;
            tabs.forEach(function (t)   { t.classList.remove('ais-tab--active'); });
            panels.forEach(function (p) { p.classList.remove('ais-tab-panel--active'); });
            this.classList.add('ais-tab--active');
            var panel = document.getElementById('tab-' + target);
            if (panel) panel.classList.add('ais-tab-panel--active');
        });
    });
}());

/* ═══════════════════════════════════════════════════════════
   2. CONTEXT JSON TOGGLE  — pretty-prints on first expand
   ═══════════════════════════════════════════════════════════ */
function aisCtxToggle(btn) {
    var ctx  = btn.closest('.ais-ctx');
    var pre  = ctx.querySelector('.ais-ctx__pre');
    var chev = btn.querySelector('.ais-ctx__chevron');
    var open = pre.hidden;                    /* true = currently hidden → we're opening */

    /* Pretty-print JSON exactly once */
    if (open && !pre.dataset.rendered) {
        try {
            pre.textContent = JSON.stringify(JSON.parse(pre.textContent), null, 2);
        } catch (e) { /* leave raw if not valid JSON */ }
        pre.dataset.rendered = '1';
    }

    pre.hidden = !open;
    if (chev) chev.classList.toggle('open', open);

    /* Update button text node (last child) */
    var textNode = btn.lastChild;
    if (textNode && textNode.nodeType === 3) {
        textNode.textContent = open ? ' Hide' : ' Details';
    }
}

/* ═══════════════════════════════════════════════════════════
   3. LEVEL FILTER
   ═══════════════════════════════════════════════════════════ */
(function () {
    var sel = document.getElementById('ais-level-filter');
    if (!sel) return;
    sel.addEventListener('change', function () {
        var val = this.value.toUpperCase();
        document.querySelectorAll('#ais-log-list .ais-log-row').forEach(function (row) {
            var lv   = (row.dataset.level || '').toUpperCase();
            var show = val === 'ALL'
                || lv === val
                || (val === 'WARN' && (lv === 'WARN' || lv === 'WARNING'));
            row.classList.toggle('ais-hidden', !show);
        });
    });
}());

/* ═══════════════════════════════════════════════════════════
   4. COPY TO CLIPBOARD
   ═══════════════════════════════════════════════════════════ */
document.addEventListener('click', function (e) {
    var btn = e.target.closest('.ais-copy');
    if (!btn) return;
    var text = btn.dataset.copy || '';
    (navigator.clipboard
        ? navigator.clipboard.writeText(text)
        : new Promise(function (resolve) {
            var el = document.createElement('textarea');
            el.value = text;
            el.style.cssText = 'position:fixed;opacity:0';
            document.body.appendChild(el);
            el.select();
            document.execCommand('copy');
            document.body.removeChild(el);
            resolve();
          })
    ).then(function () {
        btn.classList.add('ais-copy--done');
        btn.title = 'Copied!';
        setTimeout(function () {
            btn.classList.remove('ais-copy--done');
            btn.title = 'Copy';
        }, 1800);
    });
});
</script>
