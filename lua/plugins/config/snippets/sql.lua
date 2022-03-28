local ls = require("luasnip")

local s, i = ls.snippet, ls.insert_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

local M = {}

table.insert(
	M,
	s(
		"_date",
		fmt(
			[[
DECLARE _date {} DEFAULT CONVERT_TZ(NOW(),@@GLOBAL.TIME_ZONE,'+08:00');
]],
			{ i(1, "dateType") }
		)
	)
)

table.insert(
	M,
	s(
		"sproc",
		fmt(
			[[
DELIMITER $$

USE `{}`$$

DROP PROCEDURE IF EXISTS `{}`$$


CREATE DEFINER=`root`@`%` PROCEDURE `{}`(
	{},
	OUT _ERR INT,
	OUT _STATE TEXT,
	OUT _MSG TEXT
)
LBL_BEGIN:
BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1
	_ERR = MYSQL_ERRNO,
	_STATE = RETURNED_SQLSTATE,
	_MSG = MESSAGE_TEXT;

	ROLLBACK;

	DELETE FROM t_user WHERE id = _uid;

	INSERT INTO t_ev_logs(e_source,e_no,e_state,e_msg)
	VALUE('{}',_ERR,_STATE,_MSG);
END;

SET _ERR = 0;
START TRANSACTION;

{}

COMMIT;
END$$
DELIMITER ;
]],
			{
				i(1, "db"),
				i(2, "sprocName"),
				-- f(function()
				-- 	vim.inspect(vim.split(vim.fn.expand("%:t"), ".", true))
				-- 	return vim.split(vim.fn.expand("%:t"), ".", true)[1] or ""
				-- end, { 2 }),
				rep(2),
				i(3, "params"),
				l(l._1:upper(), 2),
				i(0),
			}
		)
	)
)

ls.add_snippets("sql", M)
