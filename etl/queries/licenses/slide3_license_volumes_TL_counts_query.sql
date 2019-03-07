SELECT
	jobtype,
	licensetype,
	issuedate,
	COUNT(DISTINCT licensenumber) countjobs,
	SUM(amount) totalamount
FROM
	(
	SELECT
		licensetype,
		licensenumber,
		jobtype,
		TO_DATE(jobissueyear || '/' || jobissuemonth || '/' || '01', 'yyyy/mm/dd') AS issuedate,
		amount
	FROM
		(
		SELECT
			DISTINCT tlic.externalfilenum licensenumber,
			tlic.licensetype licensetype,
			tap.applicationtype jobtype,
			EXTRACT(YEAR FROM tlic.initialissuedate) jobissueyear,
			EXTRACT(MONTH FROM tlic.initialissuedate) jobissuemonth,
			fee.paymenttotal AS amount
		FROM
			query.o_tl_license tlic,
			query.j_tl_application tap,
			query.o_fn_fee fee,
			api.jobs job
		WHERE
			tlic.objectid = tap.tradelicenseobjectid (+)
			AND tap.jobid = job.jobid (+)
			AND job.jobid = fee.referencedobjectid (+)
			AND tlic.initialissuedate >= '01-JAN-16'
			AND tlic.initialissuedate < SYSDATE
	UNION
		SELECT
			DISTINCT tlic.licensetype licensetype,
			tlic.licensenumber licensenumber,
			tar.applicationtype jobtype,
			EXTRACT(YEAR FROM tar.completeddate) jobissueyear,
			EXTRACT(MONTH FROM tar.completeddate) jobissuemonth,
			fee.paymenttotal AS amount
		FROM
			query.o_tl_license tlic,
			query.j_tl_amendrenew tar,
			query.o_fn_fee fee,
			api.jobs job
		WHERE
			tlic.objectid = tar.licenseobjectid
			AND fee.referencedobjectid = job.jobid
			AND tar.jobid = job.jobid
			AND tar.completeddate >= '01-JAN-16'
			AND tar.completeddate < SYSDATE
			AND tar.statusdescription LIKE 'Approved'
			AND tar.applicationtype LIKE 'Renewal' ) )
GROUP BY
	issuedate,
	jobtype,
	licensetype
ORDER BY
	issuedate,
	jobtype,
	licensetype
	--runtime 86 sec 

