"REQUIREMENT DROPDOWN OF LFA1 ,EKKO, EKPO TABLES HIDDING SCREENS
REPORT ZINTERACTIVE_A NO STANDARD PAGE HEADING.

include ZA_TOP1.
include ZA_FORM1.

START-OF-SELECTION.

PERFORM GET.
PERFORM DIS.

TOP-OF-PAGE.
WRITE:/60 ' MAIN LFA1 TABLE' COLOR 4.
ULINE.

*&---------------------------------------------------------------------*
*&  Include           ZA_TOP1
*&---------------------------------------------------------------------*


TABLES: LFA1,EKKO,EKPO.

SELECTION-SCREEN: BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-009.
  SELECT-OPTIONS: N_LIFNR FOR LFA1-LIFNR,
                  N_AEDAT FOR EKKO-AEDAT.
SELECTION-SCREEN: END OF BLOCK B5.


TYPES:BEGIN OF TY_STR1,
      LIFNR TYPE LIFNR,
      NAME1 TYPE NAME1_GP,
      ORT01 TYPE ORT01_GP,
      PSTLZ TYPE PSTLZ,
      STRAS TYPE STRAS_GP,
      END OF TY_STR1,

      BEGIN OF TY_STR2,
      EBELN TYPE EBELN,
      AEDAT TYPE ERDAT,
      ZTERM TYPE DZTERM,
      LIFNR TYPE ELIFN,
      END OF TY_STR2,

      BEGIN OF TY_STR3,
      EBELP TYPE EBELP,
      MATNR TYPE MATNR,
      MENGE TYPE BSTMG,
      MEINS TYPE BSTME,
      NETPR TYPE BPREI,
      EBELN TYPE EBELN,
      END OF TY_STR3.

DATA: IT1 TYPE TABLE OF TY_STR1,
      IT2 TYPE TABLE OF TY_STR2,
      IT3 TYPE TABLE OF TY_STR3,


      WA1 TYPE TY_STR1,
      WA2 TYPE TY_STR2,
      WA3 TYPE TY_STR3.
*&---------------------------------------------------------------------*
*&      Form  GET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET .

  SELECT LIFNR NAME1 ORT01 PSTLZ STRAS
    FROM LFA1 INTO TABLE IT1 UP TO 20 ROWS
    WHERE LIFNR IN N_LIFNR.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DIS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DIS .

  WRITE:/ 'LIFNR' COLOR 3,
         10 'NAME1' COLOR 3,
         40 'ORT01' COLOR 3,
         60 'PSTLZ' COLOR 3 ,
         80 'STRAS' COLOR 3.
  ULINE.
    LOOP AT IT1 INTO WA1.
     WRITE:/ WA1-LIFNR HOTSPOT,
            10 WA1-NAME1,
            40 WA1-ORT01 ,
            60 WA1-PSTLZ ,
            75 WA1-STRAS.
     HIDE WA1-LIFNR.
    ENDLOOP.
ENDFORM.

AT LINE-SELECTION.
  CASE SY-LSIND.
    WHEN 1.
      SELECT EBELN AEDAT ZTERM LIFNR
      FROM EKKO INTO TABLE IT2 UP TO 20 ROWS
      WHERE LIFNR = WA1-LIFNR.


      WRITE:/  'EBELN' COLOR 3,
                  20 'AEDAT' COLOR 3,
                  40 'ZTERM' COLOR 3,
                  60 'LIFNR'COLOR 3.
      ULINE.

      LOOP AT IT2 INTO WA2.
        WRITE:/ WA2-EBELN HOTSPOT,
                 20 WA2-AEDAT ,
                 40 WA2-ZTERM ,
                 60 WA2-LIFNR.
      HIDE WA2-EBELN.
      ENDLOOP.

    WHEN 2.
      SELECT EBELP MATNR MENGE MEINS NETPR EBELN
        FROM EKPO INTO TABLE IT3 UP TO 20 ROWS
        WHERE EBELN = WA2-EBELN.

        WRITE:/ 'EBELP',
          20  'MATNR',
         40 'MENGE',
         60 'MEINS',
         85 'NETPR' ,
         100 'EBELN'.
        ULINE.

        LOOP AT IT2 INTO WA2.
          WRITE:/ WA3-EBELP,
          20 WA3-MATNR HOTSPOT ,
          40 WA3-MENGE,
          60 WA3-MEINS,
          85 WA3-NETPR,
          100 WA3-EBELN.

        HIDE WA3-MATNR.
        ENDLOOP.

    WHEN 3.
      CALL TRANSACTION 'SE11' AND SKIP FIRST SCREEN.
    ENDCASE.

    TOP-OF-PAGE DURING LINE-SELECTION.
    CASE SY-LSIND.
      WHEN 1.
        WRITE:/70 'EKKO TABLE' COLOR 5.
        ULINE.

      WHEN 2.
       WRITE:/70 'EKPO TABLE' COLOR 5.
        ULINE.
    ENDCASE.
