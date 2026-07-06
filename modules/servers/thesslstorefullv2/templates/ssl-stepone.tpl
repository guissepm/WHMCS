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
    .csr_info,.token_info,.autossl_info{
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
    /* ===== Radio Button as Button Design ===== */

.csr-radio-group{
    display: inline-flex;
    gap: 10px;
    margin: 15px 0 25px 0;
}

.csr-radio-btn{
    position: relative;
    cursor: pointer;
}

/* Hide native radio */
.csr-radio-btn input[type="radio"]{
    position: absolute;
    opacity: 0;
    pointer-events: none;
}

/* Button UI */
.csr-radio-ui{
    display: inline-block;
    padding: 8px 18px;
    font-size: 14px;
    border-radius: 4px;
    border: 1px solid #cfcfcf;
    background: #fff;
    color: #333;
    transition: all .2s ease;
}

/* Hover */
.csr-radio-btn:hover .csr-radio-ui{
    background: #f2f2f2;
}

/* Checked = AutoInstall (Green) */
.csr-radio-btn input[value="autoinstall"]:checked + .csr-radio-ui{
    background: #6aa84f;
    color: #fff;
    border-color: #5c9646;
    font-weight: 600;
}

/* Checked = Manual Enrollment (Teal) */
.csr-radio-btn input[value="existing"]:checked + .csr-radio-ui{
    background: #3f6f73;
    color: #fff;
    border-color: #355f63;
    font-weight: 600;
}

</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.js"></script>
<link href='https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.css' rel='stylesheet' type='text/css' />
{if $errormessage}
    {* ==============================================
    AutoInstall SSL - Error Template
    ============================================== *}

    <div class="panel panel-danger">

        <div class="panel-heading">
            <h3 class="panel-title">
                <i class="fa fa-exclamation-triangle"></i>
                AutoInstall SSL – Error
            </h3>
        </div>

        <div class="panel-body">

            {if $errormessage}
                <div class="alert alert-danger">
                    {$errormessage}
                </div>
            {else}
                <div class="alert alert-danger">
                    An unexpected error occurred while processing your SSL request.
                </div>
            {/if}

        </div>

    </div>
{/if}
{if $majorStatus eq "initial"}
        <h2>{$LANG.sslgenerationtitle} - {$productName}</h2>

        <div class="csr-radio-group">

            <label class="csr-radio-btn">
                <input type="radio"
                    name="csrChoice"
                    value="autoinstall"
                    {if $is_server_setup eq true}checked{/if}>
                <span class="csr-radio-ui">
                    ✓ AutoInstall
                </span>
            </label>

            <label class="csr-radio-btn">
                <input type="radio"
                    name="csrChoice"
                    value="existing" {if $is_server_setup eq false}checked {/if}>
                <span class="csr-radio-ui">
                    Manual Enrollment
                </span>
            </label>

        </div>

        <div class="clear"></div>

        <form class="sslgen" id="frmStepOne" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=steptwo">
            <input type="hidden" name="sslid" value="{$sslOrderId}">
            {if $isHostingProfileAvailable eq false}
                <div class="token_info">
                    <h3>{$LANG.token}</h3>
                    <p>{$LANG.tokens_tooltip}</p>
                    <div class="form-group">
                        <label for="sslAdminTitle">{$LANG.token}:</label>
                        <input class="form-control" type="text" value="{$sslToken}" readonly />
                    </div>
                    <p><input type="button" class="btn btn-primary" value="Copy Token" onclick="copyToken()"/></p>
                </div>
            {else}
                <input type="hidden" name="sslHostingProfile" id="sslHostingProfile" value="">
            {/if}
            <div class="autossl_info">
                <h3>{$LANG.sslServerInfoTitle}</h3>
                <p>{$LANG.sslIntstruction}</p>
            </div>

            <div class="form-group autossl_info">
                <label for="sslDomain">{$LANG.sslDomainName}:*</label>
                <select name="sslDomain" id="sslDomain" class="form-control sslDomain" data-fill="no">
                    <option value="">Loading...</option>
                </select>
                {if $vendorName eq "DIGICERT" && $isWWWDisplay}
                    <p class="help-block">
                    <input type="hidden" name="is_www" value="No">
                    <input type='checkbox' name='is_www' id='is_www' {if $www_non_www_digicert eq 'Yes'} checked='checked' {/if} value='yes' />
                    <label for='www'>{$LANG.sslWWWLabel}</label>
                    <p>
                    <p>{$LANG.sslWWWDesc}</p>
                {/if}
                {if $isWildCardProduct eq false}
                    <input type='hidden' name='www' id='www' checked='checked' value='www.'>
                {/if}
            </div>

            <div class="form-group autossl_info">
                <label for="dcv_email" class="control-label">
                    Select your preferred DCV email:*
                </label>

                <select name="ais_dcv_email" id="ais_dcv_email" class="form-control" required>
                    <!-- Options injected by JS -->
                </select>

                <p class="help-block">
                    <b>Email validation will be used in case File or DNS validation fails</b>
                </p>
            </div>

            {if $isWildCardProduct eq true || $wildCardSANCount eq true}
            <div class="form-group autossl_info">
                <label><strong>Select DCV Method:*</strong></label>

                <div class="radio">
                    <label>
                        <input type="radio" name="ais_dcv_method" value="dns" checked>
                        DNS (managed in cPanel)
                    </label>
                </div>

                <div class="radio">
                    <label>
                        <input type="radio" name="ais_dcv_method" value="email">
                        Email my preferred DCV email
                    </label>
                </div>
            </div>
            {else}
                <input type="hidden" name="ais_dcv_method" value="file">
            {/if}

            <div class="csr_info autossl_info">
                <h3>{$LANG.sslCSRTitle}</h3>
                <p>{$LANG.sslCSRDesc}</p>
            </div>
            <div class="form-group csr_info autossl_info">
                <label for="sslCSRCountry">{$LANG.sslOrgCountry}:*</label>
                <select name="sslCSRCountry" id="sslCSRCountry" class="form-control">
                    <option value="" selected>{$LANG.pleasechooseone}</option>
                    {foreach from=$countries key=countryCode item=countryName}
                        <option value="{$countryCode}" {if $certInfo.sslCSRCountry eq $countryCode} selected{/if}>
                            {$countryName->name}
                        </option>
                    {/foreach}
                </select>
            </div>

            <div class="form-group csr_info autossl_info">
                <label for="sslCSRState">{$LANG.sslOrgState}:*</label>
                <input type="text" class="form-control" name="sslCSRState" id="sslCSRState" value="{$certInfo.sslCSRState}">
            </div>

            <div class="form-group csr_info autossl_info">
                <label for="sslCSRCity">{$LANG.sslOrgCity}:*</label>
                <input type="text" class="form-control" name="sslCSRCity" id="sslCSRCity" value="{$certInfo.sslCSRCity}">
            </div>

            <div class="form-group csr_info autossl_info">
                <label for="sslCSRCompany">{$LANG.csrOrg}:*</label>
                <input type="text" class="form-control" name="sslCSRCompany" id="sslCSRCompany" value="{$certInfo.sslCSRCompany}">
            </div>

            <div class="form-group csr_info autossl_info">
                <label for="sslCSRDivision">{$LANG.csrOrgDivision}:*</label>
                <input type="text" class="form-control" name="sslCSRDivision" id="sslCSRDivision" value="{$certInfo.sslCSRDivision}">
            </div>

            <div class="form-group csr_info">
                <label for="sslDomainName">{$LANG.sslDomainName}:*</label>
                <input type="text" class="form-control" name="sslDomainName" id="sslDomainName" value="{$certInfo.sslDomainName}">
            </div>

            <div class="form-group csr_info autossl_info">
                <label for="sslCSREmail">{$LANG.sslCSREmail}:</label>
                <input type="text" class="form-control" name="sslCSREmail" id="sslCSREmail" value="{$certInfo.sslCSREmail}"/>
            </div>

            <div class="form-group csr_info autossl_info" id="keysize-group">
                <label><strong>{$LANG.csrKeySize}:*</strong></label>
                <div class="radio">
                    <label>
                        <input type="radio" id="csrKeySize_2048" {if $certInfo.sslCSRKeySize eq '2048'} checked {/if} name="sslCSRKeySize" value="2048">
                        2048
                    </label>
                </div>

                <div class="radio">
                    <label>
                        <input type="radio" id="csrKeySize_4096" {if $certInfo.sslCSRKeySize eq '4096'} checked {/if} name="sslCSRKeySize" value="4096">
                        4096
                    </label>
                </div>
            </div>

            <p class="csr_info">
                <a class="btn btn-primary" href="clientarea.php?action=productdetails&id={$serviceId}">{$LANG.backtoservicedetails}</a>
                <input type="submit" name="csrgeneratebtn" id="csrgeneratebtn" value="{$LANG.csrGeneratebtn}" class="btn btn-primary" />
            </p>

            <div id="generate_info">
                <h3 class="generate_info">{$LANG.sslServerInfoTitle}</h3>
                <p class="generate_info">{$LANG.sslServerInfoDesc}</p>
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
                    <p class="generate_info autossl_info">{$LANG.sslstore_san_csr_note}</p>
                    <div class="form-group generate_info">
                        <label for="sslAdditionalSan">{$LANG.sslAdditionalSan} ({$sanCount}):*</label> (Input every SAN in separate line)
                        <textarea id="sslAdditionalSan" name="sslAdditionalSan" rows="3" class="form-control">{if $certInfo.sslAdditionalSan}{$certInfo.sslAdditionalSan}{/if}</textarea>
                        <div class="theCount" style="padding:5px 0px;"><span id="linesUsed">0</span> of <span id="maxlines">{$sanCount}</span> SANs Used</div>
                    </div>
                    <div id="additinalDomaindiv" class="form-group autossl_info">
                        <label>{$LANG.sslAdditionalSan} ({$sanCount}):*</label>
                        <select id="additionalSANDD" name='sslAdditionalSanDD[]' class="additionalsan form-control">
                            <option value="">Loading...</option>
                        </select>
                        <a class='tooltips addbtb adddomain ssl-tooltipbox'><span class="tooltip">{$LANG.addDomainToolTip}</span></a>
                    </div>
                    <div class="clear"></div>
                {/if}
                {if $wildCardSANCount gt 0}
                    <p class="generate_info autossl_info">{$LANG.sslstore_wildcard_san_csr_note}</p>
                    <div class="form-group generate_info">
                        <label for="sslAdditionalWildCardSan">{$LANG.sslAdditionalWildCardSan} ({$wildCardSANCount}):*</label> (Input every Wildcard SAN in separate line)
                        <textarea id="sslAdditionalWildCardSan" name="sslAdditionalWildCardSan" rows="3" class="form-control">{if $certInfo.sslAdditionalWildCardSan}{$certInfo.sslAdditionalWildCardSan}{/if}</textarea>
                        <div class="theCount" style="padding:5px 0px;"><span id="linesUsedWildCard">0</span> of <span id="maxlinesWildCard">{$wildCardSANCount}</span> Wildcard SANs Used</div>
                    </div>
                    <div id="additinalWildCardDomaindiv" class="form-group autossl_info">
                        <label>{$LANG.sslAdditionalWildCardSan} ({$wildCardSANCount}):*</label>
                        <select id="additionalWildCardSANDD" name='sslAdditionalWildCardSanDD[]' class="additionalwildcardsan form-control">
                            <option value="">Loading...</option>
                        </select>
                        <a class='tooltips addbtb addwildcarddomain ssl-tooltipbox'><span class="tooltip">{$LANG.addWildCardDomainToolTip}</span></a>
                    </div>
                    <div class="clear"></div>
                {/if}
                {if $vendorName eq "DIGICERT" && $isWWWDisplay}
                <div class="form-group generate_info">
                    <input type="hidden" name="is_www" value="No">
                    <input type='checkbox' name='is_www' id='is_www' {if $www_non_www_digicert eq 'Yes'} checked='checked' {/if} value='yes' />
                    <label for='www'>{$LANG.sslWWWLabel}</label>
                    <p>{$LANG.sslWWWDesc}</p>
                </div>
                {/if}
                {if $isWildCardProduct eq false}
                    <input type='hidden' name='www' id='www' checked='checked' value='www.'>
                {/if}
                <div class="form-group generate_info">
                    <label for="sslServerType">{$LANG.sslservertype}:*</label>
                    <select name="sslServerType" id="sslServerType" class="form-control">
                        <option value="" selected>{$LANG.pleasechooseone}</option>
                        {foreach from=$webServerTypes key=webservertypeid item=webservertype}
                            <option value="{$webservertypeid}"{if $certInfo.sslServerType eq $webservertypeid} selected{/if}{if $defaultWebServer eq $webservertypeid} selected{/if}>
                                {$webservertype.displayName}
                            </option>
                        {/foreach}
                    </select>
                </div>
                <div class="form-group generate_info autossl_info">
                    <label for="sslSignatureAlgorithm">{$LANG.signature_algorithm_label}:*</label>
                    <p>{$signatureAlgorithmDescription}</p>
                    <select name="sslSignatureAlgorithm" id="sslSignatureAlgorithm" class="form-control">
                        <option value="" selected>{$LANG.pleasechooseone}</option>
                        {foreach from=$signatureAlgorithmList key=sigKey item=sigValue}
                            <option value="{$sigKey}"{if $certInfo.sslSignatureAlgorithm eq $sigKey} selected{/if}{if $vendorName eq "COMODO" || $vendorName eq 'SECTIGO'} selected{/if}>
                                {$sigValue}
                            </option>
                        {/foreach}
                    </select>
                </div>

                <h3 class="generate_info autossl_info">{$LANG.sslAdminTitle}</h3>
                <p class="generate_info autossl_info">{$LANG.sslAdminDesc}</p>
                <div class="form-group generate_info autossl_info">
                    <label for="sslAdminTitle">{$LANG.sslTitle}:*</label>
                    <input type="text" class="form-control" name="sslAdminTitle" id="sslAdminTitle" value="{$certInfo.sslAdminTitle}" onchange="copyContact()"/>
                </div>
                <div class="form-group generate_info autossl_info">
                    <label for="sslAdminFirstName">{$LANG.sslFirstName}:*</label>
                    <input type="text" class="form-control" name="sslAdminFirstName" id="sslAdminFirstName" value="{$certInfo.sslAdminFirstName}" onchange="copyContact()"/>
                </div>
                <div class="form-group generate_info autossl_info">
                    <label for="sslAdminLastName">{$LANG.sslLastName}:*</label>
                    <input type="text" class="form-control" name="sslAdminLastName" id="sslAdminLastName" value="{$certInfo.sslAdminLastName}" onchange="copyContact()" />
                </div>
                <div class="form-group generate_info autossl_info">
                    <label for="sslAdminEmail">{$LANG.sslEmail}:*</label>
                    <input type="text" class="form-control" name="sslAdminEmail" id="sslAdminEmail" value="{$certInfo.sslAdminEmail}" onchange="copyContact()"/>
                </div>
                <div class="form-group generate_info autossl_info">
                    <label for="sslAdminPhone">{$LANG.sslPhone}:*</label>
                    <input type="text" class="form-control" name="sslAdminPhone" id="sslAdminPhone" value="{$certInfo.sslAdminPhone}" onchange="copyContact()" />
                </div>
                {if $useDefaultTechDetails ne 1}
                    <h3 class="generate_info autossl_info">{$LANG.sslTechTitle}</h3>
                    <p class="generate_info autossl_info">{$LANG.sslTechDesc}</p>
                    <p class="generate_info autossl_info">
                        <input type="checkbox" name="sslSameAsAdmin" id="sslSameAsAdmin" onchange="copyContact()" />
                        <label class="inline-label" for="sslSameAsAdmin">{$LANG.sslSameAsAdmin}</label>
                    </p>

                    <div class="form-group generate_info autossl_info">
                        <label for="sslTechTitle">{$LANG.sslTitle}:*</label>
                        <input type="text" class="form-control" name="sslTechTitle" id="sslTechTitle" value="{$certInfo.sslTechTitle}" />
                    </div>
                    <div class="form-group generate_info autossl_info">
                        <label for="sslTechFirstName">{$LANG.sslFirstName}:*</label>
                        <input type="text" class="form-control" name="sslTechFirstName" id="sslTechFirstName" value="{$certInfo.sslTechFirstName}" />
                    </div>
                    <div class="form-group generate_info autossl_info">
                        <label for="sslTechLastName">{$LANG.sslLastName}:*</label>
                        <input type="text" class="form-control" name="sslTechLastName" id="sslTechLastName" value="{$certInfo.sslTechLastName}" />
                    </div>
                    <div class="form-group generate_info autossl_info">
                        <label for="sslTechEmail">{$LANG.sslEmail}:*</label>
                        <input type="text" class="form-control" name="sslTechEmail" id="sslTechEmail" value="{$certInfo.sslTechEmail}" />
                    </div>
                    <div class="form-group generate_info autossl_info">
                        <label for="sslTechPhone">{$LANG.sslPhone}:*</label>
                        <input type="text" class="form-control" name="sslTechPhone" id="sslTechPhone" value="{$certInfo.sslTechPhone}" />
                    </div>
                {/if}

                {if $productValidationType ne 'DV' || $productCode eq 'ssl123' || $productCode eq 'ssl123wildcard'}
                    <h3 class="generate_info">{$LANG.sslOrgTitle}</h3>
                    <p class="generate_info">{$LANG.sslOrgDesc}</p>
                    {if $preAuthOrgList|@count gt 0}
                        <div class="form-group checkbox generate_info autossl_info">
                            <input type="radio" id="sslNewOrgDetails" name="sslOrgDetails" value="new" checked><label for="sslNewOrgDetails">{$LANG.newOrgDetails}</label><br/>
                            <input type="radio" id="sslPreAuthOrgDetails" name="sslOrgDetails" value="existing"><label for="sslPreAuthOrgDetails">{$LANG.preAuthOrgDetails}</label><br/>
                        </div>
                        <div class="form-group" id="showOrgList" style="display: none;">
                            <select name="sslOrgId" id="sslOrgId" class="form-control" onchange="getOrgInfo()">
                                {foreach from=$preAuthOrgList item=orgInfo}
                                    <option {if $certInfo.sslOrgId eq $orgInfo->org_id} selected{/if} value="{$orgInfo->org_id}">
                                        {$orgInfo->org_name}
                                    </option>
                                {/foreach}
                            </select>
                        </div>
                        <div id="org-info-details">
                            <label>{$LANG.sslOrgInfo}:</label>
                            <div class="row">
                                <div class="col-lg-6"><label>{$LANG.sslOrgName} : </label><span data-org="name"></span></div>
                                <div class="col-lg-6"><label>{$LANG.sslOrgAddress1} : </label><span data-org="address"></span></div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6"><label>{$LANG.sslOrgAddress2} : </label><span data-org="address2"></span></div>
                                <div class="col-lg-6"><label>{$LANG.sslOrgCity} : </label><span data-org="city"></span></div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6"><label>{$LANG.sslOrgState} : </label><span data-org="state"></span></div>
                                <div class="col-lg-6"><label>{$LANG.sslOrgCountry} : </label><span data-org="country"></span></div>
                            </div>
                            <div class="row">
                                <div class="col-lg-6"><label>{$LANG.sslOrgZipCode} : </label><span data-org="zip"></span></div>
                                <div class="col-lg-6"><label>{$LANG.sslPhone} : </label><span data-org="phone"></span></div>
                            </div>
                        </div>
                    {/if}
                    <div class="org-info">
                        <div class="form-group generate_info autossl_info">
                            <label for="sslOrgName">{$LANG.sslOrgName}:*</label>
                            <input type="text" class="form-control" name="sslOrgName" id="sslOrgName" value="{$certInfo.sslOrgName}" />
                        </div>
                        {if $vendorName neq "DIGICERT"}
                            <div class="form-group generate_info autossl_info">
                                <label for="sslOrgName">{$LANG.sslOrgDuns}:</label>
                                <input type="text" class="form-control" name="sslOrgDuns" id="sslOrgDuns" value="{$certInfo.sslOrgDuns}" />
                            </div>
                            <div class="form-group generate_info autossl_info">
                                <label for="sslOrgDivision">{$LANG.sslOrgDivision}:*</label>
                                <input type="text" class="form-control" name="sslOrgDivision" id="sslOrgDivision" value="{$certInfo.sslOrgDivision}" />
                            </div>
                        {/if}
                        <div class="form-group generate_info autossl_info">
                            <label for="sslOrgAddress1">{$LANG.sslOrgAddress1}:*</label>
                            <input type="text" class="form-control" name="sslOrgAddress1" id="sslOrgAddress1" value="{$certInfo.sslOrgAddress1}" />
                        </div>
                        <div class="form-group generate_info autossl_info">
                            <label for="sslOrgAddress2">{$LANG.sslOrgAddress2}:</label>
                            <input type="text" class="form-control" name="sslOrgAddress2" id="sslOrgAddress2" value="{$certInfo.sslOrgAddress2}" />
                        </div>
                        <div class="form-group generate_info autossl_info">
                            <label for="sslOrgCity">{$LANG.sslOrgCity}:*</label>
                            <input type="text" class="form-control" name="sslOrgCity" id="sslOrgCity" value="{$certInfo.sslOrgCity}" />
                        </div>
                        <div class="form-group generate_info autossl_info">
                            <label for="sslOrgState">{$LANG.sslOrgState}:*</label>
                            <input type="text" class="form-control" name="sslOrgState" id="sslOrgState" value="{$certInfo.sslOrgState}" />
                        </div>
                        <div class="form-group generate_info autossl_info">
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
                        <div class="form-group generate_info autossl_info">
                            <label for="sslOrgZipCode">{$LANG.sslOrgZipCode}:*</label>
                            <input type="text" class="form-control" name="sslOrgZipCode" id="sslOrgZipCode" value="{$certInfo.sslOrgZipCode}" />
                        </div>
                        <div class="form-group generate_info autossl_info">
                            <label for="sslOrgPhone">{$LANG.sslPhone}:*</label>
                            <input type="text" class="form-control" name="sslOrgPhone" id="sslOrgPhone" value="{$certInfo.sslOrgPhone}" />
                        </div>
                    </div>
                {/if}
                <p class="generate_info autossl_info">
                    <a class="btn btn-primary" href="clientarea.php?action=productdetails&id={$serviceId}">{$LANG.backtoservicedetails}</a>
                    <input type="submit" name="btnstepone" id="btnstepone" value="{$LANG.ordercontinuebutton}" class="btn btn-primary" />
                </p>
            </div>
        </form>
    <div id="autoInstallModal" class="aismodal">
        <!-- Modal content -->
        <div class="aismodal-content">
            <p><img src="assets/ssl_resources/images/icon_loading.gif" width="100"><br>{$LANG.autossl_process_msg}</p>
        </div>
    </div>

    <div class="ajax_loader"><img src="assets/ssl_resources/images/icon_loading.gif"></div>
    <script>
(function () {
/* ============================================================
        * GLOBAL CONTEXT (unchanged values)
        * ============================================================ */
        var vendorName       = '{$vendorName}';
        var isFlexOrder      = '{$isFlexOrder}';
        var profileAvailable = '{$isHostingProfileAvailable}';
        var profileData      = {};
        
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

        /*add additional domain textbox on button click*/
        $("#additinalDomaindiv").on("click","a.adddomain", function(){
            var maxSan = {$sanCount};
            var additionalSan =  $("#additinalDomaindiv select").length;
            if(maxSan > additionalSan){
                var htmlOptions = "<div><select class='form-control additionalsan' name='sslAdditionalSanDD[]'>"+$('#additionalSANDD').html()+"</select>"+
                    "<a class='tooltips addbtb adddomain ssl-tooltipbox'><span class='tooltip'>{$LANG.addDomainToolTip}</span></a>"+
                    "<a class='tooltips lessbtn deldomain ssl-tooltipbox'><span class='tooltip'>{$LANG.removeDomainToolTip}</span></a></div>";
                $("#additinalDomaindiv").append(htmlOptions);
            }
            else{
                alert("Only "+ maxSan +" additional domains allow");
                return false;
            }
        })

        /* Remove additional domain textbox on button click */
        $("#additinalDomaindiv").on("click", "a.deldomain", function () {
            $(this).parent().remove();
        });


        /*Handle the MAX Wildcard SAN input line and Display the number of Wildcard SAN used.*/
        $('#sslAdditionalWildCardSan').bind('change keyup', function(event) {
            /*Limit to arbitrary # of rows*/
            rows = $('#maxlinesWildCard').text();
            var linesUsed = $('#linesUsedWildCard');
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

        /*add additional wildcard domain textbox on button click*/
        $("#additinalWildCardDomaindiv").on("click","a.addwildcarddomain", function(){
            var maxWildCardSan = {$wildCardSANCount};
            var additionalWildCardSan =  $("#additinalWildCardDomaindiv select").length;
            if(maxWildCardSan > additionalWildCardSan){
                var htmlOptions = "<div><select class='form-control additionalWildCardSan' name='sslAdditionalWildCardSanDD[]'>"+$('#additionalWildCardSANDD').html()+"</select>"+
                    "<a class='tooltips addbtb addwildcarddomain ssl-tooltipbox'><span class='tooltip'>{$LANG.addWildCardDomainToolTip}</span></a>"+
                    "<a class='tooltips lessbtn delwildcarddomain ssl-tooltipbox'><span class='tooltip'>{$LANG.removeWildCardDomainToolTip}</span></a></div>";
                $("#additinalWildCardDomaindiv").append(htmlOptions);
            }
            else{
                alert("Only "+ maxWildCardSan +" additional wildcard domains allow");
                return false;
            }
        })

        /* Remove additional wildcard domain textbox on button click */
        $("#additinalWildCardDomaindiv").on("click", "a.delwildcarddomain", function () {
            $(this).parent().remove();
        });

    const domainSelect = document.getElementById('sslDomain');
    const emailSelect  = document.getElementById('ais_dcv_email');

    const emailPrefixes = [
        'admin@',
        'administrator@',
        'webmaster@',
        'hostmaster@',
        'postmaster@'
    ];

    function getMainDomain(domain) {

        if (!domain || domain === 'notlisted') {
            return '';
        }

        domain = domain.replace(/^\*\./, '').toLowerCase();
        const parts = domain.split('.');

        if (parts.length <= 2) {
            return domain;
        }

        const multiTlds = [
            'co.uk','org.uk','gov.uk','ac.uk',
            'com.au','net.au','org.au','co.in'
        ];

        const lastTwo = parts.slice(-2).join('.');
        if (multiTlds.includes(lastTwo)) {
            return parts.slice(-3).join('.');
        }

        return parts.slice(-2).join('.');
    }

    function clearEmailField() {
        emailSelect.innerHTML = '';
        emailSelect.disabled = false;
        emailSelect.required = true;
        const opt = document.createElement('option');
        opt.value = "";
        opt.text  = "First select domain";
        emailSelect.appendChild(opt);
    }

    function populateEmailField(mainDomain) {
        emailSelect.innerHTML = '';
        emailSelect.disabled = false;
        emailSelect.required = true;

        emailPrefixes.forEach(prefix => {
            const opt = document.createElement('option');
            opt.value = prefix + mainDomain;
            opt.text  = prefix + mainDomain;
            emailSelect.appendChild(opt);
        });
    }

    function updateDCVEmails() {

        const selectedDomain = domainSelect.value;

        // 🔴 Case: Domain not listed
        if (selectedDomain === 'notlisted') {
            clearEmailField();
            return;
        }

        const domain = selectedDomain.split('|').at(-1);

        const mainDomain = getMainDomain(domain);

        if (!mainDomain) {
            clearEmailField();
            return;
        }

        populateEmailField(mainDomain);
    }

    // Initial load
    updateDCVEmails();

    // On domain change
    domainSelect.addEventListener('change', updateDCVEmails);

})();
</script>



    <script type="text/javascript">
        /* ============================================================
        * GLOBAL CONTEXT (unchanged values)
        * ============================================================ */
        var vendorName       = '{$vendorName}';
        var isFlexOrder      = '{$isFlexOrder}';
        var profileAvailable = '{$isHostingProfileAvailable}';
        var profileData      = {};

        /* ============================================================
        * DOCUMENT READY
        * ============================================================ */
        $(function () {

            disPlayTab();
            decodeCSR();

            /* ---------- FORM VALIDATION ---------- */
            $("#frmStepOne").validate({
                rules: {
                    sslCsr: "required",
                    sslAdditionalSan: "required",
                    'sslAdditionalSanDD[]': { required: true },
                    sslAdditionalWildCardSan: "required",
                    'sslAdditionalWildCardSanDD[]': { required: true },
                    sslServerType: "required",
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
                    sslOrgId: "required",
                    sslOrgName: "required",
                    sslOrgDivision: "required",
                    sslOrgAddress1: "required",
                    sslOrgCity: "required",
                    sslOrgState: "required",
                    sslOrgCountry: "required",
                    sslOrgZipCode: "required",
                    sslOrgPhone: "required",
                    sslDomain: "required",
                    ais_dcv_email: "required",
                    sslCSRCountry: "required",
                    sslCSRState: "required",
                    sslCSRCity: "required",
                    sslCSRCompany: "required",
                    sslCSRDivision: "required",
                    sslDomainName: "required",
                    sslCSRKeySize: "required"
                },
                errorPlacement: function (error, element) {
                    // Handle radio group
                    if (element.attr('type') === 'radio') {
                        error.insertAfter('#keysize-group label:first');
                    } else {
                        error.insertAfter(element);
                    }
                },
                submitHandler: function (form) {
                    $("#btnstepone").prop('disabled', true);

                    /*if ($('input[name="csrChoice"]:checked').val() === 'autoinstall') {
                        $("#autoInstallModal").show();
                    }*/

                    form.submit();
                }
            });

            /* ---------- DIGICERT ORG HANDLING ---------- */
            if (vendorName === 'DIGICERT') {
                handleDigicertOrg();
            }

            /* ---------- EVENTS ---------- */
            $('input[name="csrChoice"]').on('change', disPlayTab);

            $('select#sslDomain').on('change', function () {
                $('#sslHostingProfile').val(this.value);
                
                if(this.value == 'notlisted') {
                    $('input[name="csrChoice"][value="existing"]')
                    .prop('checked', true)
                    .trigger('change');
                    $('.generate_info').hide();
                    $('.token_info, .autossl_info').hide();
                    $("#frmStepOne").attr(
                        'action',
                        '{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=steptwo'
                    );
                    $('.generate_info').show();
                    $('select#sslDomain').val("");
                }
            });

            bindSanCounters();
            bindWildcardSanCounters();
        });

        /* ============================================================
        * UI TOGGLING
        * ============================================================ */
        function disPlayTab() {
            var csrChoice = $('input[name="csrChoice"]:checked').val();

            $('.generate_info').hide();
            $('.token_info, .autossl_info').hide();

            if (csrChoice === 'autoinstall') {
                if (profileAvailable) {
                    $("#frmStepOne").attr(
                        'action',
                        '{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=autosslcomplete'
                    );
                    $('.autossl_info').show();
                    fetchDomainList();
                } else {
                    $('.token_info').show();
                }
            }

            if (csrChoice === 'existing') {
                $("#frmStepOne").attr(
                    'action',
                    '{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=steptwo'
                );
                $('.generate_info').show();
            }
        }

        /* ============================================================
        * DOMAIN FETCH (CPANEL)
        * ============================================================ */
        function fetchDomainList() {
            var $dd = document.querySelector('select.sslDomain'); //$('select.sslDomain');


            if ($dd.dataset.fill == 'yes') {
                return;
            }

            var isCommonNameWildCard = ({if $isCommonNameWildCard eq true}1{else}0{/if});
            var isSANWildCard = ({if $isSANWildCard eq true}1{else}0{/if});

            $('.ajax_loader').show();

            $.post(
                'modules/servers/thesslstorefullv2/common.php',
                { action: 'getcpaneldomainlist' },
                function (result) {

                    const cn = document.createDocumentFragment();
                    const ss = document.createDocumentFragment();
                    const ws = document.createDocumentFragment();

                    [cn, ss, ws].forEach(fragment=>{
                        fragment.appendChild(Object.assign(document.createElement('option'),{
                            textContent:  " {$LANG.pleasechooseone} ",
                            value: ''
                        }));
                    })


                    if(result.domainSubDomains){
                        Object.entries(result.domainSubDomains).forEach(([name, subdomains]) => {
                            const cng = document.createElement('optgroup');
                            cng.label = name;

                            const ssg = document.createElement('optgroup');
                            ssg.label = name;

                            const wsg = document.createElement('optgroup');
                            wsg.label = name;

                            subdomains.forEach(tuple => {
                                const [user, domain] = tuple.split('|');

                                let common_name = isCommonNameWildCard && name == domain
                                    ? '*.'+domain
                                    : domain;

                                cng.appendChild(Object.assign(document.createElement('option'),{
                                    textContent:  common_name,
                                    value: [user, common_name].join('|')
                                }));

                                ssg.appendChild(Object.assign(document.createElement('option'),{
                                    textContent:  domain,
                                    value: [user, domain].join('|')
                                }));

                                wsg.appendChild(Object.assign(document.createElement('option'),{
                                    textContent:  '*.'+domain,
                                    value: [user, '*.'+domain].join('|')
                                }));
                            });

                            cn.appendChild(cng);
                            ss.appendChild(ssg);
                            ws.appendChild(wsg);

                        });

                    }

                    [cn, ss, ws].forEach(fragment=>{
                        fragment.appendChild(Object.assign(document.createElement('option'),{
                            textContent:  'Domain not listed',
                            value: 'notlisted'
                        }));
                    })

                    document
                        .querySelector('#sslDomain')
                        .replaceChildren(cn);

                    {if $sanCount gt 0}
                        document
                            .querySelector('#additionalSANDD')
                            .replaceChildren(ss);
                    {/if}

                    {if $wildCardSANCount gt 0}
                        document
                            .querySelector('#additionalWildCardSANDD')
                            .replaceChildren(ws);
                    {/if}

                    $dd.dataset.fill = 'yes';
                    $('.ajax_loader').hide();
                },
                'json');
        }

        /* ============================================================
        * SAN LINE COUNTERS
        * ============================================================ */
        function bindSanCounters() {
            $('#sslAdditionalSan').on('keyup change', function () {
                limitTextareaLines(
                    $(this),
                    $('#maxlines').text(),
                    $('#linesUsed')
                );
            });
        }

        function bindWildcardSanCounters() {
            $('#sslAdditionalWildCardSan').on('keyup change', function () {
                limitTextareaLines(
                    $(this),
                    $('#maxlinesWildCard').text(),
                    $('#linesUsedWildCard')
                );
            });
        }

        function limitTextareaLines($el, max, $counter) {
            var lines = $el.val().split("\n");

            if (lines.length > max) {
                $el.val(lines.slice(0, max).join("\n"));
                $counter.css('color', 'red');
            } else {
                $counter.css('color', '');
            }

            $counter.text(lines.length);
        }

        /* ============================================================
        * DIGICERT FLEX SAN VALIDATION
        * ============================================================ */
        if (vendorName === 'DIGICERT' && isFlexOrder) {

            $('#sslAdditionalSan').on('blur', function () {
                validateSan($(this).val(), false);
            });

            $('#sslAdditionalWildCardSan').on('blur', function () {
                validateSan($(this).val(), true);
            });
        }

        function validateSan(value, mustBeWildcard) {
            var lines = value.split("\n");

            for (var i = 0; i < lines.length; i++) {
                var hasWildcard = lines[i].indexOf('*.') > -1;

                if (mustBeWildcard !== hasWildcard) {
                    alert(
                        mustBeWildcard
                        ? 'Only wildcard domains allowed (*.domain.com)'
                        : 'Wildcard domains are not allowed here'
                    );
                    return false;
                }
            }
            return true;
        }

        /* ============================================================
        * DIGICERT ORG AUTOCOMPLETE
        * ============================================================ */
        function handleDigicertOrg() {

            if ($('#sslOrgId').val()) {
                $('#sslPreAuthOrgDetails').prop('checked', true);
                $('#showOrgList').show();
                $('.org-info').hide();
                $('#org-info-details').show();
                getOrgInfo();
            }

            $('input[name="sslOrgDetails"]').on('change', function () {
                if ($(this).val() === 'existing') {
                    $('#showOrgList').show();
                    $('.org-info').hide();
                    $('#org-info-details').show();
                } else {
                    $('#showOrgList').hide();
                    $('.org-info').show();
                    $('#org-info-details').hide();
                }
            });

            $('#sslOrgName').autocomplete({
                minLength: 6,
                delay: 1500,
                source: function (request, response) {
                    $.post(
                        'modules/servers/thesslstorefullv2/common.php',
                        { action: 'getorglist', q: request.term },
                        response,
                        'json'
                    );
                }
            });
        }

        /* ============================================================
        * CSR DECODE
        * ============================================================ */
        function decodeCSR() {
            var csr = $('#sslCsr').val().trim();

            if (!csr) {
                $('#csrDetails').hide();
                return;
            }

            $('.ajax_loader').show();

            $.post(
                'modules/servers/thesslstorefullv2/common.php',
                { action: 'decodecsr', csr: csr, productCode: '{$productCode}' },
                function (result) {
                    if (!result.isError) {
                        $.each(result.csrData, function (k, v) {
                            $('span[data-csr="' + k + '"]').text(v);
                        });
                        $('#csrDetails').slideDown();
                    } else {
                        alert(result.errorMessage);
                    }
                    $('.ajax_loader').hide();
                },
                'json'
            );
        }

        /* ============================================================
        * ORG INFO
        * ============================================================ */
        function getOrgInfo() {
            $('.ajax_loader').show();

            $.post(
                'modules/servers/thesslstorefullv2/common.php',
                { action: 'getorginfo', orgid: $('#sslOrgId').val() },
                function (result) {
                    if (!result.isError) {
                        $.each(result.orgData, function (k, v) {
                            $('span[data-org="' + k + '"]').text(v);
                        });
                        $('#org-info-details').slideDown();
                    } else {
                        alert(result.errorMessage);
                    }
                    $('.ajax_loader').hide();
                },
                'json'
            );
        }

        /* ============================================================
        * COPY TOKEN
        * ============================================================ */
        function copyToken() {
            var el = document.createElement('textarea');
            el.value = '{$sslToken}';
            document.body.appendChild(el);
            el.select();
            document.execCommand('copy');
            document.body.removeChild(el);
        }
        function copyContact(){
            if($("input#sslSameAsAdmin:checked").length > 0){
                $("input#sslTechTitle").val($("input#sslAdminTitle").val());
                $("input#sslTechFirstName").val($("input#sslAdminFirstName").val());
                $("input#sslTechLastName").val($("input#sslAdminLastName").val());
                $("input#sslTechEmail").val($("input#sslAdminEmail").val());
                $("input#sslTechPhone").val($("input#sslAdminPhone").val())
            }
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