REPORT ZFOR_ALL2 NO STANDARD PAGE HEADING.

include ZFOR_TOP.
include ZFOR_FORM.

START-OF-SELECTION.
PERFORM GET.
PERFORM COMBINED.
PERFORM DISPLAY.


*&---------------------------------------------------------------------*
*&  Include           ZFOR_TOP
*&---------------------------------------------------------------------*
TABLES: ZEMPP1,ZEMPP2.

SELECTION-SCREEN: BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-000.
   SELECT-OPTIONS: N_EMPID FOR ZEMPP1-EMP_ID.
SELECTION-SCREEN: END OF BLOCK B2.

TYPES : BEGIN OF TY_STR1, " DEFINE STRUCTURE 1
         EMP_ID TYPE ZEMPID_01,
         EMP_NAME TYPE ZNAME_01,
        END OF TY_STR1.


TYPES : BEGIN OF TY_STR2,
          EMP_ID TYPE ZEMPID_01,
          EMP_ADDRESS TYPE ZEMP_ADDRESS,
          EMP_DEPT TYPE ZEMP_DEPT,
          EMP_MOBILE TYPE ZEMP_MOBILE,
        END OF TY_STR2.

TYPES : BEGIN OF TY_STR3,
          EMP_ID TYPE ZEMPID_01,
          EMP_NAME TYPE ZNAME_01,                      "DEFINE STRUCTURE 3
          EMP_ADDRESS TYPE ZEMP_ADDRESS,
          EMP_DEPT TYPE ZEMP_DEPT,
          EMP_MOBILE TYPE ZEMP_MOBILE,
        END OF TY_STR3.


DATA: IT1 TYPE TABLE OF TY_STR1, "INITIALIZATION OF IT
      IT2 TYPE TABLE OF TY_STR2,
      IT3 TYPE TABLE OF TY_STR3.

DATA: WA1 TYPE TY_STR1, "INITIALIZATION OF WA
      WA2 TYPE      TY_STR2,
      WA3 TYPE      TY_STR3.


*&---------------------------------------------------------------------*
*&  Include           ZFOR_FORM
*&---------------------------------------------------------------------*
FORM GET.
  SELECT EMP_ID EMP_NAME                           "SELECT QUERY FOR TABLE ZEMPP1(1ST TABLE)
    FROM ZEMPP1 INTO TABLE IT1
    WHERE EMP_ID IN N_EMPID.



  IF IT1[] IS NOT INITIAL.                       "IF ITS CHECKS  EKKO(2ND TABLE) TABLE IS EMPTY OR NOT, IF NOT  EMPTY THEN IT GOES INTO TABLE
    SELECT EMP_ID EMP_ADDRESS EMP_DEPT EMP_MOBILE                    "SELECT QUERY FOR ZEMPP2(2ND TABLE)
      FROM ZEMPP2 INTO TABLE IT2
      FOR ALL ENTRIES IN IT1
      WHERE EMP_ID = IT1-EMP_ID.                      "ZEMPP1 FOR ZEMPP2,   AND IT1-EMP_ID FOR ZEMPP1
  ENDIF.

ENDFORM.

FORM COMBINED.
  LOOP AT IT1 INTO WA1.
  MOVE:WA1-EMP_ID TO WA3-EMP_ID,
       WA1-EMP_NAME  TO WA3-EMP_NAME .

      LOOP AT IT2 INTO WA2 WHERE EMP_ID = WA1-EMP_ID.
          WA3-EMP_ADDRESS =  WA2-EMP_ADDRESS.
          WA3-EMP_DEPT = WA2-EMP_DEPT.                  "WHEN WE GIVE (=) RIGHT TO LEFTT
          WA3-EMP_MOBILE = WA2-EMP_MOBILE.
          APPEND WA3 TO IT3.
      ENDLOOP.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY.


  WRITE:/ 'EMP_ID' COLOR 3,
      20 'EMP_NAME' COLOR 4,
      40 'EMP_ADDRESS' COLOR 5,
      60 'EMP_DEPT' COLOR 6,
      80 'EMP_MOBILE' COLOR 4.


  LOOP AT IT3 INTO WA3.
  WRITE:/ WA3-EMP_ID,
          20 WA3-EMP_NAME,
          40 WA3-EMP_ADDRESS,
          60 WA3-EMP_DEPT,
          80 WA3-EMP_MOBILE.
  ENDLOOP.
ENDFORM.
