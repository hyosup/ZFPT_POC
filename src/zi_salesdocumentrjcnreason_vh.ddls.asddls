/************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZI_SALESDOCUMENTRJCNREASON_VH
*  Type            : CDS VIEW
*  Description     : SALES DOCUMENT REJECT REASON VALUE HELP
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.22 THUANDC3          INITIAL RELEASE
************************************************************************/
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.representativeKey: 'SalesDocumentRjcnReason'
@EndUserText.label: 'Sales Document Rejection Reason'
@AccessControl.authorizationCheck:#NOT_REQUIRED
@AbapCatalog.sqlViewName: 'ZISDSLSDOCRJNRSN'
@Search.searchable: false
@ObjectModel.resultSet.sizeCategory: #XS
define view ZI_SalesDocumentRjcnReason_VH as select from I_SalesDocumentRjcnReasonText {
   @ObjectModel.text.element: ['SalesDocumentRjcnReasonName']
    key SalesDocumentRjcnReason,
    SalesDocumentRjcnReasonName
} where Language = $session.system_language
