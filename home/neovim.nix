# Neovim как IDE: тема base16-default-dark (та же палитра), дерево файлов,
# поиск, подсветка, подсказки и ошибки (LSP) для Nix, Python, LaTeX, Lua,
# автодополнение и форматирование. Пробел — главная клавиша (leader).
{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true; # команда vim тоже открывает neovim
    withPython3 = false;
    withRuby = false;

    # Языковые серверы и утилиты — видны только внутри neovim
    extraPackages = with pkgs; [
      nixd # Nix
      nixfmt # форматирование Nix
      basedpyright # Python
      ruff # Python: линтер и форматирование
      texlab # LaTeX
      lua-language-server # Lua
      ripgrep # поиск по проекту
      fd # поиск файлов
      wl-clipboard # общий буфер обмена
    ];

    plugins = with pkgs.vimPlugins; [
      base16-nvim
      (nvim-treesitter.withPlugins (g: [
        g.nix
        g.python
        g.lua
        g.bash
        g.latex
        g.markdown
        g.markdown_inline
        g.json
        g.toml
        g.yaml
        g.kdl
        g.vim
        g.vimdoc
      ]))
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-tree-lua
      nvim-web-devicons
      lualine-nvim
      gitsigns-nvim
      which-key-nvim
      nvim-lspconfig
      blink-cmp
      friendly-snippets
      conform-nvim
      nvim-autopairs
      indent-blankline-nvim
    ];

    initLua = ''
      -- ── Основное ───────────────────────────────────────────────────
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      vim.g.loaded_netrw = 1 -- вместо встроенного проводника — nvim-tree
      vim.g.loaded_netrwPlugin = 1

      local o = vim.opt
      o.number = true
      o.relativenumber = true
      o.cursorline = true
      o.signcolumn = "yes"
      o.tabstop = 2
      o.shiftwidth = 2
      o.expandtab = true
      o.smartindent = true
      o.wrap = false
      o.scrolloff = 8
      o.ignorecase = true
      o.smartcase = true
      o.splitright = true
      o.splitbelow = true
      o.undofile = true
      o.updatetime = 250
      o.mouse = "a"
      o.clipboard = "unnamedplus"
      o.termguicolors = true
      o.showmode = false
      pcall(function() o.winborder = "single" end) -- квадратные рамки у всплывающих окон

      -- ── Тема: та же палитра, что у всей системы ───────────────────
      vim.cmd.colorscheme("base16-default-dark")

      -- ── Подсветка синтаксиса (tree-sitter) ────────────────────────
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- ── Интерфейс ─────────────────────────────────────────────────
      require("nvim-web-devicons").setup()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = "│",
          section_separators = "",
          globalstatus = true,
        },
      })
      require("gitsigns").setup()
      require("which-key").setup()
      require("nvim-autopairs").setup()
      require("ibl").setup({ indent = { char = "│" }, scope = { enabled = false } })

      require("nvim-tree").setup({
        view = { width = 32 },
        renderer = { group_empty = true },
      })

      local telescope = require("telescope")
      telescope.setup({})
      pcall(telescope.load_extension, "fzf")

      -- ── Автодополнение ────────────────────────────────────────────
      require("blink.cmp").setup({
        keymap = { preset = "default" }, -- Ctrl+Space, Ctrl+Y принять, Ctrl+N/P
        sources = { default = { "lsp", "path", "snippets", "buffer" } },
        completion = { documentation = { auto_show = true } },
      })

      -- ── Языковые серверы ──────────────────────────────────────────
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      vim.lsp.config("nixd", {
        settings = { nixd = { formatting = { command = { "nixfmt" } } } },
      })
      vim.lsp.enable({ "nixd", "basedpyright", "ruff", "texlab", "lua_ls" })

      vim.diagnostic.config({
        virtual_text = { prefix = "■" },
        severity_sort = true,
      })

      -- ── Форматирование ────────────────────────────────────────────
      require("conform").setup({
        formatters_by_ft = {
          nix = { "nixfmt" },
          python = { "ruff_format" },
        },
      })

      -- ── Клавиши ───────────────────────────────────────────────────
      local map = vim.keymap.set
      local tb = require("telescope.builtin")
      map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Дерево файлов" })
      map("n", "<leader>ff", tb.find_files, { desc = "Найти файл" })
      map("n", "<leader>fg", tb.live_grep, { desc = "Найти текст" })
      map("n", "<leader>fb", tb.buffers, { desc = "Открытые файлы" })
      map("n", "<leader>fr", tb.oldfiles, { desc = "Недавние файлы" })
      map("n", "<leader>fd", tb.diagnostics, { desc = "Ошибки" })
      map("n", "gd", vim.lsp.buf.definition, { desc = "К определению" })
      map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Переименовать" })
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Действия" })
      map({ "n", "v" }, "<leader>cf", function()
        require("conform").format({ lsp_format = "fallback" })
      end, { desc = "Отформатировать" })
      map("n", "<leader>w", "<cmd>write<cr>", { desc = "Сохранить" })
      map("n", "<Esc>", "<cmd>nohlsearch<cr>")
    '';
  };
}
