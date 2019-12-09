SELECT DISTINCT c.casenumber,
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
  (
  CASE
    WHEN tl.LICENSETYPE IS NOT NULL
    THEN tl.LICENSETYPE
    ELSE '(N/A)'
  END) licensetype,
  (
  CASE
    WHEN tl.LICENSETYPE IS NOT NULL
    THEN 'Yes'
    ELSE 'No'
  END) licenseholder,
  c.caseaddress,
  (
  CASE
    WHEN tl.CONTACTNAME IS NOT NULL
    THEN UPPER(tl.CONTACTNAME)
    ELSE '(N/A)'
  END) LICENSECONTACTNAME,
  (
  CASE
    WHEN tl.COMPANYNAME IS NOT NULL
    THEN UPPER(tl.COMPANYNAME)
    ELSE '(N/A)'
  END) LICENSECOMPANYNAME,
  tl.ISSUEDATE LicenseIssueDate,
  tl.EXPIRATIONDATE LicenseExpirationDate,
  (
  CASE
    WHEN tl.LICENSESTATUS IS NOT NULL
    THEN tl.LICENSESTATUS
    ELSE '(N/A)'
  END) LICENSESTATUS
FROM CASE_CONTACTS_MVW c,
  TRADE_LICENSES_ALL_MVW tl
WHERE c.LICENSENUM = tl.LICENSENUMBER (+)