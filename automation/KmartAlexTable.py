# -*- coding: utf-8 -*-
"""
Created on Thu Mar 31 16:47:30 2016

@author: lshu0
"""

def KmartAlexTable (year_week,week_number, test_name):
    table_names={'Basics 1':'B1','Basics 2':'B2','D&W Dec':'DWD','Blackout':'Neg','D&W Inc':'DWI'}
    table_name = table_names[test_name]
    query = """
    create table shc_work_tbls.all_item_kmart_{tbl_nm}_week{wk_no} as (
select	a13.DVSN_NBR  DVSN_NBR,
	max(a13.DVSN_DESC)  DVSN_DESC,
	a13.CATG_ID  CATG_ID,
	max(a13.CATG_DESC)  CATG_DESC,
	max(a13.DVSN_NBR)  DVSN_NBR0,
	max(a13.CATG_NBR)  CATG_NBR,
	pa12.KSN_ID  KSN_ID,
	max(pa12.KSN_DESC)  KSN_DESC,
	pa12.MST_SSN_CD  MST_SSN_CD,
	max(a14.MST_SSN_DESC)  MST_SSN_DESC,
	max(pa12.KMARTEVENTSALES)  KMARTEVENTSALES,
	max(pa12.KMARTEVENTSALESUNITS)  KMARTEVENTSALESUNITS,
	max(pa12.KMARTTOTALSALES)  KMARTTOTALSALES,
	max(pa12.KMARTTOTALSALESUNITS)  KMARTTOTALSALESUNITS,
	max(pa12.KMARTCOSTOFMDSESOLD)  KMARTCOSTOFMDSESOLD,
	max(pa12.KMARTEVENTSALESCOST)  KMARTEVENTSALESCOST
from	(select	a11.WK_NBR  WK_NBR,
		a13.MST_SSN_CD  MST_SSN_CD,
		a12.KSN_ID  KSN_ID,
		max(a12.KSN_DESC)  KSN_DESC,
		sum((Case when a11.MDS_STS in (2, 5, 8) then (a11.TRS_SLL_DLR * a11.TY_CTR) else NULL end))  KMARTEVENTSALES,
		sum((Case when a11.MDS_STS in (2, 5, 8) then (a11.TRS_UN_QT * a11.TY_CTR) else NULL end))  KMARTEVENTSALESUNITS,
		sum((Case when a11.MDS_STS in (2, 5, 8) then (a11.TRS_CST_DLR * a11.TY_CTR) else NULL end))  KMARTEVENTSALESCOST,
		sum((a11.TRS_SLL_DLR * a11.TY_CTR))  KMARTTOTALSALES,
		sum((a11.TRS_UN_QT * a11.TY_CTR))  KMARTTOTALSALESUNITS,
		sum((a11.TRS_CST_DLR * a11.TY_CTR))  KMARTCOSTOFMDSESOLD
	from	ALEX_ARP_VIEWS_PRD.FACT_SHC_WKLY_OPR_SLS_TYLY	a11
		join	ALEX_ARP_VIEWS_PRD.LU_SHC_VENDOR_PACK	a12
		  on 	(a11.VEND_PACK_ID = a12.VEND_PACK_ID)
		join	ALEX_ARP_VIEWS_PRD.REF_SHC_SSN_TO_MST_SSN	a13
		  on 	(a12.SHC_SSN_CD = a13.SHC_SSN_CD and 
		a12.SSN_YR_NBR = a13.SSN_YR_NBR)
	where	(a12.MRCH_NBR in (10000)
	 and a11.WK_NBR in ({yr_wk})
	 and a11.LOCN_NBR in (
	 
	 sel locn from shc_work_tbls.kmart_all_stores where test_nm = '{test_nm}' and wk_no = {wk_no} 
	 )	 and a11.TRS_TYP_CD in ('A', 'R', 'S')
	 and a11.TYLY_DESC in ('TY'))
	group by	a11.WK_NBR,
		a13.MST_SSN_CD,
		a12.KSN_ID
	)	pa12
	left outer join	ALEX_ARP_VIEWS_PRD.LU_SHC_KSN	a13
	  on 	(pa12.KSN_ID = a13.KSN_ID)
	join	ALEX_ARP_VIEWS_PRD.LU_SHC_MST_SSN	a14
	  on 	(pa12.MST_SSN_CD = a14.MST_SSN_CD)
	join	ALEX_ARP_VIEWS_PRD.LU_SHC_WEEKS	a15
	  on 	(pa12.WK_NBR = a15.WK_NBR)
where	(a13.MRCH_NBR in (10000)
 and pa12.WK_NBR in ({yr_wk}))
group by	a13.DVSN_NBR,
	a13.CATG_ID,
	pa12.KSN_ID,
	pa12.WK_NBR,
	pa12.MST_SSN_CD
) with data primary index (DVSN_NBR, KSN_ID)
    """.format(tbl_nm=table_name, yr_wk = year_week, wk_no = week_number, test_nm = test_name)
    return query