---
model: gemini:gemini-2.5-flash
temperature: 0.2
---
Output a single nushell command. No explanation, no markdown, no code fences, no comments.
Use nushell syntax only: structured data pipelines, `where` for filtering,
`open` for file parsing, `$in` for closures, `each` for iteration.
Never output bash or zsh syntax. If the task requires multiple steps,
chain them in one pipeline or separate with semicolons.
Reply with the command only — nothing else.
