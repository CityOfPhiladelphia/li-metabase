SELECT a.addr_base AS address,
       i.zip,
       a.census_tract_1990, --remove field now that we're only using the 2010 census tracts

       a.census_tract_2010,
       a.council_district,
       a.ops_district,  --rename field to just District?

       a.building_district,  --remove field now that there's no distinction b/t ops and building districts

       i.ownername,
       i.organization,
       i.caseorpermitnumber casenumber,
       i.aptype,
       i.apdesc,
       i.inspectorfirstname,
       i.inspectorlastname,
       (
           CASE
               WHEN i.inspectorfirstname IS NULL
                    AND i.inspectorlastname IS NULL
               THEN '(none)'
               ELSE i.inspectorfirstname || ' ' || i.inspectorlastname
           END
       ) inspectorname,
       i.inspectiontype,
       i.inspectionscheduled,
       i.inspectioncompleted,
       i.inspectionstatus,
       c.casegrp casegroup,
       sdo_cs.transform (sdo_geometry (2001,2272,sdo_point_type (a.geocode_x,a.geocode_y,NULL),NULL,NULL),4326).sdo_point.x lon,
       sdo_cs.transform (sdo_geometry (2001,2272,sdo_point_type (a.geocode_x,a.geocode_y,NULL),NULL,NULL),4326).sdo_point.y lat,
       i.apkey,
       i.apinspkey,
       (
           CASE
               WHEN reinsp.rankcompdttm IS NOT NULL
               THEN reinsp.rankcompdttm
               WHEN i.inspectioncompleted IS NOT NULL
               THEN 1
           END
       ) inspectioncompletedrank,
       (
           CASE
               WHEN reinsp.rankcompdttm IS NOT NULL
               THEN 'Yes'
               ELSE 'No'
           END
       ) reinspection
FROM imsv7.li_allinsp_internal@lidb_link i
LEFT OUTER JOIN imsv7.apcase@lidb_link c ON i.apkey = c.apkey
LEFT OUTER JOIN lni_addr a  --eclipse version a different name?

 ON i.addresskey = a.addrkey
LEFT OUTER JOIN (SELECT *
                 FROM (SELECT RANK () OVER (
                           PARTITION BY i.apkey
                           ORDER BY i.compdttm ASC,i.apinspkey ASC NULLS LAST
                       ) AS rankcompdttm,
                              i.apinspkey,
                              i.apkey,
                              i.compdttm
                       FROM imsv7.apinsp@lidb_link i
                       WHERE i.compdttm IS NOT NULL
                      )
                 WHERE rankcompdttm > 1
                ) reinsp ON i.apkey = reinsp.apkey
                            AND i.apinspkey = reinsp.apinspkey
WHERE (i.inspectioncompleted IS NULL
       OR i.inspectioncompleted >= DATE '2018-1-1')
      AND i.aptype IN (
    'CD ENFORCE',
    'DANGEROUS',
    'L_CLIP',
    'L_DANGBLDG'
)