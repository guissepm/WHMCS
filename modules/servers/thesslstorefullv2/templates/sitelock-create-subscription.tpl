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
    .cert_gen_radio{
        border-bottom: 1px solid #ddd;
        padding: 15px 0;
        text-align: center;

    }
    .cert_gen_radio label, #csrDetails > label{
        font-size: 18px;
        font-weight: 400;
    }
    #csrDetails{
        background-color: #efefef;
        border-color: #bce8f1;
        border-radius: 10px;
        padding: 10px;
        display: none;
    }
    #org-info-details{
        background-color: #efefef;
        border-color: #bce8f1;
        border-radius: 10px;
        padding: 10px;
        margin-bottom: 15px;
        display: none;
    }

    .sslgen .form-control{
        width: 100%;
        padding: 4px;
        box-sizing: border-box;
        min-height: 30px;
    }
    textarea#sslAdditionalSan,textarea#sslAdditionalWildCardSan {
        min-height: 180px;
    }
    .inline-label{
        display:inline-block;
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
    #Primary_Sidebar-Service_Details_Overview-Information,#Primary_Sidebar-Service_Details_Overview-Addons{
        display: none;
    }

    .additionalsan,.additionalwildcardsan{
        width: 90% !important;
        float: left;
        margin-bottom: 5px;
    }
    .addbtb {
        background: rgba(0, 0, 0, 0) url("../assets/ssl_resources/images/btn-add.png") no-repeat;
        cursor: pointer;
        display: block;
        float: left;
        height: 28px;
        margin-left: 5px;
        width: 31px;
        margin-top: 0px;
    }
    .lessbtn {
        background: rgba(0, 0, 0, 0) url("../assets/ssl_resources/images/btn-less.png") no-repeat scroll left top;
        cursor: pointer;
        display: block;
        float: left;
        height: 28px;
        width: 31px;
        margin-top: 0px;
    }
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.js"></script>
<link href='https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.css' rel='stylesheet' type='text/css' />
{if $errormessage}
    <div class="alert alert-danger">
        <strong>{$LANG.clientareaerrors}</strong>
        <ul>
            {$errormessage}
        </ul>
    </div>
{/if}

<h2 class="text-left">{$LANG.account_config} - {$productName}</h2>
<div class="clear"></div>

<p class="text-left">{$LANG.account_config_sub_text}</p>
<div class="clear"></div>

<form class="sitelockCreateSubscription" id="sitelockCreateSubscription" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=subscriptiondetails">
    <div align="left" class="ssltblcmn ssltbldtl">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="frame">
            <tr>
                <td>{$LANG.sitelockSubscriptionName}:*</td>
                <td><div class="form-group">
                        <input type="text" class="form-control" name="sitelockSubscriptionName" id="sitelockSubscriptionName" value="">
                    </div>
                </td>
            </tr>
            <tr>
                <td>{$LANG.sitelockSubscriptionEmail}:*</td>
                <td><div class="form-group">
                        <input type="text" class="form-control" name="sitelockSubscriptionEmail" id="sitelockSubscriptionEmail" value="">
                    </div>
                </td>
            </tr>
            <tr>
                <td>{$LANG.sitelockSubscriptionDomain}:*</td>
                <td><div class="form-group">
                        <input type="text" class="form-control" name="sitelockSubscriptionDomain" id="sitelockSubscriptionDomain" value="">
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input id="createsubscription" type="submit" value="{$LANG.createsubscription}" class="btn btn-primary" />
                </td>
            </tr>
        </table>
    </div>
</form> 
<div class="clear"></div>

<p class="text-left">{$LANG.createsubscriptionsubtext}</p>
<div class="clear"></div>

<div class="ajax_loader"><img src="assets/ssl_resources/images/icon_loading.gif"></div>
    <script type="text/javascript">
        $(document).ready(function(){
            $("#sitelockCreateSubscription").validate({
                rules: {

                    sitelockSubscriptionName: "required",
                    sitelockSubscriptionEmail: "required",
                    sitelockSubscriptionDomain: "required",
                },
                submitHandler: function(form){
                        form.submit();
                }
            });

        });
</script>