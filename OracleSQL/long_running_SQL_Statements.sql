--Show long running SQL Statements
SELECT s.username,
       sl.sid,
       sq.executions,
       sl.last_update_time,
       sl.sql_id,
       sl.sql_hash_value,
       opname,
       target,
       elapsed_seconds,
       time_remaining,
       sq.sql_fulltext
  FROM v$session_longops sl
 INNER JOIN v$sql sq ON sq.sql_id = sl.sql_id
 INNER JOIN v$session s ON sl.SID = s.SID AND sl.serial# = s.serial#
 WHERE time_remaining > 0;
 
 -- If you want to see the SQL query causing the long running operation.
