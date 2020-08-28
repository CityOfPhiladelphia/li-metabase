SELECT
    i.jobid                              jobid,
    i.inspectionprocessid                inspectionprocessid,
    i.inspectiontype                     inspectiontype,
    i.inspectioncreateddate              inspectioncreateddate,
    i.inspectionrequesteddate            inspectionrequesteddate,
    i.inspectionscheduledstartdate       inspectionscheduleddate,
    i.inspectioncompleteddate            inspectioncompleteddate,
    i.inspectionoutcome                  inspectionoutcome,
    i.inspectorcomments                  inspectorcomments,
    CASE
        WHEN i.inspectorname IS NULL THEN
            '(none)'
        ELSE
            i.inspectorname
    END inspectorname,
    first_insp.inspectioncompleteddate   initialinspectiondate,
    p.mostrecentinsp                     mostrecentinsp,
    i.permitnumber                       permitnumber,
    i.permittype                         permittype,
    i.permitstatus                       permitstatus,
    p.issuedate                          permitissuedate,
    p.applicanttype                      permitapplicanttype,
    p.typeofwork                         permittypeofwork,
    CASE
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '31-MAR-2020' AND '01-JUL-2020' THEN
            'FY20Q4'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '31-DEC-2019' AND '01-APR-2020' THEN
            'FY20Q3'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '30-SEP-2019' AND '01-JAN-2020' THEN
            'FY20Q2'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '30-JUN-2019' AND '01-NOV-2019' THEN
            'FY20Q1'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '30-JUN-2020' AND '01-NOV-2020' THEN
            'FY21Q1'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '30-SEP-2020' AND '01-JAN-2021' THEN
            'FY21Q2'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '31-DEC-2019' AND '01-APR-2020' THEN
            'FY21Q3'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '31-MAR-2021' AND '01-JUL-2021' THEN
            'FY21Q4'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '30-JUN-2021' AND '01-NOV-2021' THEN
            'FY22Q1'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '30-SEP-2022' AND '01-JAN-2022' THEN
            'FY22Q2'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '31-DEC-2021' AND '01-APR-2021' THEN
            'FY22Q3'
        WHEN trunc(i.inspectioncompleteddate) BETWEEN '31-MAR-2022' AND '01-JUL-2022' THEN
            'FY22Q4'
        WHEN trunc(i.inspectioncompleteddate) IS NULL THEN
            '(none)'
    END inspcompleteddatefiscal,
    CASE
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '31-MAR-2020' AND '01-JUL-2020' THEN
            'FY20Q4'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '31-DEC-2019' AND '01-APR-2020' THEN
            'FY20Q3'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '30-SEP-2019' AND '01-JAN-2020' THEN
            'FY20Q2'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '30-JUN-2019' AND '01-NOV-2019' THEN
            'FY20Q1'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '30-JUN-2020' AND '01-NOV-2020' THEN
            'FY21Q1'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '30-SEP-2020' AND '01-JAN-2021' THEN
            'FY21Q2'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '31-DEC-2019' AND '01-APR-2020' THEN
            'FY21Q3'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '31-MAR-2021' AND '01-JUL-2021' THEN
            'FY21Q4'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '30-JUN-2021' AND '01-NOV-2021' THEN
            'FY22Q1'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '30-SEP-2022' AND '01-JAN-2022' THEN
            'FY22Q2'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '31-DEC-2021' AND '01-APR-2021' THEN
            'FY22Q3'
        WHEN trunc(i.inspectionscheduledstartdate) BETWEEN '31-MAR-2022' AND '01-JUL-2022' THEN
            'FY22Q4'
        WHEN trunc(i.inspectionscheduledstartdate) IS NULL THEN
            '(none)'
    END inspscheduleddatefiscal,
    case 
        when p.mostrecentinsp is null then 0
        else trunc(sysdate) - trunc(p.mostrecentinsp) 
    end dayssincemostrecinsp,
    case 
        when p.mostrecentinsp is null then 'n/a - not inspected'
        when trunc(sysdate) - trunc(p.mostrecentinsp) < 0 then 'n/a - not inspected'
        when trunc(sysdate) - trunc(p.mostrecentinsp) <= 5 then '0-5'
        when trunc(sysdate) - trunc(p.mostrecentinsp) <= 20 then '6-20'
        when trunc(sysdate) - trunc(p.mostrecentinsp) <= 90 then '21-90'
        else '90+'
    end dayssincemostrecinspcat,
    CASE
        WHEN trunc(i.inspectioncompleteddate) IS NULL
             AND ( trunc(i.inspectionscheduledstartdate) < trunc(sysdate) ) THEN
            trunc(sysdate) - trunc(i.inspectionscheduledstartdate)
        ELSE
            0
    END overdueinspection,
    CASE
        WHEN i.inspectionscheduledstartdate IS NULL THEN
            'n/a - no scheduled start date'
        when trunc(i.inspectioncompleteddate) is not null and trunc(i.inspectionscheduledstartdate) - trunc(i.inspectioncompleteddate) < 0 then 'n/a - completed on time'
        when i.inspectioncompleteddate is not null then 'n/a - completed on time'
        WHEN (trunc(i.inspectioncompleteddate) IS NULL AND (trunc(sysdate) - trunc(i.inspectionscheduledstartdate))  < 0 )
        THEN 'n/a - scheduled start date upcoming'
        WHEN trunc(i.inspectioncompleteddate) IS NULL
             AND ( trunc(sysdate) - trunc(i.inspectionscheduledstartdate) ) <= 5 THEN
            '0-5'
        WHEN trunc(i.inspectioncompleteddate) IS NULL
             AND ( trunc(sysdate) - trunc(i.inspectionscheduledstartdate) ) <= 20 THEN
            '6-20'
        WHEN trunc(i.inspectioncompleteddate) IS NULL
             AND ( trunc(sysdate) - trunc(i.inspectionscheduledstartdate) ) <= 90 THEN
            '21-90'
        ELSE
            '90+'
    END overdueinspectioncat,
    CASE
        WHEN trunc(i.inspectioncompleteddate) > trunc(i.inspectionscheduledstartdate) THEN
            abs(trunc(i.inspectioncompleteddate) - trunc(i.inspectionscheduledstartdate))
        ELSE
            0
    END daysinspcompafterscheduled,
    CASE
        WHEN i.inspectioncompleteddate IS NULL THEN
            'n/a - no completed inspection'
        WHEN i.inspectionscheduledstartdate IS NULL THEN
            'n/a - no scheduled inspection'
        when trunc(i.inspectioncompleteddate - i.inspectionscheduledstartdate) < 0 then 'n/a'
        when trunc(i.inspectioncompleteddate) - trunc(i.inspectionscheduledstartdate) <= 5 then '0-5'
        when trunc(i.inspectioncompleteddate - i.inspectionscheduledstartdate) <= 20 then '6-20'
        when trunc(i.inspectioncompleteddate - i.inspectionscheduledstartdate) <= 90 then '21-90'
        ELSE
            '90+'
    END daysinspcompafterscheduledcat,
    case when i.inspectioncompleteddate IS NULL then 0
        else trunc(i.inspectioncompleteddate - p.issuedate)
    end issuancetocompletion,
    CASE
        WHEN i.inspectioncompleteddate IS NULL THEN
            'n/a - no completed date'
        WHEN trunc(i.inspectioncompleteddate - p.issuedate) < 0 THEN
            'n/a'
        WHEN trunc(i.inspectioncompleteddate - p.issuedate) <= 5 THEN
            '0-5'
        WHEN trunc(i.inspectioncompleteddate - p.issuedate) <= 20 THEN
            '6-20'
        WHEN trunc(i.inspectioncompleteddate - p.issuedate) <= 90 THEN
            '21-90'
        ELSE
            '90+'
    END issuancetocompletioncat,
    trunc(sysdate - first_insp.inspectioncompleteddate) dayssinceinitinspection,
    case 
        when first_insp.inspectioncompleteddate is null then 'n/a - no initial inspection'
        when trunc(sysdate - first_insp.inspectioncompleteddate) < 0 then 'n/a'
        when trunc(sysdate - first_insp.inspectioncompleteddate) <= 5 then '0-5'
        when trunc(sysdate - first_insp.inspectioncompleteddate) <= 20 then '6-20'
        when trunc(sysdate - first_insp.inspectioncompleteddate) <= 90 then '21-90'
        else '90+'
    End dayssinceinitinspectioncat
FROM
    g_mvw_permits     p,
    g_mvw_perm_insp   i,
    (
        SELECT
            permitnumber,
            inspectioncompleteddate
        FROM
            (
                SELECT
                    sub.*,
                    ROW_NUMBER() OVER(
                        PARTITION BY permitnumber
                        ORDER BY
                            inspectioncompleteddate ASC NULLS LAST
                    ) seq_no
                FROM
                    (
                        SELECT
                            permitnumber,
                            inspectioncompleteddate
                        FROM
                            g_mvw_perm_insp
                    ) sub
            )
        WHERE
            seq_no = 1
    ) first_insp
WHERE
    i.jobid = p.jobid
    AND p.permitnumber = first_insp.permitnumber (+)
        AND ( p.permittype <> 'Zoning'
              OR ( p.permittype = 'Zoning'
                   AND p.typeofwork = 'Change of Use' ) )