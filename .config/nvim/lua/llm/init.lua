
local M = {}
local llm = require("llm.llm_core")
local system_prompt = require("llm.system_prompt")

local get_system_prompt = function(model, company)
    local prompt = system_prompt.system_prompt
    prompt = string.gsub(prompt, "Anthropic", company)
    prompt = string.gsub(prompt, "anthropic", company)
    prompt = string.gsub(prompt, "Claude", model)
    prompt = string.gsub(prompt, "claude", model)
    return prompt .. system_prompt.assistant_prompt
end

M.config = {
    buffer_name = "ask77.md",
    keymaps = {
        open_chat = "<leader>mo",
        send_request = "<leader>mc",
        send_request_replace = "<leader>mr",
        toggle_llm_provider = "<leader>mt",
    },
    llm_opts = {
        anthropic = {
            url = "https://api.anthropic.com/v1/messages",
            model = "claude-3-7-sonnet-20250219",
            api_key_name = "ANTHROPIC_API_KEY",
            system_prompt = get_system_prompt("Claude", "Anthropic"),
        },
        anthropic_reason = {
            url = "https://api.anthropic.com/v1/messages",
            model = "claude-3-7-sonnet-20250219",
            api_key_name = "ANTHROPIC_API_KEY",
            system_prompt = get_system_prompt("Claude", "Anthropic"),
        },
        deepseek = {
            url = "https://api.deepseek.com/chat/completions",
            model = "deepseek-chat",
            api_key_name = "DEEPSEEK_API_KEY",
            system_prompt = get_system_prompt("Deepseek Chat", "Deepseek"),
        },
        deepinfra = {
            url = "https://api.deepinfra.com/v1/openai/chat/completions",
            model = "NousResearch/Hermes-3-Llama-3.1-405B",
            api_key_name = "DEEPINFRA_API_KEY",
            system_prompt = get_system_prompt("Hermes-3-Llama-3.1-405B", "NousResearch"),
        },
        openai = {
            url = "https://api.openai.com/v1/chat/completions",
            model = "gpt-4o-2024-11-20",
            api_key_name = "OPENAI_API_KEY",
            system_prompt = get_system_prompt("GPT-4o", "OpenAI"),
        },
        gemini = {
            url = "https://generativelanguage.googleapis.com/v1beta/models/",
            model = "gemini-2.0-flash",
            api_key_name = "GOOGLE_AI_API_KEY",
            system_prompt = get_system_prompt("Gemini-2.0-Flash", "Google"),
        }
    },
    default_llm_provider = "gemini",
}

local function get_or_create_chat_buffer()
    local bufnr = vim.fn.bufnr(M.config.buffer_name)

    if bufnr == -1 then
        bufnr = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_set_name(bufnr, M.config.buffer_name)

        vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')  -- Don't save to disk
        vim.api.nvim_buf_set_option(bufnr, 'swapfile', false)    -- Don't create swap file
        vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)   -- Allow modifications
        vim.api.nvim_buf_set_option(bufnr, 'filetype', 'markdown')  -- Set markdown highlighting
    end

    vim.api.nvim_set_current_buf(bufnr)
    vim.wo.wrap = true              -- Enable line wrapping
    vim.wo.linebreak = true         -- Wrap at word boundaries
    vim.wo.breakindent = true       -- Preserve indentation when wrapping

    return bufnr
end

function M.open_chat()
    local bufnr = vim.fn.bufnr(M.config.buffer_name)
    if bufnr == vim.api.nvim_get_current_buf() then
        vim.cmd('b#')
        vim.wo.wrap = false
    else
        get_or_create_chat_buffer()
        print(vim.g.llm_provider)
    end
end

function M.send_request(replace)
    local make_curl_args_fn = llm.make_curl_args_fn[vim.g.llm_provider]
    local handle_data_fn = llm.handle_data_fn[vim.g.llm_provider]
    local opts = vim.deepcopy(M.config.llm_opts[vim.g.llm_provider])
    opts.replace = replace

    llm.invoke_llm_and_stream_into_editor(opts, make_curl_args_fn, handle_data_fn)
end

function M.toggle_llm_provider()
    local providers = { "anthropic", "anthropic_reason", "openai", "gemini", "deepseek", "deepinfra" }
    local current_index

    for i, v in ipairs(providers) do
        if v == vim.g.llm_provider then
            current_index = i
            break
        end
    end

    current_index = (current_index + 1) % (#providers + 1)
    if current_index == 0 then
        current_index = 1
    end
    vim.g.llm_provider = providers[current_index]
    print(vim.g.llm_provider)
end

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})

    vim.g.llm_provider = M.config.default_llm_provider
    vim.g.show_token_count = false
    vim.g.tmp_anthropic_state = nil

    vim.keymap.set({ 'n', 'v' }, M.config.keymaps.open_chat,
        M.open_chat,
        { noremap = true, silent = true }
    )
    vim.keymap.set({ 'n', 'v' }, M.config.keymaps.send_request,
        function()
            M.send_request(false)
        end,
        { noremap = true, silent = true }
    )
    vim.keymap.set({ 'n', 'v' }, M.config.keymaps.send_request_replace,
        function()
            M.send_request(true)
        end,
        { noremap = true, silent = true }
    )
    vim.keymap.set({ 'n', 'v' }, M.config.keymaps.toggle_llm_provider,
        M.toggle_llm_provider,
        { noremap = true, silent = true }
    )
end

return M
