SELECT DISTINCT notc.noticekey,
                a.addr_parsed address,
                notc.notice,
                notc.effdate effective,
                notc.expdate expire,
                notc.ordinance ordinance,
                notc.assessdttm assessed,
                notc.assessedby assessedbyid,
                emp.empfirst || ' ' || emp.emplast assessedby,
                notc.comments
FROM lni_addr a,
     imsv7.addrnotc@lidb_link notc,
     imsv7.employee@lidb_link emp
WHERE a.addrkey = notc.addrkey
      AND notc.assessedby = emp.empid (+)
      AND notc.notice IN (
    'FACADE',
    'FRESCP',
    'PIER',
    'BRIDGE'
)