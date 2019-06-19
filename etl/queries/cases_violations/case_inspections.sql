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
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(a.geocode_x, a.geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat
FROM IMSV7.LI_ALLINSP_INTERNAL@lidb_link i
LEFT OUTER JOIN imsv7.apcase@lidb_link c
ON i.apkey = c.apkey
LEFT OUTER JOIN lni_addr a
ON i.addresskey               = a.addrkey
WHERE (i.inspectioncompleted IS NULL
OR i.inspectioncompleted     >= DATE '2018-1-1')
AND aptype                   IN ('CD ENFORCE','DANGEROUS','L_CLIP','L_DANGBLDG')