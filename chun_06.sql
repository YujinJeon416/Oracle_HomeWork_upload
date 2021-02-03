-------------------------------------------------------------------------------------
--03_워크북_v2.0_AdditionalSelect_Option
--[Additional SELECT -Option]20210203



-- 문제1. 학생이름과 주소지를 표시하시오.
-- 단, 출력헤더는 "학생이름", "주소지"라고 하고
-- 정렬은 이름으로 오름차순 표시하도록 한다.


select student_name "학생 이름", student_address 주소지
from tb_student
order by "학생 이름";


--문제2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.

select student_name as "학생 이름", student_ssn
from tb_student
where absence_yn = 'Y'
order by student_ssn desc;


---문제3. 주소지가 강원도와 경기도인 학생들 중
-- 1900년대 학번을 가진 학생들의 이름과 학번, 주소, 이름을
-- 오름차순으로 나타내시오.
-- 단, 출력헤더는 "학생이름", "학번", "거주지 주소"으로 나타낸다.

select student_name as "학생이름", student_no as 학번, student_address as "거주지 주소"
from tb_student
where (student_address like '경기도%' or student_address like '강원도%') and student_no like '9%'
order by 학생이름;

select student_name, student_address
from tb_student;

select student_name "학생이름", student_no "학번", student_address "거주지 주소"
from tb_student
where (student_address like '강원%' or  student_address like '경기도%')
        and student_no like '9%'; 

--문제4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL문장을 작성
-- 법학과의 학과 코드는 학과테이블을 조회해서 찾아내도록한다.
--1) 법학과 학과코드. => DEPARTMENT_NO : '005'

select professor_name, professor_ssn
from tb_professor
join tb_department using (department_no)
where department_name ='법학과'
order by 2;

--1)
select *
from tb_department
where department_name='법학과';

--2) 법학과 교수
select professor_name "교수명", professor_ssn "주민번호"
from tb_professor
where department_no='005'
order by sysdate-to_date(substr(professor_ssn,1,6),'RRMMDD') desc;


--문제5. 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다.
-- 학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해라.

select student_no, round(point, 2)
from tb_grade
where class_no = 'C3118100' and term_no = '200402'
order by point desc, student_no;

--풀이 2
select student_no, to_char(point,'0.00') 
from tb_grade
where class_no='C3118100' 
        and to_number(substr(term_no,1,4))=2004  
        and to_number(substr(term_no,5,6))=2 
order by point desc; 

--문제6. 학생번호, 학생이름, 학과이름을 학생이름으로 오름차순 정렬하여
-- 출력하는 SQL문을 작성하시오

select student_no,student_name, department_name
from tb_student,tb_department
where tb_department.department_no = tb_student.department_no
order by student_name;

--join 풀이
select student_no "학생번호", student_name 학생이름, department_name 학과이름
from tb_student
    join tb_department using(department_no) 
order by student_name; 

--문제7. 춘 기술대학교의 과목이름과 과목의 학과이름을 출력하는
-- SQL문장을 작성하시오.

--join
select class_name 과목이름, department_name 학과이름
from tb_class
    join tb_department using (department_no);
    
select class_name, department_name
from tb_class,tb_department
where tb_department.department_no = tb_class.department_no;

--문제8. 과목별 교수이름을 찾으려고한다. 과목이름과 교수이름을
-- 출력하는 SQL문을 작성해라.

select class_name, professor_name
from tb_class,tb_class_professor,tb_professor
where tb_class.class_no = tb_class_professor.class_no  
and tb_professor.professor_no = tb_class_professor.professor_no;

--join
select class_name 과목이름, professor_name 교수이름
from tb_class
    join tb_class_professor using (class_no)
    join tb_professor using(professor_no); 
    
-- 문제9
-- 8번의 결과 중 '인문사회' 계열에 속한 과목의 교수 이름을
-- 찾으려고 한다. 이에 해당하는 과목 이름과 교수 이름을
-- 출력하는 SQL문을 작성해라.

select class_name, professor_name
from tb_class,tb_class_professor,tb_professor,tb_department
where tb_class.class_no = tb_class_professor.class_no
and tb_professor.professor_no = tb_class_professor.professor_no 
and tb_professor.department_no = tb_department.department_no and category='인문사회';

--1) 개설된 과목 이름과 계열을 구한다.
select class_name, category
from tb_class
    join tb_department using(department_no)
    join tb_class_professor using(class_no)
    join tb_professor using(professor_no);

--2) 인문사회 계열에 속한 교수이름을 찾는다.
select class_name, professor_name
from tb_class
        join tb_class_professor using(class_no)
        join tb_professor using(professor_no)
where (class_name, professor_name) in (select class_name, professor_name
                                        from tb_class
                                                join tb_department using(department_no)
                                                join tb_class_professor using(class_no)
                                                join tb_professor using(professor_no)
                                        where category ='인문사회');
                                        
                                        
-- 문제10. 음악학과 학생들의 평점을 구하려고 한다.
-- 음악학과 학생들의 학번/ 학생이름/ 전체 평점을 출력하는 SQL문장을 작성
-- 단, 평점은 소수점 1자리까지만 반올림하여 표시한다.

select student_no, student_name, round(avg(point),1)
from tb_student
        join tb_department using (department_no)
        join tb_grade using(student_no)
where department_name='음악학과'
group by student_no, student_name
order by student_no;

select tb_student.student_no as 학번, tb_student.student_name as "학생 이름", round(avg(point),1) as "전체 평점"
from tb_grade,tb_student,tb_department
where tb_department.department_no = tb_student.department_no and department_name='음악학과' and tb_student.student_no = tb_grade.student_no
group by tb_student.student_no,tb_student.student_name
order by tb_student.student_no;

-- 문제11. 학번이 A313047 인 학생이 학교에 나오고 있지 않다
-- 지도교수에게 내용을 전달하기 위한  학과이름/학생이름/ 지도교수 이름이 필요하다.
-- 이때 사용할 SQL문을 작성해라.

select department_name as 학과이름, student_name as 학생이름, professor_name as 지도교수이름 
from tb_student, tb_department,tb_professor
where tb_student.department_no = tb_department.department_no and tb_student.coach_professor_no=tb_professor.professor_no
and tb_student.student_no = 'A313047';

select department_name 학과이름, student_name 학생이름, professor_name 지도교수이름
from tb_student
        join tb_department using(department_no)
        join tb_professor on (coach_professor_no=professor_no)
where student_no='A313047';


--문제12. 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아
-- 학생이름과 수강학기를 표시하는 SQL문장을 작성하라

--1) 인간관계론 과목의 수강코드와 수강학기.
select distinct class_no 수강코드, term_no 수강학기
from tb_class
        join tb_grade using(class_no)
where class_name='인간관계론' --인간관계론
        and to_number(substr(term_no,1,4))=2007; --2007년도

--2) 인간관계론' 과목을 수강한 학생이름과 수강학기
select student_name, term_no "term_name"
from tb_student
        join tb_grade using(student_no)
where (class_no, term_no) in (select distinct class_no, term_no
                    from tb_class
                            join tb_grade using(class_no)
                    where class_name='인간관계론'
                            and to_number(substr(term_no,1,4))=2007)
order by student_name;

                                          
--풀이2
select student_name, term_no
from tb_student,tb_grade,tb_class
where tb_student.student_no = tb_grade.student_no and tb_class.class_no=tb_grade.class_no
and term_no like '2007%' and class_name = '인간관계론';

--13. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 그 과목이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.

select class_name, department_name
from tb_class
        left join tb_class_professor using(class_no)
        join tb_department using(department_no)
where category='예체능'
        and professor_no is null
order by department_name;


--문제14. 춘기술대학교 서반아어학과 학생들의 지도교수를 게시하고자한다.
-- 학생이름과 지도교수 이름을 찾고
-- 만일 지도교수가 없는 학생일 경우, "지도교수 미지정"으로 표시하도록 하는 SQL문을 작성하시오.

select student_name 학생이름, 
       nvl(professor_name,'지도교수 미지정') 지도교수
from tb_student s
    left join tb_professor on (coach_professor_no = professor_no)
where s.department_no = ( select department_no from tb_department
                        where department_name ='서반아어학과');



--문제15. 휴학생이 아닌 학생 중 평점이 4.0이상인 학생을 찾아
-- 그 학생의 학번, 이름, 학과 이름, 평점을 출력하는 SQL문을 작성하시오.

select student_no 학번, student_name 이름, department_name "학과 이름", round(avg(point),8) 평점
from tb_student
        join tb_department using(department_no)
        join tb_grade using(student_no) 
where absence_yn='N' 
group by student_no, student_name, department_name
having avg(point)>=4.0 
order by student_no;



--문제 16. 환경조경학과 전공과목들의 과목별 평점을 파악할 수 있는 SQL문을 작성하시오.

select c.class_no, c.class_name , avg(point)
from tb_class c
join tb_department using (department_no)
join tb_grade g on (c.class_no = g.class_no)
where department_name ='환경조경학과' and
      substr(class_type,1,2) = '전공'
group by c.class_no, c.class_name;

-- 문제 17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은과 학생들의 이름과
-- 주소를 출력하는 SQL문을 작성하시오.

--1) 최경희 학생의 학과
select *
from tb_student
where student_name='최경희';

--2) 최경희 학생과 같은 학과 
select student_name, student_address
from tb_student
where department_no =(select department_no
                      from tb_student
                      where student_name='최경희');
                      

-- 문제 18. 국어 국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL문
-- 1) 국어국문학과에 속한 학생들의 평점을 조회한다.

select student_no, student_name
from tb_student
  join tb_department using (department_no)
  join tb_grade using(student_no)
where department_name='국어국문학과'
group by student_no, student_name
having avg(point)=( select max(avg(point))
                    from tb_grade
                      join tb_student using (student_no)
                      join tb_department using (department_no)
                    where department_name='국어국문학과'
                    group by student_no
                  );



-- 풀이 2
select student_no, student_name
from (select student_no, student_name, avg(point)
      from tb_grade
           join tb_student using(student_no)
      where department_no = (select department_no
                             from tb_department
                             where department_name = '국어국문학과')
      group by student_no, student_name
      order by avg(point) desc)
where rownum = 1;

-- 문제19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의
-- 학과별 전공과목 평점을 파악하기 위한 적절한 SQL문을 찾아내시오


select department_name "계열학과명", round(avg(point),1)
from tb_department
  join tb_student using(department_no)
  join tb_grade using(student_no)
where category=(select category
                from tb_department
                where department_name='환경조경학과')
group by department_name
order by 1;

