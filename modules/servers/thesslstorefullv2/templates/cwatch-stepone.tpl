<style>
    label.error{
        color: red;
        font-weight: normal;
        margin-top: 5px;
    }
    .ajax_loader{
        position:fixed;
        width:100%;
        height:100%;
        left:0;
        top:0;
        background:rgba(0,0,0,.5);
        display: none;
    }
    .ajax_loader img{
        position:absolute;
        left:50%;
        top:50%;
        margin: -100px 0 0 -100px;
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
{if $errormessage}
    <div class="alert alert-danger">
        <strong>{$LANG.clientareaerrors}</strong>
        <ul>
            {$errormessage}
        </ul>
    </div>
{/if}
{if $majorStatus eq "initial"}
    <form class="sslgen" id="frmStepOne" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=cwatch-complete">
        <input type="hidden" name="sslid" value="{$sslOrderId}">
        <h2>{$LANG.sslGetLicenseTitle} - {$productName}</h2>

        <h3>{$LANG.sslDomainInfoTitle}</h3>
        <div class="form-group">
            <label for="sslDomainName">{$LANG.sslDomainName}:*</label>
            <input type="text" class="form-control" name="sslDomainName" id="sslDomainName" value="{$certInfo.sslDomainName}"/>
        </div>


        <h3>{$LANG.sslAdminTitle}</h3>
        <div class="form-group">
            <label for="sslAdminFirstName">{$LANG.sslFirstName}:*</label>
            <input type="text" class="form-control" name="sslAdminFirstName" id="sslAdminFirstName" value="{$certInfo.sslAdminFirstName}"/>
        </div>
        <div class="form-group">
            <label for="sslAdminLastName">{$LANG.sslLastName}:*</label>
            <input type="text" class="form-control" name="sslAdminLastName" id="sslAdminLastName" value="{$certInfo.sslAdminLastName}"/>
        </div>
        <div class="form-group">
            <label for="sslAdminEmail">{$LANG.sslEmail}:*</label>
            <input type="text" class="form-control" name="sslAdminEmail" id="sslAdminEmail" value="{$certInfo.sslAdminEmail}"/>
        </div>

        <div class="form-group">
            <label for="sslAdminCountry">{$LANG.sslOrgCountry}:*</label>
            <select name="sslAdminCountry" id="sslAdminCountry" class="form-control">
                <option value="" selected>{$LANG.pleasechooseone}</option>
                {foreach from=$countries key=countryCode item=countryName}
                    <option value="{$countryCode}"{if $certInfo.sslAdminCountry eq $countryCode} selected{/if}>
                        {$countryName->name}
                    </option>
                {/foreach}
            </select>
        </div>

        <p>
            <a class="btn btn-primary" href="clientarea.php?action=productdetails&id={$serviceId}">{$LANG.backtoservicedetails}</a>
            <input type="submit" id="btnstepone" value="{$LANG.ordercontinuebutton}" class="btn btn-primary" />
        </p>
    </form>
    <div class="ajax_loader"><img src="assets/ssl_resources/images/icon_loading.gif"></div>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#frmStepOne").validate({
                rules: {
                    sslDomainName: "required",
                    sslAdminFirstName: "required",
                    sslAdminLastName: "required",
                    sslAdminEmail: "required",
                    sslAdminCountry: "required"
                },
                submitHandler: function(form) {
                    form.submit();
                    $("#btnstepone").attr('disabled',true);
                    $('.ajax_loader').show();
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