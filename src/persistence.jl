# Metagraphs files are simply JLD2 files.

struct MGFormat <: AbstractGraphFormat end
struct DOTFormat <: AbstractGraphFormat end

function loadmg(fn::AbstractString)
    @load fn g
    return g
end

function savemg(fn::AbstractString, g::AbstractMetaGraph)
    @save fn g
    return 1
end

loadgraph(fn::AbstractString, gname::String, ::MGFormat) = loadmg(fn)
savegraph(fn::AbstractString, g::AbstractMetaGraph) =  savemg(fn, g)

# escaping unescaped quotation marks
# i.e. replacing `"`` with `\"` while leaving `\"` as is
escape_quotes(s::AbstractString) = replace(s, r"([^\\])\"" => s"\1\\\\\"")

# According to the DOT language specification https://graphviz.org/doc/info/lang.html
# we can quote everyhthing that's not an XML/HTML literal
function quote_prop(p::AbstractString)
    if  occursin(r"<+.*>+$", p)
        # The label is an HTML string, no additional quotes here.
        return p
    else
        return "\"" * escape_quotes(p) * "\""
    end
end
# if the property value is _not_ a string it cannot be XML/HTML literal, so just put it in quotes
quote_prop(p::Any) = "\"" * escape_quotes(string(p)) * "\""
# NOTE: down there I only quote property _values_. DOT allows quoting property _names_ too
# I don't do that as long as names are Symbols and can't have spaces and commas and stuff.
# That will break if someone uses a DOT keyword as a property name, as they must be quoted.

function savedot(io::IO, g::AbstractMetaGraph)

    if is_directed(g)
        write(io, "digraph G {\n")
        dash = "->"
    else
        write(io, "graph G {\n")
        dash = "--"
    end

    for p in props(g)
        write(io, "$(p[1])=$(quote_prop(p[2]));\n")
    end

    for v in vertices(g)
        write(io, "$v")
        if length(props(g, v)) > 0
            write(io, " [ ")

            for p in props(g, v)
                write(io, "$(p[1])=$(quote_prop(p[2])), ")
            end

            write(io, "];")
        end
        write(io, "\n")
    end

    for e in edges(g)
        write(io, "$(src(e)) $dash $(dst(e)) [ ")
        for p in props(g,e)
            write(io, "$(p[1])=$(quote_prop(p[2])), ")
        end
        write(io, "]\n")
    end
    write(io, "}\n")
end

function savegraph(fn::AbstractString, g::AbstractMetaGraph, ::DOTFormat)
    open(fn, "w") do fp
        savedot(fp, g)
    end
end
