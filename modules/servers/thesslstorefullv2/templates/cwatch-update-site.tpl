<style>
    label.error{
        color: red;
        font-weight: normal;
        margin-top: 5px;
    }
    .sslgen{
        text-align: left;
    }
    .sslgen label{
        max-width: 100%;
        font-weight: 700;
    }
    .sslgen .form-control{
        width: 100%;
        padding: 4px;
        box-sizing: border-box;
        min-height: 30px;
    }
    .inline-label{
        display:inline-block;
    }
    #Primary_Sidebar-Service_Details_Overview-Information,#Primary_Sidebar-Service_Details_Overview-Addons{
        display: none;
    }
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.min.js"></script>
{if $errorMessage}
    <div class="alert alert-danger">
        <strong>{$LANG.clientareaerrors}</strong>
        <ul>
            {$errorMessage}
        </ul>
    </div>
{/if}

{if $successMessage}
    <div class="alert alert-success text-center">
        {$successMessage}
    </div>
{/if}

{if $minorStatus eq "ADD_SITE_FAIL"}
    <form class="sslgen" id="frmStepOne" method="post" action="">
        <input type="hidden" name="sslid" value="{$sslOrderId}">
        <h2>{$LANG.sslUpdateSiteTitle} - {$productName}</h2>

        <h3>{$LANG.sslDomainInfoTitle}</h3>
        <div class="form-group">
            <label for="sslDomainName">{$LANG.sslDomainName}:*</label>
            <input type="text" class="form-control" name="sslDomainName" id="sslDomainName" value="{$certInfo.sslDomainName}"/>
        </div>

        <p>
            <a class="btn btn-primary" href="clientarea.php?action=productdetails&id={$serviceId}">{$LANG.backtoservicedetails}</a>
            <input type="submit" id="btnstepone" value="{$LANG.cWatchUpdateSitebtn}" class="btn btn-primary" />
        </p>
    </form>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#frmStepOne").validate({
                rules: {
                    sslDomainName: "required"
                },
                submitHandler: function(form) {
                    form.submit();
                    $("#btnstepone").attr('disabled',true);
                }
            });


        });
    </script>
{else}
    <div class="alert alert-info">
        {$LANG.sslnoconfigurationpossible}
    </div>

    <form method="post" action="clientarea.php?action=productdetails">
        <input type="hidden" name="id" value="{$serviceid}" />
        <p>
            <input type="submit" value="{$LANG.invoicesbacktoclientarea}" class="btn btn-primary" />
        </p>
    </form>
{/if}