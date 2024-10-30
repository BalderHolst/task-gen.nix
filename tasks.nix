{ task-lib }:
with task-lib;
{

    hello = mkTask "hello" ''
        echo "Hello, World!"
    '';

}
