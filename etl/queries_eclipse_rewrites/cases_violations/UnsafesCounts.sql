SELECT
	violationdate,
	COUNT(*) numberofviolations
FROM
	(
	SELECT
		TO_DATE(violationyear || '/' || violationmonth || '/' || '01', 'yyyy/mm/dd') AS violationdate
	FROM
		(
		SELECT
			EXTRACT(MONTH FROM violationdate) violationmonth,
			EXTRACT(YEAR FROM violationdate ) violationyear
		FROM
			VIOLATIONS_MVW
		WHERE
			VIOLATIONDATE >= '01-JAN-16'
			AND VIOLATIONTYPE IN (
			SELECT
				DISTINCT VIOLATIONTYPE
			FROM
				UNSAFE_MVW)))
GROUP BY
	violationdate
ORDER BY
	violationdate