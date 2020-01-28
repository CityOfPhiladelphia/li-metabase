SELECT ci.investigationprocessid,
       ci.investigationjobid,
       ci.investigationtype,
       ci.investigationscheduled,
       ci.investigationcompleted,
       ci.investigationstatus,
       ci.investigatorname,
       (
           CASE
               WHEN reinv.rankcompdate IS NOT NULL
               THEN reinv.rankcompdate
               WHEN ci.investigationcompleted IS NOT NULL
               THEN 1
           END
       ) investigationcompletedrank,
       (
           CASE
               WHEN rev.rankcompdate IS NOT NULL
               THEN 'Yes'
               ELSE 'No'
           END
       ) reinvestigation,
       ci.casenumber,
       ci.casetype,
       ci.caseresponsibility,
       ci.casepriority,
       a.streetaddress AS address,
       a.zip,
       a.census_tract,
       a.council_district,
       a.building_district district,
       a.ownername,
       a.organization,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (a.geocode_x, a.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       x lon,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (a.geocode_x, a.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       y lat
FROM g_vw_case_inv ci
LEFT OUTER JOIN eclipse_lni_addr_xy a ON ci.addressobjectid = a.addressobjectid
LEFT OUTER JOIN (SELECT *
                 FROM (SELECT RANK () OVER (
                           PARTITION BY isub.jobid
                           ORDER BY isub.datecompleted ASC, isub.processid ASC NULLS LAST
                       ) AS rankcompdate,
                              isub.processid,
                              isub.jobid,
                              isub.datecompleted
                       FROM lmscorral.performinvestigation@eclipse_link isub
                       WHERE isub.datecompleted IS NOT NULL
                      )
                 WHERE rankcompdate > 1
                ) reinv ON ci.jobid = reinv.jobid
                           AND ci.processid = reinv.processid
WHERE (ci.investigationcompleted IS NULL
       OR ci.investigationcompleted >= DATE '2018-1-1')