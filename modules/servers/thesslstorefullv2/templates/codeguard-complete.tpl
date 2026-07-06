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
        <div class="alert alert-success text-center">
            {$codeGuardCompleteInstruction}
        </div>
    {/if}
    <form method="post" action="{$smarty.server.PHP_SELF}?action=productdetails">
        <input type="hidden" name="id" value="{$serviceId}" />
        <p><input type="submit" value="{$LANG.invoicesbacktoclientarea}" class="btn btn-primary"/></p>
    </form>
</div>