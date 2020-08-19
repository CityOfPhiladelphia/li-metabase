SELECT addressobjectid,
       casenumber,
       casestatus,
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
       (
           CASE
               WHEN investigationscheduled is null
               THEN 'No'
               ELSE 'Yes'
           END
       ) investigationscheduled,
       investigationscheduled AS investigationscheduleddate,
       (
           CASE
               WHEN investigationscheduled is null
               THEN null
               ELSE trunc(sysdate) - trunc(investigationscheduled)
           END
       ) cdpastscheduleddate,
       (
           CASE
               WHEN investigationscheduled IS NULL
               THEN 'n/a - no scheduled start date'
               when trunc(sysdate) - trunc(investigationscheduled) < 0 
               then 'n/a - scheduled start date upcoming'
               WHEN trunc(sysdate) - trunc(investigationscheduled) <= 5
               THEN '0-5'
               WHEN trunc(sysdate) - trunc(investigationscheduled) <= 20
               THEN '6-20'
               WHEN trunc(sysdate) - trunc(investigationscheduled) <= 90
               THEN '21-90'
               ELSE '90+'
           END
       ) cdpastscheduleddatecategories,
       (
           CASE
               WHEN investigationscheduled is null
               THEN 'Unscheduled'
               WHEN trunc(sysdate) <= trunc(investigationscheduled)
               then 'Scheduled - Upcoming'
               else 'Scheduled - Overdue'
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
WHERE systemofrecord = 'ECLIPSE'
AND investigationcompleted is null