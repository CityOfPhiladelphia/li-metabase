SELECT a.addr_base AS ADDRESS,
  i.zip,
  a.census_tract_1990, 
  a.council_district,
  a.ops_district,
  a.building_district,
  i.ownername,
  i.organization,
  i.permitnumber,
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
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(a.geocode_x, a.geocode_y,NULL),NULL,NULL), 4326).sdo_point.X lon,
  SDO_CS.TRANSFORM(SDO_GEOMETRY(2001,2272,SDO_POINT_TYPE(a.geocode_x, a.geocode_y,NULL),NULL,NULL), 4326).sdo_point.Y lat,
  i.apkey,
  i.apinspkey
FROM
  (SELECT DISTINCT TO_CHAR(a.addrkey) AddressKey,
    CASE
      WHEN a.hseextn IS NOT NULL
      AND a.hseextn  <> '00000'
      AND a.hseextn  <> '00'
      THEN COALESCE(ltrim(a.stno, ' 0'),'')
        || '-'
        || COALESCE(SUBSTR(a.hseextn, -2),'')
      ELSE COALESCE(ltrim(a.stno, ' 0'),'')
    END
    ||
    CASE
      WHEN regexp_like(a.predir,'(N|NW|NE|S|SW|SE|W|E)')
      THEN ' '
        || COALESCE(a.predir,'')
        || ' '
      ELSE ' '
    END
    || COALESCE(ltrim(DECODE(a.STNAME, 'CHRIS COLUMBUS','CHRISTOPHER COLUMBUS','AYRDALECRESCENT','AYRDALE CRESCENT', 'BENJ FRANKLIN','BENJAMIN FRANKLIN','BONAFFON','BONNAFFON','DE KALB','DEKALB','DR KING','MARTIN LUTHER KING JR','JOS KELLY', 'JOSEPH KELLY', 'M L KING','MARTIN LUTHER KING JR','MCCALLUM', 'MC CALLUM','POQUESSING CRK','POQUESSING CREEK','SHELBORNE','SHELBOURNE','ST ALBANS','SAINT ALBANS','ST ANDREW','SAINT ANDREW','ST BERNARD','SAINT BERNARD','ST CHRISTOPHER','SAINT CHRISTOPHER','ST DAVIDS','SAINT DAVIDS','ST DENIS','SAINT DENIS','ST GEORGES','SAINT GEORGES','ST JAMES', 'SAINT JAMES','ST JOHN NEUMANN', 'SAINT JOHN NEUMANN','ST JOSEPHS','SAINT JOSEPHS','ST LUKES','SAINTS LUKES','ST MALACHYS','SAINT MALACHYS','ST MARKS','SAINT MARKS','ST MARTINS','SAINT MARTINS','ST MICHAEL','SAINT MICHAEL','ST PAUL','SAINT PAUL','ST PETERS','SAINT PETERS','ST THOMAS','SAINT THOMAS','ST VINCENT','SAINT VINCENT','AVE OF THE REP','AVENUE OF THE REPUBLIC',a.stname),' 0'),'')
    || ' '
    || COALESCE(DECODE(a.suffix, 'LA','LN','WLK','WALK', 'BLV','BLVD', 'PK','PIKE', 'MEW','MEWS', 'ML','MALL', 'PTH','PATH', 'PKY','PKWY', 'PRK','PARK', 'TNL','TUNL','EXP','EXPY', a.suffix),'') AS Address,
    ltrim(DECODE(a.STSUB,'00000000',NULL,'000000',NULL,'00000',NULL,'0000',NULL,'0',NULL,'',NULL,a.stsub),' 0') Unit,
    a.zip Zip,
    a.c_tract CensusTract,
    (
    CASE
      WHEN o.cntctfirst <> ' '
      THEN trim(o.cntctfirst
        || ' '
        || o.cntctlast)
      ELSE trim(o.cntctlast)
    END) OwnerName,
    o.coname Organization,
    trim(b.apno) PermitNumber,
    d.aptype,
    d.apdesc,
    i.apinspkey,
    i.insptype InspectionType,
    t250.descript InspectionDescription,
    i.scheddttm InspectionScheduled,
    i.compdttm InspectionCompleted,
    i.apkey,
    e.empfirst inspectorfirstname,
    e.emplast inspectorlastname,
    DECODE(i.stat, 0, 'None', 1, 'Passed', 2, 'Failed', 3, 'Cancelled', 4, 'HOLD', 5, 'Closed') InspectionStatus
  FROM imsv7.address@lidb_link a,
    imsv7.apbldg@lidb_link b,
    imsv7.apinsp@lidb_link i,
    imsv7.tbl250@lidb_link t250,
    imsv7.contact@lidb_link o,
    imsv7.addrcntc@lidb_link cntc,
    imsv7.apdefn@lidb_link d,
    imsv7.employee@lidb_link e
  WHERE a.addrkey = b.addrkey
  AND b.apkey     = i.apkey
  AND i.insptype NOT LIKE 'CLIP%'
  AND i.insptype    = t250.code
  AND cntc.addrkey  = a.addrkey
  AND cntc.cntctkey = o.cntctkey
  AND cntc.owner LIKE 'Y%'
  AND b.apdefnkey = d.apdefnkey
  AND i.assignto  = e.empid (+)
  AND i.compdttm IS NULL
  ) i
LEFT OUTER JOIN lni_addr a
ON i.addresskey = a.addrkey