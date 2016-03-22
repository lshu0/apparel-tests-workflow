select sum(SEARSEVENTSALES), sum(SEARSEVENTSALESUNITS) , sum(SEARSEVENTSALESCOST), sum(SEARSEVENTSALES)- sum(SEARSEVENTSALESCOST)
 from shc_work_tbls.all_item_alex_basics_1_week7 a join shc_work_tbls.sears_basic_apparel  b 
on a.DIV_NBR0   =b.div_no  and  a.ITM_NBR0  = b.itm_no
where PRD_SUB_ATTR_NM = 'BASIC'