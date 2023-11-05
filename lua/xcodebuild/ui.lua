local M = {}

function M.show_tests_progress(report, firstChunk)
	if not next(report.tests) then
		if firstChunk then
			vim.notify("Building Project...")
		end
	else
		vim.cmd(
			"echo 'Running Tests [Executed: " .. report.testsCount .. ", Failed: " .. report.failedTestsCount .. "]'"
		)
	end
end

function M.print_tests_summary(report)
	if report.testsCount == 0 then
		vim.notify("Tests Failed [Executed: 0]")
	else
		vim.notify(
			report.failedTestsCount == 0 and "All Tests Passed [Executed: " .. report.testsCount .. "]"
				or "Tests Failed [Executed: " .. report.testsCount .. ", Failed: " .. report.failedTestsCount .. "]"
		)
	end
end

function M.open_test_file(tests)
	if not tests then
		return
	end

	local currentLine = vim.api.nvim_get_current_line()
	local testClass, testName, line = string.match(currentLine, "(%w*)%.(.*)%:(%d+)")

	for _, test in ipairs(tests[testClass] or {}) do
		if test.name == testName and test.filepath then
			vim.cmd("wincmd p | e " .. test.filepath .. " | " .. line)
			return
		end
	end
end

return M
