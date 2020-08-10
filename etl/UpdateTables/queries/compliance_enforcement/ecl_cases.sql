SELECT c.jobid,
       c.casenumber,
       c.casetype,
       c.casesource,
       c.caseresponsibility,
       c.casepriority,
       c.createddate,
       c.completeddate,
       (
           CASE
               WHEN c.completeddate IS NULL
               THEN 'No'
               ELSE 'Yes'
           END
       ) casecompleteddatehasvalue,
       (
           CASE
               WHEN c.casestatus IS NULL
               THEN '(none)'
               ELSE c.casestatus
           END
       ) casestatus,
       nsi.investigationscheduled nextscheduledinv,
       (
           CASE
               WHEN nsi.staffassigned IS NULL
               THEN '(none)'
               ELSE nsi.staffassigned
           END
       ) nextscheduledinvinvestigator,
       ovdi.investigationscheduled overdueinvscheduleddate,
       (
           CASE
               WHEN ovdi.staffassigned IS NULL
               THEN '(none)'
               ELSE ovdi.staffassigned
           END
       ) overdueinvinvestigator,
       a.zip,
       a.councildistrict,
       a.li_district district,
       a.censustract,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (a.geocode_x, a.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       x lon,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (a.geocode_x, a.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       y lat
FROM g_mvw_cases c,
     eclipse_lni_addr a,
     (SELECT *
      FROM (SELECT RANK () OVER (
                PARTITION BY casejobid
                ORDER BY investigationscheduled ASC, investigationprocessid ASC NULLS LAST
            ) AS rankscheddate,
                   casejobid,
                   casenumber,
                   investigationscheduled,
                   staffassigned
            FROM g_mvw_case_inv
            WHERE investigationcompleted IS NULL
                  AND investigationscheduled > sysdate
           )
      WHERE rankscheddate = 1
     ) nsi,  --next scheduled investigation
     (SELECT *
      FROM (SELECT RANK () OVER (
                PARTITION BY casejobid
                ORDER BY investigationscheduled ASC, investigationprocessid ASC NULLS LAST
            ) AS rankscheddate,
                   casejobid,
                   casenumber,
                   investigationscheduled,
                   staffassigned
            FROM g_mvw_case_inv
            WHERE investigationcompleted IS NULL
                  AND investigationscheduled < sysdate
           )
      WHERE rankscheddate = 1
     ) ovdi  --overdue investigations
WHERE c.addressobjectid = a.addressobjectid (+)
      AND c.jobid  = nsi.casejobid (+)
      AND c.jobid  = ovdi.casejobid (+)