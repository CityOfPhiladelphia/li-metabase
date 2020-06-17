SELECT DISTINCT lic.licensenumber,
                lic.licensetype,
                lic.expirationdate,
                mri.jobnumber mostrecentjobnumber,
                (
                    CASE
                        WHEN mri.jobtype IS NOT NULL
                        THEN mri.jobtype
                        ELSE '(none)'
                    END
                ) mostrecentjobtype,
                mri.jobcreateddate mostrecentjobcreateddate,
                mri.jobcompleteddate mostrecentjobcompleteddate,
                (
                    CASE
                        WHEN mri.createdbyusername LIKE '%2%'
                        THEN 'Online'
                        WHEN mri.createdbyusername LIKE '%3%'
                        THEN 'Online'
                        WHEN mri.createdbyusername LIKE '%4%'
                        THEN 'Online'
                        WHEN mri.createdbyusername LIKE '%5%'
                        THEN 'Online'
                        WHEN mri.createdbyusername LIKE '%6%'
                        THEN 'Online'
                        WHEN mri.createdbyusername LIKE '%7%'
                        THEN 'Online'
                        WHEN mri.createdbyusername LIKE '%8%'
                        THEN 'Online'
                        WHEN mri.createdbyusername LIKE '%9%'
                        THEN 'Online'
                        WHEN mri.createdbyusername = 'PPG User'
                        THEN 'Online'
                        WHEN mri.createdbyusername = 'POSSE system power user'
                        THEN 'Revenue'
                        WHEN mri.createdbyusername IS NOT NULL
                        THEN 'Staff'
                        ELSE '(none)'
                    END
                ) mostrecentjobcreatedbytype,
                'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1244067&objectHandle=' || lic.licenseobjectid
                licenselink
FROM g_mvw_business_licenses lic,
     (SELECT licensenumber,
             createdbyusername,
             jobnumber,
             jobtype,
             jobcreateddate,
             jobcompleteddate
      FROM (SELECT sub.*,
                   ROW_NUMBER () OVER (
                       PARTITION BY licensenumber
                       ORDER BY jobcompleteddate DESC NULLS LAST
                   ) seq_no
            FROM (SELECT licensenumber,
                         createdbyusername,
                         jobnumber,
                         jobtype,
                         jobcreateddate,
                         jobcompleteddate
                  FROM g_mvw_bl_jobs
                  WHERE jobstatus = 'Approved'
                 ) sub
           )
      WHERE seq_no = 1
     ) mri   -- "most recent issuance"
WHERE lic.licensenumber = mri.licensenumber (+)
      AND lic.expirationdate >= add_months (trunc (sysdate, 'MM'), - 13)