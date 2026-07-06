<?php

/**
 * Created by VSCode.
 * User: ravi.vaghasiya
 * Date: 30-07-2024
 * Time: 11:11
 */

// Include the necessary WHMCS configuration
require_once __DIR__ . '/../../../init.php';
require_once __DIR__ . '/../../../includes/functions.php';

// Start the session if not already started
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Check if the user is authenticated
if ((!isset($_SESSION['adminid']) || !$_SESSION['adminid']) && (isset($_GET['cron_run']) || $_GET['cron_run'] == "manually")) {
    die("Access Denied: Please log in.");
}
use Illuminate\Database\Capsule\Manager as Capsule;

require_once dirname(__FILE__) . '/common.php';
require_once dirname(__FILE__) . '/sslstoreapiv2.php';
require_once dirname(__FILE__) . '/../../servers/thesslstorefullv2/cpanel_api.php';
logActivity("TSS Cron started at: " . date('Y/m/d H:i:s'));
echo "TSS Cron started\n";

class tss_cron
{

    private $partnerCode = '';
    private $authToken = '';
    private $apiMode = '';

    public function run()
    {
        $this->getToken();
        //get cron list
        try {
            $tblCronsData = Capsule::table('mod_sslstore_crons')
                ->get();
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
        }
        if(isset($_GET['cron_run']) && $_GET['cron_run'] == "manually") {
            $this->order_sync();
        }
        foreach ($tblCronsData as $cron) {

            if ($cron->interval > 0) {
                $currDate = date('Y-m-d', strtotime(changeTimeZone('now')));
                $last_run_cron = date('Y-m-d', strtotime($cron->last_run));
               
                if ((strtotime($cron->last_run) + (($cron->interval - 10) * 60)) <= strtotime("now")) {
                    //Run the cron
                    if ($cron->cron_key == 'order_sync') {
                        $this->order_sync();
                    } elseif ($cron->cron_key == 'expiration_reminder_email') {
                        $this->expiration_reminder_email();
                    } elseif ($cron->cron_key == 'product_sync') {
                        $this->product_sync();
                    } elseif ($cron->cron_key == 'place_imported_order') {
                        $this->place_imported_order();
                    } elseif ($cron->cron_key == 'auto_install_ssl_on_renewal') {
                        $this->auto_install_ssl_on_renew();
                    } elseif ($cron->cron_key == 'comodo_reissue_reminder') {
                        $this->comodo_reissue_reminder();
                    } elseif ($cron->cron_key == 'digicert_reissue_reminder') {
                        $this->digicert_reissue_reminder();
                    } elseif ($cron->cron_key == 'activities_module_logs_clean') {
                        $this->activities_module_logs_clean();
                    }
                }
            }
        }
    }
    private function getToken()
    {
        if (tss_get_config_option('api_mode') == 'LIVE') {
            $this->partnerCode = tss_get_config_option('live_partner_code');
            $this->authToken = tss_get_config_option('live_auth_token');
            $this->apiMode = sslstorev2::$API_MODE_LIVE;
        } else {
            $this->partnerCode = tss_get_config_option('test_partner_code');
            $this->authToken = tss_get_config_option('test_auth_token');
            $this->apiMode = sslstorev2::$API_MODE_TEST;
        }
    }

    private function order_sync()
    {
        $num_orders_updated = 0;
        $sslApi = new sslstorev2($this->partnerCode, $this->authToken, $this->apiMode);

        $orderQueryReq = new order_query_requestv2();
        $before2monthsDate = (strtotime(date('m/d/Y', strtotime('-2 month')) . "00:00:00 GMT")) * 1000;
        $orderQueryReq->StartDate = "/Date($before2monthsDate)/";
        $todaysDate = (strtotime(date("m/d/Y") . "00:00:00 GMT")) * 1000;
        $orderQueryReq->EndDate = "/Date($todaysDate)/";
        $orderQueryResp = $sslApi->order_query($orderQueryReq);

        $orderQueryRespLog = json_encode($orderQueryResp);

        foreach ($orderQueryResp as $order) {

            if(checkTheSSLStoreModule(0,$order->TheSSLStoreOrderID)){

                /******************************** Update nextduedate in tblhosting based on the certificate expiration date on thesslstore ************************/
                    $iscWatchProduct = false;

                    try {
                        $tblSSlOrderData =  Capsule::table('tblsslorders')
                            ->where('remoteid', '=', $order->TheSSLStoreOrderID)
                            ->where('module', '=', 'thesslstorefullv2')
                            ->first();
					//logActivity("1 tss_cron file func order_sync tblSSlOrderData, ".json_encode($tblSSlOrderData,true));

                    } catch (\Exception $e) {
                        logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
                    }

                    $num_orders_updated++;

                    $domain = (($iscWatchProduct) ? $order->DomainName : (!empty($order->CommonName) ? $order->CommonName : $order->ApproverEmail));
                    if (!empty($domain)) {
                        try {
                            Capsule::table('tblhosting')
                                ->where('id', '=', $tblSSlOrderData->serviceid)
                                ->update(['domain' => $domain]);
                            $tblhostingData =  Capsule::table('tblhosting')
                            ->where('id', '=', $tblSSlOrderData->serviceid)
                            ->first();
								//logActivity("2 tss_cron file func order_sync before updating tblhosting data ,".json_encode($tblhostingData,true));
                        } catch (\Exception $e) {
                            logActivity("TheSSLStore Module Log|update, {$e->getMessage()}");
                        }
                    }

                    //Get The value of the option "no_of_days_prior_to_expirationdate"
                    $noOfDaysPriorToExpirationDate = 0;
                    $noOfDaysPriorToExpirationDate = tss_get_config_option('no_of_days_prior_to_expirationdate');

                    if (strtoupper($order->OrderStatus->MajorStatus) == 'ACTIVE') {
                        if ($iscWatchProduct) {
                            $CertificateEndDate = date('Y-m-d', strtotime(changeTimeZone($order->LicenseEndDate)));
                            
                            if ($order->Validity != '1') {
                                $CertificateEndDate = date('Y-m-d', strtotime(changeTimeZone($CertificateEndDate) . '-' . $noOfDaysPriorToExpirationDate . ' days'));
                                //logActivity("3 tss cron file order_sync func iscWatchProduct order->Validity !=1 certificated end date, $CertificateEndDate");
                            }
                        } else {
                            $CertificateEndDate = date('Y-m-d', strtotime(changeTimeZone($order->CertificateEndDateInUTC)));
                            if (!empty(changeTimeZone($order->OrderExpiryDateInUTC)) && (strtotime(changeTimeZone($order->OrderExpiryDateInUTC)) >= strtotime(changeTimeZone($order->CertificateEndDateInUTC))) && $order->OrderExpiryDate != '01-01-1900 00:00:00') {
                                $CertificateEndDate = date('Y-m-d', strtotime(changeTimeZone($order->OrderExpiryDateInUTC)));
								//logActivity("4 tss cron file order_sync func certificated end date, $CertificateEndDate");
                            }
                            $CertificateEndDate = date('Y-m-d', strtotime(changeTimeZone($CertificateEndDate) . '-' . $noOfDaysPriorToExpirationDate . ' days'));
                            //logActivity("5 tss cron file order_sync func certificated end date, $CertificateEndDate");
                        }
                        if($noOfDaysPriorToExpirationDate > 0) {
                            Capsule::table('tblhosting')
                                ->where('id', '=', $tblSSlOrderData->serviceid)
                                ->whereNotIn('billingcycle', ['One Time', 'Free Account'])
                                ->update(['nextduedate' => $CertificateEndDate, 'nextinvoicedate' => $CertificateEndDate]);
                                //logActivity("6 tss cron file order_sync func noOfDaysPriorToExpirationDate > 0 after update duedate, $CertificateEndDate");
                        }
                        //if (CheckInvoiceCreateDate($order->TheSSLStoreOrderID)) {
                            try {
                                if (isset($tblSSlOrderData->addon_id) && $tblSSlOrderData->addon_id > 0) {
                                    Capsule::table('tblhostingaddons')
                                        ->where('id', '=', $tblSSlOrderData->addon_id)
                                        ->whereNotIn('billingcycle', ['One Time', 'Free Account'])
                                        ->update(['nextduedate' => $CertificateEndDate, 'nextinvoicedate' => $CertificateEndDate]);
									//logActivity("7 tss cron file order_sync func CertificateEndDate, $CertificateEndDate");
                                } else {
                                    Capsule::table('tblhosting')
                                        ->where('id', '=', $tblSSlOrderData->serviceid)
                                        ->whereNotIn('billingcycle', ['One Time', 'Free Account'])
                                        ->update(['nextduedate' => $CertificateEndDate, 'nextinvoicedate' => $CertificateEndDate]);
                                        //logActivity("8 tss cron file order_sync func after update duedate, $CertificateEndDate");
                                }
                            } catch (\Exception $e) {
                                logActivity("TheSSLStore Module Log|update, {$e->getMessage()}");
                            }
                        //}
                    }

                    //update common name and order status in mod_sslstore_orders_data table for reporting purpose
                    if (isset($order->OrderStatus->MajorStatus) && !empty($order->OrderStatus->MajorStatus)) {
                        $update_fields = array();

                        if (!empty($order->VendorOrderID)) {
                            $update_fields['vendor_order_id'] = $order->VendorOrderID;
                        }

                        if ($iscWatchProduct && !empty($order->DomainName)) {
                            $update_fields['common_name'] = $order->DomainName;
                        } elseif (!empty($order->CommonName)) {
                            $update_fields['common_name'] = $order->CommonName;
                        }

                        //if (CheckInvoiceCreateDate($order->TheSSLStoreOrderID)) {
                            $update_fields['order_expiration_date'] = date('Y-m-d H:i:s', strtotime(changeTimeZone($order->CertificateEndDateInUTC)));
                            if (!empty(changeTimeZone($order->OrderExpiryDateInUTC)) && (strtotime(changeTimeZone($order->OrderExpiryDateInUTC)) >= strtotime(changeTimeZone($order->CertificateEndDateINUTC))) && $order->OrderExpiryDate != '01-01-1900 00:00:00') {
                                $update_fields['order_expiration_date'] = date('Y-m-d H:i:s', strtotime(changeTimeZone($order->OrderExpiryDateInUTC)));
								//logActivity("9 tss cron file order_sync func order OrderStatus certificated end date {$CertificateEndDate}".$update_fields['order_expiration_date']);
                            }
                        //}

                        if (strtolower($order->OrderStatus->MajorStatus) == 'active') {
                            $update_fields['ssl_status'] = 'active';
                            if ($iscWatchProduct) {
                                if (!empty($order->LicenseStartDate)) {
                                    $update_fields['start_date'] = date('Y-m-d H:i:s', strtotime(changeTimeZone($order->LicenseStartDate)));
                                }
                                //if (CheckInvoiceCreateDate($order->TheSSLStoreOrderID)) {
                                    if (!empty($order->LicenseEndDate)) {
                                        $update_fields['expiration_date'] = date('Y-m-d H:i:s', strtotime(changeTimeZone($order->LicenseEndDate)));
										//logActivity("10 tss cron file order_sync func order OrderStatus MajorStatus Active CheckInvoiceCreateDate certificated expiration_date", $update_fields['expiration_date'] , $CertificateEndDate);
                                    }
                                //}
                            } else {
                                if (!empty($order->CertificateStartDateInUTC)) {
                                    $update_fields['start_date'] = date('Y-m-d H:i:s', strtotime(changeTimeZone($order->CertificateStartDateInUTC)));
									//logActivity("11 tss cron file order_sync func order CertificateStartDateInUTC start_date {$update_fields['start_date']}". $CertificateEndDate);
                                }

                                $update_fields['expiration_date'] = date('Y-m-d H:i:s', strtotime(changeTimeZone($order->CertificateEndDateInUTC)));
                            if (!empty(changeTimeZone($order->OrderExpiryDateInUTC)) && (strtotime(changeTimeZone($order->OrderExpiryDateInUTC)) >= strtotime(changeTimeZone($order->CertificateEndDateINUTC))) && $order->OrderExpiryDate != '01-01-1900 00:00:00') {
                                $update_fields['expiration_date'] = date('Y-m-d H:i:s', strtotime(changeTimeZone($order->OrderExpiryDateInUTC)));
								//logActivity("12 tss cron file order_sync func order OrderStatus certificated end date {$CertificateEndDate}". $update_fields['expiration_date']);
                            }

                            }
                        } elseif (strtolower($order->OrderStatus->MajorStatus) == 'cancelled') {
                            $update_fields['ssl_status'] = 'cancelled';
                        }

                        if ($order->OrderAmount > 0) {
                            $update_fields['purchase_amt'] = $order->OrderAmount;
                        }

                        if (!empty($update_fields)) {
                            try {
                                Capsule::table('mod_sslstore_orders_data')
                                    ->where('store_order_id', '=', $order->TheSSLStoreOrderID)
                                    ->update($update_fields);
                            } catch (\Exception $e) {
                                logActivity("TheSSLStore Module Log|update, {$e->getMessage()}");
                            }
                        }
                    }
            }

        }
        try {
            Capsule::table('mod_sslstore_crons')
                ->where('cron_key', 'order_sync')
                ->update(['last_run' => date('Y-m-d H:i:s')]);
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log| cron, {$e->getMessage()}");
        }
    }

    private function expiration_reminder_email()
    {
        global $CONFIG;

        $num_reminders_sent = 0;
        if (tss_get_config_option('send_expiration_reminder_email')) {

            //get web security product codes like cwatch, codeguard
            $webSecurityProductCodes = array();
            try {
                $webSecurityProductCodesData = Capsule::table('mod_sslstore_product_data')
                    ->select('product_code')
                    ->where('vendor_name', '=', 'CWATCH')
                    ->orWhere('vendor_name', '=', 'CODEGUARD')
                    ->get();

                foreach ($webSecurityProductCodesData as $key => $code) {
                    $webSecurityProductCodes[] = $code->product_code;
                }
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
            }

            //get default setting for invoice generation days from WHMCS (Setup > Automation Settings)
            //get Invoice created settings from WHMCS
            $createInvoiceDaysBefore = (!empty($CONFIG['CreateInvoiceDaysBefore']) ? $CONFIG['CreateInvoiceDaysBefore'] : 0);

            //get expiration reminder days for SSL product from TSS setting
            $expirationReminderEmailDaysForSSL = tss_get_config_option('expiration_reminder_email_days', 0);

            $monthlyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeMonthly']) || $CONFIG['CreateInvoiceDaysBeforeMonthly'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeMonthly'] + $expirationReminderEmailDaysForSSL) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForSSL));
            $quarterlyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeQuarterly']) || $CONFIG['CreateInvoiceDaysBeforeQuarterly'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeQuarterly'] + $expirationReminderEmailDaysForSSL) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForSSL));
            $semiAnnuallyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeSemiAnnually']) || $CONFIG['CreateInvoiceDaysBeforeSemiAnnually'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeSemiAnnually'] + $expirationReminderEmailDaysForSSL) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForSSL));
            $annuallyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeAnnually']) || $CONFIG['CreateInvoiceDaysBeforeAnnually'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeAnnually'] + $expirationReminderEmailDaysForSSL) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForSSL));
            $bienniallyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeBiennially']) || $CONFIG['CreateInvoiceDaysBeforeBiennially'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeBiennially'] + $expirationReminderEmailDaysForSSL) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForSSL));
            $trienniallyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeTriennially']) || $CONFIG['CreateInvoiceDaysBeforeTriennially'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeTriennially'] + $expirationReminderEmailDaysForSSL) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForSSL));

            try {
                $reminder_orders = Capsule::table('tblhosting')
                    ->select('tblhosting.id', 'tblhosting.billingcycle', 'mod_sslstore_orders_data.expiration_date')
                    ->join('tblsslorders', 'tblsslorders.serviceid', '=', 'tblhosting.id')
                    ->join('mod_sslstore_orders_data', 'mod_sslstore_orders_data.service_id', '=', 'tblhosting.id')
                    ->where('tblsslorders.module', '=', 'thesslstorefullv2')
                    ->where('mod_sslstore_orders_data.ssl_status', '=', 'active')
                    ->where('mod_sslstore_orders_data.expiration_date', '>=', Capsule::raw("now()"))
                    ->where(function ($query) use ($monthlyReminderDays, $quarterlyReminderDays, $semiAnnuallyReminderDays, $annuallyReminderDays, $bienniallyReminderDays, $trienniallyReminderDays, $webSecurityProductCodes) {

                        $query->orwhere(function ($queryOr) use ($monthlyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $monthlyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Monthly')
                                ->whereNotIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });

                        $query->orwhere(function ($queryOr) use ($quarterlyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $quarterlyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Quarterly')
                                ->whereNotIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });

                        $query->orwhere(function ($queryOr) use ($semiAnnuallyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $semiAnnuallyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Semi-Annually')
                                ->whereNotIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });

                        $query->orwhere(function ($queryOr) use ($annuallyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $annuallyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Annually')
                                ->whereNotIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });

                        $query->orwhere(function ($queryOr) use ($bienniallyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $bienniallyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Biennially')
                                ->whereNotIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });

                        $query->orwhere(function ($queryOr) use ($trienniallyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $trienniallyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Triennially')
                                ->whereNotIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });
                    })
                    ->where(function ($query) {
                        $query->where('tblhosting.domainstatus', '=', 'Active')
                            ->orwhere('tblhosting.domainstatus', '=', 'Suspended');
                    })
                    ->get();
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
            }
            foreach ($reminder_orders as $row) {
                $reminder_days = round((strtotime(changeTimeZone($row->expiration_date, 'Y-m-d')) - time()) / (60 * 60 * 24)); //minute * second * hour

                // Send e-mail using WHMCS sendmessage() function
                $sslconfigurationlink = $CONFIG['SystemURL'] . '/clientarea.php?action=productdetails&id=' . $row->id;
                $sslconfigurationlink = '<a href="' . $sslconfigurationlink . '">' . $sslconfigurationlink . '</a>';
                sendmessage('Your SSL Certificate - Expiration Reminder Email', $row->id, array('reminder_days' => $reminder_days, 'sslconfigurationlink' => $sslconfigurationlink));
                $num_reminders_sent++;
            }

            //send expiration reminder email for web security product like cwatch, code guard etc.
            //get expiration reminder days for Web Security product from TSS setting
            $expirationReminderEmailDaysForWebSecurity = tss_get_config_option('expiration_reminder_email_days_for_web_security', 0);

            $monthlyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeMonthly']) || $CONFIG['CreateInvoiceDaysBeforeMonthly'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeMonthly'] + $expirationReminderEmailDaysForWebSecurity) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForWebSecurity));
            $quarterlyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeQuarterly']) || $CONFIG['CreateInvoiceDaysBeforeQuarterly'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeQuarterly'] + $expirationReminderEmailDaysForWebSecurity) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForWebSecurity));
            $semiAnnuallyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeSemiAnnually']) || $CONFIG['CreateInvoiceDaysBeforeSemiAnnually'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeSemiAnnually'] + $expirationReminderEmailDaysForWebSecurity) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForWebSecurity));
            $annuallyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeAnnually']) || $CONFIG['CreateInvoiceDaysBeforeAnnually'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeAnnually'] + $expirationReminderEmailDaysForWebSecurity) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForWebSecurity));
            $bienniallyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeBiennially']) || $CONFIG['CreateInvoiceDaysBeforeBiennially'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeBiennially'] + $expirationReminderEmailDaysForWebSecurity) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForWebSecurity));
            $trienniallyReminderDays = ((!empty($CONFIG['CreateInvoiceDaysBeforeTriennially']) || $CONFIG['CreateInvoiceDaysBeforeTriennially'] === '0') ? ($CONFIG['CreateInvoiceDaysBeforeTriennially'] + $expirationReminderEmailDaysForWebSecurity) : ($createInvoiceDaysBefore + $expirationReminderEmailDaysForWebSecurity));

            try {
                $reminder_orders = Capsule::table('tblhosting')
                    ->select('tblhosting.id', 'tblhosting.billingcycle', 'mod_sslstore_orders_data.expiration_date')
                    ->join('tblsslorders', 'tblsslorders.serviceid', '=', 'tblhosting.id')
                    ->join('mod_sslstore_orders_data', 'mod_sslstore_orders_data.service_id', '=', 'tblhosting.id')
                    ->where('tblsslorders.module', '=', 'thesslstorefullv2')
                    ->where('mod_sslstore_orders_data.ssl_status', '=', 'active')
                    ->where('mod_sslstore_orders_data.expiration_date', '>=', Capsule::raw("now()"))
                    ->where(function ($query) use ($monthlyReminderDays, $quarterlyReminderDays, $semiAnnuallyReminderDays, $annuallyReminderDays, $bienniallyReminderDays, $trienniallyReminderDays, $webSecurityProductCodes) {

                        $query->orwhere(function ($queryOr) use ($monthlyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $monthlyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Monthly')
                                ->whereIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });

                        $query->orwhere(function ($queryOr) use ($quarterlyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $quarterlyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Quarterly')
                                ->whereIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });

                        $query->orwhere(function ($queryOr) use ($semiAnnuallyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $semiAnnuallyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Semi-Annually')
                                ->whereIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });

                        $query->orwhere(function ($queryOr) use ($annuallyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $annuallyReminderDays)
                                ->where('tblhosting.billingcycle',   '=', 'Annually')
                                ->whereIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });

                        $query->orwhere(function ($queryOr) use ($bienniallyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $bienniallyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Biennially')
                                ->whereIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });

                        $query->orwhere(function ($queryOr) use ($trienniallyReminderDays, $webSecurityProductCodes) {
                            $queryOr->orwhere(Capsule::raw("DATEDIFF(nextduedate,now())"), '=', $trienniallyReminderDays)
                                ->where('tblhosting.billingcycle', '=', 'Triennially')
                                ->whereIn('mod_sslstore_orders_data.product_code', $webSecurityProductCodes);
                        });
                    })
                    ->where(function ($query) {
                        $query->where('tblhosting.domainstatus', '=', 'Active')
                            ->orwhere('tblhosting.domainstatus', '=', 'Suspended');
                    })
                    ->get();
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
            }
            foreach ($reminder_orders as $row) {
                $reminder_days = round((strtotime(changeTimeZone($row->expiration_date, 'Y-m-d')) - time()) / (60 * 60 * 24));

                // Send e-mail using WHMCS sendmessage() function
                $sslconfigurationlink = $CONFIG['SystemURL'] . '/clientarea.php?action=productdetails&id=' . $row->id;
                $sslconfigurationlink = '<a href="' . $sslconfigurationlink . '">' . $sslconfigurationlink . '</a>';
                sendmessage('Your Web Security Order - Expiration Reminder Email', $row->id, array('reminder_days' => $reminder_days, 'sslconfigurationlink' => $sslconfigurationlink));
                $num_reminders_sent++;
            }

            //send expiration email for addon products
            if (tss_is_whmcs_support_addon()) {
                try {
                    $reminder_orders = Capsule::table('tblhostingaddons')
                        ->select('tblhostingaddons.id', 'tblhostingaddons.addonid', 'tblhostingaddons.billingcycle', 'tblhostingaddons.hostingid')
                        ->join('tblsslorders', 'tblsslorders.addon_id', '=',  'tblhostingaddons.id')
                        ->where(Capsule::raw("DATEDIFF(tblhostingaddons.nextduedate,now())"), '=', ($createInvoiceDaysBefore + $expirationReminderEmailDaysForSSL))
                        ->where('tblsslorders.module', '=', 'thesslstorefullv2')
                        ->get();

                    $reminder_order = json_encode($reminder_orders);

                    //logActivity("TheSSLStore Module Log|tss_is_whmcs_support_addon, {$reminder_order}");
                } catch (\Exception $e) {
                    logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
                }
                foreach ($reminder_orders as $row) {
                    $reminder_days = 30 + $createInvoiceDaysBefore + $expirationReminderEmailDaysForSSL;
                    // Send e-mail using WHMCS sendmessage() function
                    $sslconfigurationlink = $CONFIG['SystemURL'] . '/clientarea.php?action=productdetails&id=' . $row->hostingid;
                    $sslconfigurationlink = '<a href="' . $sslconfigurationlink . '">' . $sslconfigurationlink . '</a>';
                    sendmessage('Your SSL Certificate - Expiration Reminder Email Addon', $row->hostingid, array('reminder_days' => $reminder_days, 'sslconfigurationlink' => $sslconfigurationlink));
                    $num_reminders_sent++;
                }
            }
        }
       // logActivity("$num_reminders_sent expiration reminder emails sent!");

        try {
            Capsule::table('mod_sslstore_crons')
                ->where('cron_key', 'expiration_reminder_email')
                ->update(['last_run' => date('Y-m-d H:i:s')]);
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log| cron, {$e->getMessage()}");
        }
    }

    
    private function product_sync()
    {

        logActivity("THESSLSTORE | Run Product Sync cron");

        try {
            $row = Capsule::table('tbladmins')
                ->first();

            $admin_user = $row->username;
            $admin_id = $row->id;
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
        }

        //get Settings
        try {
            $tblSettings = Capsule::table('mod_sslstore_settings_v2')
                ->first();
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
        }

        $product_sync_setting = $tblSettings->product_sync_setting;
        $profit_margin = $tblSettings->profit_margin;
        $product_group = $tblSettings->product_group;
        $currency_id = $tblSettings->currency_code;

        $sync_now = false;
        $alteration_log = '';
        $need_to_manual_alter = false;
        if ($tblSettings->product_sync_setting == 'only_alteration' || $tblSettings->product_sync_setting == 'alteration_and_removal' || $tblSettings->product_sync_setting == 'all') {
            $sync_now = true;
        }

        $ssl_api = new sslstorev2($this->partnerCode, $this->authToken, $this->apiMode);

        //get products from WHMCS
        try {
            $result = Capsule::table('tblproducts')
                ->select(
                    'tblproducts.id as pid',
                    'tblproducts.name',
                    'tblproductgroups.name as group_name',
                    'tblproducts.configoption1',
                    'tblproducts.hidden as prd_hidden',
                    'tblproducts.paytype',
                    'tblproductconfigoptions.id as opt_id',
                    'tblproductconfigoptions.optionname',
                    'tblproductconfigoptions.optiontype',
                    'tblproductconfigoptions.qtymaximum',
                    'tblproductconfigoptions.hidden as opt_hidden',
                    'tblpricing.currency',
                    'tblpricing.monthly',
                    'tblpricing.quarterly',
                    'tblpricing.semiannually',
                    'tblpricing.annually',
                    'tblpricing.biennially',
                    'tblpricing.triennially'
                )
                ->leftJoin('tblpricing', 'tblpricing.relid', '=', 'tblproducts.id')
                ->leftJoin('tblproductconfiglinks', 'tblproducts.id', '=', 'tblproductconfiglinks.pid')
                ->leftJoin('tblproductgroups', 'tblproducts.gid', '=', 'tblproductgroups.id')
                ->leftJoin('tblproductconfigoptions', 'tblproductconfiglinks.gid', '=', 'tblproductconfigoptions.gid')
                ->where('tblproducts.servertype', '=', 'thesslstorefullv2')
                ->where('tblpricing.type', '=', 'product')
                ->orderBy('tblproducts.id', 'asc')
                ->get();
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
        }

        $whmcs_products = array();
        $new_products = array();
        $discontinued_products = array();

        foreach ($result as $row) {
            $whmcs_products[$row->pid]['pid'] = $row->pid;
            $whmcs_products[$row->pid]['name'] = $row->name;
            $whmcs_products[$row->pid]['group_name'] = $row->group_name;
            $whmcs_products[$row->pid]['code'] = $row->configoption1;
            $whmcs_products[$row->pid]['prd_hidden'] = $row->prd_hidden;
            $whmcs_products[$row->pid]['pricing'][$row->currency]['monthly'] = $row->monthly;
            $whmcs_products[$row->pid]['pricing'][$row->currency]['quarterly'] = $row->quarterly;
            $whmcs_products[$row->pid]['pricing'][$row->currency]['semiannually'] = $row->semiannually;
            $whmcs_products[$row->pid]['pricing'][$row->currency]['annually'] = $row->annually;
            $whmcs_products[$row->pid]['pricing'][$row->currency]['biennially'] = $row->biennially;
            $whmcs_products[$row->pid]['pricing'][$row->currency]['triennially'] = $row->triennially;
            $whmcs_products[$row->pid]['paytype'] = $row->paytype;

            // FIX #1: Guard against null/empty optionname — prevents trim(array) TypeError
            $conf_option_name = '';
            $conf_option_display = '';
            if (!empty($row->optionname) && is_string($row->optionname)) {
                $conf_option_parts   = explode("|", $row->optionname);
                $conf_option_name    = isset($conf_option_parts[0]) ? trim($conf_option_parts[0]) : '';
                $conf_option_display = isset($conf_option_parts[1]) ? trim($conf_option_parts[1]) : $conf_option_name;
            }

            if ($conf_option_name == 'Additional SAN' && $row->opt_hidden == 0) {
                $whmcs_products[$row->pid]['san_option_id'] = $row->opt_id;
                $whmcs_products[$row->pid]['san_option_name'] = $conf_option_display;
                $whmcs_products[$row->pid]['max_san'] = $row->qtymaximum;
                $whmcs_products[$row->pid]['san_option_hidden'] = $row->opt_hidden;

                $getconfigopt = Capsule::table('tblproductconfigoptionssub')
                    ->select('tblproductconfigoptionssub.id as subopt_id')
                    ->where('tblproductconfigoptionssub.configid', '=', $row->opt_id)
                    ->distinct()
                    ->first();

                $whmcs_products[$row->pid]['san_sub_option_id'] = isset($getconfigopt->subopt_id) ? $getconfigopt->subopt_id : null;

            } elseif ($conf_option_name == 'Additional WildCard SAN' && $row->opt_hidden == 0) {
                $whmcs_products[$row->pid]['wildcard_san_option_id'] = $row->opt_id;
                $whmcs_products[$row->pid]['wildcard_san_option_name'] = $conf_option_display;
                $whmcs_products[$row->pid]['max_san'] = $row->qtymaximum;
                $whmcs_products[$row->pid]['wildcard_san_option_hidden'] = $row->opt_hidden;

                $getconfigopt = Capsule::table('tblproductconfigoptionssub')
                    ->select('tblproductconfigoptionssub.id as subopt_id')
                    ->where('tblproductconfigoptionssub.configid', '=', $row->opt_id)
                    ->distinct()
                    ->first();

                $whmcs_products[$row->pid]['wildcard_san_sub_option_id'] = isset($getconfigopt->subopt_id) ? $getconfigopt->subopt_id : null;

            } elseif ($conf_option_name == 'Additional Servers' && $row->opt_hidden == 0) {
                $whmcs_products[$row->pid]['server_option_id'] = $row->opt_id;
                $whmcs_products[$row->pid]['server_option_name'] = $row->optionname;
                $whmcs_products[$row->pid]['max_server'] = $row->qtymaximum;
                $whmcs_products[$row->pid]['server_option_hidden'] = $row->opt_hidden;

                $getconfigopt = Capsule::table('tblproductconfigoptionssub')
                    ->select('tblproductconfigoptionssub.id as subopt_id')
                    ->where('tblproductconfigoptionssub.configid', '=', $row->opt_id)
                    ->distinct()
                    ->first();

                $whmcs_products[$row->pid]['server_sub_option_id'] = isset($getconfigopt->subopt_id) ? $getconfigopt->subopt_id : null;

            } elseif ($conf_option_name == 'CSR Domain' && $row->opt_hidden == 0) {
                $whmcs_products[$row->pid]['main_domain_option_id'] = $row->opt_id;
                $whmcs_products[$row->pid]['main_domain_option_name'] = $row->optionname;
                $whmcs_products[$row->pid]['main_domain_option_hidden'] = $row->opt_hidden;

                $getconfigopt = Capsule::table('tblproductconfigoptionssub')
                    ->select('tblproductconfigoptionssub.id as subopt_id')
                    ->where('tblproductconfigoptionssub.configid', '=', $row->opt_id)
                    ->where('tblproductconfigoptionssub.optionname', 'like', '%Standard%')
                    ->distinct()
                    ->first();

                $whmcs_products[$row->pid]['standard_domain_option_id'] = isset($getconfigopt->subopt_id) ? $getconfigopt->subopt_id : null;

                $getconfigopt = Capsule::table('tblproductconfigoptionssub')
                    ->select('tblproductconfigoptionssub.id as subopt_id')
                    ->where('tblproductconfigoptionssub.configid', '=', $row->opt_id)
                    ->where('tblproductconfigoptionssub.optionname', 'like', '%WildCard%')
                    ->distinct()
                    ->first();

                $whmcs_products[$row->pid]['wildcard_domain_option_id'] = isset($getconfigopt->subopt_id) ? $getconfigopt->subopt_id : null;
            }

            // FIX #2: Separate if (NOT elseif) — product can have BOTH SAN + Token config
            if ($conf_option_name == 'Certificate Delivery Method' && $row->opt_hidden == 0) {
                $whmcs_products[$row->pid]['configid'] = $row->opt_id;
                $whmcs_products[$row->pid]['configName'] = $conf_option_display;
                $whmcs_products[$row->pid]['configType'] = $row->optiontype;
                $whmcs_products[$row->pid]['optionname'] = $row->optionname;

                $getconfigopt = Capsule::table('tblproductconfigoptionssub')
                    ->select('tblproductconfigoptionssub.id as subopt_id')
                    ->where('tblproductconfigoptionssub.configid', '=', $row->opt_id)
                    ->distinct()
                    ->first();

                $whmcs_products[$row->pid]['sub_option_id'] = isset($getconfigopt->subopt_id) ? $getconfigopt->subopt_id : null;
            }
        }

        //get products from sync table
        $sync_pids = array();
        $sync_codes = array();
        $sync_new_codes = array();

        try {
            $result = Capsule::table('mod_sslstore_sync_products')
                ->select('pid', 'code', 'status')
                ->whereNotIn('status', ['retired'])
                ->get();
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
        }

        foreach ($result as $row) {
            $sync_pids[] = $row->pid;
            $sync_codes[] = $row->code;
            if ($row->status == 'new') {
                $sync_new_codes[] = $row->code;
            }
        }

        //get products from API
        $product_query_req = new product_query_requestv2();
        $product_query_req->ProductType = '0';
        $product_query_req->NeedSortedList = true;
        $product_query_req->IsForceNewSKUs = true;
        $product_query_resp = $ssl_api->product_query($product_query_req);

        // FIX #3: API returns ARRAY — each element is a product WITH its own AuthResponse
        // Validate: must be array, non-empty, first element has AuthResponse with no error
        $api_codes = array();
        if (is_array($product_query_resp) && count($product_query_resp) > 0
            && isset($product_query_resp->AuthResponse)
            && $product_query_resp->AuthResponse->isError == false
            && !empty($profit_margin) && !empty($product_group)) {

            // FIX #4: Get CurrencyCode from first element of the array
            $api_currency_code = isset($product_query_resp->CurrencyCode) ? $product_query_resp->CurrencyCode : 'USD';

            try {
                $api_currency = Capsule::table('tblcurrencies')
                    ->select('rate')
                    ->where('code', '=', $api_currency_code)
                    ->first();

                $selected_currency = Capsule::table('tblcurrencies')
                    ->select('rate')
                    ->where('id', '=', $currency_id)
                    ->first();
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
            }

            // FIX #5: Extract rate as STRING value — never pass the object itself
            $api_currency_rate = (isset($api_currency->rate) && $api_currency->rate !== NULL) ? $api_currency->rate : '1';
            $selected_currency_rate = (isset($selected_currency->rate) && $selected_currency->rate !== NULL) ? $selected_currency->rate : '1';

            $product_order = 1;

            // FIX #6: Loop directly over $product_query_resp — the array IS the product list
            foreach ($product_query_resp as $api_prd) {

                // FIX #7: Skip entries without ProductCode
                if (!isset($api_prd->ProductCode) || empty($api_prd->ProductCode)) {
                    continue;
                }

                $api_codes[$api_prd->ProductCode]['name'] = isset($api_prd->ProductName) ? $api_prd->ProductName : '';
                $api_codes[$api_prd->ProductCode]['product_data'] = $api_prd;
                $api_codes[$api_prd->ProductCode]['product_order'] = $product_order;
                $product_order++;

                foreach ($whmcs_products as $id => $whmcs_prd) {

                    if ($api_prd->ProductCode == $whmcs_prd['code']) {

                        // FIX #8: Pass string rate values (not objects)
                        $edit_result = tss_edit_product_configuration($whmcs_prd, $profit_margin, $api_prd, $currency_id, $selected_currency_rate, $api_currency_rate, $sync_now);

                        if ($edit_result['is_config_option_changed'] == 'y') {
                            $need_to_manual_alter = true;
                        }

                        foreach ($edit_result['logs'] as $log) {
                            if ($log['key'] == 'min_san_decreased') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - Default SANs Decreased - Previously {$log['old']} - Now {$log['new']}</li>";
                            } elseif ($log['key'] == 'min_san_increased') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - Default SANs Increased - Previously {$log['old']} - Now {$log['new']}</li>";
                            } elseif ($log['key'] == 'max_san_decreased') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - Additional SANs Decreased - Previously {$log['old']} - Now {$log['new']}</li>";
                            } elseif ($log['key'] == 'max_san_increased') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - Additional SANs Increased - Previously {$log['old']} - Now {$log['new']}</li>";
                            } elseif ($log['key'] == 'server_added') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - Server Licenses Added</li>";
                            } elseif ($log['key'] == 'server_removed') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - Server Licenses Removed</li>";
                            } elseif ($log['key'] == 'max_wildcard_san_decreased') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - Additional Wildcard SANs Decreased - Previously {$log['old']} - Now {$log['new']}</li>";
                            } elseif ($log['key'] == 'max_wildcard_san_increased') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - Additional Wildcard SANs Increased - Previously {$log['old']} - Now {$log['new']}</li>";
                            } elseif ($log['key'] == 'validity_added') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - {$log['months']} Month's Product Added.</li>";
                            } elseif ($log['key'] == 'validity_removed') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - {$log['months']} Month's Product Removed.</li>";
                            } elseif ($log['key'] == 'main_domain_configurable_option_added') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - {$log['months']} CSR/Main Domain Configurable Option Added.</li>";
                            } elseif ($log['key'] == 'certificate_delivery_method_added') {
                                $alteration_log .= "<li>{$whmcs_prd['name']}({$whmcs_prd['code']}) - Code Signing Certificate Delivery Methods added</li>";
                            }
                        }

                        //Make entry in Sync product table
                        if (in_array($id, $sync_pids)) {
                            //update
                            try {
                                $update_fields = array();
                                $update_fields['is_config_option_changed'] = $edit_result['is_config_option_changed'];
                                if ($edit_result['is_updated'] == 'y') {
                                    $update_fields['last_sync_date'] = date('Y-m-d H:i:s');
                                }
                                Capsule::table('mod_sslstore_sync_products')
                                    ->where('pid', '=', $id)
                                    ->whereNotIn('status', ['retired'])
                                    ->update($update_fields);
                            } catch (\Exception $e) {
                                logActivity("TheSSLStore Module Log|update, {$e->getMessage()}");
                            }
                        } elseif (in_array($api_prd->ProductCode, $sync_new_codes)) {
                            try {
                                Capsule::table('mod_sslstore_sync_products')
                                    ->where('code', '=', $api_prd->ProductCode)
                                    ->where('status', '=', 'new')
                                    ->update(['pid' => $id, 'is_config_option_changed' => $edit_result['is_config_option_changed'], 'group_name' => $whmcs_prd['group_name'], 'status' => 'active', 'last_sync_date' => date('Y-m-d H:i:s')]);
                            } catch (\Exception $e) {
                                logActivity("TheSSLStore Module Log|update, {$e->getMessage()}");
                            }
                        } else {
                            //Add
                            try {
                                $sync_check = Capsule::table('mod_sslstore_sync_products')
                                    ->select('pid')
                                    ->where('pid', '=', $id)
                                    ->whereNotIn('status', ['retired'])
                                    ->first();
                            } catch (\Exception $e) {
                                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
                            }

                            if ($sync_check == null) {
                                $values = array("pid" => $id, "code" => $api_prd->ProductCode, "cert_name" => $whmcs_prd['name'], "group_name" => $whmcs_prd['group_name'], "is_config_option_changed" => $edit_result['is_config_option_changed'], "status" => 'active', 'last_sync_date' => date('Y-m-d H:i:s'));
                                TSSDB::insert('mod_sslstore_sync_products', $values);
                            }
                        }
                    }
                }
            }

            //check new product available in API but not added in WHMCS
            foreach ($api_codes as $code => $p) {
                $new_product = true;
                foreach ($whmcs_products as $pid => $prd) {
                    if ($prd['code'] == $code) {
                        $new_product = false;

                        if ($prd['prd_hidden'] == 1) {
                            try {
                                $sync_check = Capsule::table('mod_sslstore_sync_products')
                                    ->select('pid')
                                    ->where('pid', '=', $pid)
                                    ->whereNotIn('status', ['retired'])
                                    ->first();
                            } catch (\Exception $e) {
                                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
                            }

                            if (!$sync_check) {
                                $values = array("pid" => $pid, "code" => $prd['code'], "cert_name" => $prd['name'], "group_name" => $prd['group_name'], "status" => 'hidden');
                                TSSDB::insert('mod_sslstore_sync_products', $values);
                            } else {
                                try {
                                    Capsule::table('mod_sslstore_sync_products')
                                        ->where('pid', '=', $pid)
                                        ->whereNotIn('status', ['retired'])
                                        ->update(['status' => 'hidden']);
                                } catch (\Exception $e) {
                                    logActivity("TheSSLStore Module Log|update, {$e->getMessage()}");
                                }
                            }
                        }
                    }
                }
                if ($new_product) {

                    $new_products[$code]['name'] = $p['name'];
                    $new_products[$code]['product_data'] = $p['product_data'];
                    $new_products[$code]['product_order'] = $p['product_order'];

                    if (in_array($code, $sync_codes)) {
                        try {
                            Capsule::table('mod_sslstore_sync_products')
                                ->where('code', '=', $code)
                                ->whereNotIn('status', ['retired'])
                                ->update(['status' => 'new']);
                        } catch (\Exception $e) {
                            logActivity("TheSSLStore Module Log|update, {$e->getMessage()}");
                        }
                    } else {
                        try {
                            $sync_check = Capsule::table('mod_sslstore_sync_products')
                                ->select('pid')
                                ->where('code', '=', $code)
                                ->whereNotIn('status', ['retired'])
                                ->first();
                        } catch (\Exception $e) {
                            logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
                        }

                        if ($sync_check == null) {
                            $values = array("code" => $code, "cert_name" => $p['name'], "status" => 'new');
                            TSSDB::insert('mod_sslstore_sync_products', $values);
                        }
                    }
                }
            }

            //Check discontinued products Available in WHMCS but not available in API
            foreach ($whmcs_products as $pid => $prd) {
                $remove_product = true;
                foreach ($api_codes as $code => $p_name) {
                    if ($prd['code'] == $code) {
                        $remove_product = false;
                        break;
                    }
                }
                if ($remove_product && $prd['prd_hidden'] == 0) {

                    $discontinued_products[$pid]['name'] = $prd['name'];
                    $discontinued_products[$pid]['code'] = $prd['code'];

                    if (in_array($pid, $sync_pids)) {
                        try {
                            Capsule::table('mod_sslstore_sync_products')
                                ->whereNotIn('status', ['retired'])
                                ->where('pid', '=', $pid)
                                ->update(['status' => 'discontinued']);
                        } catch (\Exception $e) {
                            logActivity("TheSSLStore Module Log|update, {$e->getMessage()}");
                        }
                    } else {
                        try {
                            $sync_check = Capsule::table('mod_sslstore_sync_products')
                                ->select('pid')
                                ->where('pid', '=', $pid)
                                ->whereNotIn('status', ['retired'])
                                ->first();
                        } catch (\Exception $e) {
                            logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
                        }

                        if ($sync_check == null) {
                            $values = array("pid" => $pid, "code" => $prd['code'], "cert_name" => $prd['name'], "group_name" => $prd['group_name'], "status" => 'discontinued');
                            TSSDB::insert('mod_sslstore_sync_products', $values);
                        }
                    }
                }
            }

            //Now time to process queue and send emails
            $sendCronEmail = tss_get_config_option('send_cron_email');
            if ($sendCronEmail == true) {
                $sync_product_page_url = tssGetAdminURL(). '/addonmodules.php?module=thesslstorefullv2_admin&page=sync_products';

                if ($product_sync_setting == 'only_alteration') {

                    $product_add_or_remove = 'y';
                    if (empty($new_products) && empty($discontinued_products)) {
                        $product_add_or_remove = 'n';
                    }

                    if (trim($alteration_log) != '') {
                        $alteration_log = "<strong>Configurable Changes</strong><ul>$alteration_log</ul>";
                    }

                    if (!empty($alteration_log) || !empty($new_products) || !empty($discontinued_products)) {
                        $email_template_name = 'THESSLSTORE Products Sync - Only Alterations';
                        $command = "sendadminemail";
                        $email_values = array();
                        $email_values['messagename'] = $email_template_name;
                        $email_values["mergefields"] = array("log_of_changes" => $alteration_log, "product_add_or_remove" => $product_add_or_remove, 'sync_product_page_url' => $sync_product_page_url);
                        localAPI($command, $email_values, $admin_user);
                    }

                } elseif ($product_sync_setting == 'alteration_and_removal') {
                    $log_of_changes = '';
                    $removal_log = '';

                    if (trim($alteration_log) != '') {
                        $log_of_changes = "<strong>Configurable Changes</strong><ul>$alteration_log</ul>";
                    }

                    foreach ($discontinued_products as $disc_pid => $prd) {
                        $rmproduct = array();
                        $rmproduct['productId'] = $disc_pid;
                        $rmproduct['isCancelForAllRenewal'] = '';
                        tss_remove_product($rmproduct);
                        $removal_log .= "<li>{$prd['name']}({$prd['code']}) - Now Discontinued and Disabled</li>";
                    }

                    if ($removal_log != '') {
                        $log_of_changes .= "<strong>Disabled Products</strong><ul>$removal_log</ul>";
                    }
                    $product_added = 'y';
                    if (empty($new_products)) {
                        $product_added = 'n';
                    }

                    if (!empty($log_of_changes) || !empty($new_products) || !empty($discontinued_products)) {
                        $email_template_name = 'THESSLSTORE Products Sync - Alterations & Disable';
                        $command = "sendadminemail";
                        $email_values = array();
                        $email_values['messagename'] = $email_template_name;
                        $email_values["mergefields"] = array("log_of_changes" => $log_of_changes, "product_added" => $product_added, 'sync_product_page_url' => $sync_product_page_url);
                        localAPI($command, $email_values, $admin_user);
                    }

                } elseif ($product_sync_setting == 'all') {
                    $log_of_changes = '';
                    $new_product_log = '';
                    $removal_log = '';

                    $group_name = '';
                    try {
                        $group_name_result = Capsule::table('tblproductgroups')
                            ->select('name')
                            ->where('id', '=', $product_group)
                            ->first();

                        $group_name = isset($group_name_result->name) ? $group_name_result->name : '';
                    } catch (\Exception $e) {
                        logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
                    }

                    // FIX #9: Renamed loop variable from $data to $prd_data (avoids collision)
                    // FIX #10: Pass $selected_currency_rate and $api_currency_rate (strings)
                    foreach ($new_products as $code => $prd_data) {
                        tss_add_product($profit_margin, $product_group, $prd_data['product_data'], $currency_id, $group_name, $prd_data['product_order'], $selected_currency_rate, $api_currency_rate);
                        $new_product_log .= "<li>{$prd_data['name']} - Added with $profit_margin % Profit Margin.</li>";
                    }

                    foreach ($discontinued_products as $disc_pid => $prd) {
                        $rmproduct = array();
                        $rmproduct['productId'] = $disc_pid;
                        $rmproduct['isCancelForAllRenewal'] = '';
                        tss_remove_product($rmproduct);
                        $removal_log .= "<li>{$prd['name']}({$prd['code']}) - Now Discontinued and Disabled</li>";
                    }

                    if ($new_product_log != '') {
                        $log_of_changes .= "<strong>New Products</strong><ul>$new_product_log</ul>";
                    }

                    if ($alteration_log != '') {
                        $log_of_changes .= "<strong>Configurable Changes</strong><ul>$alteration_log</ul>";
                    }

                    if ($removal_log != '') {
                        $log_of_changes .= "<strong>Disabled Products</strong><ul>$removal_log</ul>";
                    }

                    if (!empty($log_of_changes) || !empty($new_products) || !empty($discontinued_products)) {
                        $email_template_name = 'THESSLSTORE Products Sync - All';
                        $command = "SendAdminEmail";
                        $email_values = array();
                        $email_values['messagename'] = $email_template_name;
                        $email_values["mergefields"] = array("log_of_changes" => $log_of_changes);
                        localAPI($command, $email_values, $admin_user);
                    }

                } else {
                    //Manual
                    if ($need_to_manual_alter || !empty($new_products) || !empty($discontinued_products)) {
                        $email_template_name = 'THESSLSTORE Products Sync - Manually';
                        $command = 'SendAdminEmail';
                        $postData = array(
                            'messagename' => $email_template_name,
                            'mergefields' => array('sync_product_page_url' => $sync_product_page_url),
                        );
                        localAPI($command, $postData, $admin_user);
                    }
                }
            }
        }

        //send alert email when profit margin and group is not set
        if (empty($profit_margin) || empty($product_group)) {
            $setting_page_url = tssGetAdminURL(). '/addonmodules.php?module=thesslstorefullv2_admin&page=apicredentials';
            $setting_page_url = '<a href="'. $setting_page_url. '">'. $setting_page_url. '</a>';
            $email_template_name = 'THESSLSTORE Profit Margin Not Available for Sync Products';
            $command = "SendAdminEmail";
            $alert_values = array();
            $alert_values['messagename'] = $email_template_name;
            $alert_values["mergefields"] = array("module_setting_page_url" => $setting_page_url);
            localAPI($command, $alert_values, $admin_user);
        }

        //Store product info for reporting
        tss_store_product_data();

        //Update the date of the cron last run
        try {
            Capsule::table('mod_sslstore_crons')
                ->where('cron_key', 'product_sync')
                ->update(['last_run' => date('Y-m-d H:i:s')]);
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log| cron, {$e->getMessage()}");
        }
    }

    private function place_imported_order()
    {
        try {
            $tblAdminsData = Capsule::table('tbladmins')
                ->select('username')
                ->first();
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
        }

        //Send email reminder 7 days before to place an order(We placed an order before 15 days of due date so email will sent before (15+7)= 21 days )
        $num_reminders_sent = 0;
        $reminder_days = 21;

        try {
            $importOrders = Capsule::table('mod_sslstore_importorders_v2')
                ->where(Capsule::raw("DATEDIFF(duedate,now())"), '=', $reminder_days)
                ->where('emailsent', '=', 0)
                ->get();
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log | query, {$e->getMessage()}");
        }

        foreach ($importOrders as $row) {
            // Send e-mail using WHMCS sendmessage() function
            sendmessage('Your SSL Certificate - Renewal Reminder Email', $row->userid, array('reminder_days' => 7, 'domain' => $row->domain, 'productcode' => $row->productcode, 'useremail' => $row->useremail, 'billingcycle' => $row->billingcycle, 'paymentmethod' => $row->paymentmethod));

            //UPDATE the emailsent=1
            try {
                Capsule::table('mod_sslstore_importorders_v2')
                    ->where('id', '=', $row->id)
                    ->update(['emailsent' => 1]);
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log|update, {$e->getMessage()}");
            }
            $num_reminders_sent++;
        }
        logActivity("$num_reminders_sent renewal reminder emails sent!");

        //Place an order based on duedate
        $daydifference = 16;

        try {
            $importOrders = Capsule::table('mod_sslstore_importorders_v2')
                ->where(Capsule::raw("DATEDIFF(duedate,now())"), '<', $daydifference)
                ->where('orderplaced', '=', 0)
                ->get();
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
        }

        foreach ($importOrders as $data) {
            try {
                $productidarray = Capsule::table('tblproducts')
                    ->select('tblproducts.id')
                    ->where('tblproducts.servertype', '=', 'thesslstorefullv2')
                    ->where('tblproducts.gid', '=', $data->productgroupid)
                    ->where('tblproducts.configoption1', '=', $data->productcode)
                    ->first();
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
            }


            $productid = $productidarray->id;
            $numberofsan = $data->numberofsan;
            $numberofwildcardsan = $data->numberofwildcardsan;
            $additionalserver = $data->additionalserver;
            $domain = $data->domain;
            $billingcycle = $data->billingcycle;
            $paymentmethod = $data->paymentmethod;


            // Retrieve ConfigOption ID for SAN
            try {
                $sanconfigoptionsarray = Capsule::table('tblproductconfigoptions')
                    ->select('tblproductconfigoptions.id')
                    ->join('tblproductconfiglinks', 'tblproductconfiglinks.gid', '=', 'tblproductconfigoptions.gid')
                    ->where('tblproductconfigoptions.optionname', 'like', '%Additional SAN%')
                    ->where('tblproductconfiglinks.pid', '=', $productid)
                    ->first();
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
            }


            $sanconfigoptionid = $sanconfigoptionsarray->id;


            // Retrieve ConfigOption ID for Additional Server

            try {
                $serverconfigoptionsarray = Capsule::table('tblproductconfigoptions')
                    ->select('tblproductconfigoptions.id')
                    ->join('tblproductconfiglinks', 'tblproductconfiglinks.gid', '=', 'tblproductconfigoptions.gid')
                    ->where('tblproductconfigoptions.optionname', 'like', '%Additional Servers%')
                    ->where('tblproductconfiglinks.pid', '=', $productid)
                    ->first();
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
            }
            $serverconfigoptionid = $serverconfigoptionsarray->id;


            // Retrieve ConfigOption ID for Wildcard SAN for the Flex products
            try {
                $sanconfigoptionsarray = Capsule::table('tblproductconfigoptions')
                    ->select('tblproductconfigoptions.id')
                    ->join('tblproductconfiglinks', 'tblproductconfiglinks.gid', '=', 'tblproductconfigoptions.gid')
                    ->where('tblproductconfigoptions.optionname', 'like', '%Additional WildCard SAN%')
                    ->where('tblproductconfiglinks.pid', '=', $productid)
                    ->first();
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
            }


            $wildcardsanconfigoptionid = $sanconfigoptionsarray->id;


            // Retrieve ConfigOption ID for CSR/Main Domain for the Flex products
            try {
                $sanconfigoptionsarray = Capsule::table('tblproductconfigoptions')
                    ->select('tblproductconfigoptions.id')
                    ->join('tblproductconfiglinks', 'tblproductconfiglinks.gid', '=', 'tblproductconfigoptions.gid')
                    ->where('tblproductconfigoptions.optionname', 'like', '%CSR Domain%')
                    ->where('tblproductconfiglinks.pid', '=', $productid)
                    ->first();
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log|query, {$e->getMessage()}");
            }


            $csrdomainconfigoptionid = $sanconfigoptionsarray->id;



            $command = "addorder";
            $values["clientid"] = $data->userid;
            $values["pid"] = $productid;
            $values["domain"] = $domain;
            $values["billingcycle"] = $billingcycle;
            $values["paymentmethod"] = $paymentmethod;
            $values["noinvoice"] = false;
            $values["noinvoiceemail"] = false;
            $values["noemail"] = false;

            $sslApi = new sslstorev2($this->partnerCode, $this->authToken, $this->apiMode);
            $productreq = new product_query_requestv2();
            $productreq->ProductCode = $data->productcode;
            $productreq->ProductType = '0';
            $products = $sslApi->product_query($productreq);
            //Check the product is SAN enabled or not
            if ($products[0]->IsSanEnable == '1' && $data->productcode != 'quicksslpremiummd') {
                $additionalSan = $numberofsan;
            }
            //Check the product is supported additional servers or not
            if ($data->productcode == 'securesite' || $data->productcode == 'securesitepro' || $data->productcode == 'securesiteproev' || $data->productcode == 'securesitewildcard' || $data->productcode == 'securesiteev') {
                $additionalServer = $additionalserver;
            }
            // Check for the Flex DV, OV products
            if ($products[0]->isFlexProduct == true && $products[0]->isEVProduct == false) {
                $wildCardSan = $numberofwildcardsan;
                //Check the domain contains wilcard value or not
                $pos = strpos($values["domain"], "*.");
                if ($pos === false) {
                    $csrDomain = "Standard";
                } else {
                    $csrDomain = "WildCard";
                }

                // Get CSR Domain Config Option ID
                $row = Capsule::table('tblproductconfigoptionssub')
                    ->select('tblproductconfigoptionssub.id')
                    ->where('tblproductconfigoptionssub.configid', '=', $csrdomainconfigoptionid)
                    ->where('tblproductconfigoptionssub.optionname', 'like', '%' . $csrDomain . '%')
                    ->first();
                $mainDomainConfigOptionId = $row->id;
            }

            $values["configoptions"] = base64_encode(serialize(array($sanconfigoptionid => $additionalSan, $serverconfigoptionid => $additionalServer, $wildcardsanconfigoptionid => $wildCardSan, $csrdomainconfigoptionid => $mainDomainConfigOptionId)));
            $results = localAPI($command, $values, $tblAdminsData->username);
          
            if ($results['result'] == 'error') {
                logActivity("Error while placing an order to WHMCS system: " . $results['message']);
            } else {
                // UPDATE orderplaced=1

                try {
                    Capsule::table('mod_sslstore_importorders_v2')
                        ->where('id', '=', $data->id)
                        ->update(['orderplaced' => 1, 'serviceId' => $results['productids']]);
                } catch (\Exception $e) {
                    logActivity("TheSSLStore Module Log|update, {$e->getMessage()}");
                }
            }
        }

        //Update the date of the cron last run in mod_sslstore_crons table.
        try {
            Capsule::table('mod_sslstore_crons')
                ->where('cron_key', 'place_imported_order')
                ->update(['last_run' => date('Y-m-d H:i:s')]);
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log| cron, {$e->getMessage()}"); 
        }
    }

    private function auto_install_ssl_on_renew()
    {
        $autorenew_config = tss_get_config_option('autorenew', 0);
        if($autorenew_config != "autonew_and_entrollment") {
            //get all pending installation
            try {
                $tblAdminsData = Capsule::table('tbladmins')
                    ->select('username')
                    ->first();

                $orders = Capsule::table('mod_sslstore_auto_install_ssl')
                    ->select('mod_sslstore_auto_install_ssl.id', 'mod_sslstore_auto_install_ssl.service_id', 'mod_sslstore_auto_install_ssl.addon_id', 'mod_sslstore_auto_install_ssl.hosting_id', 'mod_sslstore_auto_install_ssl.store_order_id', 'mod_sslstore_auto_install_ssl.domain_name', 'mod_sslstore_orders_data.vendor_order_id', 'mod_sslstore_orders_data.common_name')
                    ->join('mod_sslstore_orders_data', 'mod_sslstore_orders_data.store_order_id', '=', 'mod_sslstore_auto_install_ssl.store_order_id')
                    ->where('mod_sslstore_auto_install_ssl.status', '=', '0')
                    ->get();

                $sslApi = new sslstorev2($this->partnerCode, $this->authToken, $this->apiMode);

                $download_cert_req = new order_download_requestv2();
                $installed_certs = array();
                $pending_certs = array();
                $failed_certs = array();

                foreach ($orders as $order) {
                    if(checkTheSSLStoreModule(0,$order->store_order_id)){
                        //download certificate
                        $download_cert_req->TheSSLStoreOrderID = $order->store_order_id;
                        $download_cert_resp = $sslApi->order_download($download_cert_req);
                        $server_cert = '';
                        $ca_cert = '';
                        $error = '';
                        if (isset($download_cert_resp->AuthResponse->isError) && $download_cert_resp->AuthResponse->isError == false) {
                            $orderStatusReq = new order_status_request();
                            $orderStatusReq->TheSSLStoreOrderID = $order->store_order_id;
                            $orderStatusResp = $sslApi->order_status($orderStatusReq);

                            $certArray = $download_cert_resp->Certificates;
                            $tempCertName = str_replace(".", "_", $orderStatusResp->CommonName);
                            $tempCertName = str_replace("*", "STAR", $tempCertName);
                            $ComodoMDCertname = $orderStatusResp->VendorOrderID;
                            $ComodoMDCertname = str_replace("#", "_", $ComodoMDCertname);
                            //********************************  Certificate Array  **********************************//
                            foreach ($certArray as $value) {
                                if (strtoupper($orderStatusResp->VendorName) == 'DIGICERT') {
                                    $tempCertName = str_replace("STAR_", "star_", $tempCertName);
                                    if ($value->FileName == $tempCertName . ".crt") {
                                        $server_cert = (string) $value->FileContent;
                                    } else if ($value->FileName == "My_CA_Bundle.crt") {
                                        $ca_cert = (string) $value->FileContent;
                                    }
                                } else {
                                    if ($value->FileName == "ServerCertificate.cer" || $value->FileName == "Certificate.cer" || $value->FileName == $tempCertName . ".crt" || $value->FileName == $ComodoMDCertname . ".crt") {
                                        $server_cert = (string) $value->FileContent;
                                    } else if ($value->FileName == "IconScript.txt" || $value->FileName == "PKCS7.p7b" || $value->FileName == "PKCS7Certificate.p7b" || $value->FileName == "PKCS12.p7b" || $value->FileName == "PKCS12EncryptedPassword.p7b") {
                                        //Ignore the file
                                    } else {
                                        $ca_cert = '';
                                        $caarray[] = $value;
                                        foreach ($caarray as $values) {
                                            $fileContent = (string) $values->FileContent;
                                            $ca_cert = $ca_cert . $fileContent;
                                        }
                                    }
                                }
                            }
                            //install certificate
                            //get cpanel api
                            $hostingData = Capsule::table('tblhosting')
                                ->join('tblservers', 'tblhosting.server', '=', 'tblservers.id')
                                ->select('tblhosting.username as hosting_username', 'tblservers.ipaddress', 'tblservers.hostname', 'tblservers.username', 'tblservers.password', 'tblservers.accesshash', 'tblservers.secure', 'tblservers.port')
                                ->where('tblhosting.id', $order->hosting_id)
                                ->first();

                            if ($hostingData) {
                                //decrypt password using api
                                $decrypt_password_resp = localAPI('decryptpassword', array('password2' => $hostingData->password), $tblAdminsData->username);
                                if ($decrypt_password_resp['result'] == 'success') {
                                    $whm_password = $decrypt_password_resp['password'];
                                }
                                $cPanelApi = new TSSCPanel($hostingData->secure, $hostingData->ipaddress, $hostingData->hostname, $hostingData->username, $hostingData->accesshash, $whm_password, $hostingData->hosting_username);

                                //get private key id
                                $tblSSLOrdersData = Capsule::table('tblsslorders')->select('configdata')->where('remoteid', $order->store_order_id)->where('module', 'thesslstorefullv2')->first();
                                $configData = json_decode($tblSSLOrdersData->configdata);

                                $retrieve_private_key_resp = $cPanelApi->retrieve_private_key($configData->pvtKeyID);
                                if (!empty($retrieve_private_key_resp->key)) {
                                    //install ssl on domain
                                    $install_ssl_resp = $cPanelApi->install_ssl($orderStatusResp->CommonName, $retrieve_private_key_resp->key, $server_cert, $ca_cert);
                                    if ($install_ssl_resp->status == 1) {
                                        $installed_certs[] = array('domain_name' => $orderStatusResp->CommonName, 'service_id' => $order->service_id, 'store_order_id' => $order->store_order_id);
                                        //update in database
                                        Capsule::table('mod_sslstore_auto_install_ssl')
                                            ->where('id', '=', $order->id)
                                            ->update(['status' => '1', 'installed_date' => date('Y-m-d H:i:s')]);

                                        // Send e-mail to customer using WHMCS sendmessage() function
                                        sendMessage('Your SSL Certificate - Successfull Installation Email', $order->service_id, array('productName' => $orderStatusResp->ProductName, 'domainName' => $order->domain_name));
                                    } else {
                                        //error in installation
                                        $error = 'Error in certificate installation for domain ' . $order->domain_name . ':' . $install_ssl_resp->error;
                                        $failed_certs[] = array('domain_name' => $order->domain_name, 'service_id' => $order->service_id, 'store_order_id' => $order->store_order_id, 'reason' => 'Install SSL: ' . $install_ssl_resp->error);
                                    }
                                } else {
                                    //error in retrieve private key
                                    $error = 'Error in retrieve private key for domain ' . $order->domain_name . ':' . $retrieve_private_key_resp->error;
                                    $failed_certs[] = array('domain_name' => $order->domain_name, 'service_id' => $order->service_id, 'store_order_id' => $order->store_order_id, 'reason' => 'Retrieve Key: ' . $retrieve_private_key_resp->error);
                                }
                            } else {
                                $error = 'Hosting profile does not found for domain:' . $order->domain_name;
                                $failed_certs[] = array('domain_name' => $order->domain_name, 'service_id' => $order->service_id, 'store_order_id' => $order->store_order_id, 'reason' => 'Hosting Account Not Found');
                            }
                        } else {
                            $pending_certs[] = array('domain_name' => $order->domain_name, 'service_id' => $order->service_id, 'store_order_id' => $order->store_order_id);
                            $error = 'Error in download certificate(store order id:' . $order->store_order_id . ') ' . $download_cert_resp->AuthResponse->Message[0];
                        }

                        if (!empty($error)) {
                            logActivity("TheSSLStore Module Log | auto_install_ssl_cron {$error}");
                        }
                    }
                }

                if (!empty($orders) && (!empty($installed_certs) || !empty($pending_certs) || !empty($failed_certs))) {
                    //send mail to admin
                    $values = array();
                    $values['messagename'] = 'THESSLSTORE Renew AutoInstall SSL Report(WHMCS)';
                    $values["mergefields"] = array("installed_certs" => $installed_certs, 'pending_certs' => $pending_certs, 'failed_certs' => $failed_certs);
                    localAPI('SendAdminEmail', $values, $tblAdminsData->username);
                }

                //Update the date of the cron last run in mod_sslstore_crons table.
                try {
                    Capsule::table('mod_sslstore_crons')
                        ->where('cron_key', 'auto_install_ssl_on_renewal')
                        ->update(['last_run' => date('Y-m-d H:i:s')]);
                } catch (\Exception $e) {
                    logActivity("TheSSLStore Module Log| cron, {$e->getMessage()}");
                }
            } catch (\Exception $e) {
                logActivity("TheSSLStore Module Log | auto_install_ssl_cron{$e->getMessage()}");
            }
        }
    }
    private function comodo_reissue_reminder()
    {
        try {
            //get order to send reissue reminder
            $reissue_reminder_orders = Capsule::table('mod_sslstore_orders_data')
                ->select('tblsslorders.id', 'mod_sslstore_orders_data.service_id', 'mod_sslstore_orders_data.common_name', 'mod_sslstore_orders_data.expiration_date','tblsslorders.module')
                ->join('tblsslorders', 'mod_sslstore_orders_data.service_id', '=', 'tblsslorders.serviceid')
                ->join('mod_sslstore_product_data', 'mod_sslstore_orders_data.product_code', '=', 'mod_sslstore_product_data.product_code')
                ->where('tblsslorders.module', '=', 'thesslstorefullv2')
                ->where('mod_sslstore_orders_data.ssl_status', '=', 'active')
                ->where('mod_sslstore_orders_data.no_of_months', '>=', 24)
                ->whereNotNull('mod_sslstore_orders_data.order_expiration_date')
                ->where(Capsule::raw("DATEDIFF(mod_sslstore_orders_data.order_expiration_date,now())"), '>', 89)
                ->whereIn('mod_sslstore_product_data.vendor_name', array('COMODO', 'SECTIGO'))
                ->whereIn('mod_sslstore_product_data.product_type', array(1, 2, 3, 4, 7)) //1=DV=1,EV=2,OV=3,WILDCARD=4,7=SAN_ENABLED
                ->whereIn(Capsule::raw("DATEDIFF(mod_sslstore_orders_data.expiration_date,now())"), array(30, 21, 10, 3, 1))
                ->get();

            if (!empty($reissue_reminder_orders)) {
                global $CONFIG;
                $tblAdminsData = Capsule::table('tbladmins')
                    ->select('username')
                    ->first();

                foreach ($reissue_reminder_orders as $reminder_order) {
                    if(checkTheSSLStoreModule($reminder_order->service_id)){
                        $reissue_link = $CONFIG['SystemURL'] . '/clientarea.php?action=productdetails&id=' . $reminder_order->service_id . '&page=reissuestepone&sslid=' . $reminder_order->id;
                        $postData = array(
                            'messagename' => 'Comodo Reissue Reminder',
                            'id' => $reminder_order->service_id,
                            'customvars' => base64_encode(serialize(array('common_name' => $reminder_order->common_name, 'cert_expiry_date' => $reminder_order->expiration_date, 'reissue_link' => $reissue_link))),
                        );

                        localAPI('SendEmail', $postData, $tblAdminsData->username);
                    }
                }
            }

            Capsule::table('mod_sslstore_crons')
                ->where('cron_key', 'comodo_reissue_reminder')
                ->update(['last_run' => date('Y-m-d H:i:s')]);
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log| comodo reissue reminder cron, {$e->getMessage()}");
        }
    }

    private function digicert_reissue_reminder()
    {
        try {
            //get order to send reissue reminder
            $reissue_reminder_orders = Capsule::table('mod_sslstore_orders_data')
                ->select('tblsslorders.id', 'mod_sslstore_orders_data.service_id', 'mod_sslstore_orders_data.common_name', 'mod_sslstore_orders_data.expiration_date','tblsslorders.module')
                ->join('tblsslorders', 'mod_sslstore_orders_data.service_id', '=', 'tblsslorders.serviceid')
                ->join('mod_sslstore_product_data', 'mod_sslstore_orders_data.product_code', '=', 'mod_sslstore_product_data.product_code')
                ->where('tblsslorders.module', '=', 'thesslstorefullv2')
                ->where('mod_sslstore_orders_data.ssl_status', '=', 'active')
                ->where('mod_sslstore_orders_data.no_of_months', '>=', 24)
                ->whereNotNull('mod_sslstore_orders_data.order_expiration_date')
                ->where(Capsule::raw("DATEDIFF(mod_sslstore_orders_data.order_expiration_date,now())"), '>', 89)
                ->whereIn('mod_sslstore_product_data.vendor_name', array('DIGICERT', 'SYMANTEC'))
                ->whereIn('mod_sslstore_product_data.product_type', array(1, 2, 3, 4, 7)) //1=DV=1,EV=2,OV=3,WILDCARD=4,7=SAN_ENABLED
                ->whereIn(Capsule::raw("DATEDIFF(mod_sslstore_orders_data.expiration_date,now())"), array(30, 21, 10, 3, 1))
                ->get();

            if (!empty($reissue_reminder_orders)) {
                global $CONFIG;
                $tblAdminsData = Capsule::table('tbladmins')
                    ->select('username')
                    ->first();

                foreach ($reissue_reminder_orders as $reminder_order) {
                    $reissue_link = $CONFIG['SystemURL'] . '/clientarea.php?action=productdetails&id=' . $reminder_order->service_id . '&page=reissuestepone&sslid=' . $reminder_order->id;
                    $postData = array(
                        'messagename' => 'Digicert Reissue Reminder',
                        'id' => $reminder_order->service_id,
                        'customvars' => base64_encode(serialize(array('common_name' => $reminder_order->common_name, 'cert_expiry_date' => $reminder_order->expiration_date, 'reissue_link' => $reissue_link))),
                    );

                    localAPI('SendEmail', $postData, $tblAdminsData->username);
                }
            }

            Capsule::table('mod_sslstore_crons')
                ->where('cron_key', 'digicert_reissue_reminder')
                ->update(['last_run' => date('Y-m-d H:i:s')]);
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log| digicert reissue reminder cron, {$e->getMessage()}");
        }
    }

    private function activities_module_logs_clean() {
        try {
			Capsule::table('tblactivitylog')
				->where('description','LIKE','%TheSSLStore Module Log%')
                ->where('date','<','DATE_SUB(NOW(), INTERVAL 1 MONTH)')
				->delete();

            Capsule::table('mod_sslstore_crons')
                ->where('cron_key', 'activities_module_logs_clean')
                ->update(['last_run' => date('Y-m-d H:i:s')]);
        } catch (\Exception $e) {
            logActivity("TheSSLStore Module Log| Activites Module Logs Cleans cron, {$e->getMessage()}");
        }
    }
}

$tssCron = new tss_cron();
$tssCron->run();

logActivity("TSS Cron completed at: " . date('Y/m/d H:i:s'));
echo "TSS Cron completed";