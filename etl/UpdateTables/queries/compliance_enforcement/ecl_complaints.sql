SELECT compl.jobid complaintjobid,
       compl.complaintnumber,
       addr.base_address address,
       compl.complaintcode,
       compl.complaintcodename,
       compl.complaintdate,
       compl.complaintstatus,
       reviewcomplaint.datecompleted reviewcomplaint_date,
       (
           CASE
               WHEN reviewcomplaint.datecompleted IS NOT NULL
               THEN 'Completed'
               WHEN reviewcomplaint.datecompleted IS NULL
               THEN 'Incomplete'
           END
       ) reviewcomplaint_status,
       (
           CASE
               WHEN reviewcomplaint.staffassigned IS NOT NULL
               THEN reviewcomplaint.staffassigned
               ELSE '(none)'
           END
       ) reviewcomplaint_assignedto,
       (
           CASE
               WHEN reviewcomplaint.outcome IS NOT NULL
               THEN reviewcomplaint.outcome
               ELSE '(none - no completed review)'
           END
       ) reviewcomplaint_outcome,
       cases.casenumber,
       firstinv.investigationcompleted firstinv_date,
       mostrecentinv.investigationcompleted mostrecentinv_date,
       to_char (mostrecentinv.investigationcompleted, 'DAY') mostrecentinv_dayofweek,
       (
           CASE
               WHEN mostrecentinv.investigationcompleted IS NOT NULL
               THEN 'Investigated'
               WHEN mostrecentinv.investigationcompleted IS NULL
               THEN 'Uninvestigated'
           END
       ) mostrecentinv_status,
       (
           CASE
               WHEN mostrecentinv.staffassigned IS NOT NULL
               THEN mostrecentinv.staffassigned
               ELSE '(none)'
           END
       ) mostrecentinv_assignedto,
       (
           CASE
               WHEN mostrecentinv.investigationoutcome IS NOT NULL
               THEN mostrecentinv.investigationoutcome
               ELSE '(none - no completed investigation)'
           END
       ) mostrecentinv_outcome,
       compl.complaint_resolutiondate,
       (
           CASE
               WHEN compl.complaint_resolutiondate IS NOT NULL
               THEN 'Resolved'
               WHEN compl.complaint_resolutiondate IS NULL
               THEN 'Unresolved'
           END
       ) resolutionstatus,
       compl.inspectiondiscipline,
       (
           CASE
               WHEN compl.origintype IS NOT NULL
               THEN compl.origintype
               ELSE '(none)'
           END
       ) origintype,
       addr.li_district district,
       sla.sla,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (addr.geocode_x, addr.geocode_y, NULL), NULL, NULL), 4326).sdo_point
       .x lon,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (addr.geocode_x, addr.geocode_y, NULL), NULL, NULL), 4326).sdo_point
       .y lat
FROM g_mvw_complaints compl,
     g_mvw_cases cases,
     (SELECT jobid,
             datecompleted,
             outcome,
             staffassigned
      FROM (SELECT sub.*,
                   ROW_NUMBER () OVER (
                       PARTITION BY jobid
                       ORDER BY datecompleted DESC NULLS LAST
                   ) seq_no
            FROM (SELECT jobid,
                         datecompleted,
                         outcome,
                         (
                             CASE
                                 WHEN staffassigned IS NULL
                                 THEN '(none)'
                                 WHEN regexp_count (staffassigned, ',') > 0
                                 THEN 'multiple'
                                 ELSE upper (regexp_replace (replace (staffassigned, '  ', ' '), '[0-9]', ''))
                             END
                         ) staffassigned
                  FROM g_mvw_processes
                  WHERE processtype = 'Review Public Complaint'
                 ) sub
           )
      WHERE seq_no = 1
     ) reviewcomplaint,
     (SELECT casejobid,
             investigationcompleted,
             staffassigned,
             investigationoutcome
      FROM (SELECT sub.*,
                   ROW_NUMBER () OVER (
                       PARTITION BY casejobid
                       ORDER BY investigationcompleted ASC NULLS LAST
                   ) seq_no
            FROM (SELECT casejobid,
                         investigationcompleted,
                         (
                             CASE
                                 WHEN staffassigned IS NULL
                                 THEN '(none)'
                                 WHEN regexp_count (staffassigned, ',') > 0
                                 THEN 'multiple'
                                 ELSE upper (regexp_replace (replace (staffassigned, '  ', ' '), '[0-9]', ''))
                             END
                         ) staffassigned,
                         investigationoutcome
                  FROM g_mvw_case_inv
                  WHERE investigationcompleted IS NOT NULL
                 ) sub
           )
      WHERE seq_no = 1
     ) firstinv,
     (SELECT casejobid,
             investigationcompleted,
             staffassigned,
             investigationoutcome
      FROM (SELECT sub.*,
                   ROW_NUMBER () OVER (
                       PARTITION BY casejobid
                       ORDER BY investigationcompleted DESC NULLS LAST
                   ) seq_no
            FROM (SELECT casejobid,
                         investigationcompleted,
                         (
                             CASE
                                 WHEN staffassigned IS NULL
                                 THEN '(none)'
                                 WHEN regexp_count (staffassigned, ',') > 0
                                 THEN 'multiple'
                                 ELSE upper (regexp_replace (replace (staffassigned, '  ', ' '), '[0-9]', ''))
                             END
                         ) staffassigned,
                         investigationoutcome
                  FROM g_mvw_case_inv
                  WHERE investigationcompleted IS NOT NULL
                 ) sub
           )
      WHERE seq_no = 1
     ) mostrecentinv,
     eclipse_lni_addr addr,
     (SELECT DISTINCT prob,
                      sla
      FROM sla_dictionary
     ) sla
WHERE compl.casefilejobid = cases.jobid (+)
      AND compl.jobid            = reviewcomplaint.jobid (+)
      AND cases.jobid            = firstinv.casejobid (+)
      AND cases.jobid            = mostrecentinv.casejobid (+)
      AND compl.addressobjectid  = addr.addressobjectid (+)
      AND compl.complaintcode    = sla.prob (+)
ORDER BY compl.complaintnumber