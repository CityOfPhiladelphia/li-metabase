SELECT tl.licensenumber,
       tl.licensetype,
       upper (tl.contactname) licensecontactname,
       upper (tl.companyname) licensecompanyname,
       tl.issuedate licenseissuedate,
       tl.expirationdate licenseexpirationdate,
       upper (tl.status) licensestatus,     
--     'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2855291&objectHandle=' || tl.objectid AS licenselink ,
       cases.casenumber,
  --cases.listedas,
       cases.caseresponsibility,
       cases.casecreateddate,
       cases.caseresolutioncode,
       cases.casecompleteddate,
       cases.caseaddress
FROM g_mvw_trade_licenses tl,
     (SELECT tlcx.tradelicenseobjectid,
             c.casenumber,
            --c.listedas,
             c.caseresponsibility,
             c.createddate casecreateddate,
             NULL AS caseresolutioncode,
             c.completeddate casecompleteddate,
             a.base_address caseaddress
      FROM lmscorral.tradelicensecontractorxref@eclipse_link tlcx,
           g_mvw_ce_responsible_party rp,
           g_mvw_cases c,
           eclipse_lni_addr a
      WHERE tlcx.contractorobjectid = rp.contractorobjectid
            AND rp.casefileobjectid  = c.jobid
            AND c.addressobjectid    = a.addressobjectid (+)
     ) cases
WHERE tl.objectid = cases.tradelicenseobjectid (+)
      --AND tl.licensenumber = '39939'
      /*I was able to link cases to TLs through the contractor listed as the responsible party
      on the case (if there is one), but it’s not obvious to me how to associate a case to a TL 
      through other types of responsible parties (Parcel Owners, Persons, or Businesses). Do you
      know if it’s possible in eclipse for Parcel Owners, Persons, or Businesses to be associated 
      with a Trade License?
      */
ORDER BY licensenumber,
         casenumber