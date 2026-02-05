6a.

BEGIN TRANSACTION;

INSERT INTO INVOICE (INV_NUMBER,CUS_CODE,INV_DATE,INV_TOTAL,INV_TERMS,INV_STATUS)
VALUES (10983,10010,'2018-05-11',118.80, '30','OPEN');
INSERT INTO LINE (INV_NUMBER,LINE_NUMBER, P_CODE,LINE_UNITS, LINE_PRICE)
VALUES (10983, 1, '11QER/31', 1,110.00);
UPDATE PRODUCT
SET P_QTYOH = P_QTYOH-1
WHERE P_CODE='11QER/31';
UPDATE CUSTOMER
SET CUS_BALANCE=CUS_BALANCE + 118.80,
    CUS_DATESTPUR='2018-05-11'
WHERE CUS_CODE=10010;

COMMIT;




6b.

BEGIN TRANSACTION;

INSERT INTO PAYMENTS (PMT_ID,PMT_DATE,CUS_CODE,PMT_AMT,PMT_TYPE,PMT_DETAILS)
VALUES (3428, '2018-06-03',10010,100.00,'CASH','Cash payment');
UPDATE CUSTOMER
SET CUS_BALANCE = CUS_BALANCE-100.00,
    CUS_DATESTLPMT = '2018-06-03'
WHERE CUS_CODE=10010;

COMMIT;




7.

STEP,ACTION,TABLE   ,ATTRIBUTE     ,BEFORE VALUE,AFTER VALUE
1   ,INSERT,INVOICE ,INV_NUMBER    ,(null)      ,10983
2   ,INSERT,LINE    ,INV_NUMBER    ,(null)      ,10983
3   ,UPDATE,PRODUCT ,P_QTYOH       ,Current Qty ,Current Qty - 1
4   ,UPDATE,CUSTOMER,CUS_BALANCE   ,Current Bal ,Current Bal + 118.80
5   ,UPDATE,CUSTOMER,CUS_DATESTPUR ,Old Date    ,2018-05-11
6   ,COMMIT,        ,              ,            ,
7   ,INSERT,PAYMENTS,PMT_ID        ,(null)      ,3428
8   ,UPDATE,CUSTOMER,CUS_BALANCE   ,New Bal     ,New Bal - 100.00
9   ,UPDATE,CUSTOMER,CUS_DATESTLPMT,Old Date    ,2018-06-03
10  ,COMMIT,        ,              ,            ,




8.
1. Lock INVOICE. T1 requests and is granted an Exclusive Lock (X) on the INVOICE table/row
2. Write INVOICE. T1 inserts the record for Invoice #10983
3. Release INVOICE. T1 releases the lock immediately after the insert. (This is where 2PL would normally hold the lock until the end)
4. Lock LINE. T1 request and is granted an exclusive lock (X) on the LINE table
5. Write LINE. T1 inserts the line item for product '11QER/31' (1 unit at 110.00$)
6. Release LINE. T1 releases the lock immediately
7. Lock PRODUCT. T1 requests and is granted an Exclusive Lock (X) on the PRODUCT row for '11QER/31'
8. Read/Write PRODUCT, T1 reads the current P_QTYOH, subtracts 1, and updates the value
9. Release PRODUCT, T1 releases the lock immediately.
10. Lock CUSTOMER, T1 requests and is granted an Exclusive Lock (X) on the CUSTOMER row for 10010
11. Read/Write CUSTOMER, T1 reads CUS_BALANCE, adds the $118.80 total, and updates CUS_DATESTPUR to May 11, 2018
12. Release CUSTOMER. T1 releases the lock
13. COMMIT. T1 finishes and makes all changes permanent