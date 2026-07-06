{* ==============================================
   AutoInstall SSL - Completion Template
   ============================================== *}

<div class="panel panel-success">

    <div class="panel-heading">
        <h3 class="panel-title">
            <i class="fa fa-lock"></i>
            AutoInstall SSL – Enrollment Complete
        </h3>
    </div>

    <div class="panel-body">

        <p>
            Your SSL certificate request has been successfully submitted.
        </p>

        {if $sslCompleteInstruction}
            <div class="alert alert-info" style="margin-top:15px;">
                {$sslCompleteInstruction}
            </div>
        {/if}

        <hr>

        <div class="text-center">
            <a href="clientarea.php?action=productdetails&id={$serviceId}"
               class="btn btn-primary btn-lg">
                View SSL Order
            </a>
        </div>

    </div>

</div>
