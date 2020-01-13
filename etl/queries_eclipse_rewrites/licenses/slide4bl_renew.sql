SELECT DISTINCT
                            (
                                CASE
                                    WHEN ar.createdby LIKE '%2%' THEN 'Online'
                                    WHEN ar.createdby LIKE '%3%' THEN 'Online'
                                    WHEN ar.createdby LIKE '%4%' THEN 'Online'
                                    WHEN ar.createdby LIKE '%5%' THEN 'Online'
                                    WHEN ar.createdby LIKE '%6%' THEN 'Online'
                                    WHEN ar.createdby LIKE '%7%' THEN 'Online'
                                    WHEN ar.createdby LIKE '%7%' THEN 'Online'
                                    WHEN ar.createdby LIKE '%9%' THEN 'Online'
                                    WHEN ar.createdby = 'PPG User'                THEN 'Online'
                                    WHEN ar.createdby = 'POSSE system power user' THEN 'Revenue'
                                    ELSE 'Staff'
                                END
                            ) AS createdbytype,
                            (
                                CASE
                                    WHEN ar.applicationtype LIKE 'Renewal' THEN 'Renewal'
                                END
                            ) jobtype,
                            lt.name licensetype,
                            lic.externalfilenum licensenumber,
                            EXTRACT(MONTH FROM ar.issuedate) issuemonth,
                            EXTRACT(YEAR FROM ar.issuedate) issueyear
                          FROM
                            query.j_bl_amendrenew ar,
                            query.r_bl_amendrenew_license arl,
                            query.o_bl_license lic,
                            lmscorral.bl_licensetype lt
                          WHERE
                            lic.licensetypeid = lt.objectid
                            AND lic.objectid = arl.licenseid
                            AND arl.amendrenewid = ar.jobid
                            AND ar.statusdescription LIKE 'Approved'
                            AND ar.issuedate > '01-APR-16'
                            AND ar.issuedate < SYSDATE
                            AND ar.applicationtype LIKE 'Renewal'
