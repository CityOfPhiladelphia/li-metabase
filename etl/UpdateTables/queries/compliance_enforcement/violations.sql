SELECT v.casenumber,
       v.casetype, --used to be aptype
       v.casecreateddate, --used to be caseaddeddate
       v.casecompleteddate, --used to be caseresolutiondate,
/* No real equivalent in Eclipse
      (
           CASE
               WHEN caseresolutioncode IS NOT NULL
               THEN caseresolutioncode
               ELSE '(none)'
           END
       ) caseresolutioncode, */
       v.objectid,
       v.violationdate,
       nvl (substr (violationcode, 0, instr (violationcode, '-') - 1), violationcode) violationcategory,
       v.violationcode,
       v.violatoncodetitle,
       v.mostrecentinvestigation,
       (
           CASE
               WHEN v.violationstatus IS NOT NULL
               THEN v.violationstatus
               ELSE 'OPEN'
           END
       ) violationstatus,
       v.casestatus,
       (
           CASE
               WHEN v.caseresponsibility IS NOT NULL
               THEN v.caseresponsibility
               ELSE '(none)'
           END
       ) caseresponsibility,
       (
           CASE
               WHEN v.casepriority IS NOT NULL
               THEN v.casepriority
               ELSE '(none)'
           END
       ) casepriority,
       a.opa_account_num,
       a.base_address address,
       a.unit,
       a.zip_code,
       a.census_tract_2010,
      -- a.owner,
      -- a.organization,
       a.council_district,
       a.li_district,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (a.geocode_x, a.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       x lon,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (a.geocode_x, a.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       y lat
FROM g_mvw_violations_t v,
     eclipse_lni_addr_xy a
WHERE v.addressobjectid = a.addressobjectid (+)
      AND v.violationdate > add_months (trunc (sysdate, 'MM'), - 25)
      AND v.violationdate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')