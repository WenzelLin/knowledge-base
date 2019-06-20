CREATE OR REPLACE TYPE split_type IS TABLE OF VARCHAR2 (50);

create or replace function SPLITSTR
(
  p_str       in varchar2,
  p_delimiter in varchar2
) return split_type is
  j        int := 0;
  i        int := 1;
  len      int := 0;
  len1     int := 0;
  str      varchar2(4000);
  my_split split_type := split_type();
begin
  len  := LENGTH(p_str);
  len1 := LENGTH(p_delimiter);
  while j < len loop
    j := INSTR(p_str, p_delimiter, i);
    if j = 0
    then
      j   := len;
      str := SUBSTR(p_str, i);
      my_split.EXTEND;
      my_split(my_split.COUNT) := str;
      if i >= len
      then
        exit;
      end if;
    else
      str := SUBSTR(p_str, i, j - i);
      i   := j + len1;
      my_split.EXTEND;
      my_split(my_split.COUNT) := str;
    end if;
  end loop;
  return my_split;
end SPLITSTR;



CREATE OR REPLACE TRIGGER tr_ins_emp
   BEFORE INSERT --ָ������ʱ��Ϊ�������ǰ����
   ON timsemployee
   FOR EACH ROW   --˵�����������м�������
DECLARE
  accounts_s varchar2(2000);
  account_s varchar2(50);
  DATALIST split_type;
BEGIN
  accounts_s := :new.ACCOUNTS;
  IF accounts_s <> '||' THEN
    DATALIST := SPLITSTR(accounts_s,'|');
    FOR j IN 1..DATALIST.count LOOP
      account_s := DATALIST(j);
      INSERT INTO tUserEmployee(userAccount, employeeCode) VALUES(account_s, :new.EMPLOYEECODE);
    END LOOP;
  END IF;
END;


CREATE OR REPLACE TRIGGER tr_upd_emp
   BEFORE UPDATE --ָ������ʱ��Ϊ���²���ǰ����
   ON timsemployee
   FOR EACH ROW   --˵�����������м�������
DECLARE
  accounts_s varchar2(2000);
  account_s varchar2(50);
  DATALIST split_type;
BEGIN
  --ɾ��Ա���ɵļ�¼
  DELETE tUserEmployee WHERE employeeCode = :old.EMPLOYEECODE;

  --����Ա����¼
  accounts_s := :new.ACCOUNTS;
  IF accounts_s <> '||' THEN
    DATALIST := SPLITSTR(accounts_s,'|');
    FOR j IN 1..DATALIST.count LOOP
      account_s := DATALIST(j);
      INSERT INTO tUserEmployee(userAccount, employeeCode) VALUES(account_s, :new.EMPLOYEECODE);
    END LOOP;
  END IF;
END;


CREATE OR REPLACE TRIGGER tr_del_emp
   BEFORE DELETE --ָ������ʱ��Ϊɾ������ǰ����
   ON timsemployee
   FOR EACH ROW   --˵�����������м�������
BEGIN
   DELETE tUserEmployee WHERE employeeCode = :old.EMPLOYEECODE;
END;