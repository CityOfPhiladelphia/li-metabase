SELECT proc.processid,
       proc.processtype,
       j.jobnumber,
       j.jobtype,
       (
           CASE
               WHEN j.licensetype IS NOT NULL
               THEN j.licensetype
               ELSE '(none)'
           END
       ) licensetype,
       j.jobstatus,
       (
           CASE
               WHEN proc.staffassigned IS NULL
               THEN '(none)'
               WHEN regexp_count (proc.staffassigned, ',') > 0
               THEN 'multiple'
               ELSE initcap (regexp_replace (replace (proc.staffassigned, '  ', ' '), '[0-9]', ''))
           END
       ) assignedstaff,
       (
           CASE
               WHEN proc.staffassigned IS NULL
               THEN 0
               WHEN regexp_count (proc.staffassigned, ',') > 0
               THEN regexp_count (proc.staffassigned, ',') + 1
               ELSE 1
           END
       ) numassignedstaff,
       proc.createddate,
       proc.scheduledstartdate,
       sysdate - proc.scheduledstartdate timesincescheduledstartdate,
       proc.processstatus,
       (
           CASE
               WHEN j.jobtype = 'Application'
               THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle=' || j.
               jobid || '&processHandle=' || proc.processid || '&paneId=2854033_140'
               WHEN j.jobtype IN (
                   'Renewal',
                   'Amendment'
               )
               THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle=' || j.
               jobid || '&processHandle=' || proc.processid || '&paneId=2857688_116'
           END
       ) processlink
FROM g_mvw_processes proc,
     g_mvw_bl_jobs j
WHERE proc.jobid = j.jobid
      AND proc.datecompleted IS NULL