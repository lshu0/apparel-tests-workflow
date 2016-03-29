sel sum(KMARTEVENTSALES), sum(KMARTEVENTSALESUNITS), sum(KMARTEVENTSALES)-sum(KMARTEVENTSALESCOST)
 from shc_work_tbls.all_item_kmart_DW2_week8 a
 join shc_work_tbls.kmart_all_items b 
on a.ksn_id = b.ksn
where  wk_no =8
and test_nm = 'D&W 2'