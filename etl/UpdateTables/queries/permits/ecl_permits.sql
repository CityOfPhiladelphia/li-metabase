SELECT
    JOBID,
    PERMITNUMBER,
    PERMITTYPE,
    PERMITDESCRIPTION,
    COMMERCIALORRESIDENTIAL,
    TYPEOFWORK,
    WORKDESCRIPTION,
    APPROVEDSCOPEOFWORK,
    CERTIFICATEOFOCCUPANCY,
    CREATEDDATE,
    ISSUEDATE,
    COMPLETEDDATE,
    EXPIRATIONDATE,
    PERMITSTATUS,
    APPLICANTTYPE,
    MOSTRECENTINSP,
    CASE
        WHEN trunc(issuedate) BETWEEN '31-MAR-2020' AND '01-JUL-2020' THEN
            'FY20Q4'
        WHEN trunc(issuedate) BETWEEN '31-DEC-2019' AND '01-APR-2020' THEN
            'FY20Q3'
        WHEN trunc(issuedate) BETWEEN '30-SEP-2019' AND '01-JAN-2020' THEN
            'FY20Q2'
        WHEN trunc(issuedate) BETWEEN '30-JUN-2019' AND '01-NOV-2019' THEN
            'FY20Q1'
        WHEN trunc(issuedate) BETWEEN '30-JUN-2020' AND '01-NOV-2020' THEN
            'FY21Q1'
        WHEN trunc(issuedate) BETWEEN '30-SEP-2020' AND '01-JAN-2021' THEN
            'FY21Q2'
        WHEN trunc(issuedate) BETWEEN '31-DEC-2019' AND '01-APR-2020' THEN
            'FY21Q3'
        WHEN trunc(issuedate) BETWEEN '31-MAR-2021' AND '01-JUL-2021' THEN
            'FY21Q4'
        WHEN trunc(issuedate) BETWEEN '30-JUN-2021' AND '01-NOV-2021' THEN
            'FY22Q1'
        WHEN trunc(issuedate) BETWEEN '30-SEP-2022' AND '01-JAN-2022' THEN
            'FY22Q2'
        WHEN trunc(issuedate) BETWEEN '31-DEC-2021' AND '01-APR-2021' THEN
            'FY22Q3'
        WHEN trunc(issuedate) BETWEEN '31-MAR-2022' AND '01-JUL-2022' THEN
            'FY22Q4'
        WHEN trunc(issuedate) IS NULL THEN
            '(none)'
    END ISSUEDATEFISCAL,
    CASE
        WHEN trunc(completeddate) BETWEEN '31-MAR-2020' AND '01-JUL-2020' THEN
            'FY20Q4'
        WHEN trunc(completeddate) BETWEEN '31-DEC-2019' AND '01-APR-2020' THEN
            'FY20Q3'
        WHEN trunc(completeddate) BETWEEN '30-SEP-2019' AND '01-JAN-2020' THEN
            'FY20Q2'
        WHEN trunc(completeddate) BETWEEN '30-JUN-2019' AND '01-NOV-2019' THEN
            'FY20Q1'
        WHEN trunc(completeddate) BETWEEN '30-JUN-2020' AND '01-NOV-2020' THEN
            'FY21Q1'
        WHEN trunc(completeddate) BETWEEN '30-SEP-2020' AND '01-JAN-2021' THEN
            'FY21Q2'
        WHEN trunc(completeddate) BETWEEN '31-DEC-2019' AND '01-APR-2020' THEN
            'FY21Q3'
        WHEN trunc(completeddate) BETWEEN '31-MAR-2021' AND '01-JUL-2021' THEN
            'FY21Q4'
        WHEN trunc(completeddate) BETWEEN '30-JUN-2021' AND '01-NOV-2021' THEN
            'FY22Q1'
        WHEN trunc(completeddate) BETWEEN '30-SEP-2022' AND '01-JAN-2022' THEN
            'FY22Q2'
        WHEN trunc(completeddate) BETWEEN '31-DEC-2021' AND '01-APR-2021' THEN
            'FY22Q3'
        WHEN trunc(completeddate) BETWEEN '31-MAR-2022' AND '01-JUL-2022' THEN
            'FY22Q4'
        WHEN trunc(completeddate) IS NULL THEN
            '(none)'
    END COMPLETEDDATEFISCAL,
    trunc(sysdate - issuedate)  DAYSSINCEISSUANCE,
    case 
        when issuedate is null then 'n/a'
        when trunc(sysdate - issuedate) < 0 then 'n/a'
        when trunc(sysdate - issuedate) <= 5 then '0-5'
        when trunc(sysdate - issuedate) <= 20 then '6-20'
        when trunc(sysdate - issuedate) <= 90 then '21-90'
        else '90+'
    End DAYSSINCEISSUANCECAT
FROM
    g_mvw_permits