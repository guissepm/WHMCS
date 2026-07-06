<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.min.js"></script>
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
    .mass-selection-label{
        width: 70%;
    }
    .mass-selection{
        width: 70% !important;
        float: left;
    }
    .mass-selection-btn{
        float: left;
        margin: 0 5px;
    }
    #Primary_Sidebar-Service_Details_Overview-Information,#Primary_Sidebar-Service_Details_Overview-Addons{
        display: none;
    }
</style>
{if $errormessage}
    <div class="alert alert-danger">
        <strong>{$LANG.clientareaerrors}</strong>
        <ul>
            {$errormessage}
        </ul>
    </div>
{/if}

{if $majorStatus eq "active"}
    <form class="sslgen" id="frmReissueStepTwo" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=reissuecomplete">
        <input type="hidden" name="sslid" value="{$sslOrderId}">
        <h2>{$LANG.sslreissuetitle} - {$productName}</h2>
        <h3>{$LANG.sslDCVAuthTitle}</h3>
        <p>{$LANG.sslstore_custom_phrase_sslcertapproveremaildetails}</p>
        <p>{$LANG.sslstore_custom_phrase_sslcertapproveremaildetails_with_filebased}</p>

        {if $authDomainsList|@count gt 1}
            <div class="form-group checkbox">
                {foreach from=$DCVAuthMethods key=dcvKey item=dcvValue}
                    <input type="radio" id="sslAuthMethodAll_{$dcvKey}" name="sslAuthMethodAll" data-id="{$dcvValue}" value="{$dcvKey}" {if "EMAIL" eq $dcvKey} checked="checked"{/if}><label for="sslAuthMethodAll_{$dcvKey}">  {$dcvKey} For All Domain</label><br/>
                {/foreach}
                {if $vendorName eq 'COMODO' || $vendorName eq 'SECTIGO'}
                    <input type="radio" id="sslAuthMethodAll_EMAIL" name="sslAuthMethodAll" data-id="EMAIL" value="EMAIL"><label for="sslAuthMethodAll_EMAIL">  EMAIL For All Domain</label><br/>
                {/if}
            </div>
            <div class="form-group massemail" style="display: none">
                <label for="sslMassSelection" class="mass-selection-label">{$LANG.mass_selection_label}:</label>
                <select name="massSelection" class="form-control mass-selection">
                    <option value="" selected>None</option>
                    {foreach from=$aliasEmails item=alias}
                        <option class="preemail" value="{$alias}{$dm}" {if $certInfo.sslDCVAuthMethod.{$authDomain|replace:'*':'star'} eq "{$alias}{$dm}"} selected{/if}>{$alias}{$dm}</option>
                    {/foreach}
                </select>
                <a id="applyselection" class="btn btn-primary mass-selection-btn">{$LANG.applyselection}</a>
                <a id="clearselection"class="btn btn-primary mass-selection-btn">{$LANG.clearselection}</a>
                <div class="clear"></div>
            </div>
        {/if}

        <table width="100%" cellpadding="2" cellspacing="2">
            <thead>
            <th width="40%">Domain</th>
            <th width="60%" style="padding: 0 15px 20px 15px;">{$LANG.authMethod}</th>
            </thead>
            <tbody>
            {foreach from=$authDomainsList item=authDomain}
                <tr>
                    <td>{$authDomain}</td>
                    <td>
                        <div class="form-group">
                            <input value="normal" name="DCVtype" class="form-control" type="hidden">
                            <select name="sslDCVAuthMethod[{$authDomain|replace:'*':'star'}]" data-domain="{$authDomain}" class="form-control sslDCVMethod">
                                <option value="" selected>{$LANG.pleasechooseone}</option>
                                <optgroup label="Alternative DCV Methods"></optgroup>
                                {foreach from=$DCVAuthMethods key=dcvKey item=dcvValue}
                                    <option value="{$dcvKey}"{if $certInfo.sslDCVAuthMethod.{$authDomain|replace:'*':'star'} eq $dcvKey} selected{/if}>
                                        {$dcvValue}
                                    </option>
                                {/foreach}
                                {if $vendorName eq 'COMODO' || $vendorName eq 'SECTIGO'}
                                    <optgroup label="EMAILS"></optgroup>
                                    {assign var="dm" value=$authDomain|replace:'*.':''}
                                    {assign var="dm" value=$dm|replace:'www.':''}
                                    {foreach from=$aliasEmails item=alias}
                                        <option class="preemail" value="{$alias}{$dm}" {if $certInfo.sslDCVAuthMethod.{$authDomain|replace:'*':'star'} eq "{$alias}{$dm}"} selected{/if}>{$alias}{$dm}</option>
                                    {/foreach}
                                    {if get_primary_domain($authDomain) ne $authDomain|replace:'www.':'' && get_primary_domain($authDomain) ne $authDomain|replace:'*.':''}
                                        {assign var="pdm" value=get_primary_domain($authDomain)|replace:'*.':''}
                                        {assign var="pdm" value=$pdm|replace:'www.':''}
                                        {foreach from=$aliasEmails item=alias}
                                            <option value="{$alias}{$pdm}" {if $certInfo.sslDCVAuthMethod.{$authDomain|replace:'*':'star'} eq "{$alias}{$pdm}"} selected{/if}>{$alias}{$pdm}</option>
                                        {/foreach}
                                    {/if}
                                {/if}
                            </select>
                            {if $isSymantecOrder eq 'yes'}
                                <br>
                                <select class="form-control appEmail" name="sslApproverEmail[{$authDomain|replace:'*':'star'}]" data-domain="{$authDomain}">
                                </select>
                            {/if}
                        </div>
                    </td>
                </tr>
            {/foreach}
            </tbody>
        </table>
        <p>
            <a class="btn btn-primary" href="clientarea.php?action=productdetails&id={$serviceId}">{$LANG.backtoservicedetails}</a>
            <input type="submit" id="btnsteptwo" value="{$LANG.ordercontinuebutton}" class="btn btn-primary" />
        </p>
    </form>
	<div class="ajax_loader"><img src="assets/ssl_resources/images/icon_loading.gif"></div>
    <script type="text/javascript">
            $(document).ready(function(){
                if('{$isSymantecOrder}' == 'yes'){
                    populateDCVEmails($('select.appEmail'))
                }
                $('[name="sslAuthMethodAll"]').change(function(){
                    if($(this).val()=='EMAIL' && '{$vendorName}' != 'DIGICERT') {
                        $(".massemail").show();
                        $('.sslDCVMethod').val('');
                    }else {
                        $(".massemail").hide();
                        $('.sslDCVMethod').val($(this).val());
                        $('.sslDCVMethod').attr('id',$(this).val());
                    }
                });

                $("#applyselection").click(function(){
                    if($('.mass-selection').val()!='') {
                        var alis = $('.mass-selection').val();
                        var items = $('.sslDCVMethod');
                        for (var i = 0; i < items.length; i++) {
                            var domainName = $(items[i]).attr('data-domain').replace('www.','').replace('*.','');
                            $(items[i]).val(alis + domainName);
                        }
                    }else {
                        $('.sslDCVMethod').val('');
                    }
                });

                $("#clearselection").click(function(){
                    $('.sslDCVMethod').val('');
                });

                if('{$ProductType}' != 'WILDCARD-DV' && '{$ProductType}' != 'SAN_ENABLED-WILDCARD-DV'){
                    $("#frmReissueStepTwo").validate({
                        submitHandler: function(form) {
                            form.submit();
                            $("#btnsteptwo").attr('disabled',true);
                        }
                    });
                    customRulesAdd();

                    $('.sslDCVMethod').change(function () {
                        if($(this).val() == 'repull'){
                            populateDCVEmails(this);
                        }
                    })

                } else {
                    $("#frmReissueStepTwo").validate({
                        submitHandler: function(form) {
                            form.submit();
                            $("#btnsteptwo").attr('disabled',true);
                        }
                    });
                }
            })

            function customRulesAdd(){
                /* validate auth method */
                $.each($('.sslDCVMethod'), function (index, element) {
                    $(element).rules("add", {
                        required:true
                    })
                });

            }
            function populateDCVEmails(element){
                $('.ajax_loader').show();
                var dd = $(element);
                dd.show();

                var domainName = dd.attr('data-domain');

                $.ajax({
                    type: "POST",
                    url: 'modules/servers/thesslstorefullv2/common.php',
                    data: {ldelim}'productCode':'{$productCode}','domainName': domainName,'action':'getapproverlist'{rdelim},
                    dataType: "json",
                    success:(function(result){
                        if (result.isError == false) {
                            var htmlOptions = '';
                            for (var i = 0; i < result.emailList.length; i++) {
                                htmlOptions += '<option value="' + result.emailList[i] + '">' + result.emailList[i] + '</option>';
                            }
                            dd.children('option.preemail').remove();
                            dd.append(htmlOptions);
                        }
                        else{
                            var htmlOptions = '';
                            htmlOptions += '<option value="">' + result.errorMessage + '</option>';
                            htmlOptions += '<option value="repull">Pull Approval Emails</option>';
                            dd.children('option.preemail').remove();
                            dd.append(htmlOptions);
                        }
                        $('.ajax_loader').hide();

                    })
                });

            }
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