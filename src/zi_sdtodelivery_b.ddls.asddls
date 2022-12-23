/************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZI_SDTODELIVERY_B
*  Type            : CDS VIEW
*  Description     : SUM CREDIT EXPOSURE ITEM OF DELIVERY DOC
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.24 THUANDC3          INITIAL RELEASE
************************************************************************/
@AbapCatalog.sqlViewName: 'ZV_SDDELIVERY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum Credit Exposure Item of Delivery Doc'
define view ZI_SDTODELIVERY_B
  as select from I_SalesDocument                as _SDDocument

    inner join   I_SDDocumentMultiLevelProcFlow as _SDDocumentProcFlow on  _SDDocumentProcFlow.PrecedingDocument          = _SDDocument.SalesDocument
                                                                       and _SDDocumentProcFlow.PrecedingDocumentCategory  = 'C'
                                                                       and _SDDocumentProcFlow.SubsequentDocumentCategory = 'J'

    inner join   ZI_CREDITEXPOSUREITEMSO        as _CreditExposureItem on _CreditExposureItem.docno = _SDDocumentProcFlow.SubsequentDocument
{

  _SDDocument.SalesDocument                                               as SalesDocument,
  cast( sum( _CreditExposureItem.ExposureAmount ) as abap.curr( 23, 2 ) ) as ExposureAmount

}
group by
  _SDDocument.SalesDocument
