/************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZI_SALEDOCUMENT_B
*  Type            : CDS VIEW
*  Description     : COMPOSITE VIEW OF SALES CREDIT REPORT
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.21 THUANDC3          INITIAL RELEASE
************************************************************************/
@AbapCatalog.sqlViewName: 'ZV_SALEORDER'
@AbapCatalog.compiler.compareFilter: true
@VDM: {
  viewType: #BASIC,
  lifecycle.contract.type: #PUBLIC_LOCAL_API
}
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDSView Sales Document'
define view ZI_SALEDOCUMENT_B
  as select from    I_SalesOrder
    left outer join I_CustomerToBusinessPartner                        on I_CustomerToBusinessPartner.Customer = I_SalesOrder.CustomerCreditAccount
    left outer join I_CreditControlArea2Segment                        on I_CreditControlArea2Segment.CreditControlArea = I_SalesOrder.CreditControlArea
    left outer join I_CreditManagementAccount                          on  I_CreditManagementAccount.BusinessPartner = I_SalesOrder.CustomerCreditAccount
                                                                       and I_CreditManagementAccount.CreditSegment   = I_CreditControlArea2Segment.CreditSegment
    left outer join I_CreditManagementBP                               on I_CreditManagementBP.BusinessPartner = I_SalesOrder.CustomerCreditAccount
    left outer join ZI_SUMCREDITEXPOSUREITEMSO  as _SumCreditExposure   on  _SumCreditExposure.BusinessPartner = I_SalesOrder.CustomerCreditAccount
                                                                        and _SumCreditExposure.CreditSegment   = I_CreditManagementAccount.CreditSegment
    left outer join ZI_SUMVATSALEDOCUMENTITEM_B as _sumVatSaleDocument on _sumVatSaleDocument.saledocument = I_SalesOrder.SalesOrder
{
  key I_SalesOrder.SalesOrder,
      I_SalesOrder.CreationDate,
      I_SalesOrder.SalesOrderType,
      I_SalesOrder.SalesOrganization,
      I_SalesOrder.DistributionChannel,
      I_SalesOrder.OrganizationDivision,
      I_SalesOrder.SalesOffice,
      I_SalesOrder.SalesGroup,
      @ObjectModel.foreignKey.association: '_OverallSDDocumentRejectionSts'      
      I_SalesOrder.OverallSDDocumentRejectionSts,
      I_SalesOrder.OverallDeliveryStatus,
      I_SalesOrder.TotalCreditCheckStatus,
      I_SalesOrder.CreatedByUser,
      I_SalesOrder.SoldToParty,
      I_SalesOrder._SoldToParty.CustomerName                                                                           as SoldToPartyName,
      I_SalesOrder.CustomerCreditAccount,
      I_SalesOrder.CreditControlArea,
      I_SalesOrder._CustomerCreditAccount.CustomerName                                                                 as CustomerCreditAccountName,
      I_CreditManagementBP.CreditRiskClass                                                                             as RiskCategory,
      @Semantics.currencyCode
      I_SalesOrder.TransactionCurrency,
      cast ( ( _sumVatSaleDocument.Quantity_Sales_Unit * _sumVatSaleDocument.ItemCreditPrice ) as abap.curr( 23, 2 ) ) as Value_Inc_Tax,
      I_CreditManagementAccount.CreditSegmentCurrency                                                                  as CreditCurrency,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      I_CreditManagementAccount.CustomerCreditLimitAmount                                                              as CreditLimit,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      coalesce( cast ( I_CreditManagementAccount.CustomerCreditLimitAmount as abap.curr( 23, 2 ) ), 0 ) -
      coalesce(  _SumCreditExposure.CreditExposure  , 0 )                                                              as CreditLimitLeft,
      @Semantics.quantity.unitOfMeasure: 'Percent'
      division(  _SumCreditExposure.CreditExposure  ,
      cast ( I_CreditManagementAccount.CustomerCreditLimitAmount  as abap.curr( 23, 2 ) ) , 2 ) * 100                  as CreditLimitUsed,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      _SumCreditExposure.SpecialLiabilities                                                                            as SpecialLiabilities,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      _SumCreditExposure.CreditExposure                                                                                as CreditExposure,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      _SumCreditExposure.TotalReceivables                                                                              as TotalReceivables,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      _SumCreditExposure.OpenOders                                                                                     as OpenOrders,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      _SumCreditExposure.OpenDelivery                                                                                  as OpenDelivery,
      cast(' %' as abap.unit(3))                                                                                       as Percent,
      cast('' as char10)                                                                                               as RejectReason,
      I_SalesOrder._SalesOrderType,
      I_SalesOrder._SalesOrganization,
      I_SalesOrder._DistributionChannel,
      I_SalesOrder._OrganizationDivision,
      I_SalesOrder._SalesOffice,
      I_SalesOrder._SalesGroup,
      I_SalesOrder._OverallSDDocumentRejectionSts,
      I_SalesOrder._OverallDeliveryStatus,
      I_SalesOrder._TotalCreditCheckStatus,
      I_CreditManagementBP._CreditRiskClass

}
