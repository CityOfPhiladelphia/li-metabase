SELECT
    i.jobid                              jobid,
    i.inspectionprocessid                inspectionprocessid,
    i.inspectiontype                     inspectiontype,
    i.inspectioncreateddate              inspectioncreateddate,
    i.inspectionrequesteddate            inspectionrequesteddate,
    i.inspectionscheduledstartdate       inspectionscheduleddate,
    i.inspectioncompleteddate            inspectioncompleteddate,
    (
        CASE
            WHEN i.inspectionoutcome IS NULL THEN
                '(none)'
            ELSE
                i.inspectionoutcome
        END
    ) inspectionoutcome,
    i.inspectorcomments                  inspectorcomments,
    (
        CASE
            WHEN i.inspectorname IS NULL THEN
                '(none)'
            ELSE
                i.inspectorname
        END
    ) inspectorname,
    i.permitnumber                       permitnumber,
    i.permittype                         permittype,
    i.permitstatus                       permitstatus,
    p.issuedate                          issuedate,
    p.mostrecentinsp                     mostrecentinsp,
    p.applicanttype                      applicanttype,
    p.typeofwork                         typeofwork,
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
    END inspscheduleddatefiscal,
    trunc(sysdate) - trunc(p.mostrecentinsp) AS dayssincemostrecinsp,
    CASE
        WHEN trunc(i.inspectioncompleteddate) IS NULL
             AND ( trunc(i.inspectionscheduledstartdate) < trunc(sysdate) ) THEN
            trunc(sysdate) - trunc(i.inspectionscheduledstartdate)
            || ' DAYS OVERDUE'
        ELSE
            'NOT OVERDUE'
    END overdueinspection,
    CASE
        WHEN trunc(i.inspectioncompleteddate) > trunc(i.inspectionscheduledstartdate) -- and Cast(i.inspectioncompleteddate as DATE) <> cast(i.inspectionscheduledstartdate as date)
         THEN
            abs(trunc(i.inspectioncompleteddate) - trunc(i.inspectionscheduledstartdate))
        ELSE
            0
    END daysinspcompafterscheduled,
    first_insp.inspectioncompleteddate   initialinspectiondate,
    trunc(sysdate - first_insp.inspectioncompleteddate) dayssinceinitialinspection
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