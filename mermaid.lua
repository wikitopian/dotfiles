local has_mermaid = false

-- keys: pandoc-lowercased class; values: mermaid's actual keyword
local mermaid_types = {
  ["mermaid"] = "mermaid",
  ["graph"] = "graph", ["flowchart"] = "flowchart",
  ["sequencediagram"] = "sequenceDiagram",
  ["classdiagram"] = "classDiagram",
  ["statediagram"] = "stateDiagram", ["statediagram-v2"] = "stateDiagram-v2",
  ["erdiagram"] = "erDiagram",
  ["journey"] = "journey",
  ["gantt"] = "gantt",
  ["pie"] = "pie",
  ["quadrantchart"] = "quadrantChart",
  ["requirementdiagram"] = "requirementDiagram",
  ["gitgraph"] = "gitGraph",
  ["c4context"] = "C4Context", ["c4container"] = "C4Container",
  ["c4component"] = "C4Component", ["c4deployment"] = "C4Deployment",
  ["mindmap"] = "mindmap",
  ["timeline"] = "timeline",
  ["zenuml"] = "zenuml",
  ["sankey"] = "sankey",
  ["xychart"] = "xychart", ["xychart-beta"] = "xychart-beta",
  ["block"] = "block", ["block-beta"] = "block-beta",
  ["packet"] = "packet",
  ["kanban"] = "kanban",
  ["architecture"] = "architecture", ["architecture-beta"] = "architecture-beta",
  ["radar"] = "radar",
  ["treemap"] = "treemap",
  ["venn"] = "venn",
}

function CodeBlock(block)
  local lang = block.classes[1]
  local keyword = lang and mermaid_types[lang]
  if keyword then
    has_mermaid = true
    local text = keyword == "mermaid" and block.text or keyword .. "\n" .. block.text
    return pandoc.RawBlock("html",
      '<pre class="mermaid">\n' .. text .. "\n</pre>")
  end
end

function Meta(meta)
  if has_mermaid then
    local script = pandoc.RawBlock("html",
      '<script type="module">'
      .. 'import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";'
      .. "</script>")
    local existing = meta["header-includes"]
    if existing then
      existing[#existing + 1] = script
    else
      meta["header-includes"] = pandoc.MetaBlocks({ script })
    end
    return meta
  end
end

return { { CodeBlock = CodeBlock }, { Meta = Meta } }
