SELECT la.addr_base AS address,
  a.zip,
  la.census_tract_1990,
  la.council_district,
  la.building_district,
  (
  CASE
    WHEN a.legalowner IS NOT NULL
    THEN (CAST(trim(a.legalowner) AS VARCHAR(81)))
    ELSE (
      CASE
        WHEN ownr.cntctfirst <> ' '
        THEN trim(ownr.cntctfirst
          || ' '
          || ownr.cntctlast)
        ELSE trim(ownr.cntctlast)
      END)
  END) AS ownername,
  (
  CASE
    WHEN a.legalowner = (
      CASE
        WHEN ownr.cntctfirst <> ' '
        THEN trim(ownr.cntctfirst
          || ' '
          || ownr.cntctlast)
        ELSE trim(ownr.cntctlast)
      END)
    THEN ownr.coname
  END) Organization,
  trim(b.apno) permitnumber,
  d.aptype,
  d.apdesc,
  e.empfirst inspectorfirstname,
  e.emplast inspectorlastname,
  (
  CASE
    WHEN e.empfirst IS NULL
    AND emplast     IS NULL
    THEN '(none)'
    ELSE e.empfirst
      || ' '
      || emplast
  END ) inspectorname,
  i.insptype InspectionType,
  i.scheddttm InspectionScheduled,
  DECODE(i.stat, 0, 'None', 1, 'Passed', 2, 'Failed', 3, 'Cancelled', 4, 'HOLD', 5, 'Closed') InspectionStatus,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(la.geocode_x, la.geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(la.geocode_x, la.geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat,
  i.apkey,
  i.apinspkey
FROM imsv7.address@lidb_link a,
  imsv7.apbldg@lidb_link b,
  imsv7.apinsp@lidb_link i,
  imsv7.tbl250@lidb_link t250,
  (SELECT *
  FROM
    (SELECT sub.*,
      ROW_NUMBER () OVER (PARTITION BY addrkey ORDER BY adddttm DESC, moddttm DESC, coname ASC NULLS LAST, cntctlast ASC, cntctfirst ASC) seq_no
    FROM
      (SELECT DISTINCT cntc.addrkey,
        cntc.owner,
        cntc.moddttm,
        o.adddttm,
        o.cntctfirst,
        o.cntctlast,
        o.coname
      FROM imsv7.contact@lidb_link o,
        imsv7.addrcntc@lidb_link cntc
      WHERE cntc.cntctkey = o.cntctkey
      AND cntc.owner LIKE 'Y%'
      AND cntc.Owntodt IS NULL
      ) sub
    )
  WHERE seq_no = 1
  ) ownr, --Get the current owner of the property. Some properties have multiple current owners listed (a Hansen data quality issue), so pick just one.
  imsv7.apdefn@lidb_link d,
  imsv7.employee@lidb_link e,
  lni_addr la
WHERE a.addrkey = b.addrkey
AND b.apkey     = i.apkey
AND a.addrkey   = la.addrkey (+)
AND i.insptype NOT LIKE 'CLIP%'
AND i.insptype  = t250.code
AND b.apdefnkey = d.apdefnkey
AND i.assignto  = e.empid (+)
AND a.addrkey   = ownr.addrkey (+)
AND i.compdttm IS NULL