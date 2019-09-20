SELECT DISTINCT
    lic.licensenumber LICENSE_NUMBER,
    lic.initialissuedate INITIAL_ISSUE_DATE,
    lic.mostrecentissuedate MOST_RECENT_ISSUE_DATE,
    lt.name License_Type,
    lic.licensestate License_Status,
    a.formattedaddress full_address,
    upper(b.doingbusinessas) "BUSINESS_NAME",
    CAST(mad.formattedinlinedisplay AS VARCHAR(1999)) "BUSINESS_MAILING_ADDRESS",
    dum.medallionid MEDALLION_ID,
    dum.dumpstersize DUMPSTER_SIZE,
    dum.dumpstertype DUMPSTER_TYPE,
    dum.createddate CREATED_DATE,
    dum.lastupdateddate LAST_UPDATED_DATE
FROM
    lmscorral.bl_business      b,
    lmscorral.bl_license       lic,
    lmscorral.bl_dumpster      dum,
    lmscorral.bl_licensetype   lt,
    lmscorral.address          a,
    lmscorral.legalentity      leg,
    lmscorral.mailingaddress   mad
WHERE
    lic.businessobjectid = b.objectid (+)
    AND b.addressobjectid = a.objectid (+)
    AND b.legalentityobjectid = leg.legalentityid (+)
    AND leg.mailingaddressobjectid = mad.objectid (+)
    AND lic.objectid = dum.licenseid 
    AND lic.licensetypeobjectid = lt.objectid
ORDER BY
    lic.licensenumber