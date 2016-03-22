drop table shc_work_tbls.sears_basic_apparel;

create table shc_work_tbls.sears_basic_apparel as (
SELECT DISTINCT 
        DIV_NO, 
        ITM_NO
        
   --             VBS_NO, 
     --   DIV_NO, 
     --   LN_NO, 
      --  SBL_NO, 
       -- CLS_NO, 
        --ITM_NO,
       -- PRD_IRL_NO, 
       -- NAT_SLL_PRC,
        --ITM_PRG_DT
        
FROM 
        LCI_DW_VIEWS.SPRS_PRODUCT
WHERE
        VBS_NO IN (604, 607, 618, 629, 641)
        AND SSN_CD IN ('C6', 'T6')
        AND ITM_PRG_DT IS NULL 
       )
       with data primary index (  DIV_NO, 
        ITM_NO)