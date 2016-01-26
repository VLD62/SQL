select t.table_name,tc.COMMENTS as table_comment,tcl.COLUMN_NAME,tcl.DATA_TYPE,cc.COMMENTS as column_comment,fk.TABLE_NAME as REMOTE_TABLE_NAME,fk.COLUMN_NAME as remote_column_name
from all_tables t 
join all_tab_comments tc on tc.TABLE_NAME = t.TABLE_NAME and tc.OWNER = t.OWNER 
join ALL_TAB_COLUMNS tcl on tcl.TABLE_NAME = t.TABLE_NAME and tcl.OWNER = t.OWNER 
join ALL_COL_COMMENTS cc on tcl.COLUMN_NAME = cc.COLUMN_NAME and tcl.TABLE_NAME = cc.TABLE_NAME and tcl.OWNER = cc.OWNER
left join (select c.table_name, cc.COLUMN_NAME, c.CONSTRAINT_NAME, cr.CONSTRAINT_NAME as REMOTE_CONSTRAINT_NAME, cr.TABLE_NAME as REMOTE_TABLE_NAME,cr.COLUMN_NAME as remote_coumn_name
from all_constraints c join all_cons_columns cr on c.R_CONSTRAINT_NAME = cr.CONSTRAINT_NAME
join all_cons_columns cc on c.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
where c.owner = 'LDCC_TP_OWNER' and c.TABLE_NAME like 'TP%' and c.R_CONSTRAINT_NAME is not null) fk on fk.table_name = t.table_name and fk.column_name = tcl.COLUMN_NAME
where t.owner = 'LDCC_TP_OWNER' and t.table_name like 'TP%' order by t.table_name,tcl.COLUMN_NAME;
