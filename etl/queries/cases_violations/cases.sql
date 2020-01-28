SELECT c.casenumber,
       c.caseaddeddate,
       c.caseresolutioncode,
       c.caseresolutiondate,
       c.casegroup,
       c.lastcompletedinsp,
       c.lastcompletedinspstatus,
       c.lastcompletedinspinspector,
       c.nextscheduledinsp,
       c.nextscheduledinspinspector,
       c.overdueinspscheduleddate,
       c.overdueinspinspector,
       c.zip,
       c.councildistrict,
       c.opsdistrict,
       c.censustract,
       c.caseresolutiondatehasvalue,
       c.firstcompletedinsp,
       c.firstcompletedinspstatus,
       c.firstcompletedinspinspector,
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
      AND c.caseaddeddate >= add_months (trunc (sysdate, 'MM'), - 60)
      AND c.caseaddeddate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')