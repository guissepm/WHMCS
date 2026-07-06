{* ==============================================
   AutoInstall SSL - Status Panel
   ============================================== *}

{if $autoinstall_status}

<div class="panel panel-default" style="margin-top:25px;">

    <div class="panel-heading">
        <strong>AutoInstall SSL Status</strong>
    </div>

    <div class="panel-body">

        <p>
            <strong>Status:</strong>

            {if $autoinstall_status == 'Installed'}
                <span class="label label-success">Installed</span>

            {elseif $autoinstall_status == 'Pending Validation'}
                <span class="label label-warning">Pending Validation</span>

            {elseif $autoinstall_status == 'Pending Issuance – Install'}
                <span class="label label-info">Pending Issuance</span>

            {elseif $autoinstall_status == 'Installed – Error'}
                <span class="label label-danger">Installed – Error</span>

            {elseif $autoinstall_status == 'Error'}
                <span class="label label-danger">Error</span>

            {else}
                <span class="label label-default">{$autoinstall_status}</span>
            {/if}
        </p>

        {if $issuance_status}
            <p>
                <strong>Issuance:</strong> {$issuance_status}
            </p>
        {/if}

        {if $cert_expires_at}
            <p>
                <strong>Expires:</strong> {$cert_expires_at}
            </p>
        {/if}

        {if $install_error}
            <div class="alert alert-danger">
                <strong>Installation Error:</strong><br>
                {$install_error}
            </div>
        {/if}

        {if $dcv_email}
            <p>
                <strong>DCV Email:</strong> {$dcv_email}
            </p>
        {/if}

    </div>

</div>

{/if}
