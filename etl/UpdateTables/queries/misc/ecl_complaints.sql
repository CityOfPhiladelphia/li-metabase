SELECT sub.compljobid,
       sub.complaintnumber,
       addr.base_address address,
       sub.complaintcode,
       sub.complaintcodename,
       sub.complaintdate,
       sub.complaintstatus,
       sub.reviewcomplaint_date,
       sub.reviewcomplaint_status,
       sub.reviewcomplaint_assignedto,
       sub.reviewcomplaint_outcome,
       c.casenumber,
       sub.mostrecentinv_date,
       to_char (sub.mostrecentinv_date, 'DAY') mostrecentcaseinv_dayofweek,
       sub.mostrecentinv_status,
       sub.mostrecentinv_assignedto,
       sub.mostrecentinv_outcome,
       sub.complaint_resolutiondate,
       sub.resolutionstatus,
       sub.inspectiondiscipline,
       sub.origintype,
       addr.li_district district,
       s.sla sla,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (addr.geocode_x, addr.geocode_y, NULL), NULL, NULL), 4326).sdo_point
       .x lon,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (addr.geocode_x, addr.geocode_y, NULL), NULL, NULL), 4326).sdo_point
       .y lat
FROM (SELECT compl.jobid compljobid,
             compl.complaintnumber,
             compl.addressobjectid,
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
             reviewcomplaint.staffassigned reviewcomplaint_assignedto,
             reviewcomplaint.outcome reviewcomplaint_outcome,
             compl.casefilejobid,
             mostrecentinv.investigationcompleted mostrecentinv_date,
             (
                 CASE
                     WHEN mostrecentinv.investigationcompleted IS NOT NULL
                     THEN 'Investigated'
                     WHEN mostrecentinv.investigationcompleted IS NULL
                     THEN 'Uninvestigated'
                 END
             ) mostrecentinv_status,
             mostrecentinv.staffassigned mostrecentinv_assignedto,
             mostrecentinv.investigationoutcome mostrecentinv_outcome,
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
             compl.origintype
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
                                       ELSE UPPER (regexp_replace (replace (staffassigned, '  ', ' '), '[0-9]', ''))
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
                                       ELSE UPPER (regexp_replace (replace (staffassigned, '  ', ' '), '[0-9]', ''))
                                   END
                               ) staffassigned,
                               investigationoutcome
                        FROM g_mvw_case_inv
                        WHERE investigationcompleted IS NOT NULL
                       ) sub
                 )
            WHERE seq_no = 1
           ) mostrecentinv
      WHERE compl.casefilejobid = cases.jobid (+)
            AND compl.jobid  = reviewcomplaint.jobid (+)
            AND cases.jobid  = mostrecentinv.casejobid (+)
     ) sub,
     eclipse_lni_addr addr,
     g_mvw_cases c,
     sla_dictionary s
WHERE sub.addressobjectid = addr.addressobjectid (+)
      AND sub.casefilejobid  = c.jobid (+)
      AND sub.complaintdate >= ' 01-JAN-2018'
      AND sub.complaintcode  = s.prob (+)
ORDER BY sub.complaintdate