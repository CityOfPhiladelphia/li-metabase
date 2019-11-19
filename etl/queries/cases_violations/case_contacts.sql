SELECT DISTINCT TRIM(c.apno) casenumber,
  c.casegrp casegroup,
  c.adddttm caseaddeddate,
  c.rescode caseresolutioncode,
  c.RESDTTM caseresolutiondate,
  (
  CASE
    WHEN contact.cntctfirst <> ' '
    THEN contact.cntctfirst
      || ' '
      || contact.cntctlast
    ELSE trim(contact.cntctlast)
  END) contactname,
  l.prim contactprimary,
  (
  CASE
    WHEN l.capacity = 'OTHER'
    THEN l.capother
    ELSE l.capacity
  END) contactcapacity,
  contact.coname contactorganization,
  contact.addr1 contactaddress,
  (
  CASE
    WHEN c.RESDTTM IS NULL
    OR c.rescode     IS NULL
    OR c.rescode      = '(none)'
    THEN 'Open'
    ELSE 'Closed'
  END) casestatus
FROM imsv7.contact@lidb_link contact,
  imsv7.apapl@lidb_link l,
  imsv7.apcase@lidb_link c
WHERE contact.cntctkey = l.cntctkey
AND l.apkey            = c.apkey
AND c.adddttm         >= '01-JAN-2007'
  --AND addr1 = '1218 N MARSHALL ST'
  --AND trim(c.apno) = '585670'
  --order by casenumber