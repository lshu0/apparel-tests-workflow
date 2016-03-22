create table shc_work_tbls.all_item_alex_00_week7 as (
select	a11.WK_NBR  WK_NBR,
	max(Substring(a16.WK_NBR,10,11)||' '|| a16.WK_END_DT)  WK_DESC0,
	a12.DIV_NBR  DIV_NBR,
	max(a12.DIV_DESC)  DIV_DESC,
	a12.PRD_IRL_NBR  PRD_IRL_NBR,
	max(a12.PRD_DESC)  PRD_DESC,
	max(a12.DIV_NBR)  DIV_NBR0,
	max(a12.ITM_NBR)  ITM_NBR0,
	a12.LN_ID  LN_ID,
	max(a12.DIV_NBR)  DIV_NBR1,
	max(a12.LN_NBR)  LN_NBR,
	max(a12.LN_DESC)  LN_DESC,
	a15.PRD_SUB_ATTR_ID  PRD_SUB_ATTR_ID,
	max(a15.PRD_SUB_ATTR_NM)  PRD_SUB_ATTR_NM,
	sum( CASE WHEN a11.SLS_TYP_CD not in ('M') THEN a11.TRS_SLL_DLR*a11.TY_CTR  end)  SEARSEVENTSALES,
	sum( CASE WHEN a11.SLS_TYP_CD not in ('M') THEN a11.TRS_UN_QT*a11.TY_CTR  end)  SEARSEVENTSALESUNITS,
	sum( CASE WHEN a11.SLS_TYP_CD not in ('M') THEN a11.TRS_CST_DLR*a11.TY_CTR  end)  SEARSEVENTSALESCOST
from	ALEX_ARP_VIEWS_PRD.FACT_SRS_WKLY_OPR_SLS_TYLY	a11
	join	ALEX_ARP_VIEWS_PRD.LU_SRS_PRODUCT_SKU	a12
	  on 	(a11.SKU_ID = a12.SKU_ID)
	join	ALEX_ARP_VIEWS_PRD.REF_SRS_PRD_PROD_ATTR	a13
	  on 	(a12.PRD_IRL_NBR = a13.PRD_IRL_NBR)
	join	ALEX_ARP_VIEWS_PRD.LU_MCT_PRD_ATTR_SSN	a14
	  on 	(a13.ATTR_SE_VALU = a14.PRD_VALU_KEY)
	join	(Select   PRD_SUB_ATTR_ID, PRD_SUB_ATTR_NM, PRD_VALU_KEY, PRD_VALU_ID, PRD_VALU_NM
From     ALEX_ARP_VIEWS_PRD.LU_MCT_PRD_ATTR_SSN 
Where PRD_SUB_ATTR_ID > 10000
And PRD_VALU_CD <> 'FFFF')	a15
	  on 	(a14.PRD_VALU_ID = a15.PRD_VALU_ID)
	join	ALEX_ARP_VIEWS_PRD.LU_SHC_WEEKS	a16
	  on 	(a11.WK_NBR = a16.WK_NBR)
where	(a12.MRCH_NBR in (20000)
 and a11.WK_NBR in (201607)
 and a11.LOCN_NBR in (

sel locn from shc_work_tbls.sears_all_stores where test_nm = '.00 Pricing Strategy' and wk_no = 7

 )
 and a11.TRS_TYP_CD in ('A', 'R', 'S')
 and a11.MDS_STS in (2, 5, 8)
 and a11.TYLY_DESC in ('TY'))
group by	a11.WK_NBR,
	a12.DIV_NBR,
	a12.PRD_IRL_NBR,
	a12.LN_ID,
	a15.PRD_SUB_ATTR_ID
	
)
with data primary index ( DIV_NBR0, ITM_NBR0)