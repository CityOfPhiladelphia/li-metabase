SELECT distinct j.externalfilenum jobnumber,
       (
           CASE
               WHEN j.objectdefdescription LIKE 'Amendment/Renewal'
               THEN 'Amend/Renew'
               WHEN j.objectdefdescription LIKE 'Business License Application'
               THEN 'Application'
           END
       ) AS jobtype,
       fnp.receiveddate paymentdate,
       fee.baseamount amount,
       fee.description feetype
FROM lmscorral.bl_alljobs j,
     lmscorral.fee fee,
     lmscorral.paymentdistribution pd,
     lmscorral.fn_paymenttopaydist fnpx,
     lmscorral.fn_payment fnp
WHERE j.objectdefdescription IN (
    'Amendment/Renewal',
    'Business License Application'
)
      AND j.jobid         = fee.referencedobjectid
      AND fee.objectid    = pd.feeobjectid
      AND pd.objectid     = fnpx.paydistid (+)
      AND fnpx.paymentid  = fnp.paymentid (+)
      AND fnp.receiveddate >= add_months(TRUNC(SYSDATE, 'MM'),-25)