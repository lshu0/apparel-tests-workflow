select sum(SEARSEVENTSALES), sum(SEARSEVENTSALESUNITS) , sum(SEARSEVENTSALESCOST), sum(SEARSEVENTSALES)- sum(SEARSEVENTSALESCOST)
from shc_work_tbls.all_item_alex_00_week7 a join shc_work_tbls.all_items b 
on a.DIV_NBR0   =b.div_no  and  a.ITM_NBR0  = b.itm_no
where test_nm='.00 Pricing Strategy' and wk_no = 7