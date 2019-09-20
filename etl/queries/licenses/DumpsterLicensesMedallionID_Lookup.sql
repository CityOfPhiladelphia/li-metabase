SELECT DISTINCT
    lic.licensenumber,
    lt.name,
    lic.licensestate,
    dum.medallionid,
    dum.dumpstersize,
    dum.dumpstertype,
    dum.createddate,
    dum.lastupdateddate
FROM
    lmscorral.bl_license       lic,
    lmscorral.bl_dumpster      dum,
    lmscorral.bl_licensetype   lt
WHERE
    lic.objectid = dum.licenseid
    AND lic.licensetypeobjectid = lt.objectid
ORDER BY
    lic.licensenumber