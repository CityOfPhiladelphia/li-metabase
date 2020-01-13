--Query no. of monthly on-line, L&I Concourse, and mail transactions per license type.
--For trades: March 2017 -present 
--runtime _____ seconds
 SELECT
	licensetype,
	issuedate,
	createdbytype,
	jobtype,
	COUNT(DISTINCT licensenumber) licensenumbercount
FROM
	(
	SELECT
		licensenumber,
		licensetype,
		createdbytype,
		jobtype,
		TO_DATE(jobissueyear || '/' || jobissuemonth || '/' || '01', 'yyyy/mm/dd') AS issuedate
	FROM
		(
		SELECT
			DISTINCT tlic.LicenseNumber,
			tap.applicationtype JobType,
			tlic.licensetype LicenseType,
			(CASE
				WHEN tap.createdby LIKE '%2%' THEN 'Online'
				WHEN tap.createdby LIKE '%3%' THEN 'Online'
				WHEN tap.createdby LIKE '%4%' THEN 'Online'
				WHEN tap.createdby LIKE '%5%' THEN 'Online'
				WHEN tap.createdby LIKE '%6%' THEN 'Online'
				WHEN tap.createdby LIKE '%7%' THEN 'Online'
				WHEN tap.createdby LIKE '%8%' THEN 'Online'
				WHEN tap.createdby LIKE '%9%' THEN 'Online'
				WHEN tap.createdby = 'PPG User' THEN 'Online'
				WHEN tap.createdby = 'POSSE system power user' THEN 'Revenue'
				ELSE 'Staff'
			END ) AS createdbytype,
			EXTRACT(YEAR FROM tlic.initialissuedate) JOBISSUEYEAR,
			EXTRACT(MONTH FROM tlic.initialissuedate) JOBISSUEMONTH
		FROM
			query.o_tl_license tlic,
			query.j_tl_application tap,
			query.r_tlapplicationcal apl
		WHERE
			tlic.objectid = tap.tradelicenseobjectid (+)
			AND tap.jobid = apl.tlapplicationobjectid (+)
			AND tlic.initialissuedate >= '01-JAN-16'
			AND tlic.initialissuedate < SYSDATE
			AND tap.statusdescription LIKE 'Approved'
	UNION
		SELECT
			DISTINCT tlic.licensenumber,
			tar.applicationtype JobType,
			tlic.licensetype LicenseType,
			(CASE
				WHEN tar.createdby LIKE '%2%' THEN 'Online'
				WHEN tar.createdby LIKE '%3%' THEN 'Online'
				WHEN tar.createdby LIKE '%4%' THEN 'Online'
				WHEN tar.createdby LIKE '%5%' THEN 'Online'
				WHEN tar.createdby LIKE '%6%' THEN 'Online'
				WHEN tar.createdby LIKE '%7%' THEN 'Online'
				WHEN tar.createdby LIKE '%8%' THEN 'Online'
				WHEN tar.createdby LIKE '%9%' THEN 'Online'
				WHEN tar.createdby = 'PPG User' THEN 'Online'
				WHEN tar.createdby = 'POSSE system power user' THEN 'Revenue'
				ELSE 'Staff'
			END ) AS createdbytype,
			EXTRACT(YEAR FROM tar.completeddate) jobissueyear,
			EXTRACT(MONTH FROM tar.completeddate) jobissuemonth
		FROM
			query.o_tl_license tlic,
			query.r_tl_amendrenew_license lra,
			query.j_tl_amendrenew tar
		WHERE
			tlic.objectid = lra.licenseid (+)
			AND lra.amendrenewid = tar.objectid (+)
			AND tar.completeddate >= '01-JAN-16'
			AND tar.completeddate < SYSDATE
			AND tar.statusdescription LIKE 'Approved'
			AND tar.applicationtype LIKE 'Renewal' ) )
GROUP BY
	issuedate,
	createdbytype,
	jobtype,
	licensetype
ORDER BY
	issuedate,
	createdbytype,
	jobtype,
	licensetype