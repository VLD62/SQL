--Get details about long running operations:
SELECT osuser,
       sl.sql_id,
       sl.sql_hash_value,
       opname,
       target,
       elapsed_seconds,
       time_remaining
  FROM v$session_longops sl
inner join v$session s ON sl.SID = s.SID AND sl.SERIAL# = s.SERIAL#
WHERE time_remaining > 0;
