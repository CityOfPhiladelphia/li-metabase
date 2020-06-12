SELECT c.addressobjectid,
       CAST (a.opa_account_num AS VARCHAR2 (255)) opa_account_num,
       a.base_address address,
       CAST (a.unit_type AS VARCHAR2 (255)) unit_type,
       CAST (a.unit_num AS VARCHAR2 (16)) unit_num,
       CAST (a.zip AS VARCHAR2 (10)) zip,
       CAST (a.censustract AS VARCHAR2 (6)) censustract,
       CAST ((
           CASE
               WHEN a.li_district IS NOT NULL
               THEN a.li_district
               ELSE to_nchar ('(none)')
           END
       ) AS VARCHAR2 (50)) li_district,
       CAST (a.opa_owner AS VARCHAR2 (254)) opa_owner,
       c.casenumber,
       upper (c.casetype) casetype,
       c.createddate casecreateddate,
       c.completeddate casecompleteddate,
       v.objectid violationobjectid,
       v.violationnumber,
       v.violationdate,
       v.violationresolutiondate,
       upper (v.violationresolutioncode) violationresolutioncode,
       nvl (substr (v.violationcode, 0, instr (v.violationcode, '-') - 1), v.violationcode) violationcategory,
       v.violationcode,
       v.violationcodetitle,
       c.mostrecentinvestigation,
       upper (v.violationstatus) violationstatus,
       upper (c.casestatus) casestatus,
       (
           CASE
               WHEN c.caseresponsibility IS NOT NULL
               THEN upper (c.caseresponsibility)
               ELSE '(none)'
           END
       ) caseresponsibility,
       (
           CASE
               WHEN c.casepriority IS NOT NULL
               THEN upper (c.casepriority)
               ELSE '(none)'
           END
       ) caseprioritydesc,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (a.geocode_x, a.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       x lon,
       sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (a.geocode_x, a.geocode_y, NULL), NULL, NULL), 4326).sdo_point.
       y lat,
       v.hansenconversion,
       'ECLIPSE' systemofrecord
FROM g_mvw_violations v,
     g_mvw_cases c,
     eclipse_lni_addr a
WHERE v.casefilejobid = c.jobid
      AND c.addressobjectid = a.addressobjectid (+)
      AND v.violationdate > add_months (trunc (sysdate, 'MM'), - 25)
      AND v.violationdate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')