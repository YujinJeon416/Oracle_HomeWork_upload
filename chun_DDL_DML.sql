--# DDL
​
-- 1.
CREATE TABLE TB_CATEGORY (
    "NAME" VARCHAR2(10),
    "USE_YN" CHAR(1) DEFAULT 1
);
​
--2.
CREATE TABLE TB_CLASS_TYPE (
    "NO" VARCHAR2(5) PRIMARY KEY,
    "NAME" VARCHAR2(10)
);
​
DROP TABLE TB_CLASS_TYPE;
​
--3.
ALTER TABLE TB_CATEGORY
ADD PRIMARY KEY ("NAME");
​
--4.
ALTER TABLE TB_CATEGORY
MODIFY "NAME" NOT NULL;
​
--5.
ALTER TABLE TB_CATEGORY
MODIFY "NAME" VARCHAR2(20);
​
ALTER TABLE TB_CLASS_TYPE
MODIFY ("NAME" VARCHAR2(20), "NO" VARCHAR2(10));
​
​
--6. 
ALTER TABLE TB_CATEGORY
RENAME COLUMN "NAME" TO CATEGORY_NAME;
​
ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN "NAME" TO CLASS_TYPE_NAME;
​
ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN "NO" TO CLASS_TYPE_NO;
​
--7.
SELECT TABLE_NAME,
           CONSTRAINT_NAME, 
           CONSTRAINT_TYPE,
           COLUMN_NAME
FROM USER_CONSTRAINTS
JOIN USER_CONS_COLUMNS 
USING (CONSTRAINT_NAME, TABLE_NAME)
WHERE TABLE_NAME = 'TB_CATEGORY'
OR TABLE_NAME = 'TB_CLASS_TYPE';
​
ALTER TABLE TB_CATEGORY
RENAME CONSTRAINTS SYS_C007583 TO PK_CATEGORY_NAME;
​
ALTER TABLE TB_CLASS_TYPE
RENAME CONSTRAINTS SYS_C007582 TO PK_CLASS_TYPE_NAME;
​
​
--8.
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT; 
​
--9.
ALTER TABLE TB_DEPARTMENT
ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY (CATEGORY)
        REFERENCES TB_CATEGORY (CATEGORY_NAME);
​
SELECT *
FROM USER_CONS_COLUMNS
JOIN USER_CONSTRAINTS USING (CONSTRAINT_NAME, TABLE_NAME)
WHERE TABLE_NAME = 'USER_CONS_COLUMNS';
​
​
--10.
CREATE OR REPLACE VIEW VW_학생일반정보
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
     FROM TB_STUDENT;
​
--11.
CREATE OR REPLACE VIEW VW_지도면담
AS SELECT STUDENT_NAME, DEPARTMENT_NAME, PROFESSOR_NAME
     FROM TB_STUDENT
     LEFT JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
     LEFT JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
     ORDER BY 2;
​
SELECT * FROM VW_지도면담;
​
-- 12. 
CREATE OR REPLACE VIEW VW_학과별학생수
AS SELECT DEPARTMENT_NAME, COUNT(*) "STUDENT_COUNT"
     FROM TB_STUDENT
     LEFT JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
     GROUP BY DEPARTMENT_NAME;
​
SELECT * FROM VW_학과별학생수;
​
-- 13.
CREATE OR REPLACE VIEW VW_학생일반정보
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
     FROM TB_STUDENT
     WITH CHECK OPTION;
     
UPDATE VW_학생일반정보
SET STUDENT_NAME = '김진호'
WHERE STUDENT_NO = 'A213046';
​
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO = 'A213046';
​
-- 14.
-- with read only 읽기전용 view생성하는 옵션
CREATE OR REPLACE VIEW VW_학생일반정보
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
     FROM TB_STUDENT
     WITH READ ONLY;
​
​
​
-- 15.최근 3년은 특정년도를 기술하지 않고, 년도값 추출후 rownum을 이용해 선택함.
--최근3년 2009, 2008, 2007
SELECT 년도
FROM (
    SELECT DISTINCT SUBSTR(TERM_NO, 1, 4) 년도
    FROM TB_GRADE
    ORDER BY 1 DESC
    )
WHERE ROWNUM <= 3;
​
​
SELECT *
FROM (
    SELECT CLASS_NO 과목번호, CLASS_NAME 과목이름, COUNT(STUDENT_NO) "누적수강생수(명)"
    FROM TB_CLASS 
        LEFT JOIN TB_GRADE  USING (CLASS_NO)
    WHERE SUBSTR(TERM_NO, 1, 4) IN (SELECT 년도
                                  FROM (SELECT DISTINCT SUBSTR(TERM_NO, 1, 4) 년도
                                            FROM TB_GRADE
                                            ORDER BY 1 DESC)
                                  WHERE ROWNUM <= 3)
    GROUP BY CLASS_NO, CLASS_NAME
    ORDER BY 3 DESC)
WHERE ROWNUM <= 3;
​
​
​
​
​
​
​
​
​
​
​
​
​
​
​
--# DML
​
​
--1.
INSERT INTO TB_CLASS_TYPE 
VALUES ('01', '전공필수');
INSERT INTO TB_CLASS_TYPE 
VALUES ('02', '전공선택');
INSERT INTO TB_CLASS_TYPE 
VALUES ('03', '교양필수');
INSERT INTO TB_CLASS_TYPE 
VALUES ('04', '교양선택');
INSERT INTO TB_CLASS_TYPE 
VALUES ('05', '논문지도');
COMMIT;
​
--SELECT * FROM TB_CLASS_TYPE;
​
​
--2.
​
CREATE TABLE TB_학생일반정보
AS
SELECT STUDENT_NO AS "학번",
         STUDENT_NAME AS "학생이름",
         STUDENT_ADDRESS AS "주소"
FROM   TB_STUDENT;
​
--SELECT * FROM TB_학생일반정보;
​
​
--3.
CREATE TABLE TB_국어국문학과
AS
SELECT STUDENT_NO AS "학번",
       STUDENT_NAME AS "학생이름",
         TO_CHAR(TO_DATE(SUBSTR(STUDENT_SSN, 1, 2), 'RR'), 'YYYY') AS "출생년도",
         PROFESSOR_NAME AS "교수이름"
FROM   TB_STUDENT A
JOIN   TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
JOIN   TB_DEPARTMENT B ON (A.DEPARTMENT_NO = B.DEPARTMENT_NO)
WHERE  DEPARTMENT_NAME = '국어국문학과';
​
--SELECT * FROM TB_국어국문학과;
​
--4.
UPDATE TB_DEPARTMENT
SET    CAPACITY = ROUND(CAPACITY * 1.1);
​
​
--5.
UPDATE TB_STUDENT
SET    STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21 '
WHERE  STUDENT_NO = 'A413042';
​
--6.
UPDATE TB_STUDENT
SET    STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);
​
--7.
​
UPDATE TB_GRADE
SET POINT = '3.5'
WHERE  STUDENT_NO IN (
                     SELECT STUDENT_NO
		     FROM   TB_STUDENT
		     WHERE  STUDENT_NAME = '김명훈'
		 )
AND    TERM_NO = '200501'
AND    CLASS_NO IN (
                   SELECT CLASS_NO
		   FROM   TB_CLASS
		   WHERE  CLASS_NAME = '피부생리학'
		 )
;
				
--8.
DELETE FROM TB_GRADE
WHERE STUDENT_NO IN (
                    SELECT STUDENT_NO
		    FROM   TB_STUDENT
		    WHERE ABSENCE_YN = 'Y') 
;
접기


