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
       investigationscheduled AS investigationscheduleddate,
       investigationcompleted AS investigationcompleteddate,
       trunc (investigationcompleted) - trunc (investigationcreated) AS daysdiffcreatedcompl,
       (
           CASE
               WHEN investigationcreated IS NULL
               THEN 'n/a'
               WHEN trunc (investigationcompleted) - trunc (investigationcreated) <= 10
               THEN '0-10'
               WHEN trunc (investigationcompleted) - trunc (investigationcreated) <= 30
               THEN '11-30'
               WHEN trunc (investigationcompleted) - trunc (investigationcreated) <= 90
               THEN '31-90'
               ELSE '90+'
           END
       ) daysdiffcreatedcomplcategories,
       trunc (investigationcompleted) - trunc (investigationscheduled) AS daysdiffschedcompl,
       (
           CASE
               WHEN investigationscheduled IS NULL
               THEN 'n/a - no scheduled start date'
               WHEN trunc (investigationcompleted) - trunc (investigationscheduled) < 0
               THEN 'Completed Date before Scheduled Start Date'
               WHEN trunc (investigationcompleted) - trunc (investigationscheduled) = 0
               THEN '0'
               WHEN trunc (investigationcompleted) - trunc (investigationscheduled) <= 10
               THEN '1-10'
               WHEN trunc (investigationcompleted) - trunc (investigationscheduled) <= 30
               THEN '11-30'
               WHEN trunc (investigationcompleted) - trunc (investigationscheduled) <= 90
               THEN '31-90'
               ELSE '90+'
           END
       ) daysdiffschedcomplcategories,
       (
           CASE
               WHEN investigationcompleted IS NULL
               THEN '(none)'
               ELSE investigationstatus
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
WHERE investigationcompleted >= add_months (trunc (sysdate, 'MM'), - 13)
      AND investigationcompleted <= sysdate
--ORDER BY investigationcompleted DESC