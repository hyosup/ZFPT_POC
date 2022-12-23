************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZCL_CDS_ZEXTCPURORDFPT
*  Type            : CLASS
*  Description     : CALCULATE CREDIT EXPOSE
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.24 THUANDC3          INITIAL RELEASE
************************************************************************
CLASS zcl_cds_zextcpurordfpt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_cds_zextcpurordfpt IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_calculated_data TYPE STANDARD TABLE OF zep_saledocument.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

*   Get data Sum Credit Exposure Item of Delivery Document
    SELECT * FROM  zi_sdtodelivery_b
    FOR ALL ENTRIES IN @lt_calculated_data
    WHERE salesdocument = @lt_calculated_data-salesorder
    INTO TABLE @DATA(lt_opendelivery).

*   Get data Sum Credit Exposure Item of Billing Document
    SELECT * FROM  zi_sdtobilling_b
    FOR ALL ENTRIES IN @lt_calculated_data
    WHERE salesdocument = @lt_calculated_data-salesorder
    INTO TABLE @DATA(lt_totalreceivables).

*   Get data Sum Credit Exposure Item of Sales Document
    SELECT * FROM  zi_sdtosalesorder_b
    FOR ALL ENTRIES IN @lt_calculated_data
    WHERE salesdocument = @lt_calculated_data-salesorder
    INTO TABLE @DATA(lt_openorders).

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<ls_calculated_data>).
      <ls_calculated_data>-opendelivery = VALUE #( lt_opendelivery[ salesdocument = <ls_calculated_data>-salesorder ]-exposureamount DEFAULT 0 ).
      <ls_calculated_data>-totalreceivables = VALUE #( lt_totalreceivables[ salesdocument = <ls_calculated_data>-salesorder ]-exposureamount DEFAULT 0 ).
      <ls_calculated_data>-openorders = VALUE #( lt_openorders[ salesdocument = <ls_calculated_data>-salesorder ]-exposureamount DEFAULT 0 ).
      <ls_calculated_data>-specialliabilities = 0.
      <ls_calculated_data>-creditexposure = <ls_calculated_data>-opendelivery + <ls_calculated_data>-totalreceivables + <ls_calculated_data>-openorders.

    ENDLOOP.

    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
