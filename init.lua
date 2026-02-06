local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- run :GoBuild or :GoTestCompile based on the go file
local function build_go_files()
  if vim.endswith(vim.api.nvim_buf_get_name(0), "_test.go") then
    vim.cmd("GoTestCompile")
  else
    vim.cmd("GoBuild")
  end
end

----------------
--  Plugins 
----------------
require("lazy").setup({

  -- Color Schema
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        italic_comments = true,
        transparent = false,
        disable_nvimtree_bg = true,
      })
      vim.cmd("colorscheme vscode")
    end,
  },

  -- Greeting Screen
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                     ]],
        [[       ████ ██████           █████      ██                     ]],
        [[      ███████████             █████                             ]],
        [[      █████████ ███████████████████ ███   ███████████   ]],
        [[     █████████  ███    █████████████ █████ ██████████████   ]],
        [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
        [[                                                                       ]],
        [[                                                                       ]],
        [[                                                                       ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button( "e", "  > New file" , ":ene <BAR> startinsert <CR>"),
        dashboard.button( "f", "  > Find file", ":cd $HOME/Brkdev | Telescope find_files<CR>"),
        dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
        dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
        dashboard.button( "q", "  > Quit", ":qa<CR>"),
      }

      alpha.setup(dashboard.opts)
    end,
  },

  -- Status Line
  { 
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require("lualine").setup({
        options = { theme = 'gruvbox' },
        sections = {
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
          }
        }
      })
    end,
  },

  -- Golang
  {
    "fatih/vim-go",
    config = function ()
      -- we disable most of these features because treesitter and nvim-lsp
      -- take care of it
      vim.g['go_gopls_enabled'] = 0
      vim.g['go_code_completion_enabled'] = 0
      vim.g['go_fmt_autosave'] = 0
      vim.g['go_imports_autosave'] = 0
      vim.g['go_mod_fmt_autosave'] = 0
      vim.g['go_doc_keywordprg_enabled'] = 0
      vim.g['go_def_mapping_enabled'] = 0
      vim.g['go_textobj_enabled'] = 0
      vim.g['go_list_type'] = 'quickfix'
    end,
  },

  -- Tree Sitter
  { 
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'bash', 'dockerfile', 'fish', 'go', 'gomod', 'helm', 'html', 'java', 'javascript', 'json',
          'markdown', 'markdown_inline', 'nginx', 'python', 'sql', 'terraform', 'toml', 'vim', 'vimdoc',
          'yaml',
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<space>", -- maps in normal mode to init the node/scope selection with space
            node_incremental = "<space>", -- increment to the upper named parent
            node_decremental = "<bs>", -- decrement to the previous node
            scope_incremental = "<tab>", -- increment to the upper scope (as defined in locals.scm)
          },
        },
        autopairs = {
          enable = true,
        },
        highlight = {
          enable = true,

          -- Disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ["iB"] = "@block.inner",
              ["aB"] = "@block.outer",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']]'] = '@function.outer',
            },
            goto_next_end = {
              [']['] = '@function.outer',
            },
            goto_previous_start = {
              ['[['] = '@function.outer',
            },
            goto_previous_end = {
              ['[]'] = '@function.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>sn'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>sp'] = '@parameter.inner',
            },
          },
        },
      })
    end,
  },

  -- Treesitter Context
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      mode = "cursor",
      max_lines = 4,
      trim_scope = "outer",
      min_window_height = 8,
      separator = "─",
      patterns = {
        go = {
          "function_declaration",
          "method_declaration",
          "type_declaration",
        },
      },
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
    end,
  },

  -- Search selection via *
  { 'bronson/vim-visual-star-search' },

  -- Git
  {
    'dinhhuy258/git.nvim',
    config = function ()
      require("git").setup()
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        filters = {
          dotfiles = false,
        },
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return {
              desc = 'nvim-tree: ' .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
          vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))
          vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
          vim.keymap.set('n', '<leader>h', '<C-w>h', { desc = "Move left pane" })
          vim.keymap.set('n', '<leader>j', '<C-w>j', { desc = "Move down pane" })
          vim.keymap.set('n', '<leader>k', '<C-w>k', { desc = "Move up pane" })
          vim.keymap.set('n', '<leader>l', '<C-w>l', { desc = "Move right pane" })
        end
      })
    end,
  },

  -- Save last cursor position
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
        lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
        lastplace_open_folds = true
      })
    end,
  },

  { 
    "AndrewRadev/splitjoin.vim"
  },

  {
    "windwp/nvim-autopairs",
    config = function() 
      local npairs = require("nvim-autopairs")
      npairs.setup {
        check_ts = true,
      }

      -- Remove backtick pairing
      local Rule = require('nvim-autopairs.rule')
      npairs.remove_rule('`')
    end
  },

  -- Markdown etc. preview
  {
    'brianhuster/live-preview.nvim',
    dependencies = {
      'ibhagwan/fzf-lua',
      'folke/snacks.nvim',
    },
  },

  -- { -- Fuzzy Finder (files, lsp, etc)
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function() 
      require("fzf-lua").register_ui_select()
      require('fzf-lua').setup {
        oldfiles = {
          -- include current sessions in old_files mode
          include_current_session = true,
        },
        winopts = {
          -- split = "belowright 10new",
          backdrop = 100,
          border = "rounded",

          preview = {
            default = "bat",
            hidden = false,
            border = "rounded",
            layout = "vertical",
            vertical = "down:60%",
            title = true,
            title_pos = "center",
          },
        },
        git = {
          files = {
            cwd_header = false,
            prompt        = '❯ ',
            cmd           = 'git ls-files --exclude-standard',
            multiprocess  = true,  -- run command in a separate process
            git_icons     = true, -- show git icons?
            file_icons    = true, -- show file icons (true|"devicons"|"mini")?
            color_icons   = true, -- colorize file|git icons
          },
        },
        files = {
          git_files = false,
          cwd_header = false,
          cwd_prompt = true,
          file_icons = true,
        }
      }

    end
  },

  -- { -- Fuzzy Finder (files, lsp, etc)
  --   'nvim-telescope/telescope.nvim',
  --   event = 'VimEnter',
  --   branch = '0.1.x',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     { -- If encountering errors, see telescope-fzf-native README for installation instructions
  --       'nvim-telescope/telescope-fzf-native.nvim',
  --
  --       -- `build` is used to run some command when the plugin is installed/updated.
  --       -- This is only run then, not every time Neovim starts up.
  --       build = 'make',
  --
  --       -- `cond` is a condition used to determine whether this plugin should be
  --       -- installed and loaded.
  --       cond = function()
  --         return vim.fn.executable 'make' == 1
  --       end,
  --     },
  --     { 'nvim-telescope/telescope-ui-select.nvim' },
  --
  --     -- Useful for getting pretty icons, but requires a Nerd Font.
  --     { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  --   },
  --
  --   config = function()
  --     require('telescope').setup {
  --       defaults = {
  --         layout_strategy = 'center',
  --         sorting_strategy = "ascending",
  --         layout_config = {
  --           prompt_position = "top"  -- search bar at the top
  --         },
  --       },
  --       extensions = {
  --         ['ui-select'] = {
  --           require('telescope.themes').get_dropdown(),
  --         },
  --       },
  --       picker = {
  --         find_files = {
  --           theme = "dropdown",
  --         }
  --       }
  --     }
  --
  --     -- Enable Telescope extensions if they are installed
  --     pcall(require('telescope').load_extension, 'fzf')
  --     pcall(require('telescope').load_extension, 'ui-select')
  --
  --     -- See `:help telescope.builtin`
  --     local builtin = require 'telescope.builtin'
  --     vim.keymap.set('n', '<C-p>', builtin.git_files, {})
  --     vim.keymap.set('n', '<C-b>', builtin.find_files, {})
  --     vim.keymap.set('n', '<C-g>', builtin.lsp_document_symbols, {})
  --     vim.keymap.set('n', '<leader>td', builtin.diagnostics, {})
  --     vim.keymap.set('n', '<leader>gs', builtin.grep_string, {})
  --     vim.keymap.set('n', '<leader>gg', builtin.live_grep, {})
  --   end,
  -- },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },

  { 'Bilal2453/luvit-meta', lazy = true },

  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      'saghen/blink.cmp',

    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        gopls = {
          capabilities = capabilities,
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'gofumpt', -- Used to format Go code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { "rafamadriz/friendly-snippets" },

  -- autocompletion
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = { 
        preset = 'enter',
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_next", "snippet_forward", "fallback" },
      },
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = { 
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
        },
        menu = {
          border = 'rounded',
          draw = {
            treesitter = { 'lsp' },
          },
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets'},
      },
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },


  -- DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
      "nvim-neotest/nvim-nio"
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup()
    end,
    ft = "go",
  },

})

----------------
--- SETTINGS ---
----------------

-- disable netrw at the very start of our init.lua, because we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true -- Enable 24-bit RGB colors

vim.opt.number = true        -- Don't show line numbers
vim.opt.relativenumber = true -- Show relative numbers
vim.opt.showmatch = true     -- Highlight matching parenthesis
vim.opt.splitright = true    -- Split windows right to the current windows
vim.opt.splitbelow = true    -- Split windows below to the current windows
vim.opt.autowrite = true     -- Automatically save before :next, :make etc.
vim.opt.autochdir = true     -- Change CWD when I open a file

vim.opt.mouse = 'a'                -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'  -- Copy/paste to system clipboard
vim.opt.swapfile = false           -- Don't use swapfile
vim.opt.ignorecase = true          -- Search case insensitive...
vim.opt.smartcase = true           -- ... but not it begins with upper case 
vim.opt.completeopt = 'menuone,noinsert,noselect'  -- Autocomplete options

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "undo"

-- Indent Settings
-- I'm in the Spaces camp (sorry Tabs folks), so I'm using a combination of
-- settings to insert spaces all the time. 
vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.shiftwidth = 2    -- number of spaces to use for each step of indent.
vim.opt.tabstop = 2       -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = true

-- This comes first, because we have mappings that depend on leader
-- With a map leader it's possible to do extra key combinations
-- i.e: <leader>w saves the current file
vim.g.mapleader = ','

-- Fast saving
vim.keymap.set('n', '<Leader>w', ':write!<CR>')
vim.keymap.set('n', '<Leader>q', ':q!<CR>', { silent = true })

-- Center cursor after navigation
vim.keymap.set('n', '{', '{zz')
vim.keymap.set('n', '}', '}zz')
vim.keymap.set("n", "j", function()
  if vim.v.count > 1 then
    vim.cmd.normal({ vim.v.count .. "gj", bang = true })
    vim.cmd.normal({ "zz", bang = true })
  else
    vim.cmd.normal({ "j", bang = true })
  end
end, { noremap = true })
vim.keymap.set("n", "k", function()
  if vim.v.count > 1 then
    vim.cmd.normal({ vim.v.count .. "gk", bang = true })
    vim.cmd.normal({ "zz", bang = true })
  else
    vim.cmd.normal({ "k", bang = true })
  end
end, { noremap = true })


-- Some useful quickfix shortcuts for quickfix
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-m>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>a', '<cmd>cclose<CR>')

-- Exit on jj and jk
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('i', 'jk', '<ESC>')

-- Remove search highlight
vim.keymap.set('n', '<Leader><space>', ':nohlsearch<CR>')

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
vim.keymap.set('n', 'n', 'nzzzv', {noremap = true})
vim.keymap.set('n', 'N', 'Nzzzv', {noremap = true})

-- Don't jump forward if I higlight and search for a word
local function stay_star()
  local sview = vim.fn.winsaveview()
  local args = string.format("keepjumps keeppatterns execute %q", "sil normal! *")
  vim.api.nvim_command(args)
  vim.fn.winrestview(sview)
end
vim.keymap.set('n', '*', stay_star, {noremap = true, silent = true})

-- We don't need this keymap, but here we are. If I do a ctrl-v and select
-- lines vertically, insert stuff, they get lost for all lines if we use
-- ctrl-c, but not if we use ESC. So just let's assume Ctrl-c is ESC.
vim.keymap.set('i', '<C-c>', '<ESC>')

-- If I visually select words and paste from clipboard, don't replace my
-- clipboard with the selected word, instead keep my old word in the
-- clipboard
vim.keymap.set("x", "p", "\"_dP")

-- rename the word under the cursor 
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Better split switching
vim.keymap.set('', '<C-j>', '<C-W>j')
vim.keymap.set('', '<C-k>', '<C-W>k')
vim.keymap.set('', '<C-h>', '<C-W>h')
vim.keymap.set('', '<C-l>', '<C-W>l')

-- Visual linewise up and down by default (and use gj gk to go quicker)
vim.keymap.set('n', '<Up>', 'gk')
vim.keymap.set('n', '<Down>', 'gj')

-- Yanking a line should act like D and C
vim.keymap.set('n', 'Y', 'y$')

-- we don't use netrw (because of nvim-tree), hence re-implement gx to open
-- links in browser
vim.keymap.set("n", "gx", '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>')

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("help_window_right", {}),
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == 'help' then vim.cmd.wincmd("L") end
  end
})

-- git.nvim
vim.keymap.set('n', '<leader>gb', '<CMD>lua require("git.blame").blame()<CR>')
vim.keymap.set('n', '<leader>go', "<CMD>lua require('git.browse').open(false)<CR>")
vim.keymap.set('x', '<leader>go', ":<C-u> lua require('git.browse').open(true)<CR>")
vim.keymap.set('n', '<leader>gid', '<CMD>lua require("git.diff").open()<CR>')

-- old habits 
vim.api.nvim_create_user_command("GBrowse", 'lua require("git.browse").open(true)<CR>', {
  range = true,
  bang = true,
  nargs = "*",
})

-- File-tree mappings
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true })
vim.keymap.set('n', '<leader>f', ':NvimTreeFindFileToggle!<CR>', { noremap = true })

-- vim-go
vim.keymap.set('n', '<leader>b', build_go_files)
vim.api.nvim_create_user_command("A", ":lua vim.api.nvim_call_function('go#alternate#Switch', {true, 'edit'})<CR>", {})
vim.api.nvim_create_user_command("AV", ":lua vim.api.nvim_call_function('go#alternate#Switch', {true, 'vsplit'})<CR>", {})
vim.api.nvim_create_user_command("AS", ":lua vim.api.nvim_call_function('go#alternate#Switch', {true, 'split'})<CR>", {})

-- Go uses gofmt, which uses tabs for indentation and spaces for aligment.
-- Hence override our indentation rules.
vim.api.nvim_create_autocmd('Filetype', {
  group = vim.api.nvim_create_augroup('setIndent', { clear = true }),
  pattern = { 'go' },
  command = 'setlocal noexpandtab tabstop=4 shiftwidth=4'
})


-- automatically resize all vim buffers if I resize the terminal window
vim.api.nvim_command('autocmd VimResized * wincmd =')

-- https://github.com/neovim/neovim/issues/21771
local exitgroup = vim.api.nvim_create_augroup('setDir', { clear = true })
vim.api.nvim_create_autocmd('DirChanged', {
  group = exitgroup,
  pattern = { '*' },
  command = [[call chansend(v:stderr, printf("\033]7;file://%s\033\\", v:event.cwd))]],
})

vim.api.nvim_create_autocmd('VimLeave', {
  group = exitgroup,
  pattern = { '*' },
  command = [[call chansend(v:stderr, "\033]7;\033\\")]],
})


-- put quickfix window always to the bottom
local qfgroup = vim.api.nvim_create_augroup('changeQuickfix', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  group = qfgroup,
  command = 'wincmd J',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  group = qfgroup,
  command = 'setlocal wrap',
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- disable diagnostics, I didn't like them
vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

-- Run gofmt/gofmpt, import packages automatically on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('setGoFormatting', { clear = true }),
  pattern = '*.go',
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end

    vim.lsp.buf.format()
  end
})

-- File Tree
vim.api.nvim_create_autocmd({ "TabNew" }, {
  callback = function()
    require("nvim-tree.api").tree.open()
    vim.cmd("wincmd p")  -- move focus back to previous window
  end,
})


-- File finder
vim.keymap.set("n", "<C-p>", require("fzf-lua").git_files, {})
vim.keymap.set("n", "<C-b>", require("fzf-lua").files, {})
vim.keymap.set("n", "<leader>gg", function() require("fzf-lua").live_grep() end, {})
vim.keymap.set("n", "<leader>gs", function() require("fzf-lua").grep_cword() end, {})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', 'gd', function () require('fzf-lua').lsp_definitions() end, opts)
    vim.keymap.set('n', '<leader>v', "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set('n', '<leader>s', "<cmd>belowright split | lua vim.lsp.buf.definition()<CR>", opts)

    vim.keymap.set('n', 'gr', function () require('fzf-lua').lsp_references() end, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', function () require('fzf-lua').lsp_implementations() end, opts)
    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

-- DAP
vim.keymap.set("n", "<leader>dt","<CMD>lua require('dap').toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>dc", "<CMD>lua require('dap').continue()<CR>")
vim.keymap.set("n", "<leader>dr", "<CMD>lua require('dap').repl.open()<CR>")
