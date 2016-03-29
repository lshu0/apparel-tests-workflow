select sum(SEARSEVENTSALES), sum(SEARSEVENTSALESUNITS) , sum(SEARSEVENTSALESCOST), sum(SEARSEVENTSALES)- sum(SEARSEVENTSALESCOST)
from  shc_work_tbls.all_item_alex_00_week8 a join  shc_work_tbls.Sears_Apparel_Div_Line b on
a.div_nbr = b.div_no and a.ln_nbr= b.ln_no
where PRD_SUB_ATTR_NM != 'BASIC'
