
vim.g.vimtex_view_method = "zathura"

function LatexClean()
    local filename = vim.fn.expand("%:p")
    if string.sub(filename, -4) == ".tex" then
        local base = string.sub(filename, 1, -5)
        -- local path = vim.fn.expand("%:h")
        os.execute("rm "..base..".aux")
        os.execute("rm "..base..".fdb_latexmk")
        os.execute("rm "..base..".fls")
        os.execute("rm "..base..".synctex.gz")
        os.execute("rm "..base..".log")
        os.execute("rm "..base..".out")
    else
        print("this is not a latex file")
    end
end

vim.keymap.set("n", "<leader>lc", "<cmd>lua LatexClean()<cr>",
    { noremap = true }
)
