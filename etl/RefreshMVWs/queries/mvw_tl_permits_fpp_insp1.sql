SELECT licensenumber,
       licensetype,
       licenseissuedate,
       licenseexpirationdate,
       licensestatus,
       upper(contactname) contactname,
       upper(companyname) companyname,
       licenselink,
       permitnumber,
       permittype,
       permitdescription,
       permittypeofwork,
       permitcreateddate,
       permitissuedate,
       UPPER(permitstatus) permitstatus,
       permitcompleteddate,
       permitcostorvalueofwork,
       inspectiontype,
       inspectionscheduledstartdate,
       inspectioncompleteddate,
       inspectionoutcome,
       inspectorname,
       address,
       inspectionprocessid,
       vioswhileopen,
       soleproprietor,
       'ECLIPSE' systemofrecord
FROM ecl_tl_permits_fpp_insp
UNION
SELECT licensenumber,
       licensetype,
       licenseissuedate,
       licenseexpirationdate,
       licensestatus,
       upper(contactname) contactname,
       upper(companyname) companyname,
       posselink licenselink,
       permitnumber,
       permittype,
       permittypedesc permitdescription,
       permitworktype permittypeofwork,
       permitprocesseddate permitcreateddate,
       permitissuancedate permitissuedate,
       permitstatus,
       permitfinaleddate permitcompleteddate,
       permitdeclaredvalue permitcostorvalueofwork,
       inspectiondescription inspectiontype,
       inspectionscheduled inspectionscheduledstartdate,
       inspectioncompleted inspectioncompleteddate,
       (
           CASE
               WHEN inspectionstatus = 'Failed'
               THEN inspectionstatus
               WHEN inspectionstatus IS NULL
               THEN inspectionstatus
               WHEN inspectionstatus = 'Partial Passed'
               THEN 'Partially Passed'
           END
       ) inspectionoutcome,
       inspectorname,
       address,
       apinspkey inspectionprocessid,
       vioswhileopen,
       soleproprietor,
       'HANSEN' systemofrecord
FROM contlic_permits_fpp_insp