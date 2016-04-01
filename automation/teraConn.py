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
import SearsAllApparelItem
import SearsTrackerApparel
import KmartAlexTable
import KmartAllApparelItem
import KmartTrackerApparel

def teraConnection(tduser='lshu0',tdpwd='slw1234'):


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
kmart_test=['Basics 1','Basics 2','Blackout','D&W Inc','D&W Dec']
wk= 201608

ALRS={}
for test_nm in sears_test:
    yr_wk=str(wk)
    wk_no= str(wk%100)
    query=AvgListRegSears.AvgListRegSears(yr_wk,wk_no,test_nm)
    cursor.execute(query)
    rows=cursor.fetchall()
    ALRS[test_nm+yr_wk]=rows[0][7]
        
ALRK={}        
for test_nm in kmart_test:
    yr_wk=str(wk)
    wk_no= str(wk%100)
    query=AvgListRegKmart.AvgListRegKmart(yr_wk,wk_no,test_nm)
    cursor.execute(query)
    rows=cursor.fetchall()
    ALRK[test_nm+yr_wk]=rows[0][7]

SAAI={}
STA={}
for test_nm in sears_test:
    wk_no= str(wk%100)
    yr_wk=str(wk)
    query = SearsAlexTable.SearsAlexAllItem(yr_wk,wk_no,test_nm)
    cursor.execute(query)
    query = SearsAllApparelItem.SearsAllApparelItem(yr_wk,wk_no,test_nm)
    cursor.execute(query)
    rows=cursor.fetchall()
    SAAI[test_nm+yr_wk]=rows[0]
    query = SearsTrackerApparel.SearsTrackerApparel(yr_wk,wk_no,test_nm)
    cursor.execute(query)
    rows=cursor.fetchall()
    STA[test_nm+yr_wk]=rows[0]
  
KAAI={}  
KTA={}
for test_nm in kmart_test:
    wk_no= str(wk%100)
    yr_wk=str(wk)
    query = KmartAlexTable.KmartAlexTable(yr_wk,wk_no,test_nm)
    cursor.execute(query)
    query = KmartAllApparelItem.KmartAllApparelItem(yr_wk,wk_no,test_nm)
    cursor.execute(query)
    rows=cursor.fetchall()
    KAAI[test_nm+yr_wk]=rows[0]
    query = KmartTrackerApparel.KmartTrackerApparel(yr_wk,wk_no,test_nm)
    cursor.execute(query)
    rows=cursor.fetchall()
    KTA[test_nm+yr_wk]=rows[0]
    


