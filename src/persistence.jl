# Metagraphs files are simply JLD2 files.

struct MGFormat <: AbstractGraphFormat end
struct DOTFormat <: AbstractGraphFormat end

function loadmg(args...)
    error("In order to load static graphs from binary files, you need to load the JLD2.jl \
    package")
end

function savemg(args...)
    error("In order to save static graphs to binary files, you need to load the JLD2.jl \
    package")
end

function savedot(args...)
    error("In order to save static graphs to binary files, you need to load the JLD2.jl \
    package")
end

loadgraph(fn::AbstractString, ::String, ::MGFormat) = loadmg(fn)
savegraph(fn::AbstractString, g::AbstractMetaGraph) = savemg(fn, g)

function savegraph(fn::AbstractString, g::AbstractMetaGraph, ::DOTFormat)
    open(fn, "w") do fp
        savedot(fp, g)
    end
end
