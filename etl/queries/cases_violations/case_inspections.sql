SELECT a.addr_base AS ADDRESS,
  i.zip,
  a.census_tract_1990,
  a.census_tract_2010,
  a.council_district,
  a.ops_district,
  a.building_district,
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
    AND i.inspectorlastname   IS NULL
    THEN '(none)'
    ELSE i.inspectorfirstname
      || ' '
      || i.inspectorlastname
  END ) inspectorname,
  i.inspectiontype,
  i.inspectionscheduled,
  i.inspectioncompleted,
  i.inspectionstatus,
  c.casegrp casegroup,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(a.geocode_x, a.geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(a.geocode_x, a.geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat,
  i.apkey,
  i.apinspkey,
  (
  CASE
    WHEN reinsp.RankCompDttm IS NOT NULL
    THEN reinsp.RankCompDttm
    WHEN i.inspectioncompleted IS NOT NULL
    THEN 1
  END) inspectioncompletedrank,
  (
  CASE
    WHEN reinsp.RankCompDttm IS NOT NULL
    THEN 'Yes'
    ELSE 'No'
  END) reinspection
FROM IMSV7.LI_ALLINSP_INTERNAL@lidb_link i
LEFT OUTER JOIN imsv7.apcase@lidb_link c
ON i.apkey = c.apkey
LEFT OUTER JOIN lni_addr a
ON i.addresskey = a.addrkey
LEFT OUTER JOIN
  (SELECT *
  FROM
    (SELECT RANK() OVER (PARTITION BY i.apkey ORDER BY i.compdttm ASC, i.apinspkey ASC NULLS LAST) AS RankCompDttm,
      i.apinspkey,
      i.apkey,
      i.compdttm
    FROM imsv7.apinsp@lidb_link i
    WHERE i.compdttm IS NOT NULL
    )
  WHERE RankCompDttm > 1
  ) reinsp
ON i.apkey                    = reinsp.apkey
AND i.apinspkey               = reinsp.apinspkey
WHERE (i.inspectioncompleted IS NULL
OR i.inspectioncompleted     >= DATE '2018-1-1')
AND i.aptype                 IN ('CD ENFORCE','DANGEROUS','L_CLIP','L_DANGBLDG')