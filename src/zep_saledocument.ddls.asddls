/************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZEP_SALEDOCUMENT
*  Type            : CDS VIEW
*  Description     : PROJECTION VIEW SALE DOCUMENT
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.22 THUANDC3          INITIAL RELEASE
************************************************************************/
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View Sale Document'
@Search.searchable: false
@Metadata.allowExtensions: true
define root view entity ZEP_SALEDOCUMENT
    provider contract transactional_query
  as projection on ZER_SALEDOCUMENT

{
               @Consumption.valueHelpDefinition: [{
                 entity: { name:    'I_SalesDocumentStdVH',
                           element: 'SalesDocument' }

                }]
  key          SalesOrder,
               @Consumption.filter: { mandatory: true,  selectionType: #INTERVAL }
               CreationDate,
               @Consumption.valueHelpDefinition: [{
                 entity: { name:    'I_SalesOrderType',
                           element: 'SalesOrderType' }

                }]
               @ObjectModel.text.element: [ 'SalesDocumentTypeName' ]
               SalesOrderType,
               @Consumption.valueHelpDefinition: [{
                  entity: { name:    'I_SalesOrganization',
                            element: 'SalesOrganization' }

                 }]
               @ObjectModel.text.element: [ 'SalesOrganizationName' ]
               @Consumption.filter: { mandatory: true }
               SalesOrganization,
               @Consumption.valueHelpDefinition: [{
                  entity: { name:    'I_DistributionChannel',
                            element: 'DistributionChannel' }

                 }]
               @ObjectModel.text.element: [ 'DistributionChannelName' ]
               DistributionChannel,
               @Consumption.valueHelpDefinition: [{
                  entity: { name:    'I_Division',
                            element: 'Division' }

                 }]
               @ObjectModel.text.element: [ 'DivisionName' ]
               OrganizationDivision,
               @Consumption.valueHelpDefinition: [{
                 entity: { name:    'C_SalesOfficeValueHelp',
                           element: 'SalesOffice' },
                 additionalBinding: [{element: 'SalesOrganization', localElement: 'SalesOrganization'},
                                     {element: 'DistributionChannel', localElement: 'DistributionChannel'},
                                     {element: 'OrganizationDivision', localElement: 'OrganizationDivision'} ]
                }]
               @ObjectModel.text.element: [ 'SalesOfficeName' ]
               SalesOffice,
               @Consumption.valueHelpDefinition: [{
                 entity: { name:    'C_SalesGroupValueHelp',
                           element: 'SalesGroup' },
                 additionalBinding: [{element: 'SalesOffice', localElement: 'SalesOffice' } ]
                }]
               @ObjectModel.text.element: [ 'SalesGroupName' ]
               SalesGroup,

               @Consumption.valueHelpDefinition: [{
                 entity: { name:    'I_OverallSDDocumentRjcnStatus',
                           element: 'OverallSDDocumentRejectionSts' }
                           
                }]
               @ObjectModel.text.element: [ 'OvrlSDDocumentRejectionStsDesc' ]
               @Consumption.filter.selectionType: #SINGLE
               @Consumption.filter.defaultValue: 'A'
               @ObjectModel.foreignKey.association: '_OverallSDDocumentRejectionSts'                  
               OverallSDDocumentRejectionSts,

               @Consumption.valueHelpDefinition: [{
                 entity: { name:    'I_OverallDeliveryStatus',
                           element: 'OverallDeliveryStatus' }
                            
                }]
               @ObjectModel.text.element: [ 'OverallDeliveryStatusDesc' ]
               @Consumption.filter.selectionType: #SINGLE
               @Consumption.filter.defaultValue: 'A'             
               OverallDeliveryStatus,

               @Consumption.valueHelpDefinition: [{
                 entity: { name:    'I_TotalCreditCheckStatus',
                           element: 'TotalCreditCheckStatus' }
                }]
               @ObjectModel.text.element: [ 'TotalCreditCheckStatusDesc' ]
               @Consumption.filter.selectionType: #SINGLE
               @Consumption.filter.defaultValue: 'A'
               TotalCreditCheckStatus,
               CreatedByUser,
               SoldToParty                                                         as Customer,
               SoldToPartyName,
               CustomerCreditAccount,
               CreditControlArea,
               CustomerCreditAccountName,
               @Consumption.filter.selectionType: #SINGLE
               @Consumption.valueHelpDefinition: [{
                 entity: { name:    'I_CreditRiskClassValueHelp',
                           element: 'CreditRiskClass' }
                }]
               @ObjectModel.text.element: [ 'CreditRiskClassName' ]
               RiskCategory,
               TransactionCurrency,
               Value_Inc_Tax,
               CreditCurrency,
               CreditLimit,
               CreditLimitLeft,
               CreditLimitUsed,
               @Semantics.amount.currencyCode: 'CreditCurrency'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CDS_ZEXTCPURORDFPT'
  virtual      SpecialLiabilities : abap.curr( 23, 2 ),
               @Semantics.amount.currencyCode: 'CreditCurrency'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CDS_ZEXTCPURORDFPT'
  virtual      CreditExposure     : abap.curr( 23, 2 ),
               @Semantics.amount.currencyCode: 'CreditCurrency'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CDS_ZEXTCPURORDFPT'
  virtual      TotalReceivables   : abap.curr( 23, 2 ),
               @Semantics.amount.currencyCode: 'CreditCurrency'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CDS_ZEXTCPURORDFPT'
  virtual      OpenOrders         : abap.curr( 23, 2 ),
               @Semantics.amount.currencyCode: 'CreditCurrency'
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CDS_ZEXTCPURORDFPT'
  virtual      OpenDelivery       : abap.curr( 23, 2 ),
               @Consumption.filter.selectionType: #SINGLE
               @Consumption.valueHelpDefinition: [{
                  entity: { name:'ZI_SalesDocumentRjcnReason_VH',
                            element : 'SalesDocumentRjcnReason' }
                }]
               RejectReason,
               Percent,
               _SalesOrderType,
               _OverallSDDocumentRejectionSts,
               @Semantics.text:true
               _SalesOrderType._Text.SalesDocumentTypeName                         as SalesDocumentTypeName          : localized,
               _SalesOrganization._Text.SalesOrganizationName                      as SalesOrganizationName          : localized,
               _DistributionChannel._Text.DistributionChannelName                  as DistributionChannelName        : localized,
               _OrganizationDivision._Text.DivisionName                            as DivisionName                   : localized,
               _SalesOffice._Text.SalesOfficeName                                  as SalesOfficeName                : localized,
               _SalesGroup._Text.SalesGroupName                                    as SalesGroupName                 : localized,
               _OverallSDDocumentRejectionSts._Text.OvrlSDDocumentRejectionStsDesc as OvrlSDDocumentRejectionStsDesc : localized,
               _OverallDeliveryStatus._Text.OverallDeliveryStatusDesc              as OverallDeliveryStatusDesc      : localized,
               _TotalCreditCheckStatus._Text.TotalCreditCheckStatusDesc            as TotalCreditCheckStatusDesc     : localized,
               _CreditRiskClass._Text.CreditRiskClassName                          as CreditRiskClassName            : localized

}
