SELECT v.violationnumber,
       v.violationdate,
       v.violationcode,
       v.violationcodetitle,
       (
           CASE
               WHEN v.violationstatus IS NOT NULL
               THEN v.violationstatus
               ELSE 'OPEN'
           END
       ) violationstatus,
       v.violationresolutiondate,
       (
           CASE
               WHEN v.violationresolutioncode IS NOT NULL
               THEN v.violationresolutioncode
               ELSE '(none)'
           END
       ) violationresolutioncode,
       v.casenumber,
       v.casecreateddate,
       v.casecompleteddate,
       v.casetype,
       v.casestatus,
       v.caseresponsibility,
       v.caseprioritydesc,
       v.mostrecentinvestigation,
       v.addressobjectid,
       v.parcel_id_num,
       v.opa_account_num,
       v.address,
       a.li_district district,
       v.unit_type,
       v.unit_num,
       v.zip,
       v.censustract,
       v.opa_owner,
       v.systemofrecord,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (v.geocode_x, v.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       x lon,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (v.geocode_x, v.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       y lat
FROM mvw_violations v,
     eclipse_lni_addr a
WHERE v.addressobjectid = a.addressobjectid (+)
      AND v.violationdate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')
AND ( ( violationcode LIKE 'PM-307%'
OR violationcode LIKE 'PM15-108.1%' )
AND violationcode != 'PM-307.1/20' )