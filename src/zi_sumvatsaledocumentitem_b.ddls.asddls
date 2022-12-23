/************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZI_SUMVATSALEDOCUMENTITEM_B
*  Type            : CDS VIEW
*  Description     : SUM VAT OF SALES DOCUMENT ITEM
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.23 THUANDC3          INITIAL RELEASE
************************************************************************/
@AbapCatalog.sqlViewName: 'ZV_SUMVATSDI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum Vat of Sales Document Item'
define view ZI_SUMVATSALEDOCUMENTITEM_B
  as select from vbap
{
  key vbeln           as saledocument,
      sum( kbmeng  ) as Quantity_Sales_Unit,
      sum(  cmpre  )  as ItemCreditPrice
}
where abgru is not null
group by
  vbeln
