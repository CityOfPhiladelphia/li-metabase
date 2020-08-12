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
       investigationcreated AS investigationcreateddate,
       investigationscheduled AS investigationscheduleddate,
       (
           CASE
               WHEN investigationscheduled IS NULL
               THEN 'No'
               ELSE 'Yes'
           END
       ) investigationscheduled,
       investigationcompleted AS investigationcompleteddate,
       (
           CASE
               WHEN investigationcompleted IS NULL
               THEN 'No'
               ELSE 'Yes'
           END
       ) investigationcompleted,
       (
           CASE
               WHEN investigationcompleted IS NOT NULL
               THEN investigationstatus
               WHEN investigationscheduled < sysdate
               THEN 'Incomplete - Overdue'
               WHEN investigationscheduled >= sysdate
               THEN 'Incomplete - Upcoming'
               ELSE 'Incomplete - Unscheduled'
           END
       ) investigationstatus,
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
       (
           CASE
               WHEN li_district IS NULL
               THEN '(none)'
               ELSE li_district
           END
       ) li_district,
       systemofrecord,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (geocode_x, geocode_y, NULL), NULL, NULL), 4326).sdo_point.x lon
       ,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (geocode_x, geocode_y, NULL), NULL, NULL), 4326).sdo_point.y lat
FROM mvw_case_inv_internal
WHERE (investigationcreated >= add_months (trunc (sysdate, 'MM'), - 24)
       OR investigationscheduled >= add_months (trunc (sysdate, 'MM'), - 24)
       OR investigationcompleted >= add_months (trunc (sysdate, 'MM'), - 24))