SELECT *
FROM 
(SELECT distinct addr.addr_parsed address,
  addr.census_tract_1990 CensusTract,
  addr.ops_district district,
  sub.CaseOrPermitOrLicenseNumber ,
  sub.CaseOrPermitOrLicenseKey ,
  sub.InspectionId ,
  sub.unit ,
  sub.InspectionType ,
  sub.InspectionDescription ,
  sub.InspectionScheduled ,
  sub.InspectionCompleted ,
  sub.InspectionCount,
  sub.reinspection,
  sub.inspectorname,
  sub.InspectionStatus ,
  sdo_cs.transform(sdo_geometry(2001,2272,sdo_point_type(addr.GEOCODE_X,addr.GEOCODE_y,NULL),NULL,NULL),4326).sdo_point.x lon,
  sdo_cs.transform(sdo_geometry(2001,2272,sdo_point_type(addr.GEOCODE_X,addr.GEOCODE_y,NULL),NULL,NULL),4326).sdo_point.y lat
FROM
  (SELECT * FROM insp_completed_case_bldg_mvw
  ) sub,
  lni_addr addr
WHERE sub.addresskey = addr.addrkey (+)
UNION
SELECT distinct addr.addr_parsed address,
  addr.census_tract_1990 CensusTract,
  addr.ops_district district,
  sub.CaseOrPermitOrLicenseNumber ,
  sub.CaseOrPermitOrLicenseKey ,
  sub.InspectionId ,
  sub.unit ,
  sub.InspectionType ,
  sub.InspectionDescription ,
  sub.InspectionScheduled ,
  sub.InspectionCompleted ,
  sub.InspectionCount,
  sub.reinspection,
  sub.inspectorname,
  sub.InspectionStatus ,
  sdo_cs.transform(sdo_geometry(2001,2272,sdo_point_type(addr.GEOCODE_X,addr.GEOCODE_y,NULL),NULL,NULL),4326).sdo_point.x lon,
  sdo_cs.transform(sdo_geometry(2001,2272,sdo_point_type(addr.GEOCODE_X,addr.GEOCODE_y,NULL),NULL,NULL),4326).sdo_point.y lat
FROM
  (SELECT * FROM insp_completed_bl
  ) sub,
  lni_addr addr
WHERE sub.addresskey = addr.ECLIPSE_LOCATION_ID (+))
ORDER BY CaseOrPermitOrLicenseKey DESC,
  inspectioncompleted ASC