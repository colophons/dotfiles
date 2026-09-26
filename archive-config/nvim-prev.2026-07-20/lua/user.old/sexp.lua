local M = {
  "tpope/vim-sexp-mappings-for-regular-people",
  "guns/vim-sexp"
}

function M.config()
end


-- These mappings supplement rather than replace the existing mappings (despite vim-sexp's best efforts to thwart this), so if you have muscle memory, fear not.
-- Motion mappings

-- Vim-sexp uses meta mappings to move element-wise. I've taken over the WORD motions--W, B, E, gE--instead, operating under the theory that those aren't nearly as useful in a language where so many punctuation marks are identifier characters. This might be a terrible idea.
-- List manipulation mappings

-- More meta madness in the defaults here. I've taken >f and <f to move a form and >e and <e to move an element.

-- Slurpage and barfage are handled by >), <), >(, and <(, where the angle bracket indicates the direction, and the parenthesis indicates which end to operate on.
-- Insertion mappings

-- Use <I and >I to insert at the beginning and ending of a form.
-- Mappings inspired by surround.vim

-- Note that surround.vim out of the box works great with the sexp.vim motions and text objects. Use ysaf), for example, to surround the current form with parentheses. To this, we add a few more mappings:

--     dsf: splice (delete surroundings of form)
--     cse(/cse)/cseb: surround element in parentheses
--     cse[/cse]: surround element in brackets
--     cse{/cse}: surround element in braces
return M
