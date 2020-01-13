SELECT address,
  ops_district opsdistrict,
  building_district buildingdistrict,
  casenumber,
  violationdate,
  caseresolutiondate,
  (
  CASE
    WHEN caseresolutioncode IS NOT NULL
    THEN caseresolutioncode
    ELSE '(none)'
  END ) caseresolutioncode,
  mostrecentinsp,
  violationdescription,
  (
  CASE
    WHEN status IS NOT NULL
    THEN status
    ELSE 'OPEN'
  END ) status,
  casestatus,
  casegroup,
  prioritydesc casepriority,
  sdo_cs.transform(sdo_geometry(2001,2272,sdo_point_type(geocode_x,geocode_y,NULL),NULL,NULL),4326).sdo_point.x lon,
  sdo_cs.transform(sdo_geometry(2001,2272,sdo_point_type(geocode_x,geocode_y,NULL),NULL,NULL),4326).sdo_point.y lat,
  unit,
  addresskey
FROM violations_mvw
WHERE violationdate < TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY')
AND aptype LIKE 'CD ENFORCE'
AND casegroup IN ( 'CSU', 'CSUP' )
AND ( ( violationtype LIKE 'PM-307%'
OR violationtype LIKE 'PM15-108.1%' )
AND violationtype != 'PM-307.1/20' )