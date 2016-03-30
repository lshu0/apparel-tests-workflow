# -*- coding: utf-8 -*-
"""
Created on Wed Feb 24 15:12:51 2016

@author: lshu0
"""
from __future__ import division
import os,glob


paths=[]
wd = "C:/Users/lshu0/Documents/daily work/2-24-2016 APT test report automation"
pattern   = "*.xls"
for x in os.walk(wd):
    paths.extend(glob.glob(os.path.join(x[0],pattern))) 
    
metrics = ['ASP', 'Margin', 'Net Sales', 'Net Quantity', 'Gross Sales']
    
import pandas as pd

all_test={}
for path in paths:
    xls = pd.ExcelFile(path)        
    sheets=xls.sheet_names
    test_name=xls.parse(sheets[0]).columns[0]
    print '\n Detected a test "'+ test_name + '"\n'
    test_site_num = int(raw_input('\n Please type in # of test stores\n'))
    total_site_num = int(raw_input('\n Please type in # of total stores\n'))
    owner = raw_input('\n Please type in name of owner\n')
    
    test_info = {}
    test_info['Test Name']=test_name
    test_info['Owner']=owner
    test_info['# of test stores']= test_site_num
    test_info['# of all stores'] = total_site_num
    test_info['% stores touched'] = '{0:.1f}%'.format(test_site_num/total_site_num*100)
    
    for sheet in sheets:
        df=xls.parse(sheet)
        df.columns=df.ix[2]
        df=df.ix[3:]
        df=df.set_index('Date')
        df['expected']=df['Estimated impact']/df['Lift']
        df['actual']=df['Estimated impact']+df['expected']
        df['total expected']=df['expected']*test_site_num
        df['total actual']=df['actual']*test_site_num
        df['total lift']=df['Estimated impact']*test_site_num
        metric = [metric for metric in metrics if metric in sheet][0]
        test_info['Revenue Touched in Test Stores']=df.ix['02/13/2016','total actual']
        if metric == 'ASP':
            test_info['ASP % Lift'] = df.ix['02/13/2016','Lift'] 
            test_info['ASP Test Actual'] = df.ix['02/13/2016','actual']
            test_info['ASP Test Expected'] = df.ix['02/13/2016','expected']
            test_info['ASP $ Lift'] = df.ix['02/13/2016','actual'] - df.ix['02/13/2016','expected']
        else:
            test_info[metric + ' Act/st'] = df.ix['02/13/2016','actual']
            test_info[metric + ' Exp/st'] = df.ix['02/13/2016','expected']
            test_info[metric + ' Test Actual'] = df.ix['02/13/2016','total actual']
            test_info[metric + ' Test Expected'] = df.ix['02/13/2016','total expected']
            test_info[metric + ' Incremental'] = df.ix['02/13/2016','total lift']
            test_info[metric + ' % Lift'] = df.ix['02/13/2016','Lift']
    all_test[test_name]=test_info

output=pd.DataFrame(all_test)
output=output.T
metric_list= ['Owner','# of test stores','# of all stores','% stores touched','Revenue Touched in Test Stores','ASP Test Actual','ASP Test Expected','ASP % Lift','ASP $ Lift','Net Quantity Act/st','Net Quantity Exp/st','Net Quantity Test Actual','Net Quantity Test Expected','Net Quantity % Lift','Net Quantity Incremental','Net Sales Act/st','Net Sales Exp/st','Net Sales Test Actual','Net Sales Test Expected','Net Sales % Lift','Net Sales Incremental','Margin Act/st','Margin Exp/st','Margin Test Actual','Margin Test Expected','Margin % Lift','Margin Incremental']
output=output.reindex(columns=metric_list)
writer = pd.ExcelWriter('output.xlsx')
output.to_excel(writer,'Sheet1')
writer.save()
        