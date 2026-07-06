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
                
    <form class="sslgen" id="frmStepOne" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=sitelock-upgrade">
        <h2>Account Configuration</h2>

        <p>Assign a Domain to the SiteLock license using the fields below. Once a domain is assigned, your account can be accessed from SiteLock.com or the Single Sign On link on the order page.</p>

        <h3>Assign a Domain to SiteLock Basic</h3>
        <div class="form-group">
            <label for="TheSSLStoreOrderID">{$LANG.ssl_store_orderid}:*</label>
            <input type="text" class="form-control" name="TheSSLStoreOrderID" id="TheSSLStoreOrderID" value="{$certInfo.TheSSLStoreOrderID}" disabled />
        </div>
        <div class="form-group">
            <label for="ProductCode">Product Code:*</label>
            <select name="ProductCode" id="ProductCode" class="form-control">
                {foreach from=$getSitelockProducts key=productCode item=product}
                    <option value="{$product.ProductCode}"{if $certInfo.ProductCode eq $product.ProductCode} selected{/if}>
                        {$product.ProductName}
                    </option>
                {/foreach}
            </select>
        </div>

        <p align="center">
            <a class="btn btn-primary" href="clientarea.php?action=productdetails&id={$serviceId}">{$LANG.backtoservicedetails}</a>
            <input type="submit" name="btnstepupgrade" id="btnstepupgrade" value="Click to Upgrade >>" class="btn btn-primary" />
        </p>

        <p>The Username and Password for this license will be sent to the email above. You can resend it later or use single sign on (SSO) from the order page. The email will be sent from <a href="mailto:support@cybersecuritynotifications.com">support@cybersecuritynotifications.com</a></p>
    </form>
    <div class="ajax_loader"><img src="assets/ssl_resources/images/icon_loading.gif"></div>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#frmStepOne").validate({
                rules: {
                    Email: "required",
                    Domain: "required",
                },
                submitHandler: function(form) {
                    form.submit();
                    $("#btnstepone").attr('disabled',true);
                    $('.ajax_loader').show();
                }
            });
        });
    </script>