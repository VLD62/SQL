---Issue with Oracle ORA-00020: maximum number of processes exceeded 
Select * from v$RESORUCE_LIMIT where RESOURCE_NAME in ('processes','sessions');

Select USERNAME, SID, SERIAL# from v$session group by program order by 2;

Select * from v$license;

Select machine, count(1) from v$session group by machine order by 2;

Select username, osuser, terminal, count(1)
from v$session
where machine = 'PC_NAME'
group by userm, osuser, terminal

----Identify running processes
Select sess.process, sess.status, sess.username, sess.schemaname, sql.sql_text
FROM v$session sess, v$sql sql WHERE sql.sql_id(+) = sess.sql_id and sess.type= 'USER';
