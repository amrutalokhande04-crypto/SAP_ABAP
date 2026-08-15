"REQUEIMENT 1 CLASSICAL REPORT ON TABLE MATNR , MAKT,MSEG
REPORT ZCLASSICAL_A NO STANDARD PAGE HEADING.
include ZC_TOP1.
include ZC_FORM1.

INITIALIZATION. "INITIALIZE FIELDS
PERFORM INIT.

AT SELECTION-SCREEN ON N_WERKS. "
  PERFORM VAL.

START-OF-SELECTION. "EXTRACTING DATA FROM DATABASE.
  PERFORM GETDATA.
END-OF-SELECTION.

PERFORM DISS.

TOP-OF-PAGE.
WRITE:/70 '****** CLAASICAL REPORT *****' .
ULINE.

END-OF-PAGE.


*&---------------------------------------------------------------------*
*&  Include           ZC_TOP1
*&---------------------------------------------------------------------*

TABLES: MARA, MAKT, MSEG.

SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS: N_MATNR FOR MARA-MATNR,
                N_MATKL FOR MARA-MATKL,
                N_ERSDA FOR MARA-ERSDA,
                N_WERKS FOR MSEG-WERKS,
                N_LGORT FOR MSEG-LGORT.
SELECTION-SCREEN: END OF BLOCK B1.
TYPES:BEGIN OF TY_STR1,
      MATNR TYPE MATNR,
      END OF TY_STR1,

      BEGIN OF TY_STR2,
      MATNR TYPE MATNR,
      MAKTX TYPE MAKTX,
      END OF TY_STR2,

      BEGIN OF TY_STR3,
      MATNR TYPE MATNR,
      WERKS TYPE WERKS_D,
      LGORT TYPE LGORT_D,
      MENGE TYPE MENGE_D,
      MEINS TYPE MEINS,
      DMBTR TYPE DMBTR,
      END OF TY_STR3,

     BEGIN OF TY_STR4,
      WERKS TYPE WERKS_D,
      LGORT TYPE LGORT_D,
      MATNR TYPE MATNR,
      MAKTX TYPE MAKTX,
      MENGE TYPE MENGE_D,
      MEINS TYPE MEINS,
      DMBTR TYPE DMBTR,
      END OF TY_STR4.

DATA: IT1 TYPE TABLE OF TY_STR1,
      IT2 TYPE TABLE OF TY_STR2,
      IT3 TYPE TABLE OF TY_STR3,
      IT4 TYPE TABLE OF TY_STR4,

      WA1 TYPE          TY_STR1,
      WA2 TYPE          TY_STR2,
      WA3 TYPE          TY_STR3,
      WA4 TYPE          TY_STR4.

*&---------------------------------------------------------------------*
*&      Form  INIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM INIT .
    N_WERKS-SIGN = 'I'.
    N_WERKS-OPTION = 'BT'.
    N_WERKS-LOW = 1000.
    N_WERKS-HIGH = 3000.
    APPEND N_WERKS.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM VAL .
   IF N_WERKS-LOW < 1000 OR  N_WERKS-HIGH > 3000.
  MESSAGE TEXT-000 TYPE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GETDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GETDATA .
  SELECT MATNR
  FROM MARA INTO TABLE IT1 UP TO 20 ROWS
  WHERE MATNR IN N_MATNR.

 IF IT1[] IS NOT INITIAL.
    SELECT MATNR MAKTX
     FROM MAKT INTO TABLE IT2 UP TO 20 ROWS
     FOR ALL ENTRIES IN IT1
     WHERE MATNR = IT1-MATNR.
 ENDIF.

 IF IT1[] IS NOT  INITIAL.
 SELECT MATNR WERKS LGORT MENGE MEINS DMBTR
   FROM MSEG INTO TABLE IT3 UP TO 20 ROWS
   FOR ALL ENTRIES IN IT1
   WHERE MATNR = IT1-MATNR.
 ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISS .
  LOOP AT IT1 INTO WA1.
  LOOP AT IT3 INTO WA3 WHERE MATNR = WA1-MATNR.
   MOVE: WA3-MATNR TO WA4-MATNR,
        WA3-WERKS TO WA4-WERKS,
        WA3-LGORT TO WA4-LGORT,
        WA3-MENGE TO WA4-MENGE,
        WA3-MEINS TO WA4-MEINS,
        WA3-DMBTR TO WA4-DMBTR.

   READ TABLE IT2 INTO WA2 WITH KEY MATNR = WA1-MATNR.
              WA4-MAKTX  = WA2-MAKTX.
        APPEND WA4 TO IT4.
  ENDLOOP.
ENDLOOP.
SORT IT4 BY MATNR.
LOOP AT IT4 INTO WA4.
AT FIRST.
 WRITE:/'Plant' COLOR 2,
          15 'S Location' COLOR 2,30 'Material No.' COLOR 2,50 'Description' COLOR 2,
          70 'Quantity' COLOR 2,110 'U O M' COLOR 2,
          115 'Net Price' COLOR 2.ULINE.
ENDAT.
AT NEW WERKS.
 WRITE:/ WA4-WERKS HOTSPOT.
 ENDAT.
 AT NEW LGORT.
   WRITE:/15 WA4-LGORT.
ENDAT.
   WRITE:/30  WA4-MATNR ,
          50  WA4-MAKTX ,
          75  WA4-MENGE ,
          110 WA4-MEINS ,
          115 WA4-DMBTR.
AT END OF MATNR.
  ULINE.
  SUM.
    WRITE:/'THE TOTAL OF MENGE IS',75  WA4-MENGE.
    WRITE:/'THE TOTAL OF DMBTR IS',115 WA4-DMBTR.
    ULINE.
ENDAT.
ENDLOOP.

ENDFORM.
