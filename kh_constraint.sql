--제약조건 실습문제 20210204
----------------------------------------------------------------------------
/*
1. 첫번째 테이블 명 : EX_MEMBER
* MEMBER_CODE(NUMBER) - 기본키                       -- 회원전용코드 
* MEMBER_ID (varchar2(20) ) - 중복금지                  -- 회원 아이디
* MEMBER_PWD (char(20)) - NULL 값 허용금지                 -- 회원 비밀번호
* MEMBER_NAME(varchar2(30))                             -- 회원 이름
* MEMBER_ADDR (varchar2(100)) - NULL값 허용금지                    -- 회원 거주지
* GENDER (char(3)) - '남' 혹은 '여'로만 입력 가능             -- 성별
* PHONE(char(11)) - NULL 값 허용금지                   -- 회원 연락처
*/

create table ex_member(
    member_code number,
    member_id varchar2(20),
    member_pwd char(20) not null,
    member_name varchar2(30),
    member_addr varchar2(100) not null,
    gender char(3),
    phone char(11) not null,
    constraint pk_ex_memeber_code primary key(member_code),
    constraint ck_ex_member_gender check(gender in ('남','여'))
);

comment on table ex_member is '회원테이블';

select *
from user_tab_comments
where table_name = 'EX_MEMBER';

--컬럼 주석 달기
comment on column ex_member.member_code is '회원코드';
comment on column ex_member.member_id is '회원아이디';
comment on column ex_member.member_pwd is '회원비밀번호';
comment on column ex_member.member_name is '회원이름';
comment on column ex_member.member_addr is '회원주소';
comment on column ex_member.gender is '회원성별';
comment on column ex_member.phone is '회원전화번호';

--컬럼 주석 확인
select*
from user_col_comments
where table_name = 'EX_MEMBER';

--제약조건 확인
select UC.table_name, 
       UCC.column_name, 
       UC.constraint_name,
       UC.constraint_type,
       UC.search_condition
from user_constraints UC join user_cons_columns UCC
     on UC.constraint_name = UCC.constraint_name
where UC.table_name = 'EX_MEMBER';

--테이블 내용 확인
select * from EX_MEMBER;

/*
2. EX_MEMBER_NICKNAME 테이블을 생성하자. (제약조건 이름 지정할것)
(참조키를 다시 기본키로 사용할 것.)
* MEMBER_CODE(NUMBER) - 외래키(EX_MEMBER의 기본키를 참조), 중복금지       -- 회원전용코드
* MEMBER_NICKNAME(varchar2(100)) - 필수                       -- 회원 이름
*/

--drop table EX_MEMBER_NICKNAME;
create table ex_member_nickname(
    member_code number,
    member_nickname varchar2(100) not null,
    constraint pk_ex_member_code primary key(member_code),
    constraint fk_ex_member_code foreign key(member_code)
                            references ex_member(member_code)
);

--컬럼 주석 달기
comment on column ex_member_nickname.member_code is '회원전용코드';
comment on column ex_member_nickname.member_nickname is '회원 이름';

--컬럼 주석 확인
select*
from user_col_comments
where table_name = 'EX_MEMBER_NICKNAME';

--제약조건 확인
select UC.table_name, 
       UCC.column_name, 
       UC.constraint_name,
       UC.constraint_type,
       UC.search_condition
from user_constraints UC join user_cons_columns UCC
     on UC.constraint_name = UCC.constraint_name
where UC.table_name = 'EX_MEMBER_NICKNAME';

--테이블 내용 확인
select * from EX_MEMBER_NICKNAME;
