SELECT DISTINCT lic.licensenumber,
                lic.licensetype,
                lic.issuedate,
                lic.expirationdate,
                mri.jobnumber mostrecentjobnumber,
                mri.jobtype mostrecentjobtype,
                mri.completeddate mostrecentissuancedate,
                (
                    CASE
                        WHEN mri.createdby LIKE '%2%'
                        THEN 'Online'
                        WHEN mri.createdby LIKE '%3%'
                        THEN 'Online'
                        WHEN mri.createdby LIKE '%4%'
                        THEN 'Online'
                        WHEN mri.createdby LIKE '%5%'
                        THEN 'Online'
                        WHEN mri.createdby LIKE '%6%'
                        THEN 'Online'
                        WHEN mri.createdby LIKE '%7%'
                        THEN 'Online'
                        WHEN mri.createdby LIKE '%8%'
                        THEN 'Online'
                        WHEN mri.createdby LIKE '%9%'
                        THEN 'Online'
                        WHEN mri.createdby = 'PPG User'
                        THEN 'Online'
                        WHEN mri.createdby = 'POSSE system power user'
                        THEN 'Revenue'
                        ELSE 'Staff'
                    END
                ) mostrecentjobcreatedbytype,
                'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2855291&objectHandle=' || lic.objectid
                AS licenselink
FROM g_mvw_trade_licenses lic,
     (SELECT licensenumber,
             createdby,
             jobnumber,
             jobtype,
             createddate,
             completeddate
      FROM (SELECT sub.*,
                   ROW_NUMBER () OVER (
                       PARTITION BY licensenumber
                       ORDER BY completeddate DESC NULLS LAST
                   ) seq_no
            FROM (SELECT licensenumber,
                         createdby,
                         jobnumber,
                         jobtype,
                         createddate,
                         completeddate
                  FROM g_mvw_tl_jobs
                  WHERE jobtype IN (
                      'Application',
                      'Renewal'
                  )
                        AND jobstatus = 'Approved'
                 ) sub
           )
      WHERE seq_no = 1
     ) mri   -- "most recent issuance"
WHERE lic.licensenumber = mri.licensenumber (+)
      AND lic.expirationdate >= add_months (trunc (sysdate, 'MM'), - 13)