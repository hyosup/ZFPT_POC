/************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZER_SALEDOCUMENT
*  Type            : CDS VIEW
*  Description     : ROOT ENTITY FOR SALES DOCUMENT
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.22 THUANDC3          INITIAL RELEASE
************************************************************************/
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View for Sales Order Credit Report'
define root view entity ZER_SALEDOCUMENT
  as select from ZI_SALEDOCUMENT_B
{
  key SalesOrder,
      CreationDate,
      SalesOrderType,
      SalesOrganization,
      DistributionChannel,
      OrganizationDivision,
      SalesOffice,
      SalesGroup,
      @ObjectModel.foreignKey.association: '_OverallSDDocumentRejectionSts'        
      OverallSDDocumentRejectionSts,
      OverallDeliveryStatus,
      TotalCreditCheckStatus,
      CreatedByUser,
      SoldToParty,
      SoldToPartyName,
      CustomerCreditAccount,
      CreditControlArea,
      CustomerCreditAccountName,
      RiskCategory,
      TransactionCurrency,
      Value_Inc_Tax,
      CreditCurrency,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      CreditLimit,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      CreditLimitLeft,
      @Semantics.quantity.unitOfMeasure: 'Percent'
      CreditLimitUsed,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      SpecialLiabilities,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      CreditExposure,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      TotalReceivables,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      OpenOrders,
      @Semantics.amount.currencyCode: 'CreditCurrency'
      OpenDelivery,
      RejectReason,
      Percent,
      _SalesOrderType,
      _SalesOrganization,
      _DistributionChannel,
      _OrganizationDivision,
      _SalesOffice,
      _SalesGroup,
      _OverallSDDocumentRejectionSts,
      _OverallDeliveryStatus,
      _TotalCreditCheckStatus,
      _CreditRiskClass      
      
}
