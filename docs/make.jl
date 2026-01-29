using Documenter
using Graphs
using MetaGraphs

# index is equal to the README for the time being
cp(normpath(@__FILE__, "../../README.md"), normpath(@__FILE__, "../src/index.md"); force=true)

# same for license
cp(normpath(@__FILE__, "../../LICENSE.md"), normpath(@__FILE__, "../src/license.md"); force=true)

makedocs(
    modules = [MetaGraphs],
    sitename = "MetaGraphs",
    format = Documenter.HTML(prettyurls=get(ENV, "CI", nothing) == "true"),
    pages = Any[
        "Overview"             => "index.md",
        "API reference"        => "api.md",
        "License Information"  => "license.md",
    ],
)

deploydocs(repo="github.com/JuliaGraphs/MetaGraphs.jl.git", push_preview=true)

rm(normpath(@__FILE__, "../src/index.md"))
rm(normpath(@__FILE__, "../src/license.md"))
