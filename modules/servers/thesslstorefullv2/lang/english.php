<?php
if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}
$_LANG['certificate_details'] = "Certificate details";
$_LANG['sslstatus'] = "Order Status";
$_LANG['ssl_store_orderid'] = "Store Order ID";
$_LANG['ssl_provisioning_date'] = "SSL Provisioning Date";
$_LANG['ssl_expiry_date'] = "SSL Expiry Date";
$_LANG['order_expiry_date'] = "Order Expiry Date";
$_LANG['ssl_vendor_status'] = "Vendor Status";
$_LANG['ssl_product_name'] = "Product Name";
$_LANG['ssl_vendor_orderid'] = "Vendor Order ID";
$_LANG['ssl_verification_email'] = "Verification Email";
$_LANG['ssl_poll_status'] = "File Auth Status";
$_LANG['ssl_poll_date'] = "Last File Check Date";
$_LANG['AuthenticationStatuses'] = "Authentication Statuses";
$_LANG['AuthenticationStep'] = "Authentication Step";
$_LANG['AuthenticationStatus'] = "Authentication Status";
$_LANG['LastUpdated'] = "Last Updated";
$_LANG['AuthenticationComments'] = "Authentication Comments";
$_LANG['cname_details'] = "DNS Details";
$_LANG['certificate_delivery_method'] = "Certificate Delivery Method";
$_LANG['cname_dns'] = "Host";
$_LANG['cname_point_to'] = "Target";
$_LANG['validation_status'] = "Validation Status";
$_LANG['validation_email'] = "Email Validation";
$_LANG['validationemail_urlLabel'] = "Email Address:";
$_LANG['validation_dns'] = "DNS Verification";
$_LANG['validationdns_urlLabel'] = "TXT Value:";
$_LANG['validationdns_URLContentLabel'] = "HostName:";
$_LANG['validation_http'] = "HTTP Validation";
$_LANG['validationhttp_urlLabel'] = "File URL:";
$_LANG['validationhttp_URLContentLabel'] = "File Content";
$_LANG['validation_https'] = "HTTPS Validation";
$_LANG['validationhttps_urlLabel'] = "File URL:'";
$_LANG['validationhttps_URLContentLabel'] = "File Content";
$_LANG['validation_cname'] = "CNAME Verification";
$_LANG['validationcname_urlLabel'] = "Alias/HostName:";
$_LANG['validationcname_URLContentLabel'] = "Point To:";
$_LANG['authMethod'] = "Authentication Method";

$_LANG['dns_txt_info'] = "The following steps create a TXT Record.<br/>

    1. For the record type, select TXT.<br/>
    2. In the Name/Host/Alias field, enter @ or leave it blank. Your other DNS records may indicate which you should use. <br/>
    3. In the Time to Live (TTL) field, enter 3600 or leave the default. <br/>
    4. In the Value/Answer/Destination field, paste this value: %txtrecord%. <br/>
    5. Save the record.
";


$_LANG['ssl_san_details'] = "Total SANS";
$_LANG['admin_details'] = "Admin Details";
$_LANG['admin_firstname'] = "First Name";
$_LANG['admin_lastname'] = "Last Name";
$_LANG['admin_email'] = "Email";
$_LANG['admin_title'] = "Title";
$_LANG['admin_phone'] = "Phone";
$_LANG['tech_details'] = "Technical Details";
$_LANG['tech_firstname'] = "First Name";
$_LANG['tech_lastname'] = "Last Name";
$_LANG['tech_email'] = "Email";
$_LANG['tech_title'] = "Title";
$_LANG['tech_phone'] = "Phone";
$_LANG['domains'] = "Domain(s)";
$_LANG['site_seal'] = "Get Your Site Seal";
$_LANG['refund_status_id'] = "Refund Status ID";
$_LANG['download_cert'] = "Download&nbsp;Certificate";
$_LANG['auth_file'] = "Download&nbsp;Auth&nbsp;File";
$_LANG['refund_req'] = "Cancel&nbsp;Certificate";
$_LANG['reissue_cert'] = "Re-issue&nbsp;Certificate";
$_LANG['buy_more_san_btn'] = "Purchase Additional SANs";
$_LANG['buy_more_san_tooltip'] = "An appropriate invoice will be generated once upgrade submitted. <br>After payment, the service will be modified accordingly. In order to add additional SAN in certificate, you should run the \"Reissue\" action of the certificate";
$_LANG['save'] = "Save";
$_LANG['check_order_status'] = "Check&nbsp;Status";
$_LANG['generate_cert'] = "Generate Now";
$_LANG['resend_approver_email'] = "Resend&nbsp;Approval&nbsp;Email";
$_LANG['change_approver_email'] = "Change&nbsp;Approval&nbsp;Email";
$_LANG['change_approver_method'] = "Change&nbsp;Approval&nbsp;Method";
$_LANG['emailmessage'] = "Thank you for ordering your security product! Your purchase now requires some additional configuration which can be done at the following URL:";
$_LANG['refund_status_id'] = "SSL Incident ID";
$_LANG['token'] = "Token";
$_LANG['token_code'] = "Token Code";
$_LANG['token_id'] = "Token ID";
$_LANG['tokens_tooltip'] = "This is used ONLY if your hosting platform is using the AutoInstall SSL&trade; technology. If your control panel currently has the AutoInstall SSL&trade; plugin available for use, simply copy/paste the Token within the plugin when prompted to process your order.";
$_LANG['additional_san']="Enter Additional Domains:*";
$_LANG['additional_san_label']="Addon Domain";
$_LANG['signature_algorithm_note']="Select the Signature Algorithm:<br/><span class='regular'>Please select the Secure Hashing Algorithm (SHA) that you would like to use. SHA is a hashing algorithm used by Certificate Authorities to actually sign certificates and CRLs (Certificate Revocation List) to generate unique hash values from files.</span><br/><br/>";
$_LANG['signature_algorithm_note_comodo']="You can generate all Comodo SSL Certificates with <b>ECC</b> as their <b>Signature Algorithm</b>, but you would need to submit an <b>ECC CSR</b> during this process.";
$_LANG['signature_algorithm_label']="Signature Algorithm";
$_LANG['sslcertapproveremail'] = "Domain Verification Options";
$_LANG['sslstore_custom_phrase_sslcertapproveremaildetails'] = "In this step, you must prove that you are actually in control of the domain you are attempting to secure. Simply choose one of the following pre-authorized email addresses associated with your domain. A <b>Certificate Approver Email</b> will be sent to this email, which must be completed for the vendor (CA) to issue the certificate.";
$_LANG['sslstore_custom_phrase_sslcertapproveremaildetails_with_filebased'] = "In this step, you must prove that you are actually in control of the domain you are attempting to secure. You can choose from the three options listed below: <b>File-Based Authentication</b> or <b> CNAME Based Authentication </b>or <b>Certificate Approver Email.</b><br /><br />If you select the <b>File-Based Authentication</b> method, the issuing vendor (CA) will provide you with a file to place on your server. Both the name and contents of the file will be provided to you in the last step of this process. Once the file has been placed, the vendor will attempt to ping it to verify control of the domain. <br /><br />If you select the <b>CNAME Based Authentication</b> option, the issuing vendor (CA) will provide you with two unique hash values to input as a CNAME record on the domain’s DNS. If done correctly, the vendor can view the record via a DNS lookup and issue the certificate upon confirmation. These two unique hash values will be provided to you in the last step of the process. <br/><br/>If you select the <b>Certificate Approver Email</b> option, you can choose from the following pre-authorized email addresses associated with your domain. You will receive an email at this address, which must be completed for the vendor (CA) to issue the certificate.";
$_LANG['sslstore_custom_phrase_certapproveremaildetails_san'] = "<br /><br />For example, if \"admin@\" is selected as the approver email and the common name is specified as \"domain.com\" and the addon (SAN) domain is \"sub.domain1.com\" , the approver emails will be sent to admin@domain.com and admin@sub.domain1.com.<br/><br/> You can change the approver email later in your control panel using the \"Change Approval Email\" option from the order details page.";
$_LANG['sslstore_authtxt_sslconfigcompletedetails'] = 'For File Based Authentication, Please create a folder structure "/.well-known/pki-validation/" under root directory and create a file using the following details, or download the Authentication file by clicking the "Download Auth File" button, and place it in the "/.well-known/pki-validation/" of the HTTP server, like so: %authfileurl%.<br />It may take some time for the file to be automatically validated and for the certificate to be issued by Certificate Authority<br /><br /><b>File Name : </b>%filename%<br /><b>File Content : </b>%content%<br /><br />%authfile%<br />';
$_LANG['sslstore_validated'] = 'Validated';
$_LANG['sslstore_validated'] = 'Not Validated';

$_LANG['sslconfigcompletedetails'] = "Your SSL certificate generation process has now been completed and sent to the Certificate Authority for validation. If there are any questions or issues, the Certificate Authority will reach out to the admin contact to clarify and resolve.";
$_LANG['sslstore_san_csr_note'] = 'You must explicitly state the appropriate SAN(s) you want to protect in the provided fields below. Any domains included in the SAN section of your CSR will be ignored.  </br></br><i><strong>Note:</strong> To avoid possible errors, please do not include the common name from your CSR or duplicate any SAN entries in the additional domain fields below.</i>';
$_LANG['sslstore_wildcard_san_csr_note'] = 'You must explicitly state the appropriate Wildcard SAN(s) you want to protect in the provided fields below. Any domains included in the SAN section of your CSR will be ignored.  </br></br><i><strong>Note:</strong> To avoid possible errors, please do not include the common name from your CSR or duplicate any Wildcard SAN entries in the additional wildcard domain fields below.</i>';
$_LANG['signature_algorithm_description']='<b>SHA-2</b><br /> Due to recent industry changes, SHA-2 is now the industry standard for all certificates. This option will provide you with a SHA-2 Certificate, SHA-2 Intermediate, and a SHA-1 Root. .<br /><br /><b>FULL SHA-2</b><br /> This option exceeds industry standards and is recommended only for advanced users. Similar to the SHA-2 option, the FULL SHA-2 option will provide you with the same SHA-2 Certificate and Intermediate, but a SHA-2 Root instead of SHA-1.';
$_LANG['signature_algorithm_description_securesitepro_ecc']='<b>SHA-2</b><br /> Due to recent industry changes, SHA-2 is now the industry standard for all SSL certificates. This option will provide you with a SHA-2 Certificate, SHA-2 Intermediate, and a SHA-1 Root. .<br /><br /><b>FULL SHA-2</b><br /> This option exceeds industry standards and is recommended only for advanced users. Similar to the SHA-2 option, the FULL SHA-2 option will provide you with the same SHA-2 Certificate and Intermediate, but a SHA-2 root instead of SHA-1.  <br/><br/><b>ECC-FULL</b><br /> Similar to the “FULL-SHA-2” option, Elliptic Curve Cryptography exceeds the industry standard and is recommend only for advanced users. For this option, you will need to supply an ECC CSR, which will be used to generate an ECC Certificate from an ECC Root. <br/><br/><b>ECC-HYBRID</b><br /><br/> Similar to the “ECC-FULL” option, Elliptic Curve Cryptography exceeds the industry standard and is recommend only for advanced users. For this option, you will need to supply an ECC CSR which will be used to generate an ECC Certificate but the Root will be RSA. This will provide you with the strength of ECC, and the browser compatibility of an RSA root.';
$_LANG['signature_algorithm_description_securesitepro_sha1']='<b>PRIVATE-SHA1-PCA3G1</b><br />RECOMMENDED: The PRIVATE SHA-1 PCA3G1 Root CA Certificate was a popular trusted root certificate embedded into older legacy applications or devices that supported the now outdated SHA-1 hashing algorithm. Please Note: This Root CA Certificate will only support RSA Certificate Signing Requests (CSRs); not DSA or ECC.<br /><br /><b>PRIVATE-SHA1-PCA3G2</b><br />The PRIVATE SHA-1 PCA3G2 Root CA Certificate was included in many older legacy applications and devices. This root certificate was typically used with older Windows Phone applications. You should check with your trusted root store before proceeding with this option. Please Note: This Root CA Certificate will only support RSA Certificate Signing Requests (CSRs); not DSA or ECC.';
$_LANG['sslconfsslcertificate'] = "NEXT STEP: Start the Generation Process";
$_LANG['sslserverinfodetails'] = "You must have a valid \"CSR\" (Certificate Signing Request) to generate your SSL Certificate. The CSR is an encrypted piece of text that is generated by the web server where the SSL Certificate will be installed. If you do not already have a CSR, you must generate one on your server or ask your web hosting provider to generate one for you. Please ensure you entered the correct information as it cannot be changed after the SSL Certificate has been issued. </br>When pasting your CSR, make sure it begins with: -----BEGIN NEW CERTIFICATE REQUEST----- and ends with: -----END NEW CERTIFICATE REQUEST-----<br/><br/>";
$_LANG['sslservertype'] = "Select Your Web Server";
$_LANG['sslcsr'] = "Input Your CSR:*";
$_LANG['ssladmininfodetails'] = "The contact information below will not be displayed on the issued Certificate; it will only be used for contacting you regarding this order and any validation requirements. The SSL Certificate details and renewal reminders will be sent to this contact. <br/><br/>";
$_LANG['clientareafirstname'] = "First Name:*";
$_LANG['clientarealastname'] = "Last Name:*";
$_LANG['organizationname'] = "Organization Name:*";
$_LANG['jobtitle'] = "Job Title:*";
$_LANG['jobtitlereqforcompany'] = "(Required if you’re stating your Organization Name above)";
$_LANG['clientareaemail'] = "Email Address:*";
$_LANG['clientareaaddress1'] = "Address 1:*";
$_LANG['clientareaaddress2'] = "Address 2:*";
$_LANG['clientareacity'] = "City:*";
$_LANG['clientareastate'] = "State/Region:*";
$_LANG['clientareapostcode'] = "Zip Code:*";
$_LANG['clientareacountry'] = "Country:*";
$_LANG['clientareaphonenumber'] = "Phone Number:*";

$_LANG['mass_selection_label']="Mass Selection";
$_LANG['applyselection']="Apply";
$_LANG['clearselection']="Clear Selection";

$_LANG['sslstore_techform_title'] = "<h2>Technical Contact Information</h2>";
$_LANG['sslstore_techform_desc'] = "<span class='regular'>This person will receive the certificate and is generally the individual that will be installing the certificate on the web server. They will also receive renewal notices when the certificate nears expiration to ensure no security lapses.</span><br/><br/>";
$_LANG['sslstore_TechFirstName'] = "First Name:*";
$_LANG['sslstore_TechLastName'] = "Last Name:*";
$_LANG['sslstore_TechEmail'] = 'Email Address:*';
$_LANG['sslstore_TechTitle'] = "Title:*";
$_LANG['sslstore_TechPhone'] = "Phone Number:*";
$_LANG['sslstore_cpanel_account_tooltip'] = "Preferred hosting profile for use with AutoInstall SSL token";


//Certificate generation
$_LANG['sslgenerationtitle'] = "Generate Certificate";
$_LANG['sslreissuetitle'] = "Reissue Certificate";
$_LANG['sslServerInfoTitle'] = "Server Information";
$_LANG['sslServerInfoDesc'] = "You must have a valid \"CSR\" (Certificate Signing Request) to generate your SSL Certificate. The CSR is an encrypted piece of text that is generated by the web server where the SSL Certificate will be installed. If you do not already have a CSR, you must generate one on your server or ask your web hosting provider to generate one for you. Please ensure you entered the correct information as it cannot be changed after the SSL Certificate has been issued. When pasting your CSR, make sure it begins with: -----BEGIN NEW CERTIFICATE REQUEST----- and ends with: -----END NEW CERTIFICATE REQUEST-----";
$_LANG['sslCSR'] = "Input CSR";
$_LANG['sslAdditionalSan'] = "Enter Additional SANs";
$_LANG['sslAdditionalWildCardSan'] = "Enter Additional Wildcard SANs";
$_LANG['sslAdminTitle'] = "Site Administrator Contact Information";
$_LANG['sslAdminDesc'] = "The contact information below will not be displayed on the issued Certificate; it will only be used for contacting you regarding this order and any validation requirements. The SSL Certificate details and renewal reminders will be sent to this contact.";
$_LANG['sslSameAsAdmin'] = "Same As Administrator Contact?";
$_LANG['sslTechTitle'] = "Technical Contact Information";
$_LANG['sslTechDesc'] = "This person will receive the certificate and is generally the individual that will be installing the certificate on the web server. They will also receive renewal notices when the certificate nears expiration to ensure no security lapses.";
$_LANG['sslTitle'] = "Title";
$_LANG['sslFirstName'] = "First Name";
$_LANG['sslLastName'] = "Last Name";
$_LANG['sslEmail'] = 'Email Address';
$_LANG['sslPhone'] = "Phone Number";
$_LANG['sslOrgTitle'] = "Organization Information";
$_LANG['sslOrgDesc'] = "Your product has premium business-level authentication, also known as Organization Validation (OV) or Extended Validation (EV). The information entered below will appear in your certificate. Please make sure this information matches EXACTLY with your CSR information and with your legal business registration documentation. The most common reason for delays in approval/issuance are because information does not match EXACTLY to what is listed in the Articles of Incorporation for your company, as listed in your region’s official third-party databases. Although a D&B/D-U-N-S/Dun & Bradstreet listing is not required, it may help expedite your request. If your organization is in the UK, please provide us your Registration Number in the D-U-N-S field below.";
$_LANG['sslOrgName'] = "Legal Name";
$_LANG['sslOrgDuns'] = "D-U-N-S® Number";
$_LANG['sslOrgDivision'] = "Department/Division";
$_LANG['sslOrgAddress1'] = "Address 1";
$_LANG['sslOrgAddress2'] = "Address 2";
$_LANG['sslOrgCity'] = "City";
$_LANG['sslOrgState'] = "State/Region";
$_LANG['sslOrgCountry'] = "Country";
$_LANG['sslOrgZipCode'] = "Postal or Zip Code";
$_LANG['sslDCVAuthTitle'] = "Domain Verification Options";
$_LANG['sslDCVAuthMethod'] = "Select Domain Authentication Method";
$_LANG['sslConfigCompleteMessage'] = "Congratulations! You have successfully completed configuration";
$_LANG['csrChoiceExisting'] = "Existing CSR";
$_LANG['csrChoiceAutoInstall'] = "AutoInstall";
$_LANG['csrOrg'] = "Organization";
$_LANG['csrOrgDivision'] = "Organization Unit";
$_LANG['csrKeySize'] = "Key Size";
$_LANG['csrGeneratebtn'] = "Generate CSR";
$_LANG['domainValidationTitle'] = "Choose Domain Validation Level";
$_LANG['domainValidationDesc'] = "Domains can either be validated at the exact level which they are submitted (sub.domain.com) or we can automatically validate at the first level: domain.com. We recommend Base Domain if you're not sure.";
$_LANG['baseDomainDetails'] = "Submit the base domain for validation (recommended)";
$_LANG['fqdnDetails'] = "Submit the domain name exactly as entered";


//Certificate Change Approval Method
$_LANG['sslchangeapprovaltitle'] = "Change Approval Method";
$_LANG['sslupdateapprovalbtn'] = "Update";
$_LANG['sslupdateapprovalsuccessmsg'] = "Approver Method Updated Successfully";

//cWatch Products
$_LANG['cWatchGenerateLicense'] = "Generate License Key";
$_LANG['sslGetLicenseTitle'] = "Get License";
$_LANG['sslUpdateSiteTitle'] = "Update Site";
$_LANG['sslDomainInfoTitle'] = "Domain Information";
$_LANG['sslDomainName'] = "Domain";
$_LANG['cWatchConfigCompleteDetails'] = "You’ve successfully claimed your cWatch Web license key(<strong>%licensekey%</strong>)! Our system is now working on setting up your website on the cWatch Web platform. Shortly, you should receive an email containing a unique link to set your password to login to the cWatch Web portal and complete setup. Download our guide below for help with your next steps setting up cWatch Web!<br /><br /><a href='https://certificategeneration.com/pdf/cWatch_Onboarding_Guide.pdf' target='_blank' class='btn btn-default'>Download cWatch Guide</a>";
$_LANG['sslLicenseKey'] = "License Key";
$_LANG['cwatchProvisioningDate'] = 'License Provisioning Date';
$_LANG['cwatchExpiryDate'] = 'License Expiry Date';
$_LANG['adminCountry'] = 'Country';
$_LANG['cWatchUpdateSitebtn'] = 'Update Site';
$_LANG['cWatchUpgradeLicensebtn'] = 'Upgrade License';
$_LANG['cWatchUpgradeLicenseTitle'] = "Upgrade License";
$_LANG['cWatchAdminLicenseDetails'] = 'License Details';
$_LANG['cwatchUpdateSiteSuccessmsg'] = "Site Updated Successfully";
$_LANG['cWatchLogin'] = "Login to cWatch";

//CodeGuard
$_LANG['codeguardAdminSubscriptionDetails'] = "Subscription Details";
$_LANG['codeguard_user_details'] = "User Details";
//codeGuard Products
$_LANG['codeGuardCreateUser'] = "Create Account";
$_LANG['codeGuardConfigCompleteDetails'] = "<strong>Your CodeGuard Subscription is Now Active</strong><br/>We’ve instantly activated your CodeGuard license – you can now protect your website with the most dependable website backup, monitoring, and restoration solution on the web! You can set up CodeGuard in just 5 minutes.";
$_LANG['codeGuardCancelRequest'] = "Cancel";
$_LANG['codeGuardUserInfoTitle'] = "Update User Information";
$_LANG['codeGuardUserName'] = "User Name";
$_LANG['codeGuardUserEmail'] = "User Email";
$_LANG['codeGuardSsoLink'] = "Access CodeGuard Dashboard";
$_LANG['codeGuardOrderStatus'] = "Order Status";
$_LANG['codeGuardSubscriptionStatus'] = "Subscription Status";
$_LANG['codeGuardSubscriptionId'] = "Subscription ID";
$_LANG['codeGuardStartDate'] = "Start Date";
$_LANG['codeGuardEndDate'] = "End Date";
$_LANG['codeGuardWebsiteList'] = "Website List";
$_LANG['codeGuardWebsite'] = "Website";
$_LANG['codeGuardLastBackup'] = "Last Backup";
$_LANG['codeGuardWebsiteSize'] = "Size";
$_LANG['codeGuardWebsiteStatus'] = "Status";
$_LANG['codeGuardEditUser'] = "Edit User";
$_LANG['codeGuardEditUserCompleteDetails'] = "Your CodeGuard User has been updated successfully.";
$_LANG['codeGuardAdditionalUserLabel'] = "Additional Users";
$_LANG['codeGuardAdditionalUserDesc'] = "You can grant access to additional users here. These users will be able to login via <strong>%cgloginurl%</strong>.";
$_LANG['codeGuardAddAdditionalUser'] = "Click here to add a user.";
$_LANG['codeGuardAdditionalUserInfoTitle'] = "Additional User Information";
$_LANG['codeGuardAdditionalUserPassword'] = "Password";
$_LANG['codeGuardAdditionalUserCompleteDetails'] = "Additional User has been added successfully.";

//AutoInstall Related
$_LANG['generate_ssl'] = "Auto Generate";
$_LANG['autogenerate_tooltip'] = "<strong>AutoInstall</strong> option is only available for WHM/cPanel servers, and automates the processes of CSR generation, verification when possible, and installation of the certificate. <strong>Existing CSR</strong> option can be used for all other cases, and requires manual generation of the CSR and installation of the certificate.";
$_LANG['sslIntstruction'] = "<strong>AutoInstall</strong> option is only available for WHM/cPanel servers, and automates the processes of CSR generation, verification when possible, and installation of the certificate. <strong>Existing CSR</strong> option can be used for all other cases, and requires manual generation of the CSR and installation of the certificate.";
$_LANG['sslProfileLabel'] = "Select Your preferred hosting profile to use with the Automated Process";
$_LANG['sslDomainLabel'] = "Select Your Domain/webspace";
$_LANG['sslProfileDesc'] = "Based on the Hosting Profile Selection the Domain List will be available";
$_LANG['sslDomainDesc'] = "This Domain will be used in CSR generation and Certificate Installation";
$_LANG['sslWWWLabel'] = "Would you like to use 'www' during the CSR generation?";
$_LANG['sslWWWDesc'] = "If generated as <u>www.name-of-site.com</u>, it will cover both www and non-www URLs.";
$_LANG['retrievesubdomain'] = "Retrieve Sub Domain";
$_LANG['sslCSRTitle'] = "CSR Details";
$_LANG['sslCSRDesc'] = "This information will be used in CSR generation.";
$_LANG['sslCSRCommonName'] = "Common Name";
$_LANG['sslCSRCompany'] = "Company";
$_LANG['sslCSRDivision'] = "Division";
$_LANG['sslCSRCity'] = "City";
$_LANG['sslCSRState'] = "State";
$_LANG['sslCSRCountry'] = "Country";
$_LANG['sslCSREmail'] = "Email";
$_LANG['addDomainToolTip'] = "Click to Add Domain";
$_LANG['addWildCardDomainToolTip'] = "Click to Add Wildcard Domain";
$_LANG['removeDomainToolTip'] = "Click to Remove Domain";
$_LANG['removeWildCardDomainToolTip'] = "Click to Remove Wildcard Domain";
$_LANG['ReissueSSLDomainLabel'] = "Domain/webspace";
$_LANG['download_pvtkey'] = "Download&nbsp;Private Key";
$_LANG['install_certificate'] = "Install&nbsp;Certificate";
$_LANG['auto_reissue_cert'] = "AutoSSL&nbsp;Re-issue";
$_LANG['autossl_reissue_tooltip'] = "<strong>AutoSSL Re-issue</strong> option is only available for WHM/cPanel servers, and automates the processes of CSR generation, verification when possible, and installation of the certificate. <strong>Re-issue Certificate</strong> option can be used for all other cases, and requires manual generation of the CSR and installation of the certificate.";
$_LANG['autossl_pvtkey_tooltip'] = "Your Certificate Private Key is stored upon your cPanel Server and when clicked will be retrieved from the cPanel Server.";
$_LANG['autossl_process_msg'] = "Please allow two to three minutes as we complete the generation, validation, and installation of your SSL Certificate.";
$_LANG['nonHttpDownloadKeyError'] = "Sorry, you are currently not able to download your certificate’s key because you are not accessing the website using SSL. Please connect using HTTPS:// and try again.";

//Digicert Products
$_LANG['newOrgDetails'] = "Create New Organization";
$_LANG['preAuthOrgDetails'] = "Use Existing Organization Details";
$_LANG['sslOrgContact'] = "Organization's Primary Contact";
$_LANG['sslOrgStatus'] = 'Status';
$_LANG['sslOrgId'] = 'Organization Id';
$_LANG['sslOrgVendorId'] = 'Vendor Org. Id';
$_LANG['invalid_access_error'] = 'Sorry! Invalid Access!';
$_LANG['digicert_combined_cert_files'] = 'Combined Certificate Files';
$_LANG['digicert_server_platform'] = 'Server Platform';
$_LANG['digicert_file_type'] = 'File Type';
$_LANG['download_cert_with_ca'] = 'Download Certificate With CA Bundle';
$_LANG['sslOrgInfo'] = 'Organization Info';
$_LANG['assign_license'] = 'Assign License';
$_LANG['assign_license_title'] = 'Sign to SiteLock';
$_LANG['assign_license_sub_title'] = 'Single sign-in to SiteLock Now';
$_LANG['upgrade_subscription_text'] = 'UPGRADE';
?>