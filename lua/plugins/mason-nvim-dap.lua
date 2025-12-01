return {
	"jay-babu/mason-nvim-dap.nvim",

	opts = {
		ensure_installed = { "php" },
		handlers = {
			php = function(_)
				local dap = require("dap")

				local registry = require("mason-registry")
				local php_debug = registry.get_package("php-debug-adapter")
				local php_debug_path = php_debug:get_install_path() .. "/extension/out/phpDebug.js"
				dap.adapters.php = {
					type = "executable",
					command = "node",
					args = { php_debug_path }, -- Mason path to PHP debug adapter
				}

				dap.configurations.php = {
					{
						type = "php",
						request = "launch",
						name = "Listen for XDebug",
						port = 9001,
						log = true,
						stopOnEntry = false,
						pathMappings = {
							["/var/www/arnica.local/www"] = os.getenv("HOME") .. "/Projects/arnica.local/www",
							["/var/www/arnica.local/_core"] = os.getenv("HOME") .. "/Projects/arnica.local/_core",
						},
					},
				}
			end,

			node = function(_)
				local dap = require("dap")

				local registry = require("mason-registry")
				local node_debug2 = registry.get_package("node-debug2-adapter")

				dap.adapters.node2 = {
					name = "Launch executable",
					type = "executable",
					command = "node",
					args = { node_debug2:get_install_path() .. "/out/src/nodeDebug.js" },
				}

				-- Alternative adapter for newer Node.js versions
				dap.adapters.node = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "node",
						args = { node_debug2:get_install_path() .. "js-debug/src/dapDebugServer.js", "${port}" },
					},
				}

				-- Chrome/V8 inspector adapter for attaching to running Node.js processes
				dap.adapters.chrome = {
					type = "executable",
					command = "node",
					args = { vim.fn.stdpath("data") .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" },
				}

				-- Node.js configurations
				dap.configurations.javascript = {
					{
						name = "Attach to Node.js Process (Inspector)",
						type = "chrome",
						request = "attach",
						protocol = "inspector",
						port = 9229, -- Default Node.js inspector port
						webRoot = "${workspaceFolder}",
						sourceMaps = true,
						skipFiles = {
							"<node_internals>/**",
							"node_modules/**",
						},
					},
					{
						name = "Launch Node.js Program",
						type = "node2",
						request = "launch",
						program = "${file}",
						cwd = vim.fn.getcwd(),
						sourceMaps = true,
						protocol = "inspector",
						console = "integratedTerminal",
						skipFiles = {
							"<node_internals>/**",
							"node_modules/**",
						},
					},
				}

				-- TypeScript configurations (same as JavaScript)
				dap.configurations.typescript = dap.configurations.javascript
			end,
		},
	},
}
