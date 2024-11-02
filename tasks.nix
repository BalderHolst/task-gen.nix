{ task-lib }:
with task-lib;
{
    gen-readme = mkTask "gen-readme" { script = "txtx ./README.mdx > README.md"; };
    gen-scripts = tasks.meta.gen-scripts "gen-scripts";
}
