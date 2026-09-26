local util = require 'lspconfig.util'

return {
    cmd = { 'azure-pipelines-language-server', '--stdio' },
    filetypes = { 'yaml' },
    -- root_dir = util.root_pattern '*.yml',
    -- root_dir = util.root_pattern 'azure-pipelines.yml',
    -- root_dir = util.root_pattern 'azure-pipelines.yml',
    single_file_support = true,
  priority = 10,
  -- settings = {
  --     yaml = {
  --         schemas = {
  --             ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
  --                 "**/*.azure-pipelines*.y*l",
  --                 "**/azure-pipelines*.y*l",
  --             },
  --         },
  --     },
  -- },
  }
  -- settings = {
  --       yaml = {
  --           schemas = {
  --               ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
  --                   "/azure-pipeline*.y*l",
  --                   "/*.azure-pipeline*.y*l",
  --                   "/*.azure*",
  --                   -- "Azure-Pipelines/**/*.y*l",
  --                   -- "Pipelines/*.y*l",
  --               },
  --           },
  --       },
  --   },
}


