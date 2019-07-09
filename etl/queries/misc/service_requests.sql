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
    WHEN sub.unit = 'Ops'
    THEN addr.ops_district
    WHEN sub.unit = 'Building'
    THEN addr.building_district
    WHEN sub.unit = 'CSU'
    THEN addr.ops_district
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
  END ) Inspector
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
      WHEN sr.SR_PROBLEMCODE IN ('BRH', 'DCC', 'DCR', 'DRGMR', 'FC', 'FR', 'HM', 'IR', 'LB', 'LR', 'LVCIP', 'MC', 'MR', 'NH', 'NPU', 'SMR', 'VC', 'VH', 'VRS', 'ZB', 'ZR')
      THEN 'Ops'
      WHEN sr.SR_PROBLEMCODE IN ('BC', 'BLK', 'COMP', 'EC', 'LC', 'PC', 'SPC', 'SR311', 'X', 'ZC', 'ZM')
      THEN 'Building'
      WHEN sr.SR_PROBLEMCODE IN ('BD', 'BDH', 'BDO')
      THEN 'CSU'
      ELSE 'Other'
    END) unit,
    e.empfirst,
    e.emplast
  FROM IMSV7.LI_ALLSERVICEREQUESTS@lidb_link sr,
    imsv7.custprob@lidb_link c,
    imsv7.employee@lidb_link e
  WHERE sr.SERVNO = c.SERVNO
  AND c.inspectr  = e.empid (+)
  ) sub,
  LNI_ADDR addr,
  sla_dictionary s
WHERE sub.addresskey   = addr.addrkey
AND sub.sr_calldate   >= ' 01-JAN-2016'
AND sub.unit          != 'Other'
AND sub.sr_problemcode = s.prob (+)
ORDER BY sub.sr_calldate
