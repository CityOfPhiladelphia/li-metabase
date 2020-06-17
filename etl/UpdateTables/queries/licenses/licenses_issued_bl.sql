SELECT licensetype,
       licensenumber,
       jobnumber,
       jobtype,
       licenseissuedate issuedate,
       (
           CASE
               WHEN jobtype LIKE 'Application'
               THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle=' || jobid
               WHEN jobtype LIKE 'Renewal'
               THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle=' || jobid
           END
       ) joblink
FROM g_mvw_bl_jobs
WHERE jobtype IN (
    'Application',
    'Renewal'
)
      AND jobstatus LIKE 'Approved'
      AND licenseissuedate >= '01-JAN-17'
      AND licenseissuedate < sysdate