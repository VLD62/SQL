select USERNAME, PROFILE from dba_users
where USERNAME like 'USER%' order by USERNAME;

select * from dba_profiles
where RESOURCE_NAME LIKE '%PASSWORD_LIFE_TIME%';
