SELECT
	i.address,
	i.zip,
	i.census_tract_1990,
	i.census_tract_2010,
	i.council_district,
	i.ops_district,
	i.building_district,
	i.ownername,
	i.organization,
	i.caseorpermitnumber casenumber,
	i.aptype,
	i.apdesc,
	i.inspectorfirstname,
	i.inspectorlastname,
	i.inspectorfirstname || ' ' || inspectorlastname inspectorname,
	i.inspectiontype,
	i.inspectionscheduled,
	i.inspectioncompleted,
	i.inspectionstatus,
  c.casegrp casegroup,
	SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(i.geocode_x, i.geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(i.geocode_x, i.geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat
FROM
	inspections_all_internal_mvw i
LEFT OUTER JOIN imsv7.apcase@lidb_link c ON
	i.apkey = c.apkey
WHERE inspectionscheduled >= DATE '2017-1-1'
AND inspectionscheduled < TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY')
AND aptype in ('CD ENFORCE','DANGEROUS','L_CLIP','L_DANGBLDG')