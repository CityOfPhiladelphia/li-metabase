SELECT tl.licensenumber,
       tl.licensetype,
       upper (tl.contactname) licensecontactname,
       upper (tl.companyname) licensecompanyname,
       tl.issuedate licenseissuedate,
       tl.expirationdate licenseexpirationdate,
       upper (tl.status) licensestatus,
       NULL AS licenselink, --'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2855291&objectHandle=' || tl.objectid AS licenselink ,
       cases.casenumber,
       cases.listedas,
       cases.casestatus,
       cases.casepriority,
       cases.casetype,
       cases.casesource,
       cases.caseresponsibility,
       cases.casecreateddate,
       cases.casecompleteddate,
       cases.caseaddress,
       cases.systemofrecord casesystemofrecord
FROM g_mvw_trade_licenses tl,
     mvw_tl_cases cases
WHERE tl.licensenumber = cases.licensenumber (+)
      --AND tl.licensenumber = '39939'
ORDER BY licensenumber,
         casenumber