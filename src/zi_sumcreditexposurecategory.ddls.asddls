/************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZI_SUMCREDITEXPOSURECATEGORY
*  Type            : CDS VIEW
*  Description     : SUM CREDIT EXPOSURE CATEGORY ITEM CREDIT
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.23 THUANDC3          INITIAL RELEASE
************************************************************************/
@AbapCatalog.sqlViewName: 'ZV_SUMCEC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum Credit Exposure Category Item Credit'
define view ZI_SUMCREDITEXPOSURECATEGORY
  as select from ZI_CREDITEXPOSUREITEMSO
{
  key BusinessPartner,
  key CreditSegment,
      sum ( case CreditExposureCategory
          when '300' then  ExposureAmount else cast( 0 as abap.curr( 23, 2 ) )  end )    as SpecialLiabilities,

      sum ( case CreditExposureCategory
              when '500' then  ExposureAmount else cast( 0 as abap.curr( 23, 2 ) ) end ) as TotalReceivables,

      sum (  case CreditExposureCategory
              when '100' then  ExposureAmount else cast( 0 as abap.curr( 23, 2 ) ) end ) as OpenOders,

      sum ( case CreditExposureCategory
               when '400' then ExposureAmount else cast( 0 as abap.curr( 23, 2 ) ) end ) as OpenDelivery

}
group by
  BusinessPartner,
  CreditSegment
