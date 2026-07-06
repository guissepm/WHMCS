<style>
    .sslgen{
        text-align: left;
    }
    #Primary_Sidebar-Service_Details_Overview-Information,#Primary_Sidebar-Service_Details_Overview-Addons{
        display: none;
    }
</style>
<div class="sslgen">
    {if $errormessage}
        <div class="alert alert-danger text-center">
            <strong>{$LANG.clientareaerrors}</strong>
            <ul>
                {$errormessage}
            </ul>
        </div>
    {else}
        <div align="left" class="ssltblcmn">
            <table width="100%" cellspacing="1" cellpadding="0" class="frame ssltbldtl">
                <tr>
                    <td>
                        <table width="100%" border="0" cellpadding="10" cellspacing="2">
                            <tr>
                                <td>{$LANG.sslstatus}:</td>
                                <td>{$certInfo.OrderStatus.MajorStatus}</td>
                            </tr>
                            <tr>
                                <td width="150">{$LANG.ssl_product_name}:</td>
                                <td>{$certInfo.ProductName}</td>
                            </tr>
                            <tr>
                                <td width="150">{$LANG.ssl_store_orderid}:</td>
                                <td>{$certInfo.TheSSLStoreOrderID}</td>
                            </tr>
                            <tr>
                                <td width="150">{$LANG.ssl_vendor_orderid}:</td>
                                <td>{$certInfo.VendorOrderID}</td>
                            </tr>
                            <tr>
                                <td width="150">{$LANG.ssl_vendor_status}:</td>
                                <td>{$certInfo.OrderStatus.MinorStatus}</td>
                            </tr>
                            <tr>
                                <td width="150"><span class="tokens">{$LANG.token}</span>: <div class="ssl-tooltipbox"><img alt="tooltip" src="assets/ssl_resources/images/iconquestion.png"> <div class="tooltip">{$LANG.tokens_tooltip}</div></div></td>
                                <td>{$certInfo.Token}</td>
                            </tr>
                            {*<tr>
                                <td width="160">{$LANG.ssl_provisioning_date}:</td>
                                <td>{$certInfo.CertificateStartDate}</td>
                            </tr>
                            <tr>
                                <td width="150">{$LANG.ssl_expiry_date}:</td>
                                <td>{$certInfo.CertificateEndDate}</td>
                            </tr>*}
                            <tr>
                                <td width="150">{$LANG.domains}:</td>
                                <td>{$certInfo.CommonName}</td>
                            </tr>
                            <tr>
                                <td colspan=2 align="center"><h5>Access your subscription using the button below</h5><a class='ssl-generatecertbtn' href="{$SSOLink}" target="_blank" style="padding:10px">{$LANG.assign_license_title}</a></td>
                            </tr>
                            {*
                            <tr>
                                <td colspan=2 align="center"><a class='ssl-generatecertbtn' href="{$SSOLink}" target="_blank" style="padding:10px">{$LANG.assign_license_title}</a><br/><br/><span>{$LANG.assign_license_sub_title}</span></td>
                            </tr>
                            {if $certInfo.OrderStatus.MinorStatus != 'Cancelled' && $tblhostingData->billingcycle != 'One Time'}
                            <tr>
                                <td colspan=2 align="center"><span><h4>Need more storages or features?</h4></span><a class="ssl-generatecertbtn" href="https://{$smarty.server.SERVER_NAME}/upgrade.php?type=package&id={$serviceId}" style="padding:10px">{$LANG.upgrade_subscription_text}</a></td>
                            </tr>
                            {/if} *}
                        </table>
                    </td>
                </tr>
            </table>
            {*
            {if $packagesupgrade}
            <table width="100%" border="0" cellpadding="10" cellspacing="2">
                <tr>
                    <td align="center">
                        <a class='btn btn-default' href="{$cancelCertificateLink}" target="_blank" style="padding:10px; margin-top:15px;">Cancel Certificate</a>
                    </td>
                </tr>
            </table>
            {/if} *}
        </div>
    {/if}

    <form method="post" action="{$smarty.server.PHP_SELF}?action=productdetails" align="center">
        <input type="hidden" name="id" value="{$serviceId}" />
        <p><input type="submit" value="{$LANG.invoicesbacktoclientarea}" class="btn btn-primary"/></p>
    </form>
</div>
