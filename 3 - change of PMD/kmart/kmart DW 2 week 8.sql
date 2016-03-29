select	
	coalesce(pa11.WK_NBR, pa12.WK_NBR)  WK_NBR,
	max(Substr(a14.WK_NBR,10,11)||' '|| a14.WK_END_DT)  WK_DESC0,
	coalesce(pa11.MRCH_NBR, pa12.MRCH_NBR)  MRCH_NBR,
	max(coalesce(pa11.MRCH_DESC, pa12.MRCH_DESC))  MRCH_DESC,
	max(pa11.KMARTLISTSELL)  KMARTLISTSELL,
	max(pa12.WJXBFS1)  KMARTEVENTSALES,
	max(pa12.WJXBFS2)  KMARTEVENTSALESUNITS,
	max(pa11.KMARTLISTSELL) /max(pa12.WJXBFS2) weighted_list_price 
from	(select	pa13.WK_NBR  WK_NBR,
		pa13.MRCH_NBR  MRCH_NBR,
		max(pa13.MRCH_DESC)  MRCH_DESC,
		sum(ZEROIFNULL((pa11.KMARTTOTALSALESUNITS * pa13.KMARTLISTSELLPRICE)))  KMARTLISTSELL
	from	(select	a11.WK_NBR  WK_NBR,
			a11.VEND_PACK_ID  VEND_PACK_ID,
			sum((Case when (a11.TRS_TYP_CD in ('A', 'R', 'S') and a11.MDS_STS in (2, 5, 8) and a11.TYLY_DESC in ('TY')) then (a11.TRS_UN_QT * a11.TY_CTR) else NULL end))  KMARTTOTALSALESUNITS
		from	ALEX_ARP_VIEWS_PRD.FACT_SHC_WKLY_OPR_SLS_TYLY	a11
			join	ALEX_ARP_VIEWS_PRD.LU_SHC_VENDOR_PACK	a12
			  on 	(a11.VEND_PACK_ID = a12.VEND_PACK_ID)
		where	(a12.KSN_ID in (sel ksn from shc_work_tbls.kmart_all_items where wk_no =8 and test_nm = 'D&W 2')
		 and a11.WK_NBR in (201608)
		 and a11.LOCN_NBR in (sel locn from shc_work_tbls.kmart_all_stores where wk_no=8 and test_nm = 'D&W 2')
		 and a11.TRS_TYP_CD in ('A', 'R', 'S')
		 and a11.TYLY_DESC in ('TY'))
		group by	a11.WK_NBR,
			a11.VEND_PACK_ID
		)	pa11
		join	ALEX_ARP_VIEWS_PRD.LU_SHC_VENDOR_PACK	a12
		  on 	(pa11.VEND_PACK_ID = a12.VEND_PACK_ID)
		right outer join	(select	a11.WK_NBR  WK_NBR,
			a12.MRCH_NBR  MRCH_NBR,
			max(a12.MRCH_DESC)  MRCH_DESC,
			avg((Case when a11.TYLY_DESC in ('TY') then ((a11.DFLT_SLL_PRC * a11.TY_CTR) * (a11.DFLT_SLL_PRC_MULT * a11.TY_CTR)) else NULL end))  KMARTLISTSELLPRICE,
			max((Case when a11.TYLY_DESC in ('TY') then 1 else 0 end))  GODWFLAG2_1,
			sum((Case when (a11.TRS_TYP_CD in ('A', 'R', 'S') and a11.MDS_STS in (2, 5, 8) and a11.TYLY_DESC in ('TY')) then (a11.TRS_SLL_DLR * a11.TY_CTR) else NULL end))  KMARTEVENTSALES,
			sum((Case when (a11.TRS_TYP_CD in ('A', 'R', 'S') and a11.MDS_STS in (2, 5, 8) and a11.TYLY_DESC in ('TY')) then (a11.TRS_UN_QT * a11.TY_CTR) else NULL end))  KMARTEVENTSALESUNITS,
			max((Case when (a11.TRS_TYP_CD in ('A', 'R', 'S') and a11.MDS_STS in (2, 5, 8) and a11.TYLY_DESC in ('TY')) then 1 else 0 end))  GODWFLAG4_1
		from	ALEX_ARP_VIEWS_PRD.FACT_SHC_WKLY_OPR_SLS_TYLY	a11
			join	ALEX_ARP_VIEWS_PRD.LU_SHC_VENDOR_PACK	a12
			  on 	(a11.VEND_PACK_ID = a12.VEND_PACK_ID)
		where	(a12.KSN_ID in (sel ksn from shc_work_tbls.kmart_all_items where wk_no =8 and test_nm = 'D&W 2')
		 and a11.WK_NBR in (201608)
		 and a11.LOCN_NBR in (sel locn from shc_work_tbls.kmart_all_stores where wk_no=8 and test_nm = 'D&W 2')
		 and (a11.TYLY_DESC in ('TY')
		 or (a11.TRS_TYP_CD in ('A', 'R', 'S')
		 and a11.MDS_STS in (2, 5, 8)
		 and a11.TYLY_DESC in ('TY'))))
		group by	a11.WK_NBR,
			a12.MRCH_NBR
		)	pa13
		  on 	(a12.MRCH_NBR = pa13.MRCH_NBR and 
		pa11.WK_NBR = pa13.WK_NBR)
	where	(a12.KSN_ID in (sel ksn from shc_work_tbls.kmart_all_items where wk_no =8 and test_nm = 'D&W 2')
	 and pa13.WK_NBR in (201608)
	 and pa13.GODWFLAG2_1 = 1)
	group by	pa13.WK_NBR,
		pa13.MRCH_NBR
	)	pa11
	full outer join	(select	pa01.MRCH_NBR  MRCH_NBR,
		pa01.MRCH_DESC  MRCH_DESC,
		pa01.WK_NBR  WK_NBR,
		pa01.KMARTEVENTSALES  WJXBFS1,
		pa01.KMARTEVENTSALESUNITS  WJXBFS2
	from	(select	a11.WK_NBR  WK_NBR,
			a12.MRCH_NBR  MRCH_NBR,
			max(a12.MRCH_DESC)  MRCH_DESC,
			avg((Case when a11.TYLY_DESC in ('TY') then ((a11.DFLT_SLL_PRC * a11.TY_CTR) * (a11.DFLT_SLL_PRC_MULT * a11.TY_CTR)) else NULL end))  KMARTLISTSELLPRICE,
			max((Case when a11.TYLY_DESC in ('TY') then 1 else 0 end))  GODWFLAG2_1,
			sum((Case when (a11.TRS_TYP_CD in ('A', 'R', 'S') and a11.MDS_STS in (2, 5, 8) and a11.TYLY_DESC in ('TY')) then (a11.TRS_SLL_DLR * a11.TY_CTR) else NULL end))  KMARTEVENTSALES,
			sum((Case when (a11.TRS_TYP_CD in ('A', 'R', 'S') and a11.MDS_STS in (2, 5, 8) and a11.TYLY_DESC in ('TY')) then (a11.TRS_UN_QT * a11.TY_CTR) else NULL end))  KMARTEVENTSALESUNITS,
			max((Case when (a11.TRS_TYP_CD in ('A', 'R', 'S') and a11.MDS_STS in (2, 5, 8) and a11.TYLY_DESC in ('TY')) then 1 else 0 end))  GODWFLAG4_1
		from	ALEX_ARP_VIEWS_PRD.FACT_SHC_WKLY_OPR_SLS_TYLY	a11
			join	ALEX_ARP_VIEWS_PRD.LU_SHC_VENDOR_PACK	a12
			  on 	(a11.VEND_PACK_ID = a12.VEND_PACK_ID)
		where	(a12.KSN_ID in (sel ksn from shc_work_tbls.kmart_all_items where wk_no =8 and test_nm = 'D&W 2')
		 and a11.WK_NBR in (201608)
		 and a11.LOCN_NBR in (sel locn from shc_work_tbls.kmart_all_stores where wk_no=8 and test_nm = 'D&W 2')
		 and (a11.TYLY_DESC in ('TY')
		 or (a11.TRS_TYP_CD in ('A', 'R', 'S')
		 and a11.MDS_STS in (2, 5, 8)
		 and a11.TYLY_DESC in ('TY'))))
		group by	a11.WK_NBR,
			a12.MRCH_NBR
		)	pa01
	where	pa01.GODWFLAG4_1 = 1
	)	pa12
	  on 	(pa11.MRCH_NBR = pa12.MRCH_NBR and 
	pa11.WK_NBR = pa12.WK_NBR)
	join	(select	s21.MRCH_NBR  MRCH_NBR
	from	ALEX_ARP_VIEWS_PRD.LU_SHC_KSN	s21
	where	s21.KSN_ID in (sel ksn from shc_work_tbls.kmart_all_items where wk_no =8 and test_nm = 'D&W 2')
	group by	s21.MRCH_NBR
	)	pa13
	  on 	(coalesce(pa11.MRCH_NBR, pa12.MRCH_NBR) = pa13.MRCH_NBR)
	join	ALEX_ARP_VIEWS_PRD.LU_SHC_WEEKS	a14
	  on 	(coalesce(pa11.WK_NBR, pa12.WK_NBR) = a14.WK_NBR)
where	coalesce(pa11.WK_NBR, pa12.WK_NBR) in (201608)
group by	coalesce(pa11.MRCH_NBR, pa12.MRCH_NBR),
	coalesce(pa11.WK_NBR, pa12.WK_NBR)