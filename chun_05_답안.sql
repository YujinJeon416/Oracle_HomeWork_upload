

--학과테이블
select * from tb_department;
--학생테이블
select * from tb_student;
--과목테이블
select * from tb_class;
--과목-교수테이블 
select * from tb_class_professor;
--교수테이블
select * from tb_professor;
--성적테이블
select * from tb_grade;



--@실습문제 : inner join & outer join
--1. 학번, 학생명, 학과명을 출력
select count(*)
from tb_student
where department_no is null;

--학과를 지정받지 못한 학생을 없음. 고로 INNER JOIN으로 충분함.

select tb_student.student_no 학번
       , tb_student.student_name 학생명
       , tb_department.department_name 학과
from tb_student join tb_department
    using(department_no);



--2. 학번, 학생명, 담당교수명을 출력하세요.
--담당교수가 없는 학생은 '없음'으로 표시
select student_no 학번
       , student_name 학생명
       , nvl(professor_name,'없음') 담당교수명
from tb_student s left join tb_professor p
   on s.coach_professor_no = p.professor_no;
--담당교수가 없는 학생도 있기때문에 반드시 outer join으로 처리해야함.


--3. 학과별 교수명과 인원수를 모두 표시하세요.
--학과지정을 받지 못한 교수여부 조사 -> 1명 있음.
select *
from tb_professor 
where department_no is null;

select decode(grouping(department_name),0,nvl(department_name,'미지정'),1,'총계') 학과명
       , decode(grouping(professor_name),0,professor_name,1,count(*)) 교수명  
from tb_professor p 
    left join tb_department d using(department_no)
group by rollup(department_name, professor_name)
order by d.department_name;


-- 4. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
-- 동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.
select student_name 학생명
    , round(avg(point),2) 평균학점
from tb_student s join tb_grade g using(student_no)
where student_name like '%람' 
group by student_no, student_name;

--동명이인 검사쿼리
select student_name, count(*)
from tb_student
where student_name like '%람' 
group by student_name
having count(*) > 1;


--5. 학생별 다음정보를 구하라.
/*
--------------------------------------------
학생명  학기     과목명    학점
--------------------------------------------
감현제	200401	전기생리학 	4.5
            .
            .
--------------------------------------------

*/
select student_name, term_no, class_name, point
from tb_student s 
    join tb_grade using(student_no)
    join tb_class using(class_no)
order by 1;
