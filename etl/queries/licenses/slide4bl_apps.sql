SELECT DISTINCT
(
    CASE
        WHEN ap.createdby LIKE '%2%' THEN 'Online'
        WHEN ap.createdby LIKE '%3%' THEN 'Online'
        WHEN ap.createdby LIKE '%4%' THEN 'Online'
        WHEN ap.createdby LIKE '%5%' THEN 'Online'
        WHEN ap.createdby LIKE '%6%' THEN 'Online'
        WHEN ap.createdby LIKE '%7%' THEN 'Online'
        WHEN ap.createdby LIKE '%7%' THEN 'Online'
        WHEN ap.createdby LIKE '%9%' THEN 'Online'
        WHEN ap.createdby = 'PPG User'                THEN 'Online'
        WHEN ap.createdby = 'POSSE system power user' THEN 'Revenue'
        ELSE 'Staff'
    END
) AS createdbytype,
(
    CASE
        WHEN ap.applicationtype LIKE 'Application' THEN 'Application'
    END
) jobtype,
lt.name licensetype,
lic.externalfilenum licensenumber,
EXTRACT(MONTH FROM ap.issuedate) issuemonth,
EXTRACT(YEAR FROM ap.issuedate) issueyear
FROM
query.j_bl_application ap,
query.r_bl_application_license apl,
query.o_bl_license lic,
lmscorral.bl_licensetype lt
WHERE
lic.licensetypeid = lt.objectid
AND lic.objectid = apl.licenseobjectid
AND apl.applicationobjectid = ap.jobid
AND ap.statusdescription LIKE 'Approved'
AND lic.initialissuedate > '01-APR-16'
AND lic.initialissuedate < SYSDATE
AND ap.applicationtype = 'Application'
