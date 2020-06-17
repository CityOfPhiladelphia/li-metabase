SELECT DISTINCT u.addressobjectid,
                u.opa_account_num,
                u.address,
                u.censustract,
                a.councildistrict,
                (
                    CASE
                        WHEN a.li_district IS NOT NULL
                        THEN CAST (a.li_district AS VARCHAR2 (20))
                        ELSE '(none)'
                    END
                ) li_district,
                u.casenumber,
                u.casecreateddate,
                u.casecompleteddate,
                u.violationdate,
                u.mostrecentinvestigation,
                (
                    CASE
                        WHEN u.geocode_x IS NOT NULL
                        THEN sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (u.geocode_x, u.geocode_y, NULL), NULL, NULL
                        ), 4326).sdo_point.x
                        ELSE 0
                    END
                ) lon,
                (
                    CASE
                        WHEN u.geocode_x IS NOT NULL
                        THEN sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (u.geocode_x, u.geocode_y, NULL), NULL, NULL
                        ), 4326).sdo_point.y
                        ELSE 0
                    END
                ) lat
FROM mvw_unsafe u,
     eclipse_lni_addr a
WHERE u.addressobjectid = a.addressobjectid (+)