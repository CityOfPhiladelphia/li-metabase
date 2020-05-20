SELECT DISTINCT lic.licensetype licensetype,
                lic.licensenumber,
                ap.externalfilenum jobnumber,
                ap.applicationtype jobtype,
                lic.licenseissuedate issuedate
FROM lmscorral.tl_tradelicenses lic,
     query.j_tl_application ap
WHERE lic.objectid = ap.tradelicenseobjectid (+)
      AND lic.licenseissuedate >= '01-JAN-17'
      AND lic.licenseissuedate < sysdate
      AND ap.statusdescription LIKE 'Approved'
UNION
SELECT DISTINCT lic.licensetype licensetype,
                lic.licensenumber,
                tar.externalfilenum jobnumber,
                tar.applicationtype jobtype,
                tar.completeddate issuedate
FROM lmscorral.tl_tradelicenses lic,
     query.r_tl_amendrenew_license ar,
     query.j_tl_amendrenew tar
WHERE lic.objectid = ar.licenseid (+)
      AND ar.amendrenewid = tar.objectid (+)
      AND tar.completeddate >= '01-JAN-17'
      AND tar.completeddate < sysdate
      AND tar.statusdescription LIKE 'Approved'
      AND tar.applicationtype LIKE 'Renewal'