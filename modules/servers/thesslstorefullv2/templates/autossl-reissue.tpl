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
    textarea#sslAdditionalSan,textarea#sslAdditionalWildCardSan {
        min-height: 180px;
    }
    .inline-label{
        display:inline-block;
    }
    #Primary_Sidebar-Service_Details_Overview-Information,#Primary_Sidebar-Service_Details_Overview-Addons{
        display: none;
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
    .ul-style {
        padding-left: 0px;
    }
    .ul-style li{
        list-style: none;
    }
    .ul-style li + li{
        margin: 12px 0 0 0px;
    }
    .additionalsan,.additionalwildcardsan{
        width: 90% !important;
        float: left;
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
{if $majorStatus eq "active"}
    <form class="sslgen" id="frmReissueStepOne" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=autosslreissuecomplete">
        <input type="hidden" name="sslid" value="{$sslOrderId}">
        <h2>{$LANG.sslreissuetitle} - {$productName}</h2>
        <h3>{$LANG.sslServerInfoTitle}</h3>

        <div id="showCSRForn">
            <h3>{$LANG.sslCSRTitle}</h3>
            <p>{$LANG.sslCSRDesc}</p>
            <div class="form-group">
                <label for="sslDomain">{$LANG.ReissueSSLDomainLabel}:*</label>
                <input type="text" class="form-control" name="sslDomain" id="sslDomain" value="{$certInfo.sslDomainName}" disabled/>
            </div>
            <div class="form-group">
                {if $productType eq 'WILDCARD-DV' || $productType eq 'WILDCARD-EV'}
                    <p>
                        <input id='btngetsubdomain' class='btn btn-primary' type='button' value='{$LANG.retrievesubdomain}' style="display:none">
                    </p>
                    <p class="subdomain"></p>
                {/if}
            </div>
            <div class="form-group">
                <label for="sslCSRCompany">{$LANG.sslCSRCompany}:*</label>
                <input type="text" class="form-control" name="sslCSRCompany" id="sslCSRCompany" value="{$certInfo.sslCSRCompany}"/>
            </div>
            <div class="form-group">
                <label for="sslCSRDivision">{$LANG.sslCSRDivision}:*</label>
                <input type="text" class="form-control" name="sslCSRDivision" id="sslCSRDivision" value="{$certInfo.sslCSRDivision}"/>
            </div>
            <div class="form-group">
                <label for="sslCSRCity">{$LANG.sslCSRCity}:*</label>
                <input type="text" class="form-control" name="sslCSRCity" id="sslCSRCity" value="{$certInfo.sslCSRCity}"/>
            </div>
            <div class="form-group">
                <label for="sslCSRState">{$LANG.sslCSRState}:*</label>
                <input type="text" class="form-control" name="sslCSRState" id="sslCSRState" value="{$certInfo.sslCSRState}"/>
            </div>
            <div class="form-group">
                <label for="sslCSRCountry">{$LANG.sslCSRCountry}:*</label>
                <select name="sslCSRCountry" id="sslCSRCountry" class="form-control">
                    <option value="" selected>{$LANG.pleasechooseone}</option>
                    {foreach from=$countries key=countryCode item=countryName}
                        <option value="{$countryCode}"{if $certInfo.sslCSRCountry eq $countryCode} selected{/if}>
                            {$countryName->name}
                        </option>
                    {/foreach}
                </select>
            </div>
            <div class="form-group">
                <label for="sslCSREmail">{$LANG.sslCSREmail}:</label>
                <input type="text" class="form-control" name="sslCSREmail" id="sslCSREmail" value="{$certInfo.sslCSREmail}"/>
            </div>
        </div>

        {if $sanCount gt 0}
            <p>{$LANG.sslstore_san_csr_note}</p>
            <div class="form-group" id="ddSan">
                <label>{$LANG.sslAdditionalSan} ({$sanCount}):*</label>
                <ul id='additinalDomaindiv' class='ul-style'>
                    <li class='li-style'>
                        <select id="additionalSAN" name='sslAdditionalSan[]' class="additionalsan sslDomain form-control" data-fill="no">
                            <option value="" selected>{$LANG.pleasechooseone}</option>
                            {foreach from=$domainList key=domainid item=domain}
                                <option value="{$domain}"{if $dnsNamesArray[0] eq $domain} selected{/if}>
                                    {$domain}
                                </option>
                            {/foreach}
                        </select>
                        <a class='tooltips addbtb adddomain ssl-tooltipbox'><span class="tooltip">{$LANG.addDomainToolTip}</span></a>
                        <div class="clear"></div>
                    </li>
                    {for $x=1, $y=count($dnsNamesArray); $x<$y; $x++}
                        <li class='li-style'>
                            <label>&nbsp;</label>
                            <select id="additionalSAN" name='sslAdditionalSan[]' class="additionalsan sslDomain form-control" data-fill="no">
                                <option value="" selected>{$LANG.pleasechooseone}</option>
                                {foreach from=$domainList key=domainid item=domain}
                                    <option value="{$domain}"{if $dnsNamesArray[$x] eq $domain} selected{/if}>
                                        {$domain}
                                    </option>
                                {/foreach}
                            </select>
                            <a class='tooltips addbtb adddomain ssl-tooltipbox'><span class="tooltip">{$LANG.addDomainToolTip}</span></a>
                            <a class='tooltips lessbtn deldomain ssl-tooltipbox'><span class="tooltip">{$LANG.removeDomainToolTip}</span></a>
                            <div class="clear"></div>
                        </li>
                    {/for}
                </ul>
                <div class="clear"></div>
            </div>
        {/if}
        {if $wildCardSANCount gt 0}
            <p>{$LANG.sslstore_wildcard_san_csr_note}</p>
            <div class="form-group" id="ddWildCardSan">
                <label>{$LANG.sslAdditionalWildCardSan} ({$wildCardSANCount}):*</label>
                <ul id='additinalWildCardDomaindiv' class='ul-style'>
                    <li class='li-style'>
                        <select id="additionalWildCardSAN" name='sslAdditionalWildCardSan[]' class="additionalwildcardsan sslDomain form-control" data-fill="no">
                            <option value="" selected>{$LANG.pleasechooseone}</option>
                            {foreach from=$domainList key=domainid item=domain}
                                <option value="{$domain}"{if $wildCardDnsNamesArray[0] eq $domain} selected{/if}>
                                    {$domain}
                                </option>
                            {/foreach}
                        </select>
                        <a class='tooltips addbtb addwildcarddomain ssl-tooltipbox'><span class="tooltip">{$LANG.addWildCardDomainToolTip}</span></a>
                        <div class="clear"></div>
                    </li>
                    {for $x=1, $y=count($wildCardDnsNamesArray); $x<$y; $x++}
                        <li class='li-style'>
                            <label>&nbsp;</label>
                            <select id="additionalWildCardSAN" name='sslAdditionalWildCardSan[]' class="additionalwildcardsan sslDomain form-control" data-fill="no">
                                <option value="" selected>{$LANG.pleasechooseone}</option>
                                {foreach from=$domainList key=domainid item=domain}
                                    <option value="{$domain}"{if $wildCardDnsNamesArray[$x] eq $domain} selected{/if}>
                                        {$domain}
                                    </option>
                                {/foreach}
                            </select>
                            <a class='tooltips addbtb addwildcarddomain ssl-tooltipbox'><span class="tooltip">{$LANG.addWildCardDomainToolTip}</span></a>
                            <a class='tooltips lessbtn delwildcarddomain ssl-tooltipbox'><span class="tooltip">{$LANG.removeWildCardDomainToolTip}</span></a>
                            <div class="clear"></div>
                        </li>
                    {/for}
                </ul>
                <div class="clear"></div>
            </div>
        {/if}
        <p>{$signatureAlgorithmDescription}</p>
        <div class="form-group">
            <label for="sslSignatureAlgorithm">{$LANG.signature_algorithm_label}:*</label>
            <select name="sslSignatureAlgorithm" id="sslSignatureAlgorithm" class="form-control">
                <option value="" selected>{$LANG.pleasechooseone}</option>
                {foreach from=$signatureAlgorithmList key=sigKey item=sigValue}
                    <option value="{$sigKey}"{if $certInfo.sslSignatureAlgorithm eq $sigKey} selected{/if}>
                        {$sigValue}
                    </option>
                {/foreach}
            </select>
        </div>
        <p>
            <a class="btn btn-primary" href="clientarea.php?action=productdetails&id={$serviceId}">{$LANG.backtoservicedetails}</a>
            <input type="submit" id="btnstepone" value="{$LANG.ordercontinuebutton}" class="btn btn-primary" />
        </p>
    </form>
    <!-- The Modal -->
    <div id="autoInstallModal" class="aismodal">
        <!-- Modal content -->
        <div class="aismodal-content">
            <p><img src="assets/ssl_resources/images/icon_loading.gif" width="100"><br>{$LANG.autossl_process_msg}</p>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function(){
            /*Show/Hide Get Sub Domain button*/
            var subDomains = {$subDomainList};
            if($.isEmptyObject(subDomains)){
                $('input#btngetsubdomain').hide();
            }else{
                $('input#btngetsubdomain').show();
            }

            /*Retrieve subdomain list for wild card product*/
            $('#btngetsubdomain').click(function(){
                if(subDomains!= '' && subDomains != null){
                    var strsubdomain = '<p>Select Sub-Domains to Secure:</p>'
                    strsubdomain += "<input type='checkbox' id='selectall' name='selectall' checked='checked' class='selectall' data-checkbox-name='subDomains[]'> <label for='selectall'><u>Select All</u></label>"+"<br>";
                    for(var i = 0; i < subDomains.length; i++){
                        strsubdomain += "<input type='checkbox' name='subDomains[]' class='checkme' checked='checked' value='"+subDomains[i]+"'> "+subDomains[i]+"<br>"
                    }
                    $('.subdomain').html(strsubdomain);

                    /*select all checkboxes*/
                    $(".subdomain").on('change','#selectall',function(){  /*"select all" change*/
                        $(".checkme").prop('checked', $(this).prop("checked")); /*change all ".checkbox" checked status*/
                    });

                    /*".checkbox" change*/
                    $('.subdomain').on('change','.checkme', function(){
                        /*uncheck "select all", if one of the listed checkbox item is unchecked*/
                        if(false == $(this).prop("checked")){ /*if this item is unchecked*/
                            $("#selectall").prop('checked', false); /*change "select all" checked status to false*/
                        }
                        /*check "select all" if all checkbox items are checked*/
                        if ($('.checkme:checked').length == $('.checkme').length ){
                            $("#selectall").prop('checked', true);
                        }
                    });
                    $('.subdomain').show();
                }
                else{
                    $('.subdomain').html('Subdomain is not available for your selected domain');
                }


            })

            /*add aditional domain textbox on button click*/
            jQuery("#additinalDomaindiv").on("click","a.adddomain", function(){
                var maxSan = {$sanCount};
                var domainList = {$domainList|json_encode};
                var additionalSan =  jQuery("#additinalDomaindiv select.additionalsan").length;
                if(maxSan > additionalSan){
                    var htmlOptions = '';
                    htmlOptions += '<option value="">' + '{$LANG.pleasechooseone}' + '</option>';
                    for (var i = 0; i < domainList.length; i++) {
                        htmlOptions += '<option value="' + domainList[i] + '">' + domainList[i] + '</option>';
                    }
                    var data = "<li class='li-style'>"+
                        "<label>&nbsp;</label>"+
                        "<select id='additionalSAN' name='sslAdditionalSan[]' class='additionalsan sslDomain form-control' data-fill='no'>"+
                        htmlOptions+
                        "</select>"+
                        "<a class='tooltips addbtb adddomain ssl-tooltipbox'><span class=\"tooltip\">{$LANG.addDomainToolTip}</span></a>"+
                        "<a class='tooltips lessbtn deldomain ssl-tooltipbox'><span class=\"tooltip\">{$LANG.removeDomainToolTip}</span></a></li>";

                    $("#additinalDomaindiv").append(data);
                }
                else{
                    alert("Only "+ maxSan +" additional domains allow");
                    return false;
                }
            })

            /*Remove additional domain textbox on button click*/
            jQuery("#additinalDomaindiv").on("click", "a.deldomain", function () {
                jQuery(this).parent().remove();
            });

            /*add aditional wildcard domain textbox on button click*/
            jQuery("#additinalWildCardDomaindiv").on("click","a.addwildcarddomain", function(){
                var maxWildCardSan = {$sanCount};
                var domainList = {$domainList|json_encode};
                var additionalWildCardSan =  jQuery("#additinalWildCardDomaindiv select.additionalwildcardsan").length;
                if(maxWildCardSan > additionalWildCardSan){
                    var htmlOptions = '';
                    htmlOptions += '<option value="">' + '{$LANG.pleasechooseone}' + '</option>';
                    for (var i = 0; i < domainList.length; i++) {
                        htmlOptions += '<option value="' + domainList[i] + '">' + domainList[i] + '</option>';
                    }
                    var data = "<li class='li-style'>"+
                        "<label>&nbsp;</label>"+
                        "<select id='additionalSAN' name='sslAdditionalWildCardSan[]' class='additionalwildcardsan sslDomain form-control' data-fill='no'>"+
                        htmlOptions+
                        "</select>"+
                        "<a class='tooltips addbtb addwildcarddomain ssl-tooltipbox'><span class=\"tooltip\">{$LANG.addWildCardDomainToolTip}</span></a>"+
                        "<a class='tooltips lessbtn delwildcarddomain ssl-tooltipbox'><span class=\"tooltip\">{$LANG.removeWildCardDomainToolTip}</span></a></li>";

                    $("#additinalWildCardDomaindiv").append(data);
                }
                else{
                    alert("Only "+ maxWildCardSan +" additional wildcard domains allow");
                    return false;
                }
            })

            /*Remove additional wildcard domain textbox on button click*/
            jQuery("#additinalWildCardDomaindiv").on("click", "a.delwildcarddomain", function () {
                jQuery(this).parent().remove();
            });

            $("#frmReissueStepOne").validate({
                rules: {
                    sslCSRCompany: "required",
                    sslCSRDivision: "required",
                    sslCSRCity: "required",
                    sslCSRState: "required",
                    sslCSRCountry: "required",
                    sslCsr: "required",
                    sslAdditionalSan: "required",
                    sslAdditionalWildCardSan: "required",
                    sslServerType: "required",
                    sslSignatureAlgorithm: "required"
                },
                submitHandler: function(form) {
                    form.submit();
                    $("#btnstepone").attr('disabled',true);
                    /* Get the modal */
                    var modal = document.getElementById('autoInstallModal');
                    modal.style.display = "block";
                }
            });
        });

        /*Handle the MAX SAN input line and Display the number of SAN used.*/
        $('#sslAdditionalSan').bind('change keyup', function(event) {
            /*Limit to arbitrary # of rows*/
            rows = $('#maxlines').text();
            var linesUsed = $('#linesUsed');
            var value = '';
            var splitval = $(this).val().split("\n");
            for(var a=0;a<rows && typeof splitval[a] != 'undefined';a++) {
                if(a>0) value += "\n";
                value += splitval[a];
                if(splitval.length>=rows)
                    linesUsed.css('color', 'red');
                else
                    linesUsed.css('color', '');
            }
            linesUsed.text(splitval.length);
            if (splitval.length==1 && sslAdditionalSan.value.length == 0 || splitval.length>rows) {
                linesUsed.text((splitval.length)-1);
            }
            $(this).val(value);
        });

        /*Handle the MAX WILDCARD SAN input line and Display the number of WildCard SAN used.*/
        $('#sslAdditionalWildCardSan').bind('change keyup', function(event) {
            /*Limit to arbitrary # of rows*/
            rows = $('#maxlines').text();
            var linesUsed = $('#linesUsed');
            var value = '';
            var splitval = $(this).val().split("\n");
            for(var a=0;a<rows && typeof splitval[a] != 'undefined';a++) {
                if(a>0) value += "\n";
                value += splitval[a];
                if(splitval.length>=rows)
                    linesUsed.css('color', 'red');
                else
                    linesUsed.css('color', '');
            }
            linesUsed.text(splitval.length);
            if (splitval.length==1 && sslAdditionalWildCardSan.value.length == 0 || splitval.length>rows) {
                linesUsed.text((splitval.length)-1);
            }
            $(this).val(value);
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