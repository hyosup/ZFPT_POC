/************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZI_SUMCREDITEXPOSUREITEMSO
*  Type            : CDS VIEW
*  Description     : SUM CREDIT EXPOSURE ITEM SALES DOCUMENT
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.22 THUANDC3          INITIAL RELEASE
************************************************************************/
@AbapCatalog.sqlViewName: 'ZV_SCEISO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum Credit Exposure Item Sales Document'
define view ZI_SUMCREDITEXPOSUREITEMSO
  as select from ZI_SUMCREDITEXPOSURECATEGORY
{
  key BusinessPartner,
  key CreditSegment,
      SpecialLiabilities,
      TotalReceivables,
      OpenOders,
      OpenDelivery,
       cast ( SpecialLiabilities + TotalReceivables
       + OpenOders + OpenDelivery  as abap.curr( 23, 2 )  )         as CreditExposure

}
