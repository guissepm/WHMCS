{if $certificateHistory}

<div class="panel panel-default">
    <div class="panel-heading">
        <strong>Certificate History</strong>
    </div>

    <div class="panel-body">

        <table class="table table-striped table-bordered">

            <thead>
                <tr>
                    <th>Serial Number</th>
                    <th>Issued</th>
                    <th>Expires</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>
                {foreach from=$certificateHistory item=cert}
                    <tr>
                        <td>{$cert.serial_number}</td>
                        <td>{$cert.issued_at}</td>
                        <td>{$cert.expires_at}</td>
                        <td>
                            {if $cert.revoked}
                                <span class="label label-danger">Revoked</span>
                            {else}
                                <span class="label label-success">Active</span>
                            {/if}
                        </td>
                    </tr>
                {/foreach}
            </tbody>

        </table>

    </div>
</div>

{/if}
