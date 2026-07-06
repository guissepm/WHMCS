<style>
    .sslgen{
        text-align: left;
    }
    #Primary_Sidebar-Service_Details_Overview-Information,#Primary_Sidebar-Service_Details_Overview-Addons{
        display: none;
    }
</style>
<div class="sslgen">
    {if $errormessage neq ""}
        <div class="alert alert-danger text-center">
            <strong>{$LANG.clientareaerrors}</strong>
            <ul>
                {$errormessage}
            </ul>
        </div>
    {else}
        {if $sslCompleteInstruction neq ""}
            {$sslCompleteInstruction}
        {else}
            <div class="alert alert-success text-center">
                {$LANG.sslConfigCompleteMessage}
            </div>
        {/if}

        <div class="ssltbldtl">
            <table width="100%">
                <thead>
                    <tr>
                        <th colspan="3" style="text-align: center;font-size: 18px;"><strong>Authentication Status</strong></th>
                    </tr>
                    {foreach from=$validationMethodData key=domainName item=authData}

                        {if $authData.method eq 'HTTP' || $authData.method eq 'HTTPS' || $authData.method eq 'FILE'}
                            <tr class="ssltblttl">
                                <td colspan="2"><strong>{preg_replace("/^(.*\.)?([^.]*\..*)$/", "$2", $domainName)}</strong></td>
                                <td>
                                    <form method="post">
                                        <input type="hidden" name="filename" id="filename" value="{$authData.fileName}">
                                        <input type="hidden" name="content" id="content" value="{$authData.fileContent}">
                                        <input type="submit" class="btn btn-default" name="downloadauthfile" value="Download Authfile">
                                    </form>
                                </td>
                            </tr>
                            <tr>
                                <td>Pending File Verification @ URL:</td>
                                <td colspan="2"><a target="_blank" href="{$authData.fileURL}">{$authData.fileURL}</a></td>
                            </tr>
                        {elseif $authData.method eq 'CNAME'}
                            <tr class="ssltblttl">
                                <td colspan="3"><strong>{preg_replace("/^(.*\.)?([^.]*\..*)$/", "$2", $domainName)}</strong></td>
                            </tr>
                            <tr>
                                <td width="25%">Create CNAME Alias/Host Name</td>
                                <td colspan="2">{$authData.alias}</td>
                            </tr>
                            <tr>
                                <td width="25%">Point To</td>
                                <td colspan="2" style="word-break: break-all;">{$authData.pointTo}</td>
                            </tr>
                        {elseif $authData.method eq 'DNS'}
                            <tr class="ssltblttl">
                                <td colspan="3"><strong>{preg_replace("/^(.*\.)?([^.]*\..*)$/", "$2", $domainName)}</strong></td>
                            </tr>
                            <tr>
                                <td width="25%">Create TXT Record</td>
                                <td colspan="2">{$authData.alias}</td>
                            </tr>
                            <tr>
                                <td width="25%">Value</td>
                                <td colspan="2" style="word-break: break-all;">{$authData.pointTo}</td>
                            </tr>
                        {else}
                            <tr class="ssltblttl">
                                <td colspan="3"><strong>{preg_replace("/^(.*\.)?([^.]*\..*)$/", "$2", $domainName)}</strong></td>
                            </tr>
                            <tr>
                                <td>Pending Approval @ Email</td>
                                <td>{$authData.email}</td>
                                <td width="25%">
                                    <a class="btn btn-default" style="width: 100%; margin-bottom: 5px;" href="{$changeApproverLink}">{$LANG.change_approver_method}</a>
                                    <form method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}">
                                        <input type="hidden" name="id" value="{$serviceId}" />
                                        <input type="hidden" name="domain" value="{$domainName}" />
                                        <input type="hidden" name="modop" value="custom" />
                                        <input type="hidden" name="a" value="resendemail" />
                                        <input type="submit" class="btn btn-default" style="width: 100%;" value="{$LANG.resend_approver_email}" />
                                    </form>
                                </td>
                            </tr>
                        {/if}
                    {/foreach}

                </thead>
            </table>
        </div>
    {/if}
   <br/>
   {if $errormessage}
   <form method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=steptwo&redirect=prevalidation">
        <input type="hidden" name="id" value="{$serviceId}" />
        <input type="hidden" name="sslid" value="{$sslid}" />
        <p><input type="submit" value="Back to validation" class="btn btn-primary"/></p>
    </form>
   {else}
   <form method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}">
        <input type="hidden" name="id" value="{$serviceId}" />
        <p><input type="submit" value="{$LANG.invoicesbacktoclientarea}" class="btn btn-primary"/></p>
    </form>
   {/if}
    
</div>