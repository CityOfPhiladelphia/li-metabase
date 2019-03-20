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
AND VIOLATIONDATE    < TO_DATE(TO_CHAR(sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')
AND APTYPE LIKE 'CD ENFORCE'
AND CASEGROUP IN ('CSU','CSUP')
AND ((VIOLATIONTYPE LIKE 'PM-307%'
OR VIOLATIONTYPE LIKE 'PM15-108.1%' )
AND VIOLATIONTYPE != 'PM-307.1/20')
