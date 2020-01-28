SELECT c.casenumber,
       c.casetype,
       c.caseresponsibility,
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
       c.census_tract_2010,
       (
           CASE
               WHEN cases_with_only_license_vios.casenumber IS NOT NULL
               THEN 'Yes'
               ELSE 'No'
           END
       ) onlyincludeslicensevios
FROM cases_mvw c,
     (SELECT DISTINCT casenumber
      FROM violations_mvw
      WHERE (violationtype IN (
          '9-3902 (1)',
          '9-3902 (2)',
          '9-3902 (3)',
          '9-3902 (4)',
          '9-3904',
          '9-3905'
      )
             OR violationtype NOT LIKE 'PM-102%')
            AND caseaddeddate >= add_months (trunc (sysdate, 'MM'), - 60)
            AND caseaddeddate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')
      MINUS
      SELECT DISTINCT casenumber
      FROM violations_mvw
      WHERE violationtype NOT IN (
          '9-3902 (1)',
          '9-3902 (2)',
          '9-3902 (3)',
          '9-3902 (4)',
          '9-3904',
          '9-3905'
      )
            AND violationtype NOT LIKE 'PM-102%'
            AND caseaddeddate >= add_months (trunc (sysdate, 'MM'), - 60)
            AND caseaddeddate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')
     ) cases_with_only_license_vios
WHERE c.casenumber = cases_with_only_license_vios.casenumber (+)
      AND c.createddate >= add_months (trunc (sysdate, 'MM'), - 60)
      AND c.createddate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')