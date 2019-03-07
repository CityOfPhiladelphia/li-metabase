SELECT TO_DATE(violationyear
  || '/'
  || violationmonth
  || '/'
  || '01', 'yyyy/mm/dd') AS violationdate,
  lon,
  lat,
  address,
  status,
  casestatus
FROM
  (SELECT EXTRACT(MONTH FROM violationdate) violationmonth,
    EXTRACT(YEAR FROM violationdate ) violationyear,
    SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(geocode_x, geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
    SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(geocode_x, geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat,
    address,
    status,
    casestatus
  FROM VIOLATIONS_MVW
  WHERE VIOLATIONDATE >= '01-JAN-16'
  AND VIOLATIONTYPE   IN(SELECT DISTINCT VIOLATIONTYPE FROM UNSAFE_MVW)
  )