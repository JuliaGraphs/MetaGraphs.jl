module MetaGraphsJLD2Ext

using Graphs
using JLD2
using MetaGraphs

function MetaGraphs.loadmg(fn::AbstractString)
    @load fn g
    return g
end

function MetaGraphs.savemg(fn::AbstractString, g::AbstractMetaGraph)
    @save fn g
    return 1
end

end