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
    <form class="sslgen" id="frmReissueStepOne" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=reissuesteptwo">
        <input type="hidden" name="sslid" value="{$sslOrderId}">
        <h2>{$LANG.sslreissuetitle} - {$productName}</h2>
        <h3>{$LANG.sslServerInfoTitle}</h3>
        <p>{$LANG.sslServerInfoDesc}</p>

        <div class="form-group generate_info">
            <label for="sslCsr">{$LANG.sslCSR}:*</label>
            <textarea id="sslCsr" name="sslCsr" rows="15" class="form-control" onchange="decodeCSR()">{if $certInfo.sslCsr}{$certInfo.sslCsr}{/if}</textarea>
            <br/>
            <div id="csrDetails">
                <label>{$LANG.sslCSRTitle}:</label>
                <div class="row">
                    <div class="col-lg-6"><label>{$LANG.sslCSRCommonName} : </label><span data-csr="commonName"></span></div>
                    <div class="col-lg-6"><label>{$LANG.sslCSREmail} : </label><span data-csr="email"></span></div>
                </div>
                <div class="row">
                    <div class="col-lg-6"><label>{$LANG.sslCSRCompany} : </label><span data-csr="organization"></span></div>
                    <div class="col-lg-6"><label>{$LANG.sslCSRDivision} : </label><span data-csr="organizationUnit"></span></div>
                </div>
                <div class="row">
                    <div class="col-lg-6"><label>{$LANG.sslCSRState} : </label><span data-csr="state"></span></div>
                    <div class="col-lg-6"><label>{$LANG.sslCSRCity} : </label><span data-csr="city"></span></div>
                </div>
                <div class="row">
                    <div class="col-lg-6"><label>{$LANG.sslCSRCountry} : </label><span data-csr="country"></span></div>
                </div>
            </div>
        </div>
        {if $sanCount gt 0}
            <p>{$LANG.sslstore_san_csr_note}</p>
            <div class="form-group">
                <label for="sslAdditionalSan">{$LANG.sslAdditionalSan} ({$sanCount}):*</label> (Input every SAN in separate line)
                <textarea id="sslAdditionalSan" name="sslAdditionalSan" rows="3" class="form-control">{if $certInfo.sslAdditionalSan}{$certInfo.sslAdditionalSan}{/if}</textarea>
                <div class="theCount" style="padding:5px 0px;"><span id="linesUsed">0</span> of <span id="maxlines">{$sanCount}</span> SANs Used</div>
            </div>
        {/if}
        {if $wildCardSANCount gt 0}
            <p>{$LANG.sslstore_wildcard_san_csr_note}</p>
            <div class="form-group">
                <label for="sslAdditionalWildCardSan">{$LANG.sslAdditionalWildCardSan} ({$wildCardSANCount}):*</label> (Input every Wildcard SAN in separate line)
                <textarea id="sslAdditionalWildCardSan" name="sslAdditionalWildCardSan" rows="3" class="form-control">{if $certInfo.sslAdditionalWildCardSan}{$certInfo.sslAdditionalWildCardSan}{/if}</textarea>
                <div class="theCount" style="padding:5px 0px;"><span id="linesUsedWildCard">0</span> of <span id="maxlinesWildCard">{$wildCardSANCount}</span>wildcard SANs Used</div>
            </div>
        {/if}
        {if $vendorName eq "DIGICERT" && $isWWWDisplay}
        <div class="form-group">
            <input type="hidden" name="is_www" value="No">
            <input type='checkbox' name='is_www' id='is_www' {if $certInfo.isWWW eq 'yes'} checked='checked' {/if} value='yes' />
            <label for='www'>{$LANG.sslWWWLabel}</label>
            <p>{$LANG.sslWWWDesc}</p>
        </div>
        {/if}
        <div class="form-group">
            <label for="sslServerType">{$LANG.sslservertype}:*</label>
            <select name="sslServerType" id="sslServerType" class="form-control">
                <option value="" selected>{$LANG.pleasechooseone}</option>
                {foreach from=$webServerTypes key=webservertypeid item=webservertype}
                    <option value="{$webservertypeid}"{if $certInfo.sslServerType eq $webservertypeid} selected{/if}>
                        {$webservertype.displayName}
                    </option>
                {/foreach}
            </select>
        </div>
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
            <input type="submit" value="{$LANG.ordercontinuebutton}" class="btn btn-primary" />
        </p>
    </form>
    <script type="text/javascript">
        var vendorName = '{$vendorName}';
        var isFlexOrder = '{$isFlexOrder}';
        $(document).ready(function(){
            decodeCSR();
            $("#frmReissueStepOne").validate({
                rules: {
                    sslCsr: "required",
                    sslAdditionalSan: "required",
                    sslAdditionalWildCardSan: "required",
                    sslServerType: "required",
                    sslSignatureAlgorithm: "required",
                    sslCSRCountry: "required",
                    sslCSRState: "required",
                    sslCSRCity: "required",
                    sslCSRCompany: "required",
                    sslCSRDivision: "required",
                    sslDomainName: "required",
                    sslCSRKeySize: "required"
                },
                submitHandler: function(form) {
                    form.submit();
                }
            });

            /* Display the number of SAN used. */
            var linesUsed = $('#linesUsed');
            var splitval = [];
            if(typeof $('#sslAdditionalSan').val() != 'undefined') {
                splitval = $('#sslAdditionalSan').val().split("\n");
            }
            
            linesUsed.text(splitval.length);

            /* Display the number of Wildcard SAN used. */
            var linesUsedWildCard = $('#linesUsedWildCard');
            var splitvalWildCard = [];
            if(typeof $('#sslAdditionalWildCardSan').val() != 'undefined') {
                splitvalWildCard = $('#sslAdditionalWildCardSan').val().split("\n");
            }
            linesUsedWildCard.text(splitvalWildCard.length);
        });

        /* Handle the MAX SAN input line and Display the number of SAN used. */
        $('#sslAdditionalSan').bind('change keyup', function(event) {
            /* Limit to arbitrary # of rows */
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

        /* Handle the MAX Wildcard SAN input line and Display the number of Wildcard SAN used. */
        $('#sslAdditionalWildCardSan').bind('change keyup', function(event) {
            /* Limit to arbitrary # of rows */
            rows = $('#maxlinesWildCard').text();
            var linesUsedWildCard = $('#linesUsedWildCard');
            var value = '';
            var splitval = $(this).val().split("\n");
            for(var a=0;a<rows && typeof splitval[a] != 'undefined';a++) {
                if(a>0) value += "\n";
                value += splitval[a];
                if(splitval.length>=rows)
                    linesUsedWildCard.css('color', 'red');
                else
                    linesUsedWildCard.css('color', '');
            }
            linesUsedWildCard.text(splitval.length);
            if (splitval.length==1 && sslAdditionalWildCardSan.value.length == 0 || splitval.length>rows) {
                linesUsedWildCard.text((splitval.length)-1);
            }
            $(this).val(value);
        });
        function decodeCSR(){
            $('#csrDetails').hide();
            if($('#sslCsr').val().trim() != ''){
                $('.ajax_loader').show();
                $('#csrDetails').hide();
                $.ajax({
                    type: "POST",
                    url: 'modules/servers/thesslstorefullv2/common.php',
                    data: {ldelim}'action' : 'decodecsr', 'csr' : $("#sslCsr").val().trim(), 'productCode' : '{$productCode}' {rdelim},
                    dataType: "json",
                    success:(function(result){
                        if(result.isError == false){
                            for (key in result.csrData){
                                $("span[data-csr='"+key+"']").html(result.csrData[key]);
                            }
                            $('#csrDetails').slideDown(500);
                        }
                        else{
                            alert(result.errorMessage);
                        }
                        $('.ajax_loader').hide();
                    })
                });
            }
        }

        if(vendorName == 'DIGICERT' && isFlexOrder == true){
            /* Check the value of the Additional SANs is valid or not */
            $('#sslAdditionalSan').blur(function() {
                var lines = $('#sslAdditionalSan').val().split('\n');   // lines is an array of strings
                // Loop through all lines
                var isError = false;
                for (var i = 0; i < lines.length; i++) {
                    if (lines[i].indexOf('*.') > -1)
                    {
                        isError = true;
                    }
                }
                if(isError == true)
                {
                    alert("Wildcard domains are not allowed on this field. Please enter fully qualified domain names (domain.com, www.domain.com).");
                }
            });

            /* Check the value of the Additional Wildcard SANs is valid or not */
            $('#sslAdditionalWildCardSan').blur(function() {
                var lines = $('#sslAdditionalWildCardSan').val().split('\n');   // lines is an array of strings
                // Loop through all lines
                var isError = false;
                for (var i = 0; i < lines.length; i++) {
                    if (lines[i].indexOf('*.') < 0)
                    {
                        isError = true;
                    }
                }
                if(isError == true)
                {
                    alert("Specific subdomains or fully qualified domains are not allowed. These must be wildcard domain names (*.domain.com, *.domain2.com, *.domain3.com).");
                }
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