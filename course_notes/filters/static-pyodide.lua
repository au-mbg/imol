-- Prepare Quarto Live content for static formats.
--
-- * Convert pyodide cells to plain Python code blocks.
-- * Hide setup, grading, and other non-student-facing pyodide cells.
-- * Render panel tabsets as labelled static sections instead of numbered
--   headings.

local hidden_true_options = {
  setup = true,
  check = true,
  hint = true,
  solution = true,
}

local hidden_false_options = {
  echo = true,
  include = true,
}

local function is_static_output()
  return FORMAT ~= "html" and FORMAT ~= "html5" and FORMAT ~= "revealjs"
end

local function list_includes(list, value)
  if list.includes then
    return list:includes(value)
  end

  for _, item in ipairs(list) do
    if item == value then
      return true
    end
  end

  return false
end

local function is_pyodide_block(code)
  return list_includes(code.classes, "pyodide") or
      list_includes(code.classes, "{pyodide}") or
      list_includes(code.classes, "{pyodide-python}")
end

local function is_panel_tabset(div)
  return list_includes(div.classes, "panel-tabset")
end

local function split_options_and_code(text)
  local option_lines = {}
  local code_lines = {}

  for line in (text .. "\n"):gmatch("(.-)\n") do
    line = line:gsub("\r$", "")
    local option = line:match("^%s*#|%s?(.*)$")

    if option ~= nil then
      table.insert(option_lines, option)
    else
      table.insert(code_lines, line)
    end
  end

  return option_lines, table.concat(code_lines, "\n")
end

local function parse_options(option_lines)
  if #option_lines == 0 then
    return {}
  end

  local yaml = "---\n" .. table.concat(option_lines, "\n") .. "\n---\n"
  local ok, doc = pcall(pandoc.read, yaml, "markdown")

  if not ok then
    error("Unable to parse pyodide cell options:\n" .. table.concat(option_lines, "\n"))
  end

  return doc.meta or {}
end

local function option_as_string(value)
  if value == nil then
    return nil
  end

  if type(value) == "boolean" then
    return tostring(value)
  end

  return pandoc.utils.stringify(value)
end

local function option_is_true(options, key)
  local value = options[key]

  if value == true then
    return true
  end

  local string_value = option_as_string(value)
  return string_value ~= nil and string.lower(string_value) == "true"
end

local function option_is_false(options, key)
  local value = options[key]

  if value == false then
    return true
  end

  local string_value = option_as_string(value)
  return string_value ~= nil and string.lower(string_value) == "false"
end

local function should_hide(options)
  for option, _ in pairs(hidden_true_options) do
    if option_is_true(options, option) then
      return true
    end
  end

  for option, _ in pairs(hidden_false_options) do
    if option_is_false(options, option) then
      return true
    end
  end

  return false
end

function CodeBlock(code)
  if not is_static_output() then
    return nil
  end

  if not is_pyodide_block(code) then
    return nil
  end

  local option_lines, clean_code = split_options_and_code(code.text)
  local options = parse_options(option_lines)

  if should_hide(options) then
    return {}
  end

  return pandoc.CodeBlock(
    clean_code,
    pandoc.Attr(code.identifier, { "python" }, code.attributes)
  )
end

local function labelled_tab(title, content)
  local blocks = pandoc.Blocks({
    pandoc.Para({ pandoc.Strong(title) })
  })

  blocks:extend(content)
  return blocks
end

function Div(div)
  if not is_static_output() then
    return nil
  end

  if not is_panel_tabset(div) then
    return nil
  end

  local blocks = pandoc.Blocks({})
  local current_title = nil
  local current_content = pandoc.Blocks({})

  local function flush()
    if current_title ~= nil then
      blocks:extend(labelled_tab(current_title, current_content))
    else
      blocks:extend(current_content)
    end
  end

  for _, block in ipairs(div.content) do
    if block.t == "Header" then
      flush()
      current_title = block.content
      current_content = pandoc.Blocks({})
    else
      current_content:insert(block)
    end
  end

  flush()

  return pandoc.Div(
    blocks,
    pandoc.Attr(div.identifier, { "static-tabset" }, div.attributes)
  )
end
