sel sum(KMARTEVENTSALES), sum(KMARTEVENTSALESUNITS), sum(KMARTEVENTSALES)-sum(KMARTEVENTSALESCOST) 
 from shc_work_tbls.all_item_kmart_basic1_week7 a join shc_work_tbls.Kmart_Apparel_Div_Cat b
 on a.DVSN_NBR  =b.div_no  and a.CATG_NBR  =b.cat_no
 where MST_SSN_DESC = 'Basic';