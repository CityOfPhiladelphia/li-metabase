SELECT addressobjectid,
       casenumber,
       (
           CASE
               WHEN casetype IS NULL
               THEN '(none)'
               ELSE casetype
           END
       ) casetype,
       (
           CASE
               WHEN caseresponsibility IS NULL
               THEN '(none)'
               ELSE caseresponsibility
           END
       ) caseresponsibility,
       (
           CASE
               WHEN casepriority IS NULL
               THEN '(none)'
               ELSE casepriority
           END
       ) casepriority,
       investigationprocessid,
       (
           CASE
               WHEN investigationtype IS NULL
               THEN '(none)'
               ELSE investigationtype
           END
       ) investigationtype,
       investigationcreated,
       investigationscheduled,
       investigationcompleted,
       (
           CASE
               WHEN investigationresult IS NULL
               THEN '(none)'
               ELSE investigationresult
           END
       ) investigationresult,
       (
           CASE
               WHEN investigationoutcome IS NULL
               THEN '(none)'
               ELSE investigationoutcome
           END
       ) investigationoutcome,
       (
           CASE
               WHEN investigationstatus IS NULL
               THEN '(none)'
               ELSE investigationstatus
           END
       ) investigationstatus,
       findings,
       (
           CASE
               WHEN staffassigned IS NULL
               THEN '(none)'
               ELSE staffassigned
           END
       ) staffassigned,
       opa_account_num,
       address,
       zip,
       censustract,
       council_district,
       li_district,
       systemofrecord,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (geocode_x, geocode_y, NULL), NULL, NULL), 4326).sdo_point.x lon
       ,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (geocode_x, geocode_y, NULL), NULL, NULL), 4326).sdo_point.y lat
FROM mvw_case_inv_internal
WHERE (investigationcreated >= add_months (trunc (sysdate, 'MM'), - 24)
       OR investigationscheduled >= add_months (trunc (sysdate, 'MM'), - 24)
       OR investigationcompleted >= add_months (trunc (sysdate, 'MM'), - 24))