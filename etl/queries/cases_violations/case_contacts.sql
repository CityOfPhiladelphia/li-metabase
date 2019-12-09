SELECT DISTINCT   c.casenumber,
  c.casegroup,
  c.caseaddeddate,
  c.caseresolutioncode,
  c.caseresolutiondate,
  c.contactaddress,
  c.contactprimary,
  c.contactcapacity,
  c.contactname,
  c.contactorganization,
  c.casestatus,
  tl.LICENSENUMBER ,
  (CASE WHEN tl.LICENSETYPE IS NOT NULL
  THEN tl.LICENSETYPE
  ELSE '(N/A)'
  END) licensetype,
  (CASE WHEN tl.LICENSETYPE IS NOT NULL
  THEN 'Yes'
  ELSE 'No'
  END) licenseholder,
  c.caseaddress
FROM CASE_CONTACTS_MVW c,
TRADE_LICENSES_ALL_MVW tl  
WHERE c.LICENSENUM = tl.LICENSENUMBER (+)