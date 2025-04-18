local M = {}

local utils = require("utils.mkdocs-toolkit.utils")
local configs = require("utils.mkdocs-toolkit.configs")

-- Install MkDocs for standard mkdocs-material {{{

--- Install MkDocs and the Material theme, ensuring a virtual environment is active.
--- @return boolean Indicates success or failure of the installation process.
function M.material()
	-- Path to the material-index.md file
	local material_index_path = vim.fn.stdpath("config") .. "/lua/utils/mkdocs-toolkit/templates/material/index.md"
	local material_docs_dir = vim.fn.getcwd() .. "/docs"
	local material_index_target = material_docs_dir .. "/index.md"

	-- Path to the template mkdocs.yml file
	local material_mkdocs_path = vim.fn.stdpath("config") .. "/lua/utils/mkdocs-toolkit/templates/material/mkdocs.yml"
	local material_mkdocs_target = vim.fn.getcwd() .. "/mkdocs.yml"

	-- Check if the virtual environment is active
	if not utils.venv_is_active() then
		vim.notify("Please activate a virtual environment first", vim.log.levels.ERROR)
		return false
	end

	-- Check if MkDocs is installed
	if utils.mkdocs_is_installed() then
		vim.notify("MkDocs is already installed", vim.log.levels.INFO)
		return true
	end

	-- Construct the command to install MkDocs and Material theme
	local cmd = utils.get_python_path() .. " -m pip install --upgrade pip"
	vim.fn.system(cmd)

	cmd = utils.get_python_path() .. " -m pip install mkdocs mkdocs-material"
	-- Notify user about the installation process
	vim.notify("Installing MkDocs and Material theme...", vim.log.levels.INFO)

	-- Execute the installation command with verbose output
	local result = vim.fn.system(cmd .. " --verbose")

	-- Check if the installation was successful
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to install MkDocs. Error:\n" .. result, vim.log.levels.ERROR)
		return false
	else
		-- Only proceed with file copying if the file doesn't exist
		if vim.fn.filereadable(material_mkdocs_target) == 0 then
			if vim.fn.filereadable(material_mkdocs_path) == 1 then
				local copy_cmd = "cp "
					.. vim.fn.shellescape(material_mkdocs_path)
					.. " "
					.. vim.fn.shellescape(material_mkdocs_target)
				local copy_result = vim.fn.system(copy_cmd)

				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to copy template:\n" .. copy_result, vim.log.levels.ERROR)
					return false
				end
				vim.notify("Copied mkdocs.yml in the project root", vim.log.levels.INFO)
			else
				vim.notify("No mkdocs.yml template found at:\n" .. material_mkdocs_path, vim.log.levels.WARN)
			end
		else
			vim.notify("mkdocs.yml already exists - skipping template copy", vim.log.levels.INFO)
		end

		-- Ensure docs directory exists
		if vim.fn.isdirectory(material_docs_dir) == 0 then
			vim.fn.mkdir(material_docs_dir, "p")
			local name_docs_dir = vim.fn.fnamemodify(material_docs_dir, ":t")
			vim.notify("Created docs directory: " .. name_docs_dir, vim.log.levels.INFO)
		end

		-- Only proceed with file copying if the file doesn't exist
		if vim.fn.filereadable(material_index_target) == 0 then
			if vim.fn.filereadable(material_index_path) == 1 then
				local copy_index_cmd = "cp "
					.. vim.fn.shellescape(material_index_path)
					.. " "
					.. vim.fn.shellescape(material_index_target)
				local index_result = vim.fn.system(copy_index_cmd)

				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to copy index template:\n" .. index_result, vim.log.levels.ERROR)
					return false
				end
				vim.notify("Copied template to docs/index.md", vim.log.levels.INFO)
			else
				vim.notify("No material-index.md template found at:\n" .. material_index_path, vim.log.levels.WARN)
			end
		else
			vim.notify("docs/index.md already exists - skipping copy", vim.log.levels.INFO)
		end

		vim.notify("Successfully installed MkDocs and Material theme", vim.log.levels.INFO)

		utils.deactivate_venv()

		return true
	end
end

-- }}}

-- Install MkDocs for RockyDocs Project {{{

--- Set up MkDocs for Rocky Documentation with the specified templates and themes.
--- @return boolean Indicates success or failure of the setup process
function M.rockydocs()
	-- Get paths
	local config_path = vim.fn.stdpath("config")
	local rockydocs_dir = config_path .. "/lua/utils/mkdocs-toolkit/templates/rockydocs"

	-- Source paths
	local rockydocs_requirements = rockydocs_dir .. "/requirements.txt"
	local mkdocs_path = rockydocs_dir .. "/mkdocs.yml"
	local theme_path = rockydocs_dir .. "/theme"
	local rockydocs_index_path = rockydocs_dir .. "/index.md"

	-- Target paths
	local target_path = vim.fn.getcwd()
	local mkdocs_target = target_path .. "/mkdocs.yml"
	local theme_target = target_path .. "/theme"
	-- local docs_dir = target_path .. "/docs"
	local rockydocs_docs_dir = target_path .. "/docs/docs" -- This folder will be created for rockydocs
	local index_target = rockydocs_docs_dir .. "/index.md"

	-- Check if the virtual environment is active
	if not utils.venv_is_active() then
		vim.notify("Please activate a virtual environment first", vim.log.levels.ERROR)
		return false
	end

	-- Verify if the requirements template exists
	if vim.fn.filereadable(rockydocs_requirements) == 0 then
		vim.notify("Requirements template not found:\n" .. rockydocs_requirements, vim.log.levels.ERROR)
		return false
	end

	-- Install requirements (always run this part)
	vim.notify("Installing RockyDocs environments...", vim.log.levels.INFO)

	local pip_cmd = utils.get_python_path() .. " -m pip install -r " .. vim.fn.shellescape(rockydocs_requirements)
	local install_result = vim.fn.system(pip_cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to install requirements:\n" .. install_result, vim.log.levels.ERROR)
		return false
	end

	-- Verify MkDocs installation
	local verify_cmd = utils.get_python_path() .. " -m pip show mkdocs >/dev/null 2>&1"
	vim.fn.system(verify_cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("MkDocs not found after installation. Aborting setup.", vim.log.levels.ERROR)
		return false
	end

	-- Only proceed with file copying if the files don't exist
	local files_copied = false

	-- Copy rocky-mkdocs.yml template if it doesn't exist
	if vim.fn.filereadable(mkdocs_target) == 0 then
		if vim.fn.filereadable(mkdocs_path) == 1 then
			local copy_cmd = "cp " .. vim.fn.shellescape(mkdocs_path) .. " " .. vim.fn.shellescape(mkdocs_target)
			local copy_result = vim.fn.system(copy_cmd)

			if vim.v.shell_error ~= 0 then
				vim.notify("Failed to copy template:\n" .. copy_result, vim.log.levels.ERROR)
				return false
			end
			files_copied = true
		else
			vim.notify("No rocky-mkdocs.yml template found at:\n" .. mkdocs_path, vim.log.levels.ERROR)
			return false -- Abort if the template does not exist
		end
	else
		vim.notify("mkdocs.yml already exists - skipping template copy", vim.log.levels.INFO)
	end

	-- Copy theme folder if it doesn't exist
	if vim.fn.isdirectory(theme_target) == 0 then
		if vim.fn.isdirectory(theme_path) == 1 then
			-- Create target directory if it doesn't exist
			if vim.fn.isdirectory(theme_target) == 0 then
				vim.fn.mkdir(theme_target, "p")
			end

			local copy_theme_cmd = "rsync -a "
				.. vim.fn.shellescape(theme_path)
				.. "/ "
				.. vim.fn.shellescape(theme_target)
				.. "/"
			local theme_result = vim.fn.system(copy_theme_cmd)

			if vim.v.shell_error ~= 0 then
				vim.notify("Failed to copy theme:\n" .. theme_result, vim.log.levels.ERROR)
				return false
			end
			files_copied = true
			vim.notify("Successfully copied theme folder to project root", vim.log.levels.INFO)
		else
			vim.notify("No theme folder found at:\n" .. theme_path, vim.log.levels.ERROR)
			return false -- Abort if the theme folder does not exist
		end
	else
		vim.notify("theme folder already exists - skipping copy", vim.log.levels.INFO)
	end

	-- Copy rocky-index.md to docs/docs/index.md if it doesn't exist
	if vim.fn.filereadable(index_target) == 0 then
		if vim.fn.filereadable(rockydocs_index_path) == 1 then
			-- Ensure docs/docs directory exists
			if vim.fn.isdirectory(rockydocs_docs_dir) == 0 then
				vim.fn.mkdir(rockydocs_docs_dir, "p")
			end

			local copy_index_cmd = "cp "
				.. vim.fn.shellescape(rockydocs_index_path)
				.. " "
				.. vim.fn.shellescape(index_target)
			local index_result = vim.fn.system(copy_index_cmd)

			if vim.v.shell_error ~= 0 then
				vim.notify("Failed to copy index template:\n" .. index_result, vim.log.levels.ERROR)
				return false
			end
			files_copied = true
			vim.notify("Successfully copied template to docs/docs/index.md", vim.log.levels.INFO)
		else
			vim.notify("No rocky-index.md template found at:\n" .. rockydocs_index_path, vim.log.levels.ERROR)
			return false -- Abort if the index template does not exist
		end
	else
		vim.notify("docs/docs/index.md already exists - skipping copy", vim.log.levels.INFO)
	end

	if files_copied then
		vim.notify(
			"Successfully set up MkDocs with:\n- Rocky configuration\n- Theme folder\n- Documentation index",
			vim.log.levels.INFO
		)
	else
		vim.notify(
			"Requirements installed successfully, but no files were copied as they already exist",
			vim.log.levels.INFO
		)
	end

	utils.venv_is_active()

	return true
end

-- }}}

-- Create a new MkDocs project in the current directory {{{
function M.new_project()
	utils.activate_venv()

	if not utils.venv_is_active() then
		vim.notify("Please activate a virtual environment first", vim.log.levels.ERROR)
		return false
	end

	-- Install MkDocs
	if not utils.mkdocs_is_installed() then
		local cmd = utils.get_python_path() .. " -m pip install --upgrade pip"
		vim.fn.system(cmd)
		cmd = utils.get_python_path() .. " -m pip install mkdocs"
		vim.notify("Installing MkDocs...", vim.log.levels.INFO)
		vim.fn.system(cmd)
		if vim.v.shell_error ~= 0 then
			vim.notify("Failed to install MkDocs", vim.log.levels.ERROR)
			return false
		end
	end

	-- Check if MkDocs is installed
	if not utils.check_mkdocs_installed() then
		return false
	end

	local cmd = utils.get_python_path() .. " -m mkdocs new ."
	vim.notify("Creating new MkDocs project...", vim.log.levels.INFO)
	vim.fn.system(cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to create MkDocs project", vim.log.levels.ERROR)
		return false
	else
		vim.notify("Successfully created MkDocs project", vim.log.levels.INFO)
		utils.deactivate_venv()
		return true
	end
end

-- }}}

-- Serve the MkDocs documentation {{{

function M.serve()
	utils.activate_venv() -- Activate the virtual environment
	if not utils.venv_is_active() then -- Check if the virtual environment is now active
		vim.notify("Please activate a virtual environment first", vim.log.levels.ERROR)
		return false
	end

	utils.check_mkdocs_installed()

	if vim.fn.filereadable("mkdocs.yml") ~= 1 then -- Ensure mkdocs.yml is present
		vim.notify("No mkdocs.yml found in the current directory", vim.log.levels.ERROR)
		return false
	end

	-- Stop any existing server first if already running
	if configs.server_job_id and vim.fn.jobwait({ configs.server_job_id }, 0)[1] == -1 then
		vim.fn.jobstop(configs.server_job_id)
	end

	local cmd = utils.get_python_path() .. " -m mkdocs serve -q"
	vim.notify("Starting MkDocs server...", vim.log.levels.INFO)

	-- Start the server as a background job
	configs.server_job_id = vim.fn.jobstart(cmd, {
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line:find("Serving") then
						vim.notify(line, vim.log.levels.INFO)
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
			end
		end,
		on_exit = function()
			utils.deactivate_venv()
			configs.server_job_id = nil
		end,
	})

	return true
end

-- }}}

-- Stop the running MkDocs server {{{

function M.stop_serve()
	if not configs.server_job_id then
		vim.notify("No MkDocs server is currently running", vim.log.levels.WARN)
		return false
	end

	-- Check if the job is still running
	if vim.fn.jobwait({ configs.server_job_id }, 0)[1] == -1 then
		vim.fn.jobstop(configs.server_job_id)
		vim.notify("Stopped MkDocs server", vim.log.levels.INFO)
		configs.server_job_id = nil
		utils.deactivate_venv() -- Automatically deactivate the virtual environment after stopping
		return true
	else
		vim.notify("MkDocs server is not running", vim.log.levels.WARN)
		configs.server_job_id = nil
		return false
	end
end

-- }}}

-- Build the MkDocs documentation {{{

function M.build()
	utils.activate_venv()
	if not utils.venv_is_active() then
		vim.notify("Please activate a virtual environment first", vim.log.levels.ERROR)
		return false
	end

	if not utils.mkdocs_is_installed() then
		vim.notify("MkDocs is not installed. Install MkDocs Enviroment first", vim.log.levels.ERROR)
		return false
	end

	if vim.fn.filereadable("mkdocs.yml") ~= 1 then
		vim.notify("No mkdocs.yml found in current directory", vim.log.levels.ERROR)
		return false
	end

	local cmd = utils.get_python_path() .. " -m mkdocs build"
	vim.notify("Building MkDocs documentation...", vim.log.levels.INFO)

	vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to build documentation", vim.log.levels.ERROR)
		return false
	else
		vim.notify("Successfully built documentation in site/ directory", vim.log.levels.INFO)
		return true
	end
end

-- }}}

-- Show the status of MkDocs and its environment {{{
function M.mkdocs_status()
	local status = "MkDocs status:\n"

	if not utils.venv_is_active() then
		status = status .. "No active virtual environment\n"
	else
		status = status .. "Virtual environment: " .. vim.env.VIRTUAL_ENV .. "\n"
		status = status .. "MkDocs installed: " .. (utils.mkdocs_is_installed() and "Yes" or "No") .. "\n"

		if vim.fn.filereadable("mkdocs.yml") == 1 then
			status = status .. "MkDocs project detected in current directory\n"
		else
			status = status .. "No MkDocs project in current directory\n"
		end
	end

	if configs.server_job_id and vim.fn.jobwait({ configs.server_job_id }, 0)[1] == -1 then
		status = status .. "MkDocs server: Running\n"
	else
		status = status .. "MkDocs server: Not running\n"
	end

	vim.notify(status, vim.log.levels.INFO)
end
-- }}}

return M
