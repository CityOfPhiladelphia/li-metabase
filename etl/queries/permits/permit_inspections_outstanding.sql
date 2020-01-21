SELECT i.apinspkey,
  i.apkey,
  trim(b.apno) permitnumber,
  la.addr_base AS address,
  a.zip,
  la.census_tract_1990,
  la.council_district,
  la.ops_district,
  la.building_district,
  (
  CASE
    WHEN o.cntctfirst <> ' '
    THEN trim(o.cntctfirst
      || ' '
      || o.cntctlast)
    ELSE trim(o.cntctlast)
  END) ownername,
  o.coname,
  d.aptype,
  d.apdesc,
  e.empfirst inspectorfirstname,
  e.emplast inspectorlastname,
  (
  CASE
    WHEN e.empfirst IS NULL
    AND emplast     IS NULL
    THEN '(none)'
    ELSE e.empfirst
      || ' '
      || emplast
  END ) inspectorname,
  i.insptype InspectionType,
  i.scheddttm InspectionScheduled,
  DECODE(i.stat, 0, 'None', 1, 'Passed', 2, 'Failed', 3, 'Cancelled', 4, 'HOLD', 5, 'Closed') InspectionStatus,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(la.geocode_x, la.geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(la.geocode_x, la.geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat
FROM imsv7.address@lidb_link a,
  imsv7.apbldg@lidb_link b,
  imsv7.apinsp@lidb_link i,
  imsv7.tbl250@lidb_link t250,
  imsv7.contact@lidb_link o,
  imsv7.addrcntc@lidb_link cntc,
  imsv7.apdefn@lidb_link d,
  imsv7.employee@lidb_link e,
  lni_addr la
WHERE a.addrkey  = b.addrkey
AND b.apkey      = i.apkey
AND a.addrkey = la.addrkey (+)
AND i.insptype NOT LIKE 'CLIP%'
AND i.insptype    = t250.code
AND cntc.addrkey  = a.addrkey
AND cntc.cntctkey = o.cntctkey
AND cntc.owner LIKE 'Y%'
AND b.apdefnkey = d.apdefnkey
AND i.assignto  = e.empid (+)
AND i.compdttm IS NULL
)