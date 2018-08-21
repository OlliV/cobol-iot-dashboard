

        IDENTIFICATION DIVISION.
        PROGRAM-ID. dashboard.

        DATA DIVISION.
        WORKING-STORAGE SECTION.

        01 the-vars.
            03 COW-vars                 OCCURS 99 TIMES.
                05 COW-varname          PIC X(99).
                05 COW-varvalue         PIC X(99).

        01 STR PIC X(256).

        01 RETVAL                       PIC S9(9) BINARY.
        01 OUTVAL                       PIC S9(9) COMP-5.

        01 REDIS-ERR                    PIC S9(9) VALUE -1.

        LINKAGE SECTION.

        01 the-values.
            05 COW-query-values         OCCURS 10 TIMES.
                10 COW-query-value-name PIC X(90).
                10 COW-query-value      PIC X(90).

        PROCEDURE DIVISION USING the-values.
            CALL "redis_connect" RETURNING RETVAL.
            IF RETVAL = REDIS-ERR THEN
                EXIT PROGRAM
            END-IF

            STRING "GET counter" INTO STR.
            CALL "redis_cmd_int" USING
                STR
                BY REFERENCE OUTVAL
                RETURNING RETVAL
            END-CALL
            IF RETVAL = REDIS-ERR THEN
                EXIT PROGRAM
            END-IF

            MOVE "counter" TO COW-varname(1).
            MOVE OUTVAL TO COW-varvalue(1).

            CALL "redis_disco".

            call 'template' USING the-vars "dashboard.cow".
       GOBACK.

       END PROGRAM dashboard.
