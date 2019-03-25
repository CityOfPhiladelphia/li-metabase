SELECT address,
  caseorpermitnumber CaseNumber,
  start_date StartDate,
  completed_date CompletedDate,
  status,
  mostrecentinsp,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(geocode_x, geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(geocode_x, geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat
FROM GIS_LNI.LI_DEMOLITIONS
WHERE city_demo     = 'YES'
AND completed_date IS NOT NULL
AND completed_date  < SYSDATE
