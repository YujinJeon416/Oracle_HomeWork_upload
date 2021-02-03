--@DQL종합실습문제
--문제1
--기술지원부에 속한 사람들의 사람의 이름,부서코드,급여를 출력하시오. 
SELECT EMP_NAME 이름
        ,DEPT_CODE 부서코드
        ,SALARY 급여
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.DEPT_TITLE ='기술지원부';
​
SELECT EMP_NAME 이름
        ,DEPT_CODE 부서코드
        ,SALARY 급여
FROM EMPLOYEE
WHERE DEPT_CODE=(SELECT DEPT_ID FROM DEPARTMENT WHERE DEPT_TITLE ='기술지원부');
​
​
--문제2
--기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름,부서코드,급여를 출력하시오
SELECT *
FROM (
SELECT EMP_NAME 이름
        ,DEPT_CODE 부서코드
        ,(SALARY+SALARY*NVL(BONUS,0))*12 급여
FROM EMPLOYEE
WHERE DEPT_CODE=(SELECT DEPT_ID FROM DEPARTMENT WHERE DEPT_TITLE ='기술지원부')
ORDER BY (SALARY+SALARY*NVL(BONUS,0))*12 DESC)
WHERE ROWNUM < 2; 
​
​
​
--문제3
--매니저가 있는 사원중에 월급이 전체사원 평균을 넘고 
--사번,이름,매니저 이름, 월급을 구하시오. 
--1. JOIN을 이용하시오
--2. JOIN하지 않고, 스칼라상관쿼리(SELECT)를 이용하기
​
--JOIN
SELECT A.EMP_ID 사번
        ,A.EMP_NAME 이름
        ,B.EMP_NAME 매니져이름
        ,A.SALARY월급
FROM EMPLOYEE A JOIN EMPLOYEE B
    ON A.MANAGER_ID = B.EMP_ID
WHERE A.MANAGER_ID IS NOT NULL
    AND A.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);
    
--스칼라서브쿼리(SELECT)
SELECT EMP_ID 사번
        ,EMP_NAME 이름
        ,(SELECT EMP_NAME FROM EMPLOYEE WHERE E.MANAGER_ID = EMP_ID) 매니져이름
        ,SALARY 월급
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL
    AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);
​
​
--문제4
--같은 직급의 평균급여보다 같거나 많은 급여를 받는 직원의 이름, 직급코드, 급여, 급여등급 조회
SELECT *
FROM EMPLOYEE E
WHERE SALARY >= (SELECT AVG(SALARY)
                  FROM EMPLOYEE 
                  WHERE E.JOB_CODE = JOB_CODE);
​
--문제5
--부서별 평균 급여가 3000000 이상인 부서명, 평균 급여 조회
--단, 평균 급여는 소수점 버림, 부서명이 없는 경우 '인턴'처리
​
SELECT NVL((SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID=EMPLOYEE.DEPT_CODE),'인턴') 부서명
        ,FLOOR(AVG(SALARY)) 평균급여
FROM EMPLOYEE GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;
​
SELECT NVL((SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID=EMPLOYEE.DEPT_CODE),'인턴') 부서명
        ,TRUNC(AVG(SALARY),0) 평균급여
FROM EMPLOYEE GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;
​
​
--문제6
--직급의 연봉 평균보다 적게 받는 여자사원의
--사원명,직급명,부서명,연봉을 이름 오름차순으로 조회하시오
--연봉 계산 => (급여+(급여*보너스))*12    
​
with my_emp
as
(select emp_name,
         nvl((select dept_title from department where dept_id = E.dept_code), '인턴') dept_title, 
         job_code,
         (select job_name from job where job_code = E.job_code) job_name,
         (salary+salary*nvl(bonus,0))*12 annual_salary,
         decode(substr(emp_no,8,1), '2','여','4','여','남') gender
from employee E)
select *
from my_emp E
where gender = '여' 
    and annual_salary < (select avg((salary+salary*nvl(bonus,0))*12) from employee where job_code = E.job_code)
order by emp_name;
​
​
​
--문제7
--다음 도서목록테이블을 생성하고, 공저인 도서만 출력하세요.
create table tbl_books (
book_title  varchar2(50)
,author     varchar2(50)
,loyalty     number(5)
);
​
insert into tbl_books values ('반지나라 해리포터', '박나라', 200);
insert into tbl_books values ('대화가 필요해', '선동일', 500);
insert into tbl_books values ('나무', '임시환', 300);
insert into tbl_books values ('별의 하루', '송종기', 200);
insert into tbl_books values ('별의 하루', '윤은해', 400);
insert into tbl_books values ('개미', '장쯔위', 100);
insert into tbl_books values ('아지랑이 피우기', '이오리', 200);
insert into tbl_books values ('아지랑이 피우기', '전지연', 100);
insert into tbl_books values ('삼국지', '노옹철', 200);
​
commit;
​
select * from tbl_books;
​
--7.1.상관서브쿼리 사용
select *
from tbl_books A
where book_title in (select book_title 
                   from tbl_books 
                   where book_title = A.book_title and author != A.author );
                   
--7.2.group by, having, count(*)
select book_title
from tbl_books
group by book_title
having count(*) > 1;
​
--7.3.상관서브쿼리와 exists( ) 사용
select *
from tbl_books A
where exists (select 1 
              from tbl_books 
              where book_title = A.book_title and author != A.author );
​
--7.4.조인 사용
select A.*
from tbl_books A join tbl_books B
on A.book_title = B.book_title
  and A.author != B.author;
