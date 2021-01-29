-------------------------------------------------------------
--20120128 join 실습문제_chun
-------------------------------------------------------------
--@실습문제 : INNER JOIN & OUTER JOIN
--1. 학번, 학생명, 학과명을 출력
select s.student_no 학번,
        s.student_name 학생명,
        d.department_name 학과명
from tb_student s 
            join tb_department d 
            using(department_no)
order by 1;
    
--2. 학번, 학생명, 담당교수명을 출력하세요.
--담당교수가 없는 학생은 '없음'으로 표시
select S.student_no 학번, S.student_name 학생명, nvl(professor_name, '없음') 담당교수명
from tb_student S left join tb_professor P
    on S.coach_professor_no = P.professor_no
order by 1;
​
--3. 학과별 교수명과 인원수를 모두 표시하세요.
​
select 
        d.department_name 학과명,
       nvl2(p.professor_name,p.professor_name,count(*)) 교수명
from tb_department d 
            join tb_professor p 
            on d.department_no = p.department_no
group by rollup(d.department_name, p.professor_name)
order by 1;
​
-- 4. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
-- (동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.)

select *
from tb_student
where student_name = '%람';

​select S.student_name 학생명, 
    round(avg(point),2) 평균학점
from tb_student S, tb_grade G
where S.student_no = G.student_no and student_name like '%람'
group by S.student_no, S.student_name;
​
--5. 학생별 다음정보를 구하라.
/*
--------------------------------------------
학생명  학기     과목명    학점
--------------------------------------------
감현제	200401	전기생리학 	4.5
            .
            .
--------------------------------------------
​
*/

select student_name 학생명,
        term_no 학기,
        class_name 과목명,
        point 학점
from tb_student S, tb_grade G, tb_class C
where S.student_no = G.student_no and G.class_no = C.class_no
order by 학생명,학기;

