SELECT proc.processid,
       pt.description processtype,
       j.externalfilenum jobnumber,
       replace (jt.description, 'Business License ', '') jobtype,
       (
           CASE
               WHEN ap.licensetypesdisplayformat IS NOT NULL
               THEN ap.licensetypesdisplayformat
               ELSE '(none)'
           END
       ) licensetype,
       (
           CASE
               WHEN proc.assignedstaff IS NULL
               THEN '(none)'
               ELSE 'multiple'
           END
       ) assignedstaff,
       (
           CASE
               WHEN regexp_count (proc.assignedstaff, ',') IS NULL
               THEN 0
               ELSE regexp_count (proc.assignedstaff, ',') + 1
           END
       ) numassignedstaff,
       proc.scheduledstartdate scheduledstartdate,
       sysdate - proc.scheduledstartdate timesincescheduledstartdate,
       (
           CASE
               WHEN jt.description LIKE 'Business License Application'
               THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle=' || j.
               jobid || '&processHandle=' || proc.processid || '&paneId=1239699_151'
           END
       ) joblink,
       stat.description jobstatus
FROM api.processes proc,
     api.processtypes pt,
     api.jobs j,
     api.jobtypes jt,
     api.statuses stat,
     query.j_bl_application ap
WHERE proc.jobid = j.jobid
      AND j.jobid             = ap.jobid
      AND proc.processtypeid  = pt.processtypeid
      AND j.jobtypeid         = jt.jobtypeid
      AND j.statusid          = stat.statusid
      AND proc.datecompleted IS NULL
      AND (proc.assignedstaff IS NULL
           OR regexp_count (proc.assignedstaff, ',') > 0)
UNION
SELECT proc.processid,
       pt.description processtype,
       j.externalfilenum jobnumber,
       replace (jt.description, 'Business License ', '') jobtype,
       (
           CASE
               WHEN ap.licensetypesdisplayformat IS NOT NULL
               THEN ap.licensetypesdisplayformat
               ELSE '(none)'
           END
       ) licensetype,
       initcap (regexp_replace (replace (u.name, '  ', ' '), '[0-9]', '')) assignedstaff,
       1 numassignedstaff,
       proc.scheduledstartdate scheduledstartdate,
       sysdate - proc.scheduledstartdate timesincescheduledstartdate,
       (
           CASE
               WHEN jt.description LIKE 'Business License Application'
               THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle=' || j.
               jobid || '&processHandle=' || proc.processid || '&paneId=1239699_151'
           END
       ) joblink,
       stat.description jobstatus
FROM api.processes proc,
     api.processtypes pt,
     api.jobs j,
     api.jobtypes jt,
     api.statuses stat,
     query.j_bl_application ap,
     api.users u
WHERE proc.jobid = j.jobid
      AND j.jobid                               = ap.jobid
      AND proc.processtypeid                    = pt.processtypeid
      AND j.jobtypeid                           = jt.jobtypeid
      AND j.statusid                            = stat.statusid
      AND proc.assignedstaff                    = u.oraclelogonid
      AND proc.datecompleted IS NULL
      AND regexp_count (proc.assignedstaff, ',') = 0
UNION
SELECT proc.processid,
       pt.description processtype,
       j.externalfilenum jobnumber,
       replace (replace (jt.description, 'Business License ', ''), 'Amendment/Renewal', 'Amend/Renew') jobtype,
       (
           CASE
               WHEN ar.licensetypesdisplayformat IS NOT NULL
               THEN ar.licensetypesdisplayformat
               ELSE '(none)'
           END
       ) licensetype,
       (
           CASE
               WHEN proc.assignedstaff IS NULL
               THEN '(none)'
               ELSE 'multiple'
           END
       ) assignedstaff,
       (
           CASE
               WHEN regexp_count (proc.assignedstaff, ',') IS NULL
               THEN 0
               ELSE regexp_count (proc.assignedstaff, ',') + 1
           END
       ) numassignedstaff,
       proc.scheduledstartdate scheduledstartdate,
       sysdate - proc.scheduledstartdate timesincescheduledstartdate,
       (
           CASE
               WHEN jt.description LIKE 'Amendment/Renewal'
               THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle=' || j.
               jobid || '&processHandle=' || proc.processid || '&paneId=1243107_175'
           END
       ) joblink,
       stat.description jobstatus
FROM api.processes proc,
     api.processtypes pt,
     api.jobs j,
     api.jobtypes jt,
     api.statuses stat,
     query.j_bl_amendrenew ar
WHERE proc.jobid = j.jobid
      AND j.jobid             = ar.jobid
      AND proc.processtypeid  = pt.processtypeid
      AND j.jobtypeid         = jt.jobtypeid
      AND j.statusid          = stat.statusid
      AND proc.datecompleted IS NULL
      AND (proc.assignedstaff IS NULL
           OR regexp_count (proc.assignedstaff, ',') > 0)
UNION
SELECT proc.processid,
       pt.description processtype,
       j.externalfilenum jobnumber,
       replace (replace (jt.description, 'Business License ', ''), 'Amendment/Renewal', 'Amend/Renew') jobtype,
       (
           CASE
               WHEN ar.licensetypesdisplayformat IS NOT NULL
               THEN ar.licensetypesdisplayformat
               ELSE '(none)'
           END
       ) licensetype,
       initcap (regexp_replace (replace (u.name, '  ', ' '), '[0-9]', '')) assignedstaff,
       1 numassignedstaff,
       proc.scheduledstartdate scheduledstartdate,
       sysdate - proc.scheduledstartdate timesincescheduledstartdate,
       (
           CASE
               WHEN jt.description LIKE 'Amendment/Renewal'
               THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle=' || j.
               jobid || '&processHandle=' || proc.processid || '&paneId=1243107_175'
           END
       ) joblink,
       stat.description jobstatus
FROM api.processes proc,
     api.processtypes pt,
     api.jobs j,
     api.jobtypes jt,
     api.statuses stat,
     query.j_bl_amendrenew ar,
     api.users u
WHERE proc.jobid = j.jobid
      AND j.jobid                               = ar.jobid
      AND proc.processtypeid                    = pt.processtypeid
      AND j.jobtypeid                           = jt.jobtypeid
      AND j.statusid                            = stat.statusid
      AND proc.assignedstaff                    = u.oraclelogonid
      AND proc.datecompleted IS NULL
      AND regexp_count (proc.assignedstaff, ',') = 0