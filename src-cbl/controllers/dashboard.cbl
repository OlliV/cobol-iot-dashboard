

       identification division.
       program-id. dashboard.

       data division.
       working-storage section.

       01 the-vars.

          03  COW-vars OCCURS 99 times.
        
            05 COW-varname       pic x(99).
            05 COW-varvalue      pic x(99).    

       01 STR PIC X(256).
       01 RETVAL PIC S9(9) BINARY.
       01 REDIS-ERR PIC 9(9).

       linkage section.

       01 the-values.

          05 COW-query-values           occurs 10 times.
            10 COW-query-value-name     pic x(90).
            10 COW-query-value          pic x(90).


       procedure division using the-values.
           MOVE -1 TO REDIS-ERR

           CALL "redis_connect" RETURNING RETVAL.
           IF RETVAL = REDIS-ERR THEN
               EXIT PROGRAM
           END-IF

           MOVE "GET counter" to STR
           CALL "redis_cmd_int"
               USING STR
               RETURNING RETVAL
           END-CALL

           MOVE "counter" to COW-varname(1).
           MOVE RETVAL to COW-varvalue(1).   

           CALL "redis_disco".

           call 'template' using the-vars "dashboard.cow".

      
       goback.

       end program dashboard.

