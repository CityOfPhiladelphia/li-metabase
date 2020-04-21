/*
Purpose/Description: 
Problems:
*/WITH base AS (SELECT addressobjectid,
                     opa_account_num,
                     address,
                     unit_type,
                     unit_num,
                     zip,
                     censustract,
                     li_district,
                     opa_owner,
                     casenumber,
                     casetype,
                     casecreateddate,
                     casecompleteddate,
                     violationobjectid,
                     violationnumber,
                     violationdate,
                     violationresolutiondate,
                     violationresolutioncode,
                     violationcode,
                     violationcodetitle,
                     mostrecentinvestigation,
                     violationstatus,
                     casestatus,
                     caseresponsibility,
                     caseprioritydesc,
                     lon,
                     lat,
                     hansenconversion,
                     systemofrecord
              FROM ecl_violations
)
SELECT addressobjectid,
       opa_account_num,
       address,
       unit_type,
       unit_num,
       zip,
       censustract,
       li_district,
       opa_owner,
       casenumber,
       casetype,
       casecreateddate,
       casecompleteddate,
       violationnumber,
       violationdate,
       violationresolutiondate,
       violationresolutioncode,
       violationcode,
       violationcodetitle,
       mostrecentinvestigation,
       violationstatus,
       casestatus,
       caseresponsibility,
       caseprioritydesc,
       lon,
       lat,
       systemofrecord
FROM base
WHERE hansenconversion = 'N'
UNION
(SELECT addressobjectid,
        opa_account_num,
        address,
        unit_type,
        unit_num,
        zip,
        censustract,
        li_district,
        opa_owner,
        casenumber,
        casetype,
        casecreateddate,
        casecompleteddate,
        violationnumber,
        violationdate,
        violationresolutiondate,
        violationresolutioncode,
        violationcode,
        violationcodetitle,
        mostrecentinvestigation,
        violationstatus,
        casestatus,
        caseresponsibility,
        caseprioritydesc,
        lon,
        lat,
        systemofrecord
FROM (SELECT sub.*,
             ROW_NUMBER () OVER (
                 PARTITION BY casenumber, violationcode, violationdate
                 ORDER BY systemofrecord ASC --If the same vio
             ) seq_no
      FROM (SELECT addressobjectid,
                   opa_account_num,
                   address,
                   unit_type,
                   unit_num,
                   zip,
                   censustract,
                   li_district,
                   opa_owner,
                   casenumber,
                   casetype,
                   casecreateddate,
                   casecompleteddate,
                   (
                       CASE
                           WHEN violationnumber IS NULL
                           THEN violationobjectid
                           ELSE violationnumber
                       END
                   ) violationnumber,
                   violationdate,
                   violationresolutiondate,
                   violationresolutioncode,
                   violationcode,
                   violationcodetitle,
                   mostrecentinvestigation,
                   violationstatus,
                   casestatus,
                   caseresponsibility,
                   caseprioritydesc,
                   lon,
                   lat,
                   systemofrecord
            FROM base
            WHERE hansenconversion = 'Y'
            UNION
            SELECT h.addresskey addressobjectid,
                   CAST (h.opa_account_num AS VARCHAR2 (255)) opa_account_num,
                   CAST (h.address AS VARCHAR (120)) address,
                   NULL AS unit_type,
                   CAST (h.unit AS VARCHAR2 (16)) unit_num,
                   CAST (h.zip AS VARCHAR2 (10)) zip,
                   CAST (h.census_tract_2010 AS VARCHAR2 (6)) censustract,
                   CAST (h.ops_district AS VARCHAR2 (50)) li_district,
                   CAST (h.ownername AS VARCHAR2 (254)) opa_owner,
                   h.casenumber,
                   NULL AS casetype,
                   h.caseaddeddate casecreateddate,
                   h.caseresolutiondate casecompleteddate,
                   CAST (h.apfailkey AS VARCHAR2 (100)) violationnumber,
                   h.violationdate,
                   NULL AS violationresolutiondate,
                   NULL AS violationresolutioncode,
                   h.violationtype violationcode,
                   h.violationdescription violationcodetitle,
                   h.mostrecentinsp mostrecentinvestigation,
                   h.status violationstatus,
                   (
                       CASE
                           WHEN h.caseresolutioncode IS NOT NULL
                                OR h.caseresolutiondate IS NOT NULL
                           THEN 'CLOSED'
                           ELSE h.casestatus
                       END
                   ) casestatus,
                   h.casegroup caseresponsibility,
                   h.prioritydesc caseprioritydesc,
                   h.lon,
                   h.lat,
                   'HANSEN' systemofrecord
            FROM violations h
      ) sub
     )
WHERE seq_no = 1
)