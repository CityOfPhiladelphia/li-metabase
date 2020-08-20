SELECT DISTINCT "Complaint Number",
                "Address",
                "Complaint Type",
                "Complaint Status",
                "Complaint Date",
                "Days Since Complaint",
                "First Action Date",
                "Days Before First Action",
                "SLA",
                "Within SLA",
                "Complaint Res. Date",
                "Origin",
                "Insp. Discipline",
                "District",
                "Review Complaint Date",
                "Review Complaint Outcome",
                "Review Complaint Assigned To",
                "Case Number",
                "First Inv. Date",
                "Most Recent Inv. Date",
                "Most Recent Inv. Outcome",
                "Most Recent Inv. Assigned To"
FROM (WITH temp AS (SELECT COUNT (*) OVER () AS "ROWCOUNT",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."COMPLAINTNUMBER" AS "Complaint Number",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."ADDRESS" AS "Address",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."COMPLAINTTYPE" AS "Complaint Type",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."COMPLAINTSTATUS" AS "Complaint Status",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."COMPLAINTDATE" AS "Complaint Date",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."CDSINCECOMPLAINT" AS "Days Since Complaint",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."FIRSTACTION_DATE" AS "First Action Date",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."CDBEFOREFIRSTACTION" AS "Days Before First Action",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."SLA_CALENDAR_DAYS" AS "SLA",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."CDWITHINSLA" AS "Within SLA",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."COMPLAINT_RESOLUTIONDATE" AS "Complaint Res. Date",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."ORIGINTYPE" AS "Origin",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."INSPECTIONDISCIPLINE" AS "Insp. Discipline",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."DISTRICT" AS "District",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."REVIEWCOMPLAINT_DATE" AS "Review Complaint Date",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."REVIEWCOMPLAINT_OUTCOME" AS "Review Complaint Outcome",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."REVIEWCOMPLAINT_ASSIGNEDTO" AS "Review Complaint Assigned To",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."CASENUMBER" AS "Case Number",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."FIRSTINV_DATE" AS "First Inv. Date",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."MOSTRECENTINV_DATE" AS "Most Recent Inv. Date",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."MOSTRECENTINV_OUTCOME" AS "Most Recent Inv. Outcome",
                           "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."MOSTRECENTINV_ASSIGNEDTO" AS "Most Recent Inv. Assigned To"
                          FROM "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"
                          WHERE "GIS_LNI"."ECL_COMPLAINTS_BUS_DAYS"."COMPLAINTNUMBER" IS NOT NULL
                          [[AND {{COMPLAINTDATE}}]]
                          [[AND {{COMPLAINTSTATUS}}]]
                          [[AND {{ORIGINTYPE}}]]
                          [[AND {{COMPLAINTTYPE}}]]
                          [[AND {{INSPECTIONDISCIPLINE}}]]
                          [[AND {{DISTRICT}}]]
                          [[AND {{REVIEWCOMPLAINT_OUTCOME}}]]
                          [[AND {{MOSTRECENTINV_OUTCOME}}]]
                          [[AND {{REVIEWCOMPLAINT_STATUS}}]]
                          [[AND {{REVIEWCOMPLAINT_DATE}}]]
                          [[AND {{REVIEWCOMPLAINT_ASSIGNEDTO}}]]
                          [[AND {{FIRSTINV_DATE}}]]
                          [[AND {{MOSTRECENTINV_STATUS}}]]
                          [[AND {{MOSTRECENTINV_DATE}}]]
                          [[AND {{MOSTRECENTINV_ASSIGNEDTO}}]]
                          [[AND {{COMPLAINT_RESOLUTIONDATE}}]]
                          [[AND {{BDSINCECOMPLAINTCATEGORIES}}]]
                          [[AND {{CDSINCECOMPLAINTCATEGORIES}}]]
                          [[AND {{CDWITHINSLA}}]]
      )
      SELECT (
          CASE
              WHEN "ROWCOUNT" <= 2000
              THEN "Complaint Number"
              ELSE NULL
          END
      ) AS "Complaint Number",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Address"
                     ELSE 'Sorry, this table can only report 2,000 or fewer results. Adjust the filters to reduce the number of results returned.'
                 END
             ) AS "Address",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Complaint Type"
                     ELSE NULL
                 END
             ) AS "Complaint Type",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Complaint Status"
                     ELSE NULL
                 END
             ) AS "Complaint Status",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Complaint Date"
                     ELSE NULL
                 END
             ) AS "Complaint Date",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Days Since Complaint"
                     ELSE NULL
                 END
             ) AS "Days Since Complaint",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "First Action Date"
                     ELSE NULL
                 END
             ) AS "First Action Date",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Days Before First Action"
                     ELSE NULL
                 END
             ) AS "Days Before First Action",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "SLA"
                     ELSE NULL
                 END
             ) AS "SLA",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Within SLA"
                     ELSE NULL
                 END
             ) AS "Within SLA",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Complaint Res. Date"
                     ELSE NULL
                 END
             ) AS "Complaint Res. Date",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Origin"
                     ELSE NULL
                 END
             ) AS "Origin",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Insp. Discipline"
                     ELSE NULL
                 END
             ) AS "Insp. Discipline",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "District"
                     ELSE NULL
                 END
             ) AS "District",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Review Complaint Date"
                     ELSE NULL
                 END
             ) AS "Review Complaint Date",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Review Complaint Outcome"
                     ELSE NULL
                 END
             ) AS "Review Complaint Outcome",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Review Complaint Assigned To"
                     ELSE NULL
                 END
             ) AS "Review Complaint Assigned To",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Case Number"
                     ELSE NULL
                 END
             ) AS "Case Number",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "First Inv. Date"
                     ELSE NULL
                 END
             ) AS "First Inv. Date",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Most Recent Inv. Date"
                     ELSE NULL
                 END
             ) AS "Most Recent Inv. Date",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Most Recent Inv. Outcome"
                     ELSE NULL
                 END
             ) AS "Most Recent Inv. Outcome",
             (
                 CASE
                     WHEN "ROWCOUNT" <= 2000
                     THEN "Most Recent Inv. Assigned To"
                     ELSE NULL
                 END
             ) AS "Most Recent Inv. Assigned To"
      FROM temp
     ) sub
ORDER BY "Complaint Number" ASC