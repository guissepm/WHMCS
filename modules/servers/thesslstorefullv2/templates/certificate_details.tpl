{*
 * AutoInstallSSL Certificate Details Template
 * Shows certificate status and details on order page
 *}

<div class="autoinstall-certificate-details">

    {* AutoInstall Status Badge *}
    <div class="panel panel-{$status_panel_class}">
        <div class="panel-heading">
            <h3 class="panel-title">
                <i class="fas fa-{$status_icon}"></i> AutoInstall Status: {$install_status_text}
            </h3>
        </div>
        <div class="panel-body">

            {if $install_status == 'installed'}
                <div class="alert alert-success">
                    <i class="fas fa-check-circle fa-2x pull-left" style="margin-right: 15px;"></i>
                    <strong>Certificate Installed Successfully!</strong><br>
                    Your SSL certificate is active and protecting your website.
                </div>
            {elseif $install_status == 'error'}
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle fa-2x pull-left" style="margin-right: 15px;"></i>
                    <strong>Installation Error</strong><br>
                    {$install_error|default:'An error occurred during installation. Please contact support.'}
                </div>
            {elseif $validation_status == 'pending'}
                <div class="alert alert-info">
                    <i class="fas fa-hourglass-half fa-2x pull-left" style="margin-right: 15px;"></i>
                    <strong>Pending Validation</strong><br>
                    Your certificate is awaiting domain control validation.
                    {if $dcv_method == 'email'}
                        <br><small>Please check your email at <strong>{$dcv_email}</strong> and approve the validation request.</small>
                    {/if}
                </div>
            {else}
                <div class="alert alert-warning">
                    <i class="fas fa-cog fa-spin fa-2x pull-left" style="margin-right: 15px;"></i>
                    <strong>Processing</strong><br>
                    AutoInstallSSL is working on your certificate.
                </div>
            {/if}

            {* Certificate Information *}
            {if $certificate_text}
                <div class="row ais-card-row">

                    {* ── LEFT: Certificate Details ── *}
                    <div class="col-md-4">
                        <div class="ais-card">
                            <div class="ais-card-header">
                                <i class="fas fa-certificate"></i> Certificate Details
                            </div>
                            <div class="ais-card-body">
                                <table class="table table-condensed ais-detail-table">
                                    <tr>
                                        <th>Common Name</th>
                                        <td class="ais-break">{$common_name}</td>
                                    </tr>
                                    {if $sans}
                                        <tr>
                                            <th>Additional Domains</th>
                                            <td class="ais-break">
                                                {foreach from=$sans item=san}
                                                    {$san}<br>
                                                {/foreach}
                                            </td>
                                        </tr>
                                    {/if}
                                    <tr>
                                        <th>Serial Number</th>
                                        <td>
                                            <code class="ais-serial">{$serial_number}</code>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Issued</th>
                                        <td>{$issue_date|date_format:"%B %d, %Y"}</td>
                                    </tr>
                                    <tr>
                                        <th>Expires</th>
                                        <td>
                                            <span class="ais-expiry-date">{$expiry_date|date_format:"%B %d, %Y"}</span>
                                            {if $days_until_expiry <= 28}
                                                <br>
                                                <span class="label {if $days_until_expiry <= 7}label-danger{else}label-warning{/if} ais-expiry-badge">
                                                    <i class="fas fa-exclamation-circle"></i>
                                                    {$days_until_expiry} day{if $days_until_expiry != 1}s{/if} remaining
                                                </span>
                                            {/if}
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Auto-Renewal</th>
                                        <td>
                                            {if $autoinstall_enabled}
                                                <span class="label label-success">
                                                    <i class="fas fa-check"></i> Enabled
                                                </span>
                                            {else}
                                                <span class="label label-default">Disabled</span>
                                            {/if}
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>

                    {* ── MIDDLE: Installation Info ── *}
                    <div class="col-md-4">
                        <div class="ais-card">
                            <div class="ais-card-header">
                                <i class="fas fa-server"></i> Installation Info
                            </div>
                            <div class="ais-card-body">
                                <table class="table table-condensed ais-detail-table">
                                    <tr>
                                        <th>Server</th>
                                        <td class="ais-break">{$server_name}</td>
                                    </tr>
                                    <tr>
                                        <th>Domain</th>
                                        <td class="ais-break">{$cpanel_domain}</td>
                                    </tr>
                                    <tr>
                                        <th>DCV Method</th>
                                        <td>
                                            {if $dcv_method == 'file'}
                                                <i class="fas fa-file-alt"></i> File-Based
                                            {elseif $dcv_method == 'dns'}
                                                <i class="fas fa-globe"></i> DNS
                                            {elseif $dcv_method == 'email'}
                                                <i class="fas fa-envelope"></i> Email
                                            {/if}
                                        </td>
                                    </tr>
                                    {if $last_check_date}
                                        <tr>
                                            <th>Last Checked</th>
                                            <td>{$last_check_date|date_format:"%b %d, %Y %H:%M"}</td>
                                        </tr>
                                    {/if}
                                </table>
                            </div>
                        </div>
                    </div>

                    {* ── RIGHT: Download ── *}
                    <div class="col-md-4">
                        <div class="ais-card">
                            <div class="ais-card-header">
                                <i class="fas fa-download"></i> Download
                            </div>
                            <div class="ais-card-body ais-download-body">
                                <a href="clientarea.php?action=productdetails&id={$serviceid}&download=certificate"
                                   class="btn btn-primary btn-block ais-dl-btn">
                                    <i class="fas fa-file-archive"></i> Download Certificate (.zip)
                                </a>
                                <a href="clientarea.php?action=productdetails&id={$serviceid}&download=key"
                                   class="btn btn-warning btn-block ais-dl-btn">
                                    <i class="fas fa-key"></i> Download Private Key
                                </a>
                                <p class="ais-dl-help">
                                    <i class="fas fa-info-circle"></i>
                                    Use these files to install the certificate on other servers.
                                </p>
                            </div>
                        </div>
                    </div>

                </div>{* /.row *}

                {* ── Certificate History ── *}
                {if $show_history && $history}
                    <div class="row" style="margin-top: 20px;">
                        <div class="col-md-12">
                            <div class="ais-card">
                                <div class="ais-card-header">
                                    <i class="fas fa-history"></i> Certificate History
                                </div>
                                <div class="ais-card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped table-condensed ais-history-table">
                                            <thead>
                                                <tr>
                                                    <th>Date</th>
                                                    <th>Action</th>
                                                    <th>Serial Number</th>
                                                    <th>Status</th>
                                                    <th>Details</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {foreach from=$history item=record}
                                                    <tr>
                                                        <td style="white-space: nowrap;">
                                                            {$record.created_at|date_format:"%m/%d/%Y %H:%M"}
                                                        </td>
                                                        <td>
                                                            {if $record.action_type == 'issue'}
                                                                <span class="label label-info">Issue</span>
                                                            {elseif $record.action_type == 'renew'}
                                                                <span class="label label-success">Renew</span>
                                                            {elseif $record.action_type == 'install'}
                                                                <span class="label label-primary">Install</span>
                                                            {elseif $record.action_type == 'revoke'}
                                                                <span class="label label-danger">Revoke</span>
                                                            {else}
                                                                <span class="label label-default">{$record.action_type|capitalize}</span>
                                                            {/if}
                                                        </td>
                                                        <td>
                                                            <code class="ais-serial">{$record.serial_number|default:'-'}</code>
                                                        </td>
                                                        <td>{$record.status}</td>
                                                        <td>{$record.details|truncate:50:"...":true}</td>
                                                    </tr>
                                                {/foreach}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                {/if}

            {/if}{* /certificate_text *}

            {* ── Action Buttons ── *}
            <div class="row" style="margin-top: 20px;">
                <div class="col-md-12">
                    {if !$certificate_text}
                        <a href="clientarea.php?action=productdetails&id={$serviceid}&setup_autoinstall=1"
                           class="btn btn-primary btn-lg btn-block">
                            <i class="fas fa-bolt"></i> Setup AutoInstall
                        </a>
                    {else}
                        {if $autoinstall_enabled}
                            <button type="button" class="btn btn-warning"
                                    data-toggle="modal" data-target="#disable-autoinstall-modal">
                                <i class="fas fa-pause"></i> Disable Auto-Renewal
                            </button>
                        {else}
                            <form method="post"
                                  action="clientarea.php?action=productdetails&id={$serviceid}"
                                  style="display: inline;">
                                <input type="hidden" name="enable_autoinstall" value="1">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-play"></i> Enable Auto-Renewal
                                </button>
                            </form>
                        {/if}
                    {/if}
                </div>
            </div>

        </div>{* /.panel-body *}
    </div>{* /.panel *}

</div>{* /.autoinstall-certificate-details *}

{* ── Disable AutoInstall Modal ── *}
<div class="modal fade" id="disable-autoinstall-modal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Disable Auto-Renewal</h4>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to disable automatic renewal for this certificate?</p>
                <div class="alert alert-warning">
                    <strong>Warning:</strong> You will need to manually renew this certificate before
                    it expires on <strong>{$expiry_date|date_format:"%B %d, %Y"}</strong>.
                </div>
            </div>
            <div class="modal-footer">
                <form method="post" action="clientarea.php?action=productdetails&id={$serviceid}">
                    <input type="hidden" name="disable_autoinstall" value="1">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Yes, Disable Auto-Renewal</button>
                </form>
            </div>
        </div>
    </div>
</div>

<style type="text/css">
/* ── Card layout ──────────────────────────────────────── */
.ais-card-row {
    margin-top: 10px;
}
.ais-card {
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    overflow: hidden;
    margin-bottom: 20px;
    background: #fff;
    box-shadow: 0 1px 3px rgba(0,0,0,.06);
    height: 100%;
}
.ais-card-header {
    background: #f7f7f7;
    border-bottom: 1px solid #e0e0e0;
    padding: 10px 15px;
    font-weight: 700;
    font-size: 14px;
    color: #444;
}
.ais-card-body {
    padding: 15px;
}

/* ── Detail table ─────────────────────────────────────── */
.ais-detail-table {
    margin-bottom: 0;
    table-layout: fixed;   /* prevents columns from blowing out */
    width: 100%;
}
.ais-detail-table th {
    width: 42%;
    font-weight: 600;
    color: #555;
    vertical-align: top;
    padding-top: 8px !important;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.ais-detail-table td {
    width: 58%;
    vertical-align: top;
    padding-top: 8px !important;
    word-break: break-all;   /* breaks long hex serial numbers */
    overflow-wrap: break-word;
}

/* ── Serial number ────────────────────────────────────── */
.ais-serial {
    font-size: 11px;
    word-break: break-all;
    overflow-wrap: break-word;
    white-space: normal;        /* allow wrapping — fixes mid-word cut */
    display: inline-block;
    max-width: 100%;
}

/* ── Expiry date + badge on separate lines ────────────── */
.ais-expiry-date {
    display: block;
    white-space: nowrap;        /* date itself never wraps */
}
.ais-expiry-badge {
    display: inline-block;
    margin-top: 4px;
    white-space: nowrap;
    font-size: 11px;
    padding: 3px 7px;
}

/* ── Long text break helper ───────────────────────────── */
.ais-break {
    word-break: break-all;
    overflow-wrap: break-word;
}

/* ── Download card ────────────────────────────────────── */
.ais-download-body {
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: calc(100% - 42px);  /* subtract header height */
}
.ais-dl-btn {
    margin-bottom: 10px !important;
    white-space: normal;
    text-align: center;
}
.ais-dl-help {
    font-size: 12px;
    color: #888;
    text-align: center;
    margin: 8px 0 0;
}

/* ── History table ────────────────────────────────────── */
.ais-history-table {
    table-layout: auto;
}
.ais-history-table code {
    font-size: 11px;
    word-break: break-all;
    white-space: normal;
}

/* ── Panel heading colours ────────────────────────────── */
.autoinstall-certificate-details .panel-success .panel-heading {
    background-color: #5cb85c;
    color: #fff;
}
.autoinstall-certificate-details .panel-danger .panel-heading {
    background-color: #d9534f;
    color: #fff;
}
.autoinstall-certificate-details .panel-warning .panel-heading {
    background-color: #f0ad4e;
    color: #fff;
}
.autoinstall-certificate-details .panel-info .panel-heading {
    background-color: #5bc0de;
    color: #fff;
}
</style>