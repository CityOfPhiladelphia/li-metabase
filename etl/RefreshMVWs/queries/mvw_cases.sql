SELECT jobid,
       casenumber,
       casetype,
       casesource,
       caseresponsibility,
       casepriority,
       createddate,
       completeddate,
       casecompleteddatehasvalue,
       casestatus,
       fci.investigationcompleted firstcompletedinv,
       fci.investigationstatus firstcompletedinvstatus,
       (
           CASE
               WHEN fci.staffassigned IS NULL
               THEN '(none)'
               ELSE fci.staffassigned
           END
       ) firstcompletedinvinvestigator,
       lci.investigationcompleted lastcompletedinv,
       lci.investigationstatus lastcompletedinvstatus,
       (
           CASE
               WHEN lci.staffassigned IS NULL
               THEN '(none)'
               ELSE lci.staffassigned
           END
       ) lastcompletedinvinvestigator,
       nextscheduledinv,
       nextscheduledinvinvestigator,
       overdueinvscheduleddate,
       overdueinvinvestigator,
       (
           CASE
               WHEN cases_with_only_license_vios.casenumber IS NOT NULL
               THEN 'Yes'
               ELSE 'No'
           END
       ) onlyincludeslicensevios,
       zip,
       councildistrict,
       district,
       censustract,
       lon,
       lat,
       systemofrecord
FROM (SELECT sub.*,
             ROW_NUMBER () OVER (
                 PARTITION BY casenumber
                 ORDER BY systemofrecord ASC --If the same vio
             ) seq_no
      FROM (SELECT jobid,
                   casenumber,
                   casetype,
                   casesource,
                   caseresponsibility,
                   casepriority,
                   createddate,
                   completeddate,
                   casecompleteddatehasvalue,
                   casestatus,
                   nextscheduledinv,
                   nextscheduledinvinvestigator,
                   overdueinvscheduleddate,
                   overdueinvinvestigator,
                   zip,
                   councildistrict,
                   district,
                   censustract,
                   lon,
                   lat,
                   'ECLIPSE' systemofrecord
            FROM ecl_cases
            UNION
            SELECT jobid,
                   casenumber,
                   casetype,
                   casesource,
                   caseresponsibility,
                   casepriority,
                   createddate,
                   completeddate,
                   casecompleteddatehasvalue,
                   casestatus,
                   nextscheduledinv,
                   nextscheduledinvinvestigator,
                   overdueinvscheduleddate,
                   overdueinvinvestigator,
                   zip,
                   council_district councildistrict,
                   li_district district,
                   census_tract_2010 censustract,
                   NULL AS lon,
                   NULL AS lat,
                   'HANSEN' systemofrecord
            FROM cases h
      ) sub1
     ) sub2,
     (SELECT casenumber,
             investigationcompleted,
             investigationstatus,
             staffassigned
      FROM (SELECT ROW_NUMBER () OVER (
                PARTITION BY casenumber
                ORDER BY investigationcompleted ASC NULLS LAST
            ) seq_no,
                   casenumber,
                   investigationcompleted,
                   investigationstatus,
                   staffassigned
            FROM case_investigations
           )
      WHERE seq_no = 1
     ) fci, --first completed investigation
     (SELECT casenumber,
             investigationcompleted,
             investigationstatus,
             staffassigned
      FROM (SELECT ROW_NUMBER () OVER (
                PARTITION BY casenumber
                ORDER BY investigationcompleted DESC NULLS LAST
            ) seq_no,
                   casenumber,
                   investigationcompleted,
                   investigationstatus,
                   staffassigned
            FROM case_investigations
           )
      WHERE seq_no = 1
     ) lci, --last completed investigation
     (SELECT DISTINCT casenumber
      FROM mvw_violations
      WHERE (violationcode IN (
          '9-3902 (1)',
          '9-3902 (2)',
          '9-3902 (3)',
          '9-3902 (4)',
          '9-3904',
          '9-3905'
      )
             OR violationcode NOT LIKE 'PM-102%')
            AND casecreateddate >= add_months (trunc (sysdate, 'MM'), - 60)
            AND casecreateddate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')
      MINUS
      SELECT DISTINCT casenumber
      FROM mvw_violations
      WHERE violationcode NOT IN (
          '9-3902 (1)',
          '9-3902 (2)',
          '9-3902 (3)',
          '9-3902 (4)',
          '9-3904',
          '9-3905'
      )
            AND violationcode NOT LIKE 'PM-102%'
            AND casecreateddate >= add_months (trunc (sysdate, 'MM'), - 60)
            AND casecreateddate < to_date (to_char (sysdate, 'MM/DD/YYYY' ), 'MM/DD/YYYY')
     ) cases_with_only_license_vios
WHERE sub2.seq_no = 1
      AND sub2.casenumber  = fci.casenumber (+)
      AND sub2.casenumber  = lci.casenumber (+)
      AND sub2.casenumber  = cases_with_only_license_vios.casenumber (+)
      AND sub2.createddate >= add_months (trunc (sysdate, 'MM'), - 60)
      AND sub2.createddate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')