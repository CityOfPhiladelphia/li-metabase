SELECT DISTINCT sub.SERVNO servreqno,
  sub.address address,
  sub.sr_problemdesc problemdescription,
  sub.sr_calldate calldate,
  sub.sr_inspectiondate inspectiondate,
  sub.inspectionstatus,
  sub.sr_resolutiondate resolutiondate,
  sub.resolutionstatus,
  sub.sr_resolutiondesc resolutiondescription,
  sub.unit unit,
  (
  CASE
    WHEN sub.unit = 'Code Enforcement'
    THEN addr.ops_district
    WHEN sub.unit = 'Construction Services'
    THEN addr.building_district
    WHEN sub.unit = 'CSU'
    THEN addr.ops_district
    ELSE addr.ops_district
  END) district,
  s.sla SLA,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(addr.geocode_x, addr.geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(addr.geocode_x, addr.geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat,
  (
  CASE
    WHEN sub.empfirst IS NOT NULL
    AND sub.emplast   IS NOT NULL
    THEN sub.empfirst
      || ' '
      || sub.emplast
    ELSE '(none)'
  END ) Inspector,
  sub.source,
  to_char(sub.sr_inspectiondate, 'DAY') inspectiondayofweek
FROM
  (SELECT sr.SERVNO,
    sr.addresskey,
    sr.address,
    sr.sr_problemcode,
    sr.sr_problemdesc,
    sr.sr_calldate,
    sr.sr_inspectiondate,
    (
    CASE
      WHEN sr.sr_inspectiondate IS NOT NULL
      THEN 'Inspected'
      WHEN sr.sr_inspectiondate IS NULL
      THEN 'Uninspected'
    END) inspectionstatus,
    sr.sr_resolutiondate,
    (
    CASE
      WHEN sr.sr_resolutiondate IS NOT NULL
      THEN 'Resolved'
      WHEN sr.sr_resolutiondate IS NULL
      THEN 'Unresolved'
    END) resolutionstatus,
    sr.sr_resolutiondesc,
    (
    CASE
      WHEN sr.DEPTRESP = 'CLIP'
      THEN 'CLIP'
      WHEN sr.DEPTRESP = 'BU'
      THEN 'Vending'
      WHEN sr.DEPTRESP     IN ('CI', 'SO', 'BRU', 'HCEU')
      OR sr.SR_PROBLEMCODE IN ('BRH', 'DCC', 'DCR', 'DRGMR', 'FC', 'FR', 'HM', 'IR', 'LR', 'LVCIP', 'MC', 'MR', 'NH', 'NPU', 'SMR', 'VC', 'VH', 'VRS', 'ZR', 'HCEU', 'DP02', 'DP03', 'DP22')
      THEN 'Code Enforcement'
      WHEN sr.DEPTRESP     IN ('DCC', 'DCV', 'DE', 'DN', 'DS', 'DW', 'CSTF', 'CCD')
      OR sr.SR_PROBLEMCODE IN ('BC', 'BLK', 'COMP', 'EC', 'LC', 'PC', 'SPC', 'SR311', 'X', 'ZC', 'ZM', 'DP13')
      THEN 'Construction Services'
      WHEN sr.DEPTRESP      = 'CSU'
      OR sr.SR_PROBLEMCODE IN ('BD', 'BDH', 'BDO', 'EMERG', 'TD', 'RSA', 'OD', 'DEMO', 'DP23')
      THEN 'CSU'
      ELSE 'Other'
    END) unit,
    e.empfirst,
    e.emplast,
    (
    CASE
      WHEN c.SFDC_CASEID IS NULL
      THEN 'Internal'
      ELSE '311'
    END) source
  FROM IMSV7.LI_ALLSERVICEREQUESTS@lidb_link sr,
    imsv7.custprob@lidb_link c,
    imsv7.employee@lidb_link e
  WHERE sr.SERVNO = c.SERVNO
  AND c.inspectr  = e.empid (+)
  ) sub,
  LNI_ADDR addr,
  sla_dictionary s
WHERE sub.addresskey   = addr.addrkey
AND sub.sr_calldate   >= ' 01-JAN-2018'
AND sub.sr_problemcode = s.prob (+)
ORDER BY sub.sr_calldate