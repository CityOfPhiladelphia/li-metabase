SELECT tl.licensenumber,
       tl.licensetype,
       tl.issuedate licenseissuedate,
       tl.expirationdate licenseexpirationdate,
       upper (tl.status) licensestatus,
       upper (tl.contactname) contactname,
       upper (tl.companyname) companyname,
       'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2855291&objectHandle=' || tl.objectid AS licenselink
       ,
       p.permitnumber,
       p.permittype,
       p.permitdescription,
       p.typeofwork permittypeofwork,
       p.createddate permitcreateddate,
       p.issuedate permitissuedate,
       p.permitstatus,
       p.completeddate permitcompleteddate,
       i.inspectiontype,
       i.inspectionscheduledstartdate,
       i.inspectioncompleteddate,
       i.inspectionoutcome,
       i.inspectorname,
       a.base_address address,
       i.inspectionprocessid,
       tl.soleproprietor
FROM g_mvw_trade_licenses tl,
     g_mvw_contractor c,
     (SELECT jobid,
             addressobjectid,
             contractorid,
             permitnumber,
             permittype,
             permitdescription,
             typeofwork,
             createddate,
             issuedate,
             permitstatus,
             completeddate
      FROM g_mvw_permits p
      WHERE issuedate IS NOT NULL
            AND issuedate >= add_months (trunc (sysdate, 'MM'), - 36)
            AND createddate < trunc (sysdate)
            AND issuedate < trunc (sysdate)
     ) p,
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
      AND c.objectid         = p.contractorid (+)
      AND p.jobid            = i.jobid (+)
      AND p.addressobjectid  = a.addressobjectid (+)
ORDER BY tl.licensenumber,
         p.permitnumber