CLASS zcl_security_cc_problem_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    "Uses Data Model - https://github.com/SAP-samples/abap-platform-refscen-flight
  PROTECTED SECTION.
  PRIVATE SECTION.
    "Simulate Input Parameters via a constant to keep example UI/Service/Interface agnostic
    CONSTANTS: dbTable TYPE string VALUE '/DMO/FLIGHT'.

    METHODS select_table_content
      IMPORTING i_tablename     TYPE string
      RETURNING VALUE(r_result) TYPE REF TO data
      RAISING   cx_abap_not_a_table
                cx_abap_not_in_package.

ENDCLASS.



CLASS zcl_security_cc_problem_3 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    FIELD-SYMBOLS <results> TYPE STANDARD TABLE.

    TRY.
        DATA(content) = select_table_content( dbtable ).
        ASSIGN content->* TO <results>.
        out->write( |Data for table: { dbTable }| ).
        out->write( <results> ).

      CATCH cx_abap_not_a_table
            cx_abap_not_in_package INTO DATA(lcx).
        out->write( lcx->get_text( ) ).
    ENDTRY.

  ENDMETHOD.

  METHOD select_table_content.

    DATA dref TYPE REF TO data.
    FIELD-SYMBOLS <results> TYPE STANDARD TABLE.

    cl_abap_dyn_prg=>check_table_or_view_name_str(
      EXPORTING
        val               = i_tablename
        packages          = '/DMO/FLIGHT_LEGACY'
    ).

    CREATE DATA dref TYPE STANDARD TABLE OF (dbTable)
                     WITH EMPTY KEY.
    ASSIGN dref->* TO <results>.

    "Do you really want every table to be accessible? Yet it needs to be dynamic and support all tables within your Package
    SELECT * FROM (dbTable) INTO TABLE @<results> UP TO 100 ROWS.
    r_result = dref.

  ENDMETHOD.

ENDCLASS.
