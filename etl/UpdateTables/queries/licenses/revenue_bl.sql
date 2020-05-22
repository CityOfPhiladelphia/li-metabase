SELECT j.jobnumber,
       j.jobtype,
       pay.maxpaymentreceiveddate paymentdate,
       pay.totalpaymentamount amount,
       fee.feetype
FROM g_mvw_bl_jobs j,
     g_mvw_fee fee,
     (SELECT feeobjectid,
             SUM (paymentdistamount) totalpaymentamount,
             MAX (paymentreceiveddate) maxpaymentreceiveddate
      FROM g_mvw_payment pay
      GROUP BY feeobjectid
     ) pay
WHERE j.jobid = fee.referencedobjectid
      AND fee.feeobjectid = pay.feeobjectid
      AND pay.maxpaymentreceiveddate >= add_months (trunc (sysdate, 'MM'), - 25)