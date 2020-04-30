SELECT tl.licensenumber,
       tl.licensetype,
       tl.issuedate licenseissuedate,
       tl.expirationdate licenseexpirationdate,
       upper (tl.status) licensestatus,
       upper (tl.contactname) contactname,
       upper (tl.companyname) companyname,
       'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2855291&objectHandle=' || tl.objectid AS licenselink
       ,
       p2.permitnumber,
       p2.permittype,
       p2.permitdescription,
       p2.typeofwork permittypeofwork,
       p2.createddate permitcreateddate,
       p2.issuedate permitissuedate,
       p2.permitstatus,
       p2.completeddate permitcompleteddate,
       i.inspectiontype,
       i.inspectionscheduledstartdate,
       i.inspectioncompleteddate,
       i.inspectionoutcome,
       i.inspectorname,
       a.base_address address,
       i.inspectionprocessid,
       (
           CASE
               WHEN p2.count_days_w_vios_while_open IS NULL
               THEN 'No'
               ELSE 'Yes'
           END
       ) vioswhileopen,
       tl.soleproprietor
FROM g_mvw_trade_licenses tl,
     g_mvw_contractor c,
     (SELECT p1.jobid,
             p1.addressobjectid,
             p1.contractorid,
             p1.permitnumber,
             p1.permittype,
             p1.permitdescription,
             p1.typeofwork,
             p1.createddate,
             p1.issuedate,
             p1.permitstatus,
             p1.completeddate,
             pv.dates_with_violations count_days_w_vios_while_open
      FROM g_mvw_permits p1,
           mvw_permits_vios_while_open1 pv
      WHERE p1.issuedate IS NOT NULL
            AND p1.issuedate >= add_months (trunc (sysdate, 'MM'), - 36)
            AND p1.createddate < trunc (sysdate)
            AND p1.issuedate < trunc (sysdate)
            AND (p1.addressobjectid = pv.addressobjectid (+)
                 AND p1.jobid = pv.jobid (+))
     ) p2,
     (SELECT jobid,
             inspectiontype,
             inspectionscheduledstartdate,
             inspectioncompleteddate,
             inspectionoutcome,
             inspectorlastname || ', ' || inspectorfirstname AS inspectorname,
             inspectionprocessid
      FROM g_mvw_perm_insp
      WHERE inspectioncompleteddate IS NOT NULL
            AND inspectioncompleteddate >= add_months (trunc (sysdate, 'MM'), - 36)
            AND inspectioncreateddate < trunc (sysdate)
            AND inspectioncompleteddate < trunc (sysdate)
            AND inspectionoutcome IN (
          'Partially Passed',
          'Failed'
      )
     ) i,
     eclipse_lni_addr a
WHERE tl.contractorobjectid = c.objectid (+)
      AND c.objectid          = p2.contractorid (+)
      AND p2.jobid            = i.jobid (+)
      AND p2.addressobjectid  = a.addressobjectid (+)
ORDER BY tl.licensenumber,
         p2.permitnumber