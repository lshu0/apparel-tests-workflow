# -*- coding: utf-8 -*-
"""
Created on Mon Mar 28 22:41:31 2016

@author: lshu0
"""
import jaydebeapi
import jpype
import AvgListRegKmart
import AvgListRegSears
import SearsAlexTable

def teraConnection(tduser='XXX',tdpwd='XXXX'):


    driverClass='com.teradata.jdbc.TeraDriver'
    path='jdbc:teradata://s00t0108.searshc.com'
    classpath = """C:\\Users\\lshu0\\Documents\\Teradata driver\\tdgssconfig.jar;C:\\Users\\lshu0\\Documents\\Teradata driver\\terajdbc4.jar"""
    jvm_path =  u'C:\\Program Files\\Java\\jre7\\bin\\server\\jvm.dll'
    jpype.startJVM(jvm_path, "-Djava.class.path=%s" % classpath)
    conn = jaydebeapi.connect(driverClass,[path,tduser,tdpwd])
    cursor = conn.cursor()
    return cursor

cursor=teraConnection()    
    
sears_test=['.00 Pricing Strategy','Basics 1','Basics 2','Blackout','Seasonal Variation','Simple Messaging Test']
kmart_test=['Basics 1','Basics 2','Blackout','D&W 1','D&W 2']
wk_start = 201601
wk_end = 201608

ALRS={}
for test_nm in sears_test:
    for wk in xrange(wk_start, wk_end+1, 1):
        yr_wk=str(wk)
        wk_no= str(wk%100)
        query=AvgListRegSears.AvgListRegSears(yr_wk,wk_no,test_nm)
        cursor.execute(query)
        rows=cursor.fetchall()
        ALRS[test_nm+yr_wk]=rows[0][7]
        
ALRK={}        
for test_nm in kmart_test:
    for wk in xrange(wk_start, wk_end+1, 1):
        yr_wk=str(wk)
        wk_no= str(wk%100)
        query=AvgListRegKmart.AvgListRegKmart(yr_wk,wk_no,test_nm)
        cursor.execute(query)
        rows=cursor.fetchall()
        ALRK[test_nm+yr_wk]=rows[0][7]

for test_nm in sears_test:
    wk = 201608
    wk_no= str(wk%100)
    yr_wk=str(wk)
    query = SearsAlexTable.SearsAlexAllItem(yr_wk,wk_no,test_nm)
    cursor.execute(query)
    
    
