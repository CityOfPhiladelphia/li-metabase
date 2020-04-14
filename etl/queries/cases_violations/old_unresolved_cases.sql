SELECT c.casenumber,
       c.casetype,
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
       c.firstcompletedinv,
       c.firstcompletedinvstatus,
       (
           CASE
               WHEN c.firstcompletedinvinvestigatore IS NULL
               THEN '(none)'
               ELSE c.firstcompletedinvinvestigator
           END
       ) firstcompletedinvinvestigator,
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
       c.census_tract_2010
FROM cases_mvw c
WHERE c.createddate < add_months (trunc (sysdate, 'MM'), - 60)
      AND (c.casestatus <> 'Closed'
           OR c.completeddate IS NULL)