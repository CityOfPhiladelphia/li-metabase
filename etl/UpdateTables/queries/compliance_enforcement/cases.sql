SELECT c.internalid,
       c.casenumber,
       c.casetype,
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
               THEN 'No'
               ELSE 'Yes'
           END
       ) casecompleteddatehasvalue,
       c.casestatus,
       c.firstcompletedinv,
       (
           CASE
               WHEN c.firstcompletedinvstatus IS NULL
               THEN '(none)'
               ELSE c.firstcompletedinvstatus
           END
       ) firstcompletedinvstatus,
       (
           CASE
               WHEN c.firstcompletedinvinvestigator IS NULL
               THEN '(none)'
               ELSE c.firstcompletedinvinvestigator
           END
       ) firstcompletedinvinvestigator,
       c.lastcompletedinv,
       c.lastcompletedinvstatus,
       (
           CASE
               WHEN c.lastcompletedinvinvestigator IS NULL
               THEN '(none)'
               ELSE c.lastcompletedinvinvestigator
           END
       ) lastcompletedinvinvestigator,
       c.nextscheduledinv,
       (
           CASE
               WHEN c.nextscheduledinvinvestigator IS NULL
               THEN '(none)'
               ELSE c.nextscheduledinvinvestigator
           END
       ) nextscheduledinvinvestigator,
       c.overdueinvscheduleddate,
       (
           CASE
               WHEN c.overdueinvinvestigator IS NULL
               THEN '(none)'
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
       c.systemofrecord
FROM mvw_cases c