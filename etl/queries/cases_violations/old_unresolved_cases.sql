SELECT c.casenumber,
       c.caseaddeddate,
       c.casestatus,
       c.completeddate,
       c.caseresponsibility,
       c.lastcompletedinv,
       c.lastcompletedinvstatus,
       c.lastcompletedinvinvestigator,
       c.nextscheduledinv,
       c.nextscheduledinvinvestigator,
       c.overdueinvscheduleddate,
       c.overdueinvinvestigator,
       c.zip,
       c.council_district,
       c.li_district,
       c.census_tract_2010,
       c.casecompleteddatehasvalue,
       c.firstcompletedinv,
       c.firstcompletedinvstatus,
       c.firstcompletedinvinvestigator
FROM cases_mvw c
WHERE c.caseaddeddate < add_months (trunc (sysdate, 'MM'), - 60)
      AND (c.casestatus <> 'Closed'
           OR c.completeddate IS NULL)