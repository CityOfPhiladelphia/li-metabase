SELECT DISTINCT *
FROM (SELECT j.externalfilenum jobnumber,
             replace (jt.description, 'Business License ', '') jobtype,
             (
                 CASE
                     WHEN ar.licensetypesdisplayformat IS NOT NULL
                     THEN ar.licensetypesdisplayformat
                     ELSE '(none)'
                 END
             ) licensetype,
             stat.description jobstatus,
             proc.processid processid,
             pt.description processtype,
             proc.createddate createddate,
             proc.scheduledstartdate scheduledstartdate,
             proc.processstatus processstatus,
             (
                 CASE
                     WHEN round (sysdate - proc.scheduledstartdate) <= 1
                     THEN '0-1 Day'
                     WHEN round (sysdate - proc.scheduledstartdate) BETWEEN 2 AND 5
                     THEN '2-5 Days'
                     WHEN round (sysdate - proc.scheduledstartdate) BETWEEN 6 AND 10
                     THEN '6-10 Days'
                     WHEN round (sysdate - proc.scheduledstartdate) BETWEEN 11 AND 365
                     THEN '11 Days-1 Year'
                     ELSE 'Over 1 Year'
                 END
             ) timesincescheduledstartdate,
             (
                 CASE
                     WHEN jt.description LIKE 'Business License Application'
                     THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
                     || j.jobid || '&processHandle=' || proc.processid || '&paneId=1239699_151'
                     WHEN jt.description LIKE 'Amendment/Renewal'
                     THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
                     || j.jobid || '&processHandle=' || proc.processid || '&paneId=1243107_175'
                 END
             ) processlink
      FROM api.processes proc,
           api.jobs j,
           api.processtypes pt,
           api.jobtypes jt,
           api.statuses stat,
           query.j_bl_amendrenew ar
      WHERE proc.jobid = j.jobid
            AND proc.processtypeid  = pt.processtypeid
            AND proc.datecompleted IS NULL
            AND j.jobtypeid         = jt.jobtypeid
            AND j.statusid          = stat.statusid
            AND pt.processtypeid NOT IN (
          '984507',
          '2852606',
          '2853029'
      ) --Exclude "Pay Fees", "Provide More Information for Renewal", and "Amend License" processes
            AND jt.jobtypeid        = '1240320'
            AND j.statusid NOT IN (
          '1030266',
          '964970',
          '1014809',
          '1036493',
          '1010379'
      ) --Exclude jobs that have statuses of "Approved", "Deleted", "Draft", "Withdrawn", or "More Information Required" 
            AND j.jobid             = ar.jobid (+)
      UNION
      SELECT j.externalfilenum jobnumber,
             replace (jt.description, 'Business License ', '') jobtype,
             (
                 CASE
                     WHEN ap.licensetypesdisplayformat IS NOT NULL
                     THEN ap.licensetypesdisplayformat
                     ELSE '(none)'
                 END
             ) licensetype,
             stat.description jobstatus,
             proc.processid processid,
             pt.description processtype,
             proc.createddate createddate,
             proc.scheduledstartdate scheduledstartdate,
             proc.processstatus processstatus,
             (
                 CASE
                     WHEN round (sysdate - proc.scheduledstartdate) <= 1
                     THEN '0-1 Day'
                     WHEN round (sysdate - proc.scheduledstartdate) BETWEEN 2 AND 5
                     THEN '2-5 Days'
                     WHEN round (sysdate - proc.scheduledstartdate) BETWEEN 6 AND 10
                     THEN '6-10 Days'
                     WHEN round (sysdate - proc.scheduledstartdate) BETWEEN 11 AND 365
                     THEN '11 Days-1 Year'
                     ELSE 'Over 1 Year'
                 END
             ) timesincescheduledstartdate,
             (
                 CASE
                     WHEN jt.description LIKE 'Business License Application'
                     THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
                     || j.jobid || '&processHandle=' || proc.processid || '&paneId=1239699_151'
                     WHEN jt.description LIKE 'Amendment/Renewal'
                     THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
                     || j.jobid || '&processHandle=' || proc.processid || '&paneId=1243107_175'
                 END
             ) processlink
      FROM api.processes proc,
           api.jobs j,
           api.processtypes pt,
           api.jobtypes jt,
           api.statuses stat,
           query.j_bl_application ap
      WHERE proc.jobid = j.jobid
            AND proc.processtypeid  = pt.processtypeid
            AND proc.datecompleted IS NULL
            AND j.jobtypeid         = jt.jobtypeid
            AND j.statusid          = stat.statusid
            AND pt.processtypeid NOT IN (
          '984507',
          '2852606',
          '2853029'
      )  --Exclude "Pay Fees", "Provide More Information for Renewal", and "Amend License" processes
            AND jt.jobtypeid        = '1244773'
            AND j.statusid NOT IN (
          '1030266',
          '964970',
          '1014809',
          '1036493',
          '1010379'
      )  --Exclude jobs that have statuses of "Approved", "Deleted", "Draft", "Withdrawn", or "More Information Required" 
            AND j.jobid             = ap.jobid (+)
)