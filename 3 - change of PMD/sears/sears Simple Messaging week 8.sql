select	coalesce(pa11.WK_NBR, pa12.WK_NBR)  WK_NBR,
	max(Substr(a14.WK_NBR,10,11)||' '|| a14.WK_END_DT)  WK_DESC0,
	coalesce(pa11.MRCH_NBR, pa12.MRCH_NBR)  MRCH_NBR,
	max(coalesce(pa11.SHC_MDS_DESC, pa12.SHC_MDS_DESC))  SHC_MDS_DESC,
	max(pa11.SEARSLISTSELL)  SEARSLISTSELL,
	max(pa12.SEARSEVENTSALES)  SEARSEVENTSALES,
	max(pa12.SEARSEVENTSALESUNITS)  SEARSEVENTSALESUNITS,
	max(pa11.SEARSLISTSELL)/max(pa12.SEARSEVENTSALESUNITS) weighted_list_price
from	(select	pa11.WK_NBR  WK_NBR,
		a13.MRCH_NBR  MRCH_NBR,
		max(a13.MRCH_DESC)  SHC_MDS_DESC,
		sum(ZEROIFNULL((pa11.SEARSTOTALSALESUNITS * pa12.SEARSLISTSELLPRICE)))  SEARSLISTSELL
	from	(select	a11.WK_NBR  WK_NBR,
			a12.PRD_IRL_NBR  PRD_IRL_NBR,
			sum( Case when a11.MDS_STS in (2, 5, 8) then  CASE WHEN a11.SLS_TYP_CD not in ('M') THEN a11.TRS_UN_QT*a11.TY_CTR  end else NULL end)  SEARSTOTALSALESUNITS
		from	ALEX_ARP_VIEWS_PRD.FACT_SRS_WKLY_OPR_SLS_TYLY	a11
			join	ALEX_ARP_VIEWS_PRD.LU_SRS_PRODUCT_SKU	a12
			  on 	(a11.SKU_ID = a12.SKU_ID)
		where	(a11.WK_NBR in (201608)
		 and a11.LOCN_NBR in (sel locn from shc_work_tbls.Sears_all_stores where wk_no = 8 and test_nm = 'Simple Messaging Test' )
		 and a11.TRS_TYP_CD in ('A', 'R', 'S'))
		group by	a11.WK_NBR,
			a12.PRD_IRL_NBR
		)	pa11
		join	(select	a11.PRD_IRL_NBR  PRD_IRL_NBR,
			avg(a11.NATL_SLL_PRC)  SEARSLISTSELLPRICE
		from	ALEX_ARP_VIEWS_PRD.LU_SRS_PRODUCT	a11
		group by	a11.PRD_IRL_NBR
		)	pa12
		  on 	(pa11.PRD_IRL_NBR = pa12.PRD_IRL_NBR)
		join	ALEX_ARP_VIEWS_PRD.LU_SRS_PRODUCT	a13
		  on 	(pa11.PRD_IRL_NBR = a13.PRD_IRL_NBR)
	where	(a13.MRCH_NBR in (20000)
	 and pa11.WK_NBR in (201608)
	 and a13.DIVITEM in (sel trim(div_no)||'-'||trim(itm_no) from shc_work_tbls.sears_all_items where wk_no = 8 and test_nm = 'Simple Messaging Test'))
	group by	pa11.WK_NBR,
		a13.MRCH_NBR
	)	pa11
	full outer join	(select	a11.WK_NBR  WK_NBR,
		a12.MRCH_NBR  MRCH_NBR,
		max(a12.MRCH_DESC)  SHC_MDS_DESC,
		sum( CASE WHEN a11.SLS_TYP_CD not in ('M') THEN a11.TRS_SLL_DLR*a11.TY_CTR  end)  SEARSEVENTSALES,
		sum( CASE WHEN a11.SLS_TYP_CD not in ('M') THEN a11.TRS_UN_QT*a11.TY_CTR  end)  SEARSEVENTSALESUNITS
	from	ALEX_ARP_VIEWS_PRD.FACT_SRS_WKLY_OPR_SLS_TYLY	a11
		join	ALEX_ARP_VIEWS_PRD.LU_SRS_PRODUCT_SKU	a12
		  on 	(a11.SKU_ID = a12.SKU_ID)
	where	(a12.MRCH_NBR in (20000)
	 and a11.WK_NBR in (201608)
	 and a11.LOCN_NBR in (sel locn from  shc_work_tbls.Sears_all_stores where wk_no = 8 and test_nm = 'Simple Messaging Test')
	 and a12.DIVITEM in (sel trim(div_no)||'-'||trim(itm_no) from shc_work_tbls.sears_all_items where wk_no = 8 and test_nm = 'Simple Messaging Test')
	 and a11.TRS_TYP_CD in ('A', 'R', 'S')
	 and a11.MDS_STS in (2, 5, 8)
	 and a11.TYLY_DESC in ('TY'))
	group by	a11.WK_NBR,
		a12.MRCH_NBR
	)	pa12
	  on 	(pa11.MRCH_NBR = pa12.MRCH_NBR and 
	pa11.WK_NBR = pa12.WK_NBR)
	join	(select	s21.MRCH_NBR  MRCH_NBR
	from	ALEX_ARP_VIEWS_PRD.LU_SRS_PRODUCT	s21
	where	(s21.MRCH_NBR in (20000)
	 and s21.DIVITEM in (sel trim(div_no)||'-'||trim(itm_no) from shc_work_tbls.sears_all_items where wk_no = 8 and test_nm = 'Simple Messaging Test'))
	group by	s21.MRCH_NBR
	)	pa13
	  on 	(coalesce(pa11.MRCH_NBR, pa12.MRCH_NBR) = pa13.MRCH_NBR)
	join	ALEX_ARP_VIEWS_PRD.LU_SHC_WEEKS	a14
	  on 	(coalesce(pa11.WK_NBR, pa12.WK_NBR) = a14.WK_NBR)
where	coalesce(pa11.WK_NBR, pa12.WK_NBR) in (201608)
group by	coalesce(pa11.WK_NBR, pa12.WK_NBR),
	coalesce(pa11.MRCH_NBR, pa12.MRCH_NBR)
