

--1. 학과테이블에서 계열별 정원의 평균을 조회(정원 내림차순 정렬)
select category, 
            trunc(avg(capacity))
from tb_department
group by category
order by 2 desc;

--2. 휴학생을 제외하고, 학과별로 학생수를 조회(학과별 인원수 내림차순)
select department_no, count(*)
from tb_student
where absence_yn = 'N'
group by department_no
order by 2 desc;

--3. 과목별 지정된 교수가 2명이상인 과목번호와 교수인원수를 조회
select class_no, count(*)
from tb_class_professor
group by class_no
having count(*) >= 2
order by 2 desc;


--4. 학과별로 과목을 구분했을때, 과목구분이 "전공선택"에 한하여 과목수가 10개 이상인 행의 학과번호, 과목구분(class_type), 과목수를 조회(전공선택만 조회)
select department_no, 
           class_type,
           count(*)
from tb_class
group by department_no, class_type
having class_type = '전공선택' and count(*) >= 10
order by 3 desc;

select department_no, 
           class_type,
           count(*)
from tb_class
where class_type = '전공선택'
group by department_no, class_type
having  count(*) >= 10
order by 3 desc;
