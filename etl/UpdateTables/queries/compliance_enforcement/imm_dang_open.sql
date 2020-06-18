SELECT DISTINCT i.addressobjectid,
                i.opa_account_num,
                i.address,
                i.censustract,
                a.councildistrict,
                (
                    CASE
                        WHEN a.li_district IS NOT NULL
                        THEN CAST (a.li_district AS VARCHAR2 (20))
                        ELSE '(none)'
                    END
                ) li_district,
                i.casenumber,
                i.casecreateddate,
                i.casecompleteddate,
                i.violationdate,
                i.mostrecentinvestigation,
                (
                    CASE
                        WHEN i.geocode_x IS NOT NULL
                        THEN sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (i.geocode_x, i.geocode_y, NULL), NULL, NULL
                        ), 4326).sdo_point.x
                        ELSE 0
                    END
                ) lon,
                (
                    CASE
                        WHEN i.geocode_x IS NOT NULL
                        THEN sdo_cs.transform (sdo_geometry (2001, 2272, sdo_point_type (i.geocode_x, i.geocode_y, NULL), NULL, NULL
                        ), 4326).sdo_point.y
                        ELSE 0
                    END
                ) lat
FROM mvw_imm_dang i,
     eclipse_lni_addr a
WHERE i.addressobjectid = a.addressobjectid (+)