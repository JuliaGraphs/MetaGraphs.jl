# MetaGraphs

[![Build Status][build-img]][build-url]
[![Codecov branch][codecov-img]][codecov-url]
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://juliagraphs.org/MetaGraphs.jl/dev/)

[MetaGraphs.jl](https://github.com/JuliaGraphs/MetaGraphs.jl) graphs with arbitrary metadata.

[build-img]: https://github.com/JuliaGraphs/Metagraphs.jl/workflows/CI/badge.svg?branch=master
[build-url]: https://github.com/JuliaGraphs/Metagraphs.jl/actions?query=workflow%3ACI
[codecov-img]: http://codecov.io/github/JuliaGraphs/Metagraphs.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/JuliaGraphs/Metagraphs.jl?branch=master

## Documentation
Full documentation is available on the [JuliaGraphs site](https://juliagraphs.org/MetaGraphs.jl/dev/).
Documentation for methods is also available via the Julia REPL help system.

## Installation
Installation is straightforward: from the Julia `pkg` prompt,
```julia
add MetaGraphs
```

## Example Usage
```julia
julia> using Graphs, MetaGraphs

# create a standard simplegraph
julia> g = path_graph(5)
{5, 4} undirected simple Int64 graph

# create a metagraph based on the simplegraph, with optional default edgeweight
julia> mg = MetaGraph(g, 3.0)
{5, 4} undirected Int64 metagraph with Float64 weights defined by :weight (default weight 3.0)

# create a directed metagraph based on the simplegraph, with optional default edgeweight
julia> mdg = MetaDiGraph(g, 3.0)
{5, 8} directed Int64 metagraph with Float64 weights defined by :weight (default weight 3.0)

# set some properties for the graph itself
julia> set_prop!(mg, :description, "This is a metagraph.")
Dict{Symbol,Any} with 1 entry:
  :description => "This is a metagraph."

# set properties on a vertex in bulk
julia> set_props!(mg, 1, Dict(:name=>"Susan", :id => 123))
true

# set individual properties
julia> set_prop!(mg, 2, :name, "John")
true

# set a property on an edge
julia> set_prop!(mg, Edge(1, 2), :action, "knows")
true

julia> using Dates: Date

# set another property on an edge by specifying source and destination
julia> set_prop!(mg, 1, 2, :since, Date("20170501", "yyyymmdd"))
Dict{Symbol,Any} with 2 entries:
  :since   => 2017-05-01
  :action => "knows"

# get all the properties for an element
julia> props(mg, 1)
Dict{Symbol,Any} with 2 entries:
  :id   => 123
  :name => "Susan"

# get a specific property by name
julia> get_prop(mg, 2, :name)
"John"

# delete a specific property
julia> rem_prop!(mg, 1, :name)
Dict{Symbol,Any} with 1 entry:
  :id => 123

# clear all properties for vertex 2
julia> clear_props!(mg, 2)
Dict{Symbol,Any} with 0 entries

# confirm there are no properties set for vertex 2
julia> props(mg, 2)
Dict{Symbol,Any} with 0 entries

# all Graphs.jl analytics work
julia> betweenness_centrality(mg)
5-element Array{Float64,1}:
 0.0
 0.5
 0.666667
 0.5
 0.0

# using weights
julia> mg = MetaGraph(complete_graph(3))
{3, 3} undirected Int64 metagraph with Float64 weights defined by :weight (default weight 1.0)

julia> enumerate_paths(dijkstra_shortest_paths(mg, 1), 3)
2-element Array{Int64,1}:
 1
 3

julia> set_prop!(mg, 1, 2, :weight, 0.2)
true

julia> set_prop!(mg, 2, 3, :weight, 0.6)
true

julia> enumerate_paths(dijkstra_shortest_paths(mg, 1), 3)
3-element Array{Int64,1}:
 1
 2
 3

# use vertex values as indices
julia> G = MetaGraph(100)
{100, 0} undirected Int64 metagraph with Float64 weights defined by :weight (default weight 1.0)

julia> for i in 1:100
           set_prop!(G, i, :name, "node$i")
       end

julia> set_indexing_prop!(G, :name)
Set(Symbol[:name])

# nodes can now be found by the value in the index
julia> G["node4", :name]
4

# You can also find the value of an index by the vertex number (note, this behavior will dominate if index values are also integers)
julia> G[4, :name]
"node4"

julia> set_prop!(G, 3, :name, "name3") # or set_indexing_prop!(G, 3, :name, "name3")
Set(Symbol[:name])
```
