<div class="ssl-certificates-list">
    
    <!-- Page Header -->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">
                <i class="fas fa-lock"></i> My SSL Certificates
            </h3>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-4">
                    <div class="stats-box">
                        <div class="stats-number">{$total_orders}</div>
                        <div class="stats-label">Total Certificates</div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="stats-box">
                        <div class="stats-number text-success">{$active_orders}</div>
                        <div class="stats-label">Active</div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="stats-box">
                        <div class="stats-number text-warning">{$pending_orders}</div>
                        <div class="stats-label">Pending</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    {if $orders|@count > 0}
        
        <!-- Orders Table -->
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">Certificate Orders</h4>
            </div>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Domain</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Expires</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$orders item=order}
                        <tr>
                            <td>
                                <strong>{$order.domain}</strong>
                                {if $order.is_wildcard}
                                    <span class="badge badge-info">Wildcard</span>
                                {/if}
                            </td>
                            <td>
                                <span class="badge badge-secondary">{$order.cert_type}</span>
                            </td>
                            <td>
                                <span class="badge badge-{$order.status_badge.color}">
                                    <i class="fas fa-{$order.status_badge.icon}"></i> {$order.status_badge.text}
                                </span>
                            </td>
                            <td>
                                {if $order.cert_expiry}
                                    {$order.cert_expiry|date_format:"%b %e, %Y"}
                                    {if $order.days_remaining !== null}
                                        <br>
                                        <small class="text-{if $order.days_remaining < 30}danger{else}muted{/if}">
                                            ({$order.days_remaining} days)
                                        </small>
                                    {/if}
                                {else}
                                    <span class="text-muted">Not issued</span>
                                {/if}
                            </td>
                            <td>{$order.created_at|date_format:"%b %e, %Y"}</td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <a href="index.php?m=sslstore&action=view&order_id={$order.id}" 
                                       class="btn btn-default" title="View Details">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    {if $order.can_download}
                                        <a href="index.php?m=sslstore&action=download_certificate&order_id={$order.id}" 
                                           class="btn btn-success" title="Download Certificate">
                                            <i class="fas fa-download"></i>
                                        </a>
                                    {/if}
                                </div>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
        
    {else}
        
        <!-- No Orders -->
        <div class="alert alert-info text-center">
            <i class="fas fa-info-circle fa-3x mb-3"></i>
            <h4>No SSL Certificates Found</h4>
            <p>You don't have any SSL certificates yet.</p>
            <a href="index.php?rp=/store/ssl-certificates" class="btn btn-primary">
                <i class="fas fa-shopping-cart"></i> Order SSL Certificate
            </a>
        </div>
        
    {/if}
    
    <!-- Help Section -->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">
                <i class="fas fa-question-circle"></i> Need Help?
            </h4>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-4">
                    <h5><i class="fas fa-clock text-warning"></i> Pending Validation</h5>
                    <p>Your certificate is awaiting domain validation. This typically takes 2-24 hours. Check your email for validation instructions.</p>
                </div>
                <div class="col-md-4">
                    <h5><i class="fas fa-download text-success"></i> Download Certificate</h5>
                    <p>Once issued, you can download your certificate files for installation on other servers or applications.</p>
                </div>
                <div class="col-md-4">
                    <h5><i class="fas fa-life-ring text-info"></i> Support</h5>
                    <p>Having issues? <a href="submitticket.php">Contact our support team</a> and we'll be happy to help.</p>
                </div>
            </div>
        </div>
    </div>
    
</div>

<style>
.ssl-certificates-list {
    padding: 20px 0;
}

.stats-box {
    text-align: center;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 8px;
    margin-bottom: 10px;
}

.stats-number {
    font-size: 2.5em;
    font-weight: bold;
    color: #333;
}

.stats-label {
    color: #666;
    font-size: 0.9em;
    text-transform: uppercase;
}

.badge {
    font-size: 0.85em;
    padding: 5px 10px;
}

.btn-group-sm .btn {
    padding: 3px 8px;
}

.panel {
    margin-bottom: 20px;
}

.table > tbody > tr > td {
    vertical-align: middle;
}
</style>
