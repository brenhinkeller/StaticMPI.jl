using StaticMPI
using Documenter

DocMeta.setdocmeta!(StaticMPI, :DocTestSetup, :(using StaticMPI); recursive=true)

makedocs(;
    modules=[StaticMPI],
    authors="C. Brenhin Keller",
    repo="https://github.com/brenhinkeller/StaticMPI.jl/blob/{commit}{path}#{line}",
    sitename="StaticMPI.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://brenhinkeller.github.io/StaticMPI.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/brenhinkeller/StaticMPI.jl",
    devbranch="main",
)
