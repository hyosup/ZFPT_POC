/************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZI_PARAM_CHANGE_DATA_SO
*  Type            : CDS VIEW
*  Description     : PARAM CHANGE DATA SALES DOCUMENT
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.22 THUANDC3          INITIAL RELEASE
************************************************************************/
@EndUserText.label: 'Param change data Sales Document'
define abstract entity ZI_PARAM_CHANGE_DATA_SO
{
  pricing_date  : abap.char( 8 );
  reject_reason : augru;
}
