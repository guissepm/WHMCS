<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.min.js"></script>
<style>
    label.error{
        color: red;
        font-weight: normal;
        margin-top: 5px;
    }
    table tr{
        border-bottom: 1pt solid #dddddd;
    }
    table tr td{
        padding: 8px;
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

{if $minorStatus eq "ADD_SITE_COMPLETED"}
    <h2>{$LANG.cWatchUpgradeLicenseTitle} - {$productName}</h2>
    {foreach from=$upgradableProducts item=upgradableProduct}
        <form method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$serviceId}&page=upgrade-license">
            <input type="hidden" name="sslid" value="{$sslOrderId}">
            <input type="hidden" name="pid" value="{$upgradableProduct['pid']}">
            <table width="100%">
                <tbody>
                    <tr>
                        <td width="70%">
                           <strong>{$upgradableProduct['name']}</strong>
                            <br>
                            {$upgradableProduct['description']}
                        </td>
                        <td width="30%">
                            <div class="form-group">
                                <select name="billingcycle" class="form-control">
                                    {foreach from=$upgradableProduct['pricing'] key=billingterm item=price}
                                        <option value="{$billingterm}">{$upgradableProduct['prefix']} {$price} {$upgradableProduct['suffix']} {$billingterm|ucfirst}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <input type="submit" value="{$LANG.cWatchUpgradeLicensebtn}" class="btn btn-primary btn-block btnupgrade" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    {/foreach}
    <br>
    <p class="form-group">
        <a class="btn btn-primary" href="clientarea.php?action=productdetails&id={$serviceId}">{$LANG.backtoservicedetails}</a>
    </p>

{else}
    <div class="alert alert-info">
        {$LANG.sslnoconfigurationpossible}
    </div>
    <form method="post" action="clientarea.php?action=productdetails">
        <input type="hidden" name="id" value="{$serviceid}" />
        <p>
            <input type="submit" value="{$LANG.invoicesbacktoclientarea}" class="btn btn-primary"/>
        </p>
    </form>
{/if}
<script type="text/javascript">
    $(document).ready(function(){
        $('.btnupgrade').click(function () {
            return confirm("This will upgrade your product and charge!");
        })
    })
</script>