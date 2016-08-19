declare 
l_val pls_integer;
l_max pls_integer;
l_seq pls_integer;
l_cnt pls_integer;
begin
select max(boza_id) into l_max from boza_table;
select last_number into l_seq from user_sequences where sequence_name = 'seq_boza_id';

if l_seq < l_max then
for l_cnt in l_seq..l_max
loop
  select seq_boza_id.nextval into l_val from dual;
end loop;
end if;
end;
/
