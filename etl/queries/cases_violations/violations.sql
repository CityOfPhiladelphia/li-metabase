SELECT addresskey,
       opa_account_num,
       address,
       unit,
       zip,
       censustract,
       census_tract_1990,
       census_tract_2010,
       council_district,
       (
           CASE
               WHEN ops_district IS NOT NULL
               THEN ops_district
               ELSE to_nchar ('(none)')
           END
       ) ops_district,
       (
           CASE
               WHEN building_district IS NOT NULL
               THEN building_district
               ELSE to_nchar ('(none)')
           END
       ) building_district,
       ownername,
       organization,
       casenumber,
       aptype,
       caseaddeddate,
       caseresolutiondate,
       (
           CASE
               WHEN caseresolutioncode IS NOT NULL
               THEN caseresolutioncode
               ELSE '(none)'
           END
       ) caseresolutioncode,
       apfailkey,
       violationdate,
       violationtype,
       violationdescription,
       mostrecentinsp,
       (
           CASE
               WHEN status IS NOT NULL
               THEN status
               ELSE 'OPEN'
           END
       ) status,
       casestatus,
       (
           CASE
               WHEN casegroup IS NOT NULL
               THEN casegroup
               ELSE '(none)'
           END
       ) casegroup,
       (
           CASE
               WHEN casepriority IS NOT NULL
               THEN casepriority
               ELSE '(none)'
           END
       ) casepriority,
       (
           CASE
               WHEN prioritydesc IS NOT NULL
               THEN prioritydesc
               ELSE '(none)'
           END
       ) prioritydesc,
       addrkey_2,
       addrkey_3,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (geocode_x, geocode_y, NULL), NULL, NULL), 4326).sdo_point.x lon
       ,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (geocode_x, geocode_y, NULL), NULL, NULL), 4326).sdo_point.y lat
FROM violations_mvw
WHERE violationdate > add_months (trunc (sysdate, 'MM'), - 25)
      AND violationdate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')