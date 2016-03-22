sel sum(KMARTEVENTSALES), sum(KMARTEVENTSALESUNITS), sum(KMARTEVENTSALES)-sum(KMARTEVENTSALESCOST)
 from shc_work_tbls.all_item_kmart_basic2_week7 a
 join shc_work_tbls.kmart_all_items b 
on a.ksn_id = b.ksn
where MST_SSN_DESC = 'Basic'
and wk_no =7
and test_nm = 'Basic 2'