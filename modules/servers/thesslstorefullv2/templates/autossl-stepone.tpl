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
    textarea#sslAdditionalSan {
        min-height: 180px;
    }
    .inline-label{
        display:inline-block;
    }
    #Primary_Sidebar-Service_Details_Overview-Information,#Primary_Sidebar-Service_Details_Overview-Addons{
        display: none;
    }
    #btngetsubdomain{
        margin: 5px 0;
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
    .additionalsan{
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
{if $majorStatus eq "initial"}
    <form class="sslgen" id="frmStepOne" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=autosslcomplete">
        <input type="hidden" name="sslid" value="{$sslOrderId}">
        <h2>{$LANG.sslgenerationtitle} - {$productName}</h2>
        <h3>{$LANG.sslServerInfoTitle}</h3>

        <p>{$LANG.sslIntstruction}</p>

        <div id="CSRForn">
            <div class="form-group">
                <label for="sslHostingProfile">{$LANG.sslProfileLabel}:*</label>
                <p>{$LANG.sslProfileDesc}</p>
                <select name="sslHostingProfile" id="sslHostingProfile" class="form-control">
                    <option value="" selected>{$LANG.pleasechooseone}</option>
                    {foreach from=$cPanelHostingProfiles key=ProfileKey item=ProfileValue}
                        <option value="{$ProfileKey}|{$ProfileValue}">
                            {$ProfileValue}
                        </option>
                    {/foreach}
                </select>
            </div>
        <div class="form-group" id="showSSLDomain" style="display: none;">
            <label for="sslDomain">{$LANG.sslDomainLabel}:*</label>
            <p>{$LANG.sslDomainDesc}{$globalSubDomainDataObject}</p>
            <select name="sslDomain" id="sslDomain" class="form-control sslDomain" data-fill="no">
                <option value="">Loading...</option>
            </select>
            <div class="clear"></div>
            {if $productType eq 'WILDCARD-DV' || $productType eq 'WILDCARD-EV'}
                <p>
                    <input id='btngetsubdomain' class='btn btn-primary' type='button' value='{$LANG.retrievesubdomain}' style="display:none">
                </p>
                <p class="subdomain"></p>
            {else}
            <input type='checkbox' name='www' id='www' checked='checked' value='www.'>
            <label for='www'>{$LANG.sslWWWLabel}</label>
            <p>{$LANG.sslWWWDesc}</p>
            {/if}
        </div>
            <h3>{$LANG.sslCSRTitle}</h3>
            <p>{$LANG.sslCSRDesc}</p>
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
                <label for="sslCSREmail">{$LANG.sslCSREmail}:*</label>
                <input type="text" class="form-control" name="sslCSREmail" id="sslCSREmail" value="{$certInfo.sslCSREmail}"/>
            </div>
        </div>

        {if $sanCount gt 0}
               {*<div class="form-group" id="txtSan">
            <label for="sslAdditionalSan">{$LANG.sslAdditionalSan} ({$sanCount}):*</label> (Input every SAN in separate line)
            <textarea id="sslAdditionalSan" name="sslAdditionalSan" rows="3" class="form-control">{if $certInfo.sslAdditionalSan}{$certInfo.sslAdditionalSan}{/if}</textarea>
            <div class="theCount" style="padding:5px 0px;"><span id="linesUsed">0</span> of <span id="maxlines">{$sanCount}</span> SANs Used
                </div>
            <div class="clear"></div></div>*}
                <div class="form-group" id="ddSan" style="display: none;">
                    <p>{$LANG.sslstore_san_csr_note}</p>
                    <label>{$LANG.sslAdditionalSan} ({$sanCount}):*</label>
                    <ul id='additinalDomaindiv' class='ul-style'>
                    <li class='li-style'>
                        <div>
                        <select id="additionalSAN" name='sslAdditionalSan[]' class="additionalsan sslDomain form-control" data-fill="no">
                            <option value="">Loading...</option>
                        </select>
                        <a class='tooltips addbtb adddomain ssl-tooltipbox'><span class="tooltip">{$LANG.addDomainToolTip}</span></a>
                            <div class="clear"></div>
                        </div>
                    </li>
                    </ul>
                    <div class="clear"></div></div>
                {/if}
                <p>{$signatureAlgorithmDescription}</p>
                <div class="form-group">
                    <label for="sslSignatureAlgorithm">{$LANG.signature_algorithm_label}:*</label>
                    <select name="sslSignatureAlgorithm" id="sslSignatureAlgorithm" class="form-control">
                        <option value="" selected>{$LANG.pleasechooseone}</option>
                        {foreach from=$signatureAlgorithmList key=sigKey item=sigValue}
                            <option value="{$sigKey}"{if $certInfo.sslSignatureAlgorithm eq $sigKey} selected{/if}{if $vendorName eq "COMODO" || $vendorName eq 'SECTIGO'} selected{/if}>
                                {$sigValue}
                            </option>
                        {/foreach}
                    </select>
                </div>

                <h3>{$LANG.sslAdminTitle}</h3>
                <p>{$LANG.sslAdminDesc}</p>
                <div class="form-group">
                    <label for="sslAdminTitle">{$LANG.sslTitle}:*</label>
                    <input type="text" class="form-control" name="sslAdminTitle" id="sslAdminTitle" value="{$certInfo.sslAdminTitle}" onchange="copyContact()"/>
                </div>
                <div class="form-group">
                    <label for="sslAdminFirstName">{$LANG.sslFirstName}:*</label>
                    <input type="text" class="form-control" name="sslAdminFirstName" id="sslAdminFirstName" value="{$certInfo.sslAdminFirstName}" onchange="copyContact()"/>
                </div>
                <div class="form-group">
                    <label for="sslAdminLastName">{$LANG.sslLastName}:*</label>
                    <input type="text" class="form-control" name="sslAdminLastName" id="sslAdminLastName" value="{$certInfo.sslAdminLastName}" onchange="copyContact()" />
                </div>
                <div class="form-group">
                    <label for="sslAdminEmail">{$LANG.sslEmail}:*</label>
                    <input type="text" class="form-control" name="sslAdminEmail" id="sslAdminEmail" value="{$certInfo.sslAdminEmail}" onchange="copyContact()"/>
                </div>
                <div class="form-group">
                    <label for="sslAdminPhone">{$LANG.sslPhone}:*</label>
                    <input type="text" class="form-control" name="sslAdminPhone" id="sslAdminPhone" value="{$certInfo.sslAdminPhone}" onchange="copyContact()" />
                </div>
                {if $useDefaultTechDetails ne 1}
                    <h3>{$LANG.sslTechTitle}</h3>
                    <p>{$LANG.sslTechDesc}</p>
                    <p>
                        <input type="checkbox" name="sslSameAsAdmin" id="sslSameAsAdmin" onchange="copyContact()" />
                        <label class="inline-label" for="sslSameAsAdmin">{$LANG.sslSameAsAdmin}</label>
                    </p>

                    <div class="form-group">
                        <label for="sslTechTitle">{$LANG.sslTitle}:*</label>
                        <input type="text" class="form-control" name="sslTechTitle" id="sslTechTitle" value="{$certInfo.sslTechTitle}" />
                    </div>
                    <div class="form-group">
                        <label for="sslTechFirstName">{$LANG.sslFirstName}:*</label>
                        <input type="text" class="form-control" name="sslTechFirstName" id="sslTechFirstName" value="{$certInfo.sslTechFirstName}" />
                    </div>
                    <div class="form-group">
                        <label for="sslTechLastName">{$LANG.sslLastName}:*</label>
                        <input type="text" class="form-control" name="sslTechLastName" id="sslTechLastName" value="{$certInfo.sslTechLastName}" />
                    </div>
                    <div class="form-group">
                        <label for="sslTechEmail">{$LANG.sslEmail}:*</label>
                        <input type="text" class="form-control" name="sslTechEmail" id="sslTechEmail" value="{$certInfo.sslTechEmail}" />
                    </div>
                    <div class="form-group">
                        <label for="sslTechPhone">{$LANG.sslPhone}:*</label>
                        <input type="text" class="form-control" name="sslTechPhone" id="sslTechPhone" value="{$certInfo.sslTechPhone}" />
                    </div>
                {/if}
                {if $productValidationType ne 'DV' || $productCode eq 'ssl123' || $productCode eq 'ssl123wildcard'}
                    <h3>{$LANG.sslOrgTitle}</h3>
                    <p>{$LANG.sslOrgDesc}</p>
                    <div class="form-group">
                        <label for="sslOrgName">{$LANG.sslOrgName}:*</label>
                        <input type="text" class="form-control" name="sslOrgName" id="sslOrgName" value="{$certInfo.sslOrgName}" />
                    </div>
                    <div class="form-group">
                        <label for="sslOrgName">{$LANG.sslOrgDuns}:</label>
                        <input type="text" class="form-control" name="sslOrgDuns" id="sslOrgDuns" value="{$certInfo.sslOrgDuns}" />
                    </div>
                    <div class="form-group">
                        <label for="sslOrgDivision">{$LANG.sslOrgDivision}:*</label>
                        <input type="text" class="form-control" name="sslOrgDivision" id="sslOrgDivision" value="{$certInfo.sslOrgDivision}" />
                    </div>
                    <div class="form-group">
                        <label for="sslOrgAddress1">{$LANG.sslOrgAddress1}:*</label>
                        <input type="text" class="form-control" name="sslOrgAddress1" id="sslOrgAddress1" value="{$certInfo.sslOrgAddress1}" />
                    </div>
                    <div class="form-group">
                        <label for="sslOrgAddress2">{$LANG.sslOrgAddress2}:</label>
                        <input type="text" class="form-control" name="sslOrgAddress2" id="sslOrgAddress2" value="{$certInfo.sslOrgAddress2}" />
                    </div>
                    <div class="form-group">
                        <label for="sslOrgCity">{$LANG.sslOrgCity}:*</label>
                        <input type="text" class="form-control" name="sslOrgCity" id="sslOrgCity" value="{$certInfo.sslOrgCity}" />
                    </div>
                    <div class="form-group">
                        <label for="sslOrgState">{$LANG.sslOrgState}:*</label>
                        <input type="text" class="form-control" name="sslOrgState" id="sslOrgState" value="{$certInfo.sslOrgState}" />
                    </div>
                    <div class="form-group">
                        <label for="sslOrgCountry">{$LANG.sslOrgCountry}:*</label>
                        <select name="sslOrgCountry" id="sslOrgCountry" class="form-control">
                            <option value="" selected>{$LANG.pleasechooseone}</option>
                            {foreach from=$countries key=countryCode item=countryName}
                                <option value="{$countryCode}"{if $certInfo.sslOrgCountry eq $countryCode} selected{/if}>
                                    {$countryName->name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="sslOrgZipCode">{$LANG.sslOrgZipCode}:*</label>
                        <input type="text" class="form-control" name="sslOrgZipCode" id="sslOrgZipCode" value="{$certInfo.sslOrgZipCode}" />
                    </div>
                    <div class="form-group">
                        <label for="sslOrgPhone">{$LANG.sslPhone}:*</label>
                        <input type="text" class="form-control" name="sslOrgPhone" id="sslOrgPhone" value="{$certInfo.sslOrgPhone}" />
                    </div>
                {/if}
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
    <div class="ajax_loader"><img src="assets/ssl_resources/images/icon_loading.gif"></div>
    <script type="text/javascript">
        $(document).ready(function(){
            $('#sslHostingProfile').change(function(){
                if($(this).val() != ''){
                    $('select.sslDomain').attr('data-fill','no');
                    populateSSLDomain();
                }
                else{
                    $('#showSSLDomain').hide();
                    $('#ddSan').hide();
                }
            })
            var globalDomainList;
            var globalSubDomainData;
            var globalSubDomainDataObject;
            function populateSSLDomain(){
                if($('select[data-fill="no"]').length > 0){
                    $('.ajax_loader').show();
                }
                $('#showSSLDomain').show();
                $('#ddSan').show();
                $('select.sslDomain').each(function() {
                    var dd = $(this);
                        var profile = $('#sslHostingProfile').val();
                        var profileData = profile.split("|");
                        var profileName = profileData[0];
                        var profileDomain = profileData[1];
                        $.ajax({
                            type: "POST",
                            url: 'modules/servers/thesslstorefullv2/common.php',
                            data: {ldelim}'whmcsUserId':'{$whmcsUserId}','profileDomain':profileDomain,'profileName': profileName,'action':'getcpaneluserdomainlist'{rdelim},
                            dataType: "json",
                            success:(function(result){
                                //console.log(result);
                                if (result.isError == false) {
                                    var htmlOptions = '';
                                    htmlOptions += '<option value="">' + '{$LANG.pleasechooseone}' + '</option>';
                                    for (var i = 0; i < result.domainList.length; i++) {
                                        htmlOptions += '<option value="' + result.domainList[i] + '">' + result.domainList[i] + '</option>';
                                    }
                                    dd.empty();
                                    dd.append(htmlOptions);
                                    if({$sanCount}>0) {
                                        additionalSAN.append(htmlOptions);
                                    }
                                    dd.attr('data-fill','yes');
                                    //Assign the subdomains to a global variable
                                    globalSubDomainData = result.subDomains;
                                    globalSubDomainDataObject = result.domainSubDomains;
                                    globalDomainList = result.domainList;
                                }
                                else {
                                    var htmlOptions = '';
                                    htmlOptions += '<option value="">' + result.errorMessage + '</option>';
                                    dd.empty();
                                    dd.append(htmlOptions);
                                    dd.attr('data-fill','yes');
                                }
                                if($('select[data-fill="no"]').length == 0){
                                    $('.ajax_loader').hide();
                                }
                            })
                        });
                });
            }

            //Check common name is subdomain to disable www
            $('#sslDomain').change(function(){
                $('input#www').attr('disabled', false);
                $('input#www').prop('checked', true);
                $('.subdomain').hide();
                dm = $(this).val().trim();
                var index = globalSubDomainData.indexOf(dm);
                if(index!='-1')
                {
                    $('input#www').attr('checked', false).attr('disabled', true);
                }

                //Show/Hide Get Sub Domain button
                var subDomains = globalSubDomainDataObject[dm];
                if($.isEmptyObject(subDomains)){
                    $('input#btngetsubdomain').hide();
                }else{
                    $('input#btngetsubdomain').show();
                }
                return;
            })

            //Retrieve subdomain list for wild card product
            $('#btngetsubdomain').click(function(){
                var dm =  $('#sslDomain').val().trim();
                if(typeof(globalSubDomainDataObject[dm]) != 'undefined'){
                    var strsubdomain = '<p>Select Sub-Domains to Secure:</p>'
                    strsubdomain += "<input type='checkbox' id='selectall' name='selectall' checked='checked' class='selectall' data-checkbox-name='subDomains[]'> <label for='selectall'><u>Select All</u></label>"+"<br>";
                    for(var i = 0; i < globalSubDomainDataObject[dm].length; i++){
                        strsubdomain += "<input type='checkbox' name='subDomains[]' class='checkme' checked='checked' value='"+globalSubDomainDataObject[dm][i]+"'> "+globalSubDomainDataObject[dm][i]+"<br>"
                    }
                    $('.subdomain').html(strsubdomain);

                    //select all checkboxes
                    $(".subdomain").on('change','#selectall',function(){  //"select all" change
                        $(".checkme").prop('checked', $(this).prop("checked")); //change all ".checkbox" checked status
                    });

                    //".checkbox" change
                    $('.subdomain').on('change','.checkme', function(){
                        //uncheck "select all", if one of the listed checkbox item is unchecked
                        if(false == $(this).prop("checked")){ //if this item is unchecked
                            $("#selectall").prop('checked', false); //change "select all" checked status to false
                        }
                        //check "select all" if all checkbox items are checked
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

            //add aditional domain textbox on button click
            jQuery("#additinalDomaindiv").on("click","a.adddomain", function(){
                var maxSan = {$sanCount};
                var additionalSan =  jQuery("#additinalDomaindiv select.additionalsan").length;
                if(maxSan > additionalSan){
                    var htmlOptions = '';
                    htmlOptions += '<option value="">' + '{$LANG.pleasechooseone}' + '</option>';
                    for (var i = 0; i < globalDomainList.length; i++) {
                        htmlOptions += '<option value="' + globalDomainList[i] + '">' + globalDomainList[i] + '</option>';
                    }
                    var j = 1;
                    var data = "<li class='li-style'>"+
                        "<label>&nbsp;</label>"+
                        "<select id='additionalSAN"+j+"' name='sslAdditionalSan"+j+"' class='additionalsan sslDomain form-control' data-fill='no'>"+
                        htmlOptions+
                        "</select>"+
                        "<a class='tooltips addbtb adddomain ssl-tooltipbox'><span class=\"tooltip\">{$LANG.addDomainToolTip}</span></a>"+
                        "<a class='tooltips lessbtn deldomain ssl-tooltipbox'><span class=\"tooltip\">{$LANG.removeDomainToolTip}</span></a></li>";
                    $("#additinalDomaindiv").append(data);
                    $("#additionalSAN"+j).rules('add', {
                        required: true
                    });
                    j++;
                }
                else{
                    alert("Only "+ maxSan +" additional domains allow");
                    return false;
                }
            })

            //Remove additional domain textbox on button click
            jQuery("#additinalDomaindiv").on("click", "a.deldomain", function () {
                jQuery(this).parent().remove();
            });


            $("#frmStepOne").validate({
                rules: {
                    sslHostingProfile: "required",
                    sslDomain: "required",
                    sslCSRCompany: "required",
                    sslCSRDivision: "required",
                    sslCSRCity: "required",
                    sslCSRState: "required",
                    sslCSRCountry: "required",
                    sslCSREmail: "required",
                    "sslAdditionalSan[]": "required",
                    sslSignatureAlgorithm: "required",
                    sslAdminTitle: "required",
                    sslAdminFirstName: "required",
                    sslAdminLastName: "required",
                    sslAdminEmail: "required",
                    sslAdminPhone: "required",
                    sslTechTitle: "required",
                    sslTechFirstName: "required",
                    sslTechLastName: "required",
                    sslTechEmail: "required",
                    sslTechPhone: "required",
                    sslOrgName: "required",
                    sslOrgDivision: "required",
                    sslOrgAddress1: "required",
                    sslOrgCity: "required",
                    sslOrgState: "required",
                    sslOrgCountry: "required",
                    sslOrgZipCode: "required",
                    sslOrgPhone: "required"
                },
                submitHandler: function(form) {
                    form.submit();
                    $("#btnstepone").attr('disabled',true);
                    // Get the modal
                    var modal = document.getElementById('autoInstallModal');
                    modal.style.display = "block";
                }
            });
        });

        function copyContact(){
            if($("input#sslSameAsAdmin:checked").length > 0){
                $("input#sslTechTitle").val($("input#sslAdminTitle").val());
                $("input#sslTechFirstName").val($("input#sslAdminFirstName").val());
                $("input#sslTechLastName").val($("input#sslAdminLastName").val());
                $("input#sslTechEmail").val($("input#sslAdminEmail").val());
                $("input#sslTechPhone").val($("input#sslAdminPhone").val())
            }
        }
        //Handle the MAX SAN input line and Display the number of SAN used.
        $('#sslAdditionalSan').bind('change keyup', function(event) {
            //Limit to arbitrary # of rows
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