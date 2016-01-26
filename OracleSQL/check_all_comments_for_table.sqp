select t.table_name, tc.COMMENTS 
from all_tables t 
join all_tab_comments tc on tc.TABLE_NAME = t.TABLE_NAME 
and tc.OWNER = t.OWNER where t.owner = 'ELT_GLOBAL_OWNER'  order by 1;
