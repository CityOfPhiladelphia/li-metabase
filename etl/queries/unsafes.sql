SELECT address,
  ops_district OPSDistrict,
  building_district BuildingDistrict,
  casenumber,
  violationdate,
  caseresolutiondate,
  caseresolutioncode,
  mostrecentinsp,
  violationdescription,
  status,
  casestatus,
  casegroup,
  prioritydesc casepriority,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(geocode_x, geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(geocode_x, geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat
FROM VIOLATIONS_MVW
WHERE VIOLATIONDATE >= '01-JAN-16'
AND VIOLATIONDATE < SYSDATE
AND VIOLATIONTYPE   IN
  (SELECT DISTINCT VIOLATIONTYPE FROM UNSAFE_MVW
  )
