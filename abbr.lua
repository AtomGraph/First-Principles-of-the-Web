-- abbr.lua — wrap known abbreviations in <abbr title="…"> on first use per page.
--
-- The single-source markdown stays clean; expansions live here. Because this is a
-- pandoc AST filter operating on Str inlines only, it automatically skips inline
-- code, fenced/mermaid code blocks, and link targets. The glossary is a curated
-- allow-list, so the book's apparatus labels (S1–S4, R1–R4), Part numerals
-- (II, III, IV), and mermaid tokens (LR, TB, AN, SY) are never matched.
--
-- To cover every occurrence instead of first-use-per-page, set ALL_OCCURRENCES.

local ALL_OCCURRENCES = false

local abbr = {
  ["RFC"]    = "Request for Comments",
  ["RDF"]    = "Resource Description Framework",
  ["RDFC"]   = "RDF Dataset Canonicalization",
  ["URI"]    = "Uniform Resource Identifier",
  ["IRI"]    = "Internationalized Resource Identifier",
  ["URL"]    = "Uniform Resource Locator",
  ["SPARQL"] = "SPARQL Protocol and RDF Query Language",
  ["JSON"]   = "JavaScript Object Notation",
  ["XML"]    = "Extensible Markup Language",
  ["XSLT"]   = "Extensible Stylesheet Language Transformations",
  ["XSD"]    = "XML Schema Definition",
  ["IXSL"]   = "Interactive XSLT",
  ["HTTP"]   = "Hypertext Transfer Protocol",
  ["HTML"]   = "Hypertext Markup Language",
  ["CSS"]    = "Cascading Style Sheets",
  ["DOM"]    = "Document Object Model",
  ["W3C"]    = "World Wide Web Consortium",
  ["WWW"]    = "World Wide Web",
  ["WHATWG"] = "Web Hypertext Application Technology Working Group",
  ["TAG"]    = "Technical Architecture Group",
  ["AWWW"]   = "Architecture of the World Wide Web",
  ["REST"]   = "Representational State Transfer",
  ["API"]    = "application programming interface",
  ["UI"]     = "user interface",
  ["SPA"]    = "single-page application",
  ["JS"]     = "JavaScript",
  ["SSR"]    = "server-side rendering",
  ["RSC"]    = "React Server Components",
  ["ORM"]    = "object-relational mapping",
  ["DTO"]    = "data transfer object",
  ["MVC"]    = "Model–View–Controller",
  ["CRUD"]   = "create, read, update, delete",
  ["VM"]     = "virtual machine",
  ["BGP"]    = "basic graph pattern",
  ["CRDT"]   = "conflict-free replicated data type",
  ["CALM"]   = "Consistency As Logical Monotonicity",
  ["LDP"]    = "Linked Data Platform",
  ["WAC"]    = "Web Access Control",
  ["BCP"]    = "Best Current Practice",
  ["REC"]    = "W3C Recommendation",
}

local seen = {}

local function esc(s)
  return (s:gsub("&", "&amp;"):gsub('"', "&quot;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

function Str(el)
  -- html output only; other formats keep the plain text untouched
  if not (FORMAT and FORMAT:match("html")) then return nil end

  -- split "(RDF)," into  lead="("  core="RDF"  trail=")," ; core must be a whole token
  local lead, core, trail = el.text:match("^(%W*)(%w+)(.*)$")
  if not core or not trail:match("^%W*$") then return nil end

  -- direct hit, else a simple plural (URIs -> URI + s)
  local key, suffix = core, ""
  if not abbr[key] and key:match("s$") then
    local singular = key:sub(1, -2)
    if abbr[singular] then key, suffix = singular, "s" end
  end
  if not abbr[key] then return nil end
  if not ALL_OCCURRENCES and seen[key] then return nil end
  seen[key] = true

  local html = lead
    .. '<abbr title="' .. esc(abbr[key]) .. '">' .. key .. "</abbr>"
    .. suffix .. trail
  return pandoc.RawInline("html", html)
end
