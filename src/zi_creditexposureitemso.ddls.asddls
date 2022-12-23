/************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZI_CREDITEXPOSUREITEMSO
*  Type            : CDS VIEW
*  Description     : CREDIT EXPOSURE ITEM WITH SALES ORDER
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.22 THUANDC3          INITIAL RELEASE
************************************************************************/
@AbapCatalog.sqlViewName: 'ZCEXITEM'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Credit Exposure Item with Sales Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_CREDITEXPOSUREITEMSO
  as select from I_CreditExposureItem
{
  key BusinessPartner,
  key CreditSegment,
  key CreditManagementLineItem,
  key _BusinessPartner.BusinessPartnerUUID,
      cast (substring(CreditMgmtLinkedLineItemKey, 1, 10) as vdm_sales_order) as docno,
      cast (substring(CreditMgmtLinkedLineItemKey, 16, 6) as abap.char( 6 ))  as itemno,
      CreditExposureUTCDateTime,
      CreditExposureCategory,
      @Semantics.amount.currencyCode: 'Currency'
      ExposureAmount,
      @Semantics.amount.currencyCode: 'Currency'
      HedgedAmount,
      Currency,
      OriginalLiableBusinessPartner,
      OriginalLiableCreditSegment,
      /* Associations */
      _BusinessPartner,
      _CreditSegment,
      _ExposureCategory,
      _OriginalLiableBusinessPartner,
      _OriginalLiableCreditSegment
}
