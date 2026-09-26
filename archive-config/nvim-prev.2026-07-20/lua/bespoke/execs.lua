-- bespoke executables
local M = {}

M.decode = function()
  helpers.transform_selection({"base64", "--decode"})
end

-- dGhpcyBpcyBlbmNvZGVkIHRleHQK



M.embedded_svg_to_embedded_png = function()

  local embed = helpers.get_selection_text()
  local line1, col1, line2, col2 = unpack(helpers.get_selection_points())
  -- TODO: check that embed:sub(1, 27) ==  data:image/svg+xml;base64,
  if embed:sub(1, 26) ~= "data:image/svg+xml;base64," then
    vim.notify("This is not an embedded svg")
    return "This is not an embedded svg"
  end
  local strip = embed:sub(27)
  local decoded_svg = helpers.run({"base64", "--decode"}, strip)
  local encoded_png = helpers.run({"sh", "-c", "magick svg:- png:- | base64 -w0"}, decoded_svg)
  local embedded_png = "data:image/png;base64," .. encoded_png
  helpers.overwrite_range(embedded_png, line1, col1, line2, col2)
  return embedded_png
end

M.new_guid = function() 
  -- 8 4 4 4 12
  local longs = {}
  for i=1,8 do
    longs[i] = math.random(65536)
  end
  s = string.format(
    "%04x%04x-%04x-%04x-%04x-%04x%04x%04x",
    unpack(longs)
  ) 
  helpers.insert_at_point(s)
  return s
end

M.date_and_date = function()
  local endings = {
    ["01"] = "st",
    ["21"] = "st",
    ["02"] = "nd",
    ["22"] = "nd",
    ["03"] = "rd",
    ["23"] = "rd"
  }

  local ending = endings[os.date("%d")] or "th"
  local s = os.date("%Y-%m-%d :: %A, %B %d" .. ending)
  helpers.insert_at_point(s)
  return s
end

return M
