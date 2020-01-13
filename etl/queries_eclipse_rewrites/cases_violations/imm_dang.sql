SELECT address,
  ops_district OPSDistrict,
  building_district BuildingDistrict,
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
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(geocode_x, geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(geocode_x, geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat,
  addresskey,
  unit
FROM VIOLATIONS_MVW
WHERE VIOLATIONDATE < TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY')
AND ( violationtype LIKE 'PM-308%'
OR violationtype   = 'PM15-110.1' )
AND violationtype != 'PM-308.1/19'
