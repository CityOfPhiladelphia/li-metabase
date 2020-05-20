SELECT address,
       caseorpermitnumber casenumber,
       start_date startdate,
       completed_date completeddate,
       status,
       mostrecentinsp,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (geocode_x, geocode_y, NULL), NULL, NULL), 4326).sdo_point.x lon
       ,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (geocode_x, geocode_y, NULL), NULL, NULL), 4326).sdo_point.y lat
FROM gis_lni.li_demolitions
WHERE city_demo = 'YES'
      AND completed_date IS NOT NULL
      AND completed_date < sysdate