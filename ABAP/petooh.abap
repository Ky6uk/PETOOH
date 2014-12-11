CONSTANTS:
  lc_inc      TYPE string VALUE 'Ko',
  lc_dec      TYPE string VALUE 'kO',
  lc_incptr   TYPE string VALUE 'Kudah',
  lc_decptr   TYPE string VALUE 'kudah',
  lc_out      TYPE string VALUE 'Kukarek',
  lc_jmp      TYPE string VALUE 'Kud',
  lc_ret      TYPE string VALUE 'kud',
  lc_inc_x    TYPE string VALUE '+',
  lc_dec_x    TYPE c      VALUE '-',
  lc_incptr_x TYPE c      VALUE '>',
  lc_decptr_x TYPE c      VALUE '<',
  lc_out_x    TYPE c      VALUE 'O',
  lc_jmp_x    TYPE c      VALUE 'J',
  lc_ret_x    TYPE c      VALUE 'R',
  lc_mask     TYPE string VALUE '[^adehkKoOru]+',
  lc_mxmemory TYPE p      VALUE 65535
  .

TYPES:
  BEGIN OF  lty_file,
    line  TYPE c LENGTH 65535,
  END OF    lty_file,

  BEGIN OF  lty_memory,
    cell  TYPE i,
  END OF    lty_memory,

  BEGIN OF  lty_stack,
    cell  TYPE string,
  END OF    lty_stack
  .

DATA:
  lt_file         TYPE filetable,
  ls_file         TYPE LINE OF filetable,
  lv_rc           TYPE i,
  lt_file_raw     TYPE STANDARD TABLE OF lty_file,
  ls_file_raw     TYPE lty_file,
  lv_source_prep  TYPE c LENGTH 65535,
  lv_buffer_str   TYPE string,
  lv_buffer_char  TYPE sychar02,
  lv_length       TYPE i,
  lv_length_stack TYPE i,
  lv_index        TYPE i,
  lv_level        TYPE i VALUE 1,
  lv_pointer      TYPE i VALUE 1,
  lt_memory       TYPE STANDARD TABLE OF lty_memory,
  lt_stack        TYPE STANDARD TABLE OF lty_stack
  .

FIELD-SYMBOLS:
  <ls_file_raw> TYPE lty_file,
  <ls_memory>   TYPE lty_memory,
  <ls_stack>    TYPE lty_stack
  .

CALL METHOD cl_gui_frontend_services=>file_open_dialog
  EXPORTING
    window_title   = 'Select PETOOH source sile'
    file_filter    = 'PETOOH source (*.koko)|*.koko|Any file (*.*)|*.*'
    multiselection = abap_false
  CHANGING
    file_table     = lt_file
    rc             = lv_rc
  EXCEPTIONS
    OTHERS         = 1.
IF sy-subrc <> 0.
  RETURN.
ENDIF.

READ TABLE lt_file INTO ls_file INDEX 1.
lv_buffer_str = ls_file-filename.


CALL METHOD cl_gui_frontend_services=>gui_upload
  EXPORTING
    filename = lv_buffer_str
  CHANGING
    data_tab = lt_file_raw
  EXCEPTIONS
    OTHERS   = 1.
IF sy-subrc <> 0.
  RETURN.
ENDIF.

*memory and command stack initialising
DO lc_mxmemory TIMES.
  APPEND INITIAL LINE TO lt_memory.
  APPEND INITIAL LINE TO lt_stack.
ENDDO.


READ TABLE lt_file_raw INTO ls_file_raw INDEX 1.

LOOP AT lt_file_raw ASSIGNING <ls_file_raw>.
  REPLACE ALL OCCURRENCES OF REGEX lc_mask    IN <ls_file_raw>-line WITH space.
  REPLACE ALL OCCURRENCES OF REGEX lc_inc     IN <ls_file_raw>-line WITH lc_inc_x.
  REPLACE ALL OCCURRENCES OF REGEX lc_dec     IN <ls_file_raw>-line WITH lc_dec_x.
  REPLACE ALL OCCURRENCES OF REGEX lc_incptr  IN <ls_file_raw>-line WITH lc_incptr_x.
  REPLACE ALL OCCURRENCES OF REGEX lc_decptr  IN <ls_file_raw>-line WITH lc_decptr_x.
  REPLACE ALL OCCURRENCES OF REGEX lc_out     IN <ls_file_raw>-line WITH lc_out_x.
  REPLACE ALL OCCURRENCES OF REGEX lc_jmp     IN <ls_file_raw>-line WITH lc_jmp_x.
  REPLACE ALL OCCURRENCES OF REGEX lc_ret     IN <ls_file_raw>-line WITH lc_ret_x.
  CONCATENATE lv_source_prep <ls_file_raw>-line INTO lv_source_prep.
ENDLOOP.

*lv_index  = 0.
lv_length = STRLEN( lv_source_prep ).

*main loop
DO lv_length TIMES.

  lv_index = sy-index - 1.


  CASE lv_source_prep+lv_index(1).
    WHEN lc_inc_x.
      IF lv_level > 1.
        READ TABLE lt_stack ASSIGNING <ls_stack> INDEX lv_level.
        IF sy-subrc <> 0.
          MESSAGE 'Segmentation fault' TYPE 'E'.
        ENDIF.
        CONCATENATE <ls_stack>-cell lc_inc_x INTO <ls_stack>-cell.
      ELSE.
        READ TABLE lt_memory ASSIGNING <ls_memory> INDEX lv_pointer.
        IF sy-subrc <> 0.
          MESSAGE 'Segmentation fault' TYPE 'E'.
        ENDIF.
        ADD 1 TO <ls_memory>-cell.
      ENDIF.

    WHEN lc_dec_x.
      IF lv_level > 1.
        READ TABLE lt_stack ASSIGNING <ls_stack> INDEX lv_level.
        IF sy-subrc <> 0.
          MESSAGE 'Segmentation fault' TYPE 'E'.
        ENDIF.
        CONCATENATE <ls_stack>-cell lc_dec_x INTO <ls_stack>-cell.
      ELSE.
        READ TABLE lt_memory ASSIGNING <ls_memory> INDEX lv_pointer.
        IF sy-subrc <> 0.
          MESSAGE 'Segmentation fault' TYPE 'E'.
        ENDIF.
        SUBTRACT 1 FROM <ls_memory>-cell.
      ENDIF.

    WHEN lc_incptr_x.
      IF lv_level > 1.
        READ TABLE lt_stack ASSIGNING <ls_stack> INDEX lv_level.
        IF sy-subrc <> 0.
          MESSAGE 'Segmentation fault' TYPE 'E'.
        ENDIF.
        CONCATENATE <ls_stack>-cell lc_incptr_x INTO <ls_stack>-cell.
      ELSE.
        ADD 1 TO lv_pointer.
      ENDIF.

    WHEN lc_decptr_x.
      IF lv_level > 1.
        READ TABLE lt_stack ASSIGNING <ls_stack> INDEX lv_level.
        IF sy-subrc <> 0.
          MESSAGE 'Segmentation fault' TYPE 'E'.
        ENDIF.
        CONCATENATE <ls_stack>-cell lc_decptr_x INTO <ls_stack>-cell.
      ELSE.
        SUBTRACT 1 FROM lv_pointer.
      ENDIF.

    WHEN lc_jmp_x.
      ADD 1 TO lv_level.
      READ TABLE lt_stack ASSIGNING <ls_stack> INDEX lv_level.
      IF sy-subrc <> 0.
        MESSAGE 'Segmentation fault' TYPE 'E'.
      ENDIF.

      CLEAR <ls_stack>-cell.

    WHEN lc_ret_x.
      READ TABLE lt_stack ASSIGNING <ls_stack> INDEX lv_level.
      IF sy-subrc <> 0.
        MESSAGE 'Segmentation fault' TYPE 'E'.
      ENDIF.
      lv_length_stack = STRLEN( <ls_stack>-cell ).
      DO.

        READ TABLE lt_memory ASSIGNING <ls_memory> INDEX lv_pointer.
        IF sy-subrc <> 0.
          MESSAGE 'Segmentation fault' TYPE 'E'.
        ENDIF.
        IF <ls_memory>-cell <= 0.
          EXIT.
        ENDIF.

        DO lv_length_stack TIMES.

          READ TABLE lt_memory ASSIGNING <ls_memory> INDEX lv_pointer.
          IF sy-subrc <> 0.
            MESSAGE 'Segmentation fault' TYPE 'E'.
          ENDIF.

          lv_index = sy-index - 1.

          CASE <ls_stack>-cell+lv_index(1).
            WHEN lc_inc_x.
              ADD 1 TO <ls_memory>-cell.
            WHEN lc_dec_x.
              SUBTRACT 1 FROM <ls_memory>-cell.
            WHEN lc_incptr_x.
              ADD 1 TO lv_pointer.
            WHEN lc_decptr_x.
              SUBTRACT 1 FROM lv_pointer.
            WHEN lc_out_x.
              TRY.
                  CALL METHOD cl_abap_conv_in_ce=>uccpi
                    EXPORTING
                      uccp = <ls_memory>-cell
                    RECEIVING
                      char = lv_buffer_char.
                CATCH cx_parameter_invalid_range .
                  MESSAGE 'Error while converting number to character' TYPE 'E'.
              ENDTRY.
              WRITE lv_buffer_char+0(1) NO-GAP.
          ENDCASE.

        ENDDO.

      ENDDO.

      SUBTRACT 1 FROM lv_level.

    WHEN lc_out_x.
      IF lv_level > 1.
        READ TABLE lt_stack ASSIGNING <ls_stack> INDEX lv_level.
        IF sy-subrc <> 0.
          MESSAGE 'Segmentation fault' TYPE 'E'.
        ENDIF.
        CONCATENATE <ls_stack>-cell lc_out_x INTO <ls_stack>-cell.
      ELSE.

        READ TABLE lt_memory ASSIGNING <ls_memory> INDEX lv_pointer.
        IF sy-subrc <> 0.
          MESSAGE 'Segmentation fault' TYPE 'E'.
        ENDIF.

        TRY.
            CALL METHOD cl_abap_conv_in_ce=>uccpi
              EXPORTING
                uccp = <ls_memory>-cell
              RECEIVING
                char = lv_buffer_char.
          CATCH cx_parameter_invalid_range .
            MESSAGE 'Error while converting number to character' TYPE 'E'.
        ENDTRY.

        WRITE lv_buffer_char+0(1) NO-GAP.

      ENDIF.

  ENDCASE.

ENDDO.
