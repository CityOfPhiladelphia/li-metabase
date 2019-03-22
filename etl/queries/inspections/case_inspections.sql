SELECT
	address,
	zip,
	census_tract_1990,
	census_tract_2010,
	council_district,
	ops_district,
	building_district,
	ownername,
	organization,
	caseorpermitnumber,
	aptype,
	apdesc,
	inspectorfirstname,
	inspectorlastname,
	inspectorfirstname || ' ' || inspectorlastname inspectorname,
	inspectiontype,
	inspectionscheduled,
	inspectioncompleted,
	inspectionstatus,
	SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(geocode_x, geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
    SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(geocode_x, geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat
FROM
	inspections_all_internal_mvw
WHERE inspectionscheduled >= DATE '2017-1-1'