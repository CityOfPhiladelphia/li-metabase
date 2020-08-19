SELECT c.internalid,
       c.casenumber,
       (
           CASE
               WHEN c.casetype IS NULL
               THEN '(none)'
               ELSE c.casetype
           END
       ) casetype,
       (
           CASE
               WHEN c.caseresponsibility IS NULL
               THEN '(none)'
               ELSE c.caseresponsibility
           END
       ) caseresponsibility,
       (
           CASE
               WHEN c.casepriority IS NULL
               THEN '(none)'
               ELSE c.casepriority
           END
       ) casepriority,
       c.createddate,
       c.completeddate,
       (
           CASE
               WHEN c.completeddate IS NULL
               THEN 'Incomplete'
               ELSE 'Completed'
           END
       ) completed,
       c.casestatus,
       (
           CASE
               WHEN c.firstcompletedinv IS NULL
               THEN 'Uninvestigated'
               ELSE 'Investigated'
           END
       ) investigated,
       c.firstcompletedinv,
       (
           CASE
               WHEN c.firstcompletedinvstatus IS NULL
               THEN '(n/a - no completed investigations)'
               ELSE c.firstcompletedinvstatus
           END
       ) firstcompletedinvstatus,
       (
           CASE
               WHEN c.firstcompletedinvinvestigator IS NULL
               THEN '(n/a - no completed investigations)'
               ELSE c.firstcompletedinvinvestigator
           END
       ) firstcompletedinvinvestigator,
       c.lastcompletedinv,
       c.lastcompletedinvstatus,
       (
           CASE
               WHEN c.lastcompletedinvinvestigator IS NULL
               THEN '(n/a - no completed investigations)'
               ELSE c.lastcompletedinvinvestigator
           END
       ) lastcompletedinvinvestigator,
       c.nextscheduledinv,
       (
           CASE
               WHEN c.nextscheduledinvinvestigator IS NULL
               THEN '(n/a - no upcoming investigations)'
               ELSE c.nextscheduledinvinvestigator
           END
       ) nextscheduledinvinvestigator,
       c.overdueinvscheduleddate,
       (
           CASE
               WHEN c.overdueinvinvestigator IS NULL
               THEN '(n/a - no overdue investigations)'
               ELSE c.overdueinvinvestigator
           END
       ) overdueinvinvestigator,
       c.onlyincludeslicensevios,
       c.address,
       (
           CASE
               WHEN c.zip IS NULL
                    OR c.zip = ' '
               THEN '(none)'
               ELSE c.zip
           END
       ) zip,
       c.council_district,
       c.li_district,
       c.censustract,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (c.geocode_x, c.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       x lon,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (c.geocode_x, c.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       y lat,
       'ECLIPSE' systemofrecord
FROM mvw_cases_eclipse c