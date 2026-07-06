<?php
if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}
$_LANG['certificate_details'] = "Zertifikatsdetails";
$_LANG['sslstatus'] = "Bestellstatus";
$_LANG['ssl_store_orderid'] = "Shop-Bestellnummer";
$_LANG['ssl_provisioning_date'] = "SSL-Bereitstellungsdatum";
$_LANG['ssl_expiry_date'] = "SSL-Ablaufdatum";
$_LANG['order_expiry_date'] = "Bestellablaufdatum";
$_LANG['ssl_vendor_status'] = "Anbieterstatus";
$_LANG['ssl_product_name'] = "Produktname";
$_LANG['ssl_vendor_orderid'] = "Anbieter-Bestellnummer";
$_LANG['ssl_verification_email'] = "Bestätigungs-E-Mail";
$_LANG['ssl_poll_status'] = "Datei-Authentifizierungsstatus";
$_LANG['ssl_poll_date'] = "Letztes Dateiprüfdatum";
$_LANG['AuthenticationStatuses'] = "Authentifizierungsstatus";
$_LANG['AuthenticationStep'] = "Authentifizierungsschritt";
$_LANG['AuthenticationStatus'] = "Authentifizierungsstatus";
$_LANG['LastUpdated'] = "Zuletzt aktualisiert";
$_LANG['AuthenticationComments'] = "Authentifizierungskommentare";
$_LANG['cname_details'] = "DNS-Details";
$_LANG['certificate_delivery_method'] = "Zertifikatsliefermethode";
$_LANG['cname_dns'] = "Host";
$_LANG['cname_point_to'] = "Ziel";
$_LANG['validation_status'] = "Validierungsstatus";
$_LANG['validation_email'] = "E-Mail-Validierung";
$_LANG['validationemail_urlLabel'] = "E-Mail-Adresse:";
$_LANG['validation_dns'] = "DNS-Verifizierung";
$_LANG['validationdns_urlLabel'] = "TXT-Wert:";
$_LANG['validationdns_URLContentLabel'] = "Hostname:";
$_LANG['validation_http'] = "HTTP-Validierung";
$_LANG['validationhttp_urlLabel'] = "Datei-URL:";
$_LANG['validationhttp_URLContentLabel'] = "Dateiinhalt";
$_LANG['validation_https'] = "HTTPS-Validierung";
$_LANG['validationhttps_urlLabel'] = "Datei-URL:'";
$_LANG['validationhttps_URLContentLabel'] = "Dateiinhalt";
$_LANG['validation_cname'] = "CNAME-Verifizierung";
$_LANG['validationcname_urlLabel'] = "Alias/Hostname:";
$_LANG['validationcname_URLContentLabel'] = "Verweist auf:";
$_LANG['authMethod'] = "Authentifizierungsmethode";

$_LANG['dns_txt_info'] = "Die folgenden Schritte erstellen einen TXT-Eintrag.<br/>

    1. Wählen Sie als Eintragstyp TXT aus.<br/>
    2. Geben Sie im Feld Name/Host/Alias @ ein oder lassen Sie es leer. Ihre anderen DNS-Einträge können angeben, welche Option Sie verwenden sollen.<br/>
    3. Geben Sie im Feld Time to Live (TTL) 3600 ein oder belassen Sie den Standardwert.<br/>
    4. Fügen Sie im Feld Wert/Antwort/Ziel diesen Wert ein: %txtrecord%.<br/>
    5. Speichern Sie den Eintrag.
";


$_LANG['ssl_san_details'] = "Gesamte SANs";
$_LANG['admin_details'] = "Administrator-Details";
$_LANG['admin_firstname'] = "Vorname";
$_LANG['admin_lastname'] = "Nachname";
$_LANG['admin_email'] = "E-Mail";
$_LANG['admin_title'] = "Titel";
$_LANG['admin_phone'] = "Telefon";
$_LANG['tech_details'] = "Technische Details";
$_LANG['tech_firstname'] = "Vorname";
$_LANG['tech_lastname'] = "Nachname";
$_LANG['tech_email'] = "E-Mail";
$_LANG['tech_title'] = "Titel";
$_LANG['tech_phone'] = "Telefon";
$_LANG['domains'] = "Domain(s)";
$_LANG['site_seal'] = "Ihr Website-Siegel erhalten";
$_LANG['refund_status_id'] = "Erstattungsstatus-ID";
$_LANG['download_cert'] = "Zertifikat&nbsp;herunterladen";
$_LANG['auth_file'] = "Auth-Datei&nbsp;herunterladen";
$_LANG['refund_req'] = "Zertifikat&nbsp;stornieren";
$_LANG['reissue_cert'] = "Zertifikat&nbsp;neu ausstellen";
$_LANG['buy_more_san_btn'] = "Zusätzliche SANs kaufen";
$_LANG['buy_more_san_tooltip'] = "Nach dem Einreichen des Upgrades wird eine entsprechende Rechnung erstellt. <br>Nach der Zahlung wird der Dienst entsprechend angepasst. Um zusätzliche SANs zum Zertifikat hinzuzufügen, sollten Sie die Aktion \"Neu ausstellen\" des Zertifikats ausführen";
$_LANG['save'] = "Speichern";
$_LANG['check_order_status'] = "Status&nbsp;prüfen";
$_LANG['generate_cert'] = "Jetzt generieren";
$_LANG['resend_approver_email'] = "Genehmigungs-E-Mail&nbsp;erneut senden";
$_LANG['change_approver_email'] = "Genehmigungs-E-Mail&nbsp;ändern";
$_LANG['change_approver_method'] = "Genehmigungsmethode&nbsp;ändern";
$_LANG['emailmessage'] = "Vielen Dank für Ihre Bestellung! Ihr Kauf erfordert nun einige zusätzliche Konfigurationen, die unter folgender URL durchgeführt werden können:";
$_LANG['refund_status_id'] = "SSL-Vorfall-ID";
$_LANG['token'] = "Token";
$_LANG['token_code'] = "Token-Code";
$_LANG['token_id'] = "Token-ID";
$_LANG['tokens_tooltip'] = "Dies wird NUR verwendet, wenn Ihre Hosting-Plattform die AutoInstall SSL&trade;-Technologie nutzt. Wenn Ihr Control Panel das AutoInstall SSL&trade;-Plugin unterstützt, kopieren Sie den Token einfach in das Plugin, wenn Sie dazu aufgefordert werden.";
$_LANG['additional_san']="Zusätzliche Domains eingeben:*";
$_LANG['additional_san_label']="Addon-Domain";
$_LANG['signature_algorithm_note']="Signaturalgorithmus auswählen:<br/><span class='regular'>Bitte wählen Sie den Secure-Hashing-Algorithmus (SHA), den Sie verwenden möchten. SHA ist ein Hashing-Algorithmus, der von Zertifizierungsstellen verwendet wird, um Zertifikate und CRLs (Zertifikatsperrliste) zu signieren und eindeutige Hash-Werte aus Dateien zu erzeugen.</span><br/><br/>";
$_LANG['signature_algorithm_note_comodo']="Sie können alle Comodo SSL-Zertifikate mit <b>ECC</b> als <b>Signaturalgorithmus</b> generieren, müssen jedoch während dieses Vorgangs einen <b>ECC-CSR</b> einreichen.";
$_LANG['signature_algorithm_label']="Signaturalgorithmus";
$_LANG['sslcertapproveremail'] = "Domain-Verifizierungsoptionen";
$_LANG['sslstore_custom_phrase_sslcertapproveremaildetails'] = "In diesem Schritt müssen Sie nachweisen, dass Sie tatsächlich die Kontrolle über die zu sichernde Domain haben. Wählen Sie einfach eine der folgenden vorab autorisierten E-Mail-Adressen für Ihre Domain aus. Eine <b>Zertifikatsgenehmigungsmail</b> wird an diese Adresse gesendet, die ausgefüllt werden muss, damit der Anbieter (CA) das Zertifikat ausstellen kann.";
$_LANG['sslstore_custom_phrase_sslcertapproveremaildetails_with_filebased'] = "In diesem Schritt müssen Sie nachweisen, dass Sie tatsächlich die Kontrolle über die zu sichernde Domain haben. Sie können aus den drei unten aufgeführten Optionen wählen: <b>Dateibasierte Authentifizierung</b>, <b>CNAME-basierte Authentifizierung</b> oder <b>Zertifikatsgenehmigungsmail</b>.<br /><br />Wenn Sie die <b>dateibasierte Authentifizierung</b> wählen, stellt der ausstellende Anbieter (CA) eine Datei bereit, die Sie auf Ihrem Server ablegen müssen. Sowohl der Dateiname als auch der Inhalt werden Ihnen im letzten Schritt mitgeteilt. Sobald die Datei abgelegt ist, versucht der Anbieter, sie zur Verifizierung der Domain abzurufen.<br /><br />Wenn Sie die <b>CNAME-basierte Authentifizierung</b> wählen, stellt der ausstellende Anbieter (CA) zwei eindeutige Hash-Werte bereit, die Sie als CNAME-Eintrag im DNS der Domain eintragen müssen. Der Anbieter kann den Eintrag per DNS-Lookup prüfen und das Zertifikat nach Bestätigung ausstellen. Diese Hash-Werte werden Ihnen im letzten Schritt mitgeteilt.<br/><br/>Wenn Sie die <b>Zertifikatsgenehmigungsmail</b> wählen, können Sie aus den folgenden vorab autorisierten E-Mail-Adressen für Ihre Domain auswählen. Sie erhalten eine E-Mail an diese Adresse, die ausgefüllt werden muss, damit der Anbieter (CA) das Zertifikat ausstellen kann.";
$_LANG['sslstore_custom_phrase_certapproveremaildetails_san'] = "<br /><br />Wenn zum Beispiel \"admin@\" als Genehmigungs-E-Mail ausgewählt ist und der Common Name \"domain.com\" lautet und die Addon-Domain (SAN) \"sub.domain1.com\" ist, werden die Genehmigungs-E-Mails an admin@domain.com und admin@sub.domain1.com gesendet.<br/><br/> Sie können die Genehmigungs-E-Mail später in Ihrem Control Panel über die Option \"Genehmigungs-E-Mail ändern\" auf der Bestelldetailseite anpassen.";
$_LANG['sslstore_authtxt_sslconfigcompletedetails'] = 'Für die dateibasierte Authentifizierung erstellen Sie bitte die Ordnerstruktur "/.well-known/pki-validation/" im Stammverzeichnis und legen Sie eine Datei mit den folgenden Details an, oder laden Sie die Authentifizierungsdatei durch Klicken auf die Schaltfläche "Auth-Datei herunterladen" herunter und platzieren Sie sie unter "/.well-known/pki-validation/" des HTTP-Servers, wie folgt: %authfileurl%.<br />Es kann einige Zeit dauern, bis die Datei automatisch validiert und das Zertifikat von der Zertifizierungsstelle ausgestellt wird.<br /><br /><b>Dateiname: </b>%filename%<br /><b>Dateiinhalt: </b>%content%<br /><br />%authfile%<br />';
$_LANG['sslstore_validated'] = 'Validiert';
$_LANG['sslstore_validated'] = 'Nicht validiert';

$_LANG['sslconfigcompletedetails'] = "Ihr SSL-Zertifikatsgenerierungsprozess wurde abgeschlossen und zur Validierung an die Zertifizierungsstelle übermittelt. Bei Fragen oder Problemen wird sich die Zertifizierungsstelle an den Administrator-Kontakt wenden, um diese zu klären und zu lösen.";
$_LANG['sslstore_san_csr_note'] = 'Sie müssen die zu schützenden SAN(s) explizit in den vorgesehenen Feldern angeben. Alle im SAN-Abschnitt Ihres CSR enthaltenen Domains werden ignoriert. </br></br><i><strong>Hinweis:</strong> Um mögliche Fehler zu vermeiden, geben Sie bitte nicht den Common Name aus Ihrem CSR an und wiederholen Sie keine SAN-Einträge in den zusätzlichen Domain-Feldern.</i>';
$_LANG['sslstore_wildcard_san_csr_note'] = 'Sie müssen die zu schützenden Wildcard-SAN(s) explizit in den vorgesehenen Feldern angeben. Alle im SAN-Abschnitt Ihres CSR enthaltenen Domains werden ignoriert. </br></br><i><strong>Hinweis:</strong> Um mögliche Fehler zu vermeiden, geben Sie bitte nicht den Common Name aus Ihrem CSR an und wiederholen Sie keine Wildcard-SAN-Einträge in den zusätzlichen Wildcard-Domain-Feldern.</i>';
$_LANG['signature_algorithm_description']='<b>SHA-2</b><br /> Aufgrund aktueller Branchenänderungen ist SHA-2 nun der Industriestandard für alle Zertifikate. Diese Option liefert Ihnen ein SHA-2-Zertifikat, ein SHA-2-Zwischenzertifikat und ein SHA-1-Stammzertifikat.<br /><br /><b>VOLLSTÄNDIGES SHA-2</b><br /> Diese Option übertrifft die Industriestandards und wird nur für fortgeschrittene Benutzer empfohlen. Ähnlich wie die SHA-2-Option liefert die vollständige SHA-2-Option dasselbe SHA-2-Zertifikat und -Zwischenzertifikat, jedoch ein SHA-2-Stammzertifikat anstelle von SHA-1.';
$_LANG['signature_algorithm_description_securesitepro_ecc']='<b>SHA-2</b><br /> Aufgrund aktueller Branchenänderungen ist SHA-2 nun der Industriestandard für alle SSL-Zertifikate. Diese Option liefert Ihnen ein SHA-2-Zertifikat, ein SHA-2-Zwischenzertifikat und ein SHA-1-Stammzertifikat.<br /><br /><b>VOLLSTÄNDIGES SHA-2</b><br /> Diese Option übertrifft die Industriestandards und wird nur für fortgeschrittene Benutzer empfohlen. Ähnlich wie die SHA-2-Option liefert die vollständige SHA-2-Option dasselbe SHA-2-Zertifikat und -Zwischenzertifikat, jedoch ein SHA-2-Stammzertifikat anstelle von SHA-1. <br/><br/><b>ECC-FULL</b><br /> Ähnlich wie die Option "FULL-SHA-2" übertrifft Elliptic Curve Cryptography den Industriestandard und wird nur für fortgeschrittene Benutzer empfohlen. Für diese Option müssen Sie einen ECC-CSR bereitstellen, der zur Generierung eines ECC-Zertifikats aus einem ECC-Stammzertifikat verwendet wird. <br/><br/><b>ECC-HYBRID</b><br /><br/> Ähnlich wie die Option "ECC-FULL" übertrifft Elliptic Curve Cryptography den Industriestandard und wird nur für fortgeschrittene Benutzer empfohlen. Für diese Option müssen Sie einen ECC-CSR bereitstellen, der zur Generierung eines ECC-Zertifikats verwendet wird, während das Stammzertifikat RSA bleibt. Dies bietet Ihnen die Stärke von ECC und die Browser-Kompatibilität eines RSA-Stammzertifikats.';
$_LANG['signature_algorithm_description_securesitepro_sha1']='<b>PRIVATE-SHA1-PCA3G1</b><br />EMPFOHLEN: Das PRIVATE SHA-1 PCA3G1 Root-CA-Zertifikat war ein weit verbreitetes vertrauenswürdiges Stammzertifikat in älteren Legacy-Anwendungen oder Geräten, die den inzwischen veralteten SHA-1-Hashing-Algorithmus unterstützten. Bitte beachten Sie: Dieses Root-CA-Zertifikat unterstützt nur RSA Certificate Signing Requests (CSRs), nicht DSA oder ECC.<br /><br /><b>PRIVATE-SHA1-PCA3G2</b><br />Das PRIVATE SHA-1 PCA3G2 Root-CA-Zertifikat war in vielen älteren Legacy-Anwendungen und Geräten enthalten. Dieses Stammzertifikat wurde typischerweise mit älteren Windows Phone-Anwendungen verwendet. Bitte prüfen Sie Ihren vertrauenswürdigen Zertifikatsspeicher, bevor Sie mit dieser Option fortfahren. Bitte beachten Sie: Dieses Root-CA-Zertifikat unterstützt nur RSA Certificate Signing Requests (CSRs), nicht DSA oder ECC.';
$_LANG['sslconfsslcertificate'] = "NÄCHSTER SCHRITT: Generierungsprozess starten";
$_LANG['sslserverinfodetails'] = "Sie benötigen einen gültigen \"CSR\" (Certificate Signing Request), um Ihr SSL-Zertifikat zu generieren. Der CSR ist ein verschlüsselter Textblock, der vom Webserver generiert wird, auf dem das SSL-Zertifikat installiert wird. Falls Sie noch keinen CSR haben, müssen Sie diesen auf Ihrem Server generieren oder Ihren Webhosting-Anbieter bitten, dies für Sie zu tun. Bitte stellen Sie sicher, dass Sie die korrekten Informationen eingegeben haben, da diese nach der Ausstellung des SSL-Zertifikats nicht mehr geändert werden können. </br>Wenn Sie Ihren CSR einfügen, stellen Sie sicher, dass er beginnt mit: -----BEGIN NEW CERTIFICATE REQUEST----- und endet mit: -----END NEW CERTIFICATE REQUEST-----<br/><br/>";
$_LANG['sslservertype'] = "Ihren Webserver auswählen";
$_LANG['sslcsr'] = "Ihren CSR eingeben:*";
$_LANG['ssladmininfodetails'] = "Die unten stehenden Kontaktinformationen werden nicht im ausgestellten Zertifikat angezeigt; sie werden nur für die Kontaktaufnahme bezüglich dieser Bestellung und etwaiger Validierungsanforderungen verwendet. Die SSL-Zertifikatsdetails und Verlängerungserinnerungen werden an diesen Kontakt gesendet.<br/><br/>";
$_LANG['clientareafirstname'] = "Vorname:*";
$_LANG['clientarealastname'] = "Nachname:*";
$_LANG['organizationname'] = "Organisationsname:*";
$_LANG['jobtitle'] = "Berufsbezeichnung:*";
$_LANG['jobtitlereqforcompany'] = "(Erforderlich, wenn Sie oben Ihren Organisationsnamen angeben)";
$_LANG['clientareaemail'] = "E-Mail-Adresse:*";
$_LANG['clientareaaddress1'] = "Adresse 1:*";
$_LANG['clientareaaddress2'] = "Adresse 2:*";
$_LANG['clientareacity'] = "Stadt:*";
$_LANG['clientareastate'] = "Bundesland/Region:*";
$_LANG['clientareapostcode'] = "Postleitzahl:*";
$_LANG['clientareacountry'] = "Land:*";
$_LANG['clientareaphonenumber'] = "Telefonnummer:*";

$_LANG['mass_selection_label']="Massenauswahl";
$_LANG['applyselection']="Anwenden";
$_LANG['clearselection']="Auswahl löschen";

$_LANG['sslstore_techform_title'] = "<h2>Technische Kontaktinformationen</h2>";
$_LANG['sslstore_techform_desc'] = "<span class='regular'>Diese Person erhält das Zertifikat und ist in der Regel diejenige, die das Zertifikat auf dem Webserver installiert. Sie erhält auch Verlängerungsbenachrichtigungen, wenn das Zertifikat bald abläuft, um Sicherheitslücken zu vermeiden.</span><br/><br/>";
$_LANG['sslstore_TechFirstName'] = "Vorname:*";
$_LANG['sslstore_TechLastName'] = "Nachname:*";
$_LANG['sslstore_TechEmail'] = 'E-Mail-Adresse:*';
$_LANG['sslstore_TechTitle'] = "Titel:*";
$_LANG['sslstore_TechPhone'] = "Telefonnummer:*";
$_LANG['sslstore_cpanel_account_tooltip'] = "Bevorzugtes Hosting-Profil für die Verwendung mit dem AutoInstall SSL-Token";


//Certificate generation
$_LANG['sslgenerationtitle'] = "Zertifikat generieren";
$_LANG['sslreissuetitle'] = "Zertifikat neu ausstellen";
$_LANG['sslServerInfoTitle'] = "Serverinformationen";
$_LANG['sslServerInfoDesc'] = "Sie benötigen einen gültigen \"CSR\" (Certificate Signing Request), um Ihr SSL-Zertifikat zu generieren. Der CSR ist ein verschlüsselter Textblock, der vom Webserver generiert wird, auf dem das SSL-Zertifikat installiert wird. Falls Sie noch keinen CSR haben, müssen Sie diesen auf Ihrem Server generieren oder Ihren Webhosting-Anbieter bitten, dies für Sie zu tun. Bitte stellen Sie sicher, dass Sie die korrekten Informationen eingegeben haben, da diese nach der Ausstellung des SSL-Zertifikats nicht mehr geändert werden können. Wenn Sie Ihren CSR einfügen, stellen Sie sicher, dass er beginnt mit: -----BEGIN NEW CERTIFICATE REQUEST----- und endet mit: -----END NEW CERTIFICATE REQUEST-----";
$_LANG['sslCSR'] = "CSR eingeben";
$_LANG['sslAdditionalSan'] = "Zusätzliche SANs eingeben";
$_LANG['sslAdditionalWildCardSan'] = "Zusätzliche Wildcard-SANs eingeben";
$_LANG['sslAdminTitle'] = "Kontaktinformationen des Website-Administrators";
$_LANG['sslAdminDesc'] = "Die unten stehenden Kontaktinformationen werden nicht im ausgestellten Zertifikat angezeigt; sie werden nur für die Kontaktaufnahme bezüglich dieser Bestellung und etwaiger Validierungsanforderungen verwendet. Die SSL-Zertifikatsdetails und Verlängerungserinnerungen werden an diesen Kontakt gesendet.";
$_LANG['sslSameAsAdmin'] = "Identisch mit Administrator-Kontakt?";
$_LANG['sslTechTitle'] = "Technische Kontaktinformationen";
$_LANG['sslTechDesc'] = "Diese Person erhält das Zertifikat und ist in der Regel diejenige, die das Zertifikat auf dem Webserver installiert. Sie erhält auch Verlängerungsbenachrichtigungen, wenn das Zertifikat bald abläuft, um Sicherheitslücken zu vermeiden.";
$_LANG['sslTitle'] = "Titel";
$_LANG['sslFirstName'] = "Vorname";
$_LANG['sslLastName'] = "Nachname";
$_LANG['sslEmail'] = 'E-Mail-Adresse';
$_LANG['sslPhone'] = "Telefonnummer";
$_LANG['sslOrgTitle'] = "Organisationsinformationen";
$_LANG['sslOrgDesc'] = "Ihr Produkt verfügt über eine erweiterte Authentifizierung auf Unternehmensebene, auch bekannt als Organization Validation (OV) oder Extended Validation (EV). Die unten eingegebenen Informationen erscheinen in Ihrem Zertifikat. Bitte stellen Sie sicher, dass diese Informationen GENAU mit Ihren CSR-Informationen und Ihren offiziellen Unternehmensregistrierungsdokumenten übereinstimmen. Der häufigste Grund für Verzögerungen bei der Genehmigung/Ausstellung ist, dass Informationen nicht GENAU mit den Angaben in den Gründungsdokumenten des Unternehmens übereinstimmen, wie sie in den offiziellen Datenbanken Ihrer Region aufgeführt sind. Obwohl ein D&B/D-U-N-S/Dun & Bradstreet-Eintrag nicht erforderlich ist, kann er Ihren Antrag beschleunigen. Wenn Ihre Organisation in Großbritannien ansässig ist, geben Sie bitte Ihre Registrierungsnummer im D-U-N-S-Feld unten an.";
$_LANG['sslOrgName'] = "Offizieller Name";
$_LANG['sslOrgDuns'] = "D-U-N-S®-Nummer";
$_LANG['sslOrgDivision'] = "Abteilung/Bereich";
$_LANG['sslOrgAddress1'] = "Adresse 1";
$_LANG['sslOrgAddress2'] = "Adresse 2";
$_LANG['sslOrgCity'] = "Stadt";
$_LANG['sslOrgState'] = "Bundesland/Region";
$_LANG['sslOrgCountry'] = "Land";
$_LANG['sslOrgZipCode'] = "Postleitzahl";
$_LANG['sslDCVAuthTitle'] = "Domain-Verifizierungsoptionen";
$_LANG['sslDCVAuthMethod'] = "Domain-Authentifizierungsmethode auswählen";
$_LANG['sslConfigCompleteMessage'] = "Herzlichen Glückwunsch! Sie haben die Konfiguration erfolgreich abgeschlossen";
$_LANG['csrChoiceExisting'] = "Vorhandener CSR";
$_LANG['csrChoiceAutoInstall'] = "AutoInstall";
$_LANG['csrOrg'] = "Organisation";
$_LANG['csrOrgDivision'] = "Organisationseinheit";
$_LANG['csrKeySize'] = "Schlüsselgröße";
$_LANG['csrGeneratebtn'] = "CSR generieren";
$_LANG['domainValidationTitle'] = "Domain-Validierungsstufe auswählen";
$_LANG['domainValidationDesc'] = "Domains können entweder auf der genauen Ebene validiert werden, auf der sie eingereicht wurden (sub.domain.com), oder wir können automatisch auf der ersten Ebene validieren: domain.com. Wir empfehlen \"Basisdomain\", wenn Sie sich nicht sicher sind.";
$_LANG['baseDomainDetails'] = "Basisdomain zur Validierung einreichen (empfohlen)";
$_LANG['fqdnDetails'] = "Domain genau wie eingegeben einreichen";


//Certificate Change Approval Method
$_LANG['sslchangeapprovaltitle'] = "Genehmigungsmethode ändern";
$_LANG['sslupdateapprovalbtn'] = "Aktualisieren";
$_LANG['sslupdateapprovalsuccessmsg'] = "Genehmigungsmethode erfolgreich aktualisiert";

//cWatch Products
$_LANG['cWatchGenerateLicense'] = "Lizenzschlüssel generieren";
$_LANG['sslGetLicenseTitle'] = "Lizenz erhalten";
$_LANG['sslUpdateSiteTitle'] = "Website aktualisieren";
$_LANG['sslDomainInfoTitle'] = "Domain-Informationen";
$_LANG['sslDomainName'] = "Domain";
$_LANG['cWatchConfigCompleteDetails'] = "Sie haben Ihren cWatch Web-Lizenzschlüssel (<strong>%licensekey%</strong>) erfolgreich beansprucht! Unser System richtet nun Ihre Website auf der cWatch Web-Plattform ein. In Kürze erhalten Sie eine E-Mail mit einem einzigartigen Link zum Festlegen Ihres Passworts für das cWatch Web-Portal und zur Fertigstellung der Einrichtung. Laden Sie unseren Leitfaden unten herunter, um Hilfe bei den nächsten Schritten zur Einrichtung von cWatch Web zu erhalten!<br /><br /><a href='https://certificategeneration.com/pdf/cWatch_Onboarding_Guide.pdf' target='_blank' class='btn btn-default'>cWatch-Leitfaden herunterladen</a>";
$_LANG['sslLicenseKey'] = "Lizenzschlüssel";
$_LANG['cwatchProvisioningDate'] = 'Lizenz-Bereitstellungsdatum';
$_LANG['cwatchExpiryDate'] = 'Lizenz-Ablaufdatum';
$_LANG['adminCountry'] = 'Land';
$_LANG['cWatchUpdateSitebtn'] = 'Website aktualisieren';
$_LANG['cWatchUpgradeLicensebtn'] = 'Lizenz upgraden';
$_LANG['cWatchUpgradeLicenseTitle'] = "Lizenz upgraden";
$_LANG['cWatchAdminLicenseDetails'] = 'Lizenzdetails';
$_LANG['cwatchUpdateSiteSuccessmsg'] = "Website erfolgreich aktualisiert";
$_LANG['cWatchLogin'] = "Bei cWatch anmelden";

//CodeGuard
$_LANG['codeguardAdminSubscriptionDetails'] = "Abonnementdetails";
$_LANG['codeguard_user_details'] = "Benutzerdetails";
//codeGuard Products
$_LANG['codeGuardCreateUser'] = "Konto erstellen";
$_LANG['codeGuardConfigCompleteDetails'] = "<strong>Ihr CodeGuard-Abonnement ist jetzt aktiv</strong><br/>Wir haben Ihre CodeGuard-Lizenz sofort aktiviert – Sie können Ihre Website nun mit der zuverlässigsten Website-Backup-, Überwachungs- und Wiederherstellungslösung im Internet schützen! Sie können CodeGuard in nur 5 Minuten einrichten.";
$_LANG['codeGuardCancelRequest'] = "Abbrechen";
$_LANG['codeGuardUserInfoTitle'] = "Benutzerinformationen aktualisieren";
$_LANG['codeGuardUserName'] = "Benutzername";
$_LANG['codeGuardUserEmail'] = "Benutzer-E-Mail";
$_LANG['codeGuardSsoLink'] = "Auf CodeGuard-Dashboard zugreifen";
$_LANG['codeGuardOrderStatus'] = "Bestellstatus";
$_LANG['codeGuardSubscriptionStatus'] = "Abonnementstatus";
$_LANG['codeGuardSubscriptionId'] = "Abonnement-ID";
$_LANG['codeGuardStartDate'] = "Startdatum";
$_LANG['codeGuardEndDate'] = "Enddatum";
$_LANG['codeGuardWebsiteList'] = "Website-Liste";
$_LANG['codeGuardWebsite'] = "Website";
$_LANG['codeGuardLastBackup'] = "Letztes Backup";
$_LANG['codeGuardWebsiteSize'] = "Größe";
$_LANG['codeGuardWebsiteStatus'] = "Status";
$_LANG['codeGuardEditUser'] = "Benutzer bearbeiten";
$_LANG['codeGuardEditUserCompleteDetails'] = "Ihr CodeGuard-Benutzer wurde erfolgreich aktualisiert.";
$_LANG['codeGuardAdditionalUserLabel'] = "Zusätzliche Benutzer";
$_LANG['codeGuardAdditionalUserDesc'] = "Hier können Sie zusätzlichen Benutzern Zugang gewähren. Diese Benutzer können sich über <strong>%cgloginurl%</strong> anmelden.";
$_LANG['codeGuardAddAdditionalUser'] = "Klicken Sie hier, um einen Benutzer hinzuzufügen.";
$_LANG['codeGuardAdditionalUserInfoTitle'] = "Informationen zum zusätzlichen Benutzer";
$_LANG['codeGuardAdditionalUserPassword'] = "Passwort";
$_LANG['codeGuardAdditionalUserCompleteDetails'] = "Zusätzlicher Benutzer wurde erfolgreich hinzugefügt.";

//AutoInstall Related
$_LANG['generate_ssl'] = "Automatisch generieren";
$_LANG['autogenerate_tooltip'] = "Die Option <strong>AutoInstall</strong> ist nur für WHM/cPanel-Server verfügbar und automatisiert die CSR-Generierung, Verifizierung (wenn möglich) und Installation des Zertifikats. Die Option <strong>Vorhandener CSR</strong> kann für alle anderen Fälle verwendet werden und erfordert die manuelle Generierung des CSR sowie die manuelle Installation des Zertifikats.";
$_LANG['sslIntstruction'] = "Die Option <strong>AutoInstall</strong> ist nur für WHM/cPanel-Server verfügbar und automatisiert die CSR-Generierung, Verifizierung (wenn möglich) und Installation des Zertifikats. Die Option <strong>Vorhandener CSR</strong> kann für alle anderen Fälle verwendet werden und erfordert die manuelle Generierung des CSR sowie die manuelle Installation des Zertifikats.";
$_LANG['sslProfileLabel'] = "Wählen Sie Ihr bevorzugtes Hosting-Profil für den automatisierten Prozess aus";
$_LANG['sslDomainLabel'] = "Wählen Sie Ihre Domain/Ihren Webspace";
$_LANG['sslProfileDesc'] = "Basierend auf der Hosting-Profilauswahl wird die Domain-Liste verfügbar sein";
$_LANG['sslDomainDesc'] = "Diese Domain wird für die CSR-Generierung und Zertifikatsinstallation verwendet";
$_LANG['sslWWWLabel'] = "Möchten Sie \"www\" bei der CSR-Generierung verwenden?";
$_LANG['sslWWWDesc'] = "Wenn als <u>www.name-of-site.com</u> generiert, werden sowohl www- als auch nicht-www-URLs abgedeckt.";
$_LANG['retrievesubdomain'] = "Subdomain abrufen";
$_LANG['sslCSRTitle'] = "CSR-Details";
$_LANG['sslCSRDesc'] = "Diese Informationen werden für die CSR-Generierung verwendet.";
$_LANG['sslCSRCommonName'] = "Common Name";
$_LANG['sslCSRCompany'] = "Unternehmen";
$_LANG['sslCSRDivision'] = "Abteilung";
$_LANG['sslCSRCity'] = "Stadt";
$_LANG['sslCSRState'] = "Bundesland";
$_LANG['sslCSRCountry'] = "Land";
$_LANG['sslCSREmail'] = "E-Mail";
$_LANG['addDomainToolTip'] = "Klicken zum Hinzufügen einer Domain";
$_LANG['addWildCardDomainToolTip'] = "Klicken zum Hinzufügen einer Wildcard-Domain";
$_LANG['removeDomainToolTip'] = "Klicken zum Entfernen einer Domain";
$_LANG['removeWildCardDomainToolTip'] = "Klicken zum Entfernen einer Wildcard-Domain";
$_LANG['ReissueSSLDomainLabel'] = "Domain/Webspace";
$_LANG['download_pvtkey'] = "Privaten&nbsp;Schlüssel herunterladen";
$_LANG['install_certificate'] = "Zertifikat&nbsp;installieren";
$_LANG['auto_reissue_cert'] = "AutoSSL&nbsp;neu ausstellen";
$_LANG['autossl_reissue_tooltip'] = "Die Option <strong>AutoSSL Neu ausstellen</strong> ist nur für WHM/cPanel-Server verfügbar und automatisiert die CSR-Generierung, Verifizierung (wenn möglich) und Installation des Zertifikats. Die Option <strong>Zertifikat neu ausstellen</strong> kann für alle anderen Fälle verwendet werden und erfordert die manuelle Generierung des CSR sowie die manuelle Installation des Zertifikats.";
$_LANG['autossl_pvtkey_tooltip'] = "Ihr privater Zertifikatsschlüssel wird auf Ihrem cPanel-Server gespeichert und beim Klicken von dort abgerufen.";
$_LANG['autossl_process_msg'] = "Bitte warten Sie zwei bis drei Minuten, während wir die Generierung, Validierung und Installation Ihres SSL-Zertifikats abschließen.";
$_LANG['nonHttpDownloadKeyError'] = "Leider können Sie den Schlüssel Ihres Zertifikats derzeit nicht herunterladen, da Sie nicht über SSL auf die Website zugreifen. Bitte verbinden Sie sich über HTTPS:// und versuchen Sie es erneut.";

//Digicert Products
$_LANG['newOrgDetails'] = "Neue Organisation erstellen";
$_LANG['preAuthOrgDetails'] = "Vorhandene Organisationsdetails verwenden";
$_LANG['sslOrgContact'] = "Primärer Kontakt der Organisation";
$_LANG['sslOrgStatus'] = 'Status';
$_LANG['sslOrgId'] = 'Organisations-ID';
$_LANG['sslOrgVendorId'] = 'Anbieter-Organisations-ID';
$_LANG['invalid_access_error'] = 'Entschuldigung! Ungültiger Zugriff!';
$_LANG['digicert_combined_cert_files'] = 'Kombinierte Zertifikatsdateien';
$_LANG['digicert_server_platform'] = 'Serverplattform';
$_LANG['digicert_file_type'] = 'Dateityp';
$_LANG['download_cert_with_ca'] = 'Zertifikat mit CA-Bundle herunterladen';
$_LANG['sslOrgInfo'] = 'Organisationsinfo';
$_LANG['assign_license'] = 'Lizenz zuweisen';
$_LANG['assign_license_title'] = 'Bei SiteLock anmelden';
$_LANG['assign_license_sub_title'] = 'Jetzt bei SiteLock einmalig anmelden';
$_LANG['upgrade_subscription_text'] = 'UPGRADEN';
?>