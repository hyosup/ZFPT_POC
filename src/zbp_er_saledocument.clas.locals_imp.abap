************************************************************************
*  Module(Sub)     : SD
*  Program Id      : ZSD09920
*  Program Name    : [SD]장기미결 오더 리스트
*  Object Name     : ZBP_ER_SALEDOCUMENT
*  Type            : CLASS
*  Description     : BEHAVIOR IMPLEMENTATION FOR ZER_SALEDOCUMENT
************************************************************************
*                        MODIFICATION LOG
*-----------------------------------------------------------------------
*  NO CSR/PROJECT NO    DATE     AUTHOR           DESCRIPTION
* --- -------------- ---------- -------- -------------------------------
*  01 [FPT_POC]      2022.11.22 THUANDC3          INITIAL RELEASE
************************************************************************
CLASS lhc_zer_saledocument  DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS:
      lc_price_date  TYPE bapiupdate VALUE 'X',
      lc_reason_rej  TYPE bapiupdate VALUE 'X',
      lc_updateflag  TYPE bapiupdate VALUE 'U',
      lc_messagetype TYPE bapi_mtype VALUE 'E',
      lc_wait        TYPE bapiwait   VALUE 'X'.

    TYPES: BEGIN OF ts_itemsaleorder,
             salesdocument     TYPE i_salesdocumentitem-salesdocument,
             salesdocumentitem TYPE i_salesdocumentitem-salesdocumentitem,
           END OF    ts_itemsaleorder.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zer_saledocument RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zer_saledocument RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zer_saledocument.

    METHODS reject FOR MODIFY
      IMPORTING it_keys FOR ACTION zer_saledocument~reject RESULT result.

    METHODS updatedate FOR MODIFY
      IMPORTING it_keys FOR ACTION zer_saledocument~updatedate RESULT result.

ENDCLASS.

CLASS lhc_zer_saledocument IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD reject.

    DATA: v_vbeln         TYPE vbap-vbeln,
          order_item_in   TYPE STANDARD TABLE OF  bapisditm,
          order_item_inx  TYPE STANDARD TABLE OF  bapisditmx,
          order_header_in TYPE bapisdh1,
          orderheaderinx  TYPE bapisdh1x,
          lt_return       TYPE STANDARD TABLE OF bapiret2,
          lt_itemsd       TYPE STANDARD TABLE OF ts_itemsaleorder.

*   Get item sale order
    SELECT salesdocument,
           salesdocumentitem
      FROM i_salesdocumentitem AS _item
      FOR ALL ENTRIES IN @it_keys
      WHERE salesdocument = @it_keys-salesorder
        INTO TABLE @lt_itemsd.

    LOOP AT it_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
      CLEAR: order_header_in, orderheaderinx, order_item_in, order_item_inx, lt_return.
*     Convert sales order number into internal format.
      v_vbeln = |{ <fs_keys>-salesorder ALPHA = IN WIDTH = 10 }|.

*     Setting new value for Reject Reason of Item Sales Order:
      LOOP AT lt_itemsd ASSIGNING FIELD-SYMBOL(<lf>) WHERE salesdocument = v_vbeln .

        APPEND INITIAL LINE TO order_item_in ASSIGNING FIELD-SYMBOL(<item_in>).
        <item_in>-itm_number = <lf>-salesdocumentitem.
        <item_in>-reason_rej = <fs_keys>-%param-reject_reason.

        APPEND INITIAL LINE TO order_item_inx ASSIGNING FIELD-SYMBOL(<item_inx>).
        <item_inx>-itm_number = <lf>-salesdocumentitem.
        <item_inx>-reason_rej = lc_reason_rej.
        <item_inx>-updateflag = lc_updateflag.

      ENDLOOP.

*     Setting new value for Price Date for Header of sale order
      order_header_in-price_date = <fs_keys>-%param-pricing_date.
      orderheaderinx-price_date = lc_price_date.
      orderheaderinx-updateflag = lc_updateflag.

*     Call bapi 'BAPI_SALESORDER_CHANGE' to change Price Date and Reason Reject
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        DESTINATION 'NONE'
        EXPORTING
          salesdocument    = v_vbeln
          order_header_in  = order_header_in
          order_header_inx = orderheaderinx
        TABLES
          order_item_in    = order_item_in
          order_item_inx   = order_item_inx
          return           = lt_return.

      IF line_exists( lt_return[ type = lc_messagetype ] ).
*       If not sucessfully changed.
        APPEND VALUE #( %tky =  <fs_keys>-%tky
                        %msg = new_message_with_text(
                           severity = if_abap_behv_message=>severity-error
                           text = |{ v_vbeln }|
                        ) ) TO reported-zer_saledocument .

      ELSE.
*       If sucessfully changed.
        APPEND VALUE #( %tky =  <fs_keys>-%tky
                   %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-success
                      text = |{ v_vbeln }|
                   ) ) TO reported-zer_saledocument .

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          DESTINATION 'NONE'
          EXPORTING
            wait = lc_wait.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD updatedate.
    DATA: v_vbeln         TYPE vbap-vbeln,
          orderheaderinx  TYPE bapisdh1x,
          order_header_in TYPE bapisdh1,
          lt_return       TYPE STANDARD TABLE OF bapiret2.

    LOOP AT it_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
      CLEAR: order_header_in, orderheaderinx, lt_return.
*     Convert sales order number into internal format.
      v_vbeln = |{ <fs_keys>-salesorder ALPHA = IN WIDTH = 10 }|.
      orderheaderinx-updateflag = lc_updateflag.
      orderheaderinx-price_date = lc_price_date.
      order_header_in-price_date = <fs_keys>-%param-pricing_date.

*     Call bapi 'BAPI_SALESORDER_CHANGE' to change Price Date
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        DESTINATION 'NONE'
        EXPORTING
          salesdocument    = v_vbeln
          order_header_in  = order_header_in
          order_header_inx = orderheaderinx
        TABLES
          return           = lt_return.

      IF line_exists( lt_return[ type = lc_messagetype ] ).
*       If not sucessfully changed.
        APPEND VALUE #( %tky =  <fs_keys>-%tky
                        %msg = new_message_with_text(
                           severity = if_abap_behv_message=>severity-error
                           text = |{ v_vbeln }|
                       ) ) TO reported-zer_saledocument .

      ELSE.
*       If sucessfully changed.
        APPEND VALUE #( %tky =  <fs_keys>-%tky
                   %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-success
                      text = |{ v_vbeln }|
                   ) ) TO reported-zer_saledocument .

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          DESTINATION 'NONE'
          EXPORTING
            wait = lc_wait.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lsc_zer_saledocument DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zer_saledocument IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
