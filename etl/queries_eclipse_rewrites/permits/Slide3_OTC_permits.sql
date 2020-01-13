SELECT p.PERMITNUMBER,
  p.APDTTM ProcessingDate,
  p.PERMITISSUEDATE,
  p.PERMITTYPE,
  p.TYPEOFWORK,
  NVL(b.parentkey, u.parentkey) ParentKey
FROM imsv7.li_allpermits p,
  imsv7.apbldg b,
  imsv7.apuse u
WHERE p.apkey                       = b.apkey (+)
AND p.apkey                         = u.apkey (+)
AND (b.parentkey                    = 1
OR b.apkey                         IS NULL)
AND(u.parentkey                     = 1
OR u.apkey                         IS NULL)
AND TO_DATE(p.APDTTM, 'YYYY-MM-DD') = TO_DATE(p.PERMITISSUEDATE, 'YYYY-MM-DD')
AND p.APDTTM                       >= '01-JAN-2016'
 