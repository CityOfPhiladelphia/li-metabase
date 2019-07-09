SELECT DISTINCT addr.addr_parsed address,
  addr.census_tract_1990 CensusTract,
  (
  CASE
    WHEN sub.unit = 'Building'
    THEN INITCAP(addr.building_district)
    ELSE INITCAP(addr.ops_district)
  END ) district,
  sub.CasePermitLicenseServReqNumber ,
  sub.CasePermitLicenseServReqKey ,
  sub.InspectionId ,
  sub.unit ,
  sub.InspectionCategory ,
  sub.InspectionType ,
  sub.InspectionDescription ,
  sub.InspectionScheduled ,
  sub.InspectionCompleted ,
  sub.reinspection,
  sub.inspectorname,
  sub.InspectionStatus ,
  sdo_cs.transform(sdo_geometry(2001,2272,sdo_point_type(addr.GEOCODE_X,addr.GEOCODE_y,NULL),NULL,NULL),4326).sdo_point.x lon,
  sdo_cs.transform(sdo_geometry(2001,2272,sdo_point_type(addr.GEOCODE_X,addr.GEOCODE_y,NULL),NULL,NULL),4326).sdo_point.y lat
FROM
  (SELECT * from insp_completed_case_bldg_mvw
  UNION
  SELECT * from insp_completed_bl
  UNION
  SELECT * from insp_completed_sr_mvw
  ) sub,
  lni_addr addr
WHERE sub.addresskey = addr.addrkey (+)
ORDER BY sub.CasePermitLicenseServReqKey DESC,
  sub.inspectioncompleted ASC