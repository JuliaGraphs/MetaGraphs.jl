# Metagraphs files are simply JLD2 files.

struct MGFormat <: AbstractGraphFormat end
struct DOTFormat <: AbstractGraphFormat end

function loadmg end
function savemg end
function savedot end

loadgraph(fn::AbstractString, ::String, ::MGFormat) = loadmg(fn)
savegraph(fn::AbstractString, g::AbstractMetaGraph) = savemg(fn, g)

function savegraph(fn::AbstractString, g::AbstractMetaGraph, ::DOTFormat)
    open(fn, "w") do fp
        savedot(fp, g)
    end
end
