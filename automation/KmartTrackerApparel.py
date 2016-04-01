# -*- coding: utf-8 -*-
"""
Created on Fri Apr 01 11:26:02 2016

@author: lshu0
"""

def KmartTrackerApparel(year_week,week_number, test_name):
    table_names={'Basics 1':'B1','Basics 2':'B2','D&W Dec':'DWD','Blackout':'Neg','D&W Inc':'DWI'}
    table_name = table_names[test_name]
    query = """
select sum(KMARTEVENTSALES), sum(KMARTEVENTSALESUNITS), sum(KMARTEVENTSALES)-sum(KMARTEVENTSALESCOST)
 from shc_work_tbls.all_item_kmart_{tbl_nm}_week{wk_no} a
 join shc_work_tbls.kmart_all_items b 
on a.ksn_id = b.ksn
where  wk_no = {wk_no}
and test_nm = '{test_nm}'
    """.format(tbl_nm=table_name, wk_no = week_number, test_nm = test_name)
    return query