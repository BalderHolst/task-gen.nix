{ mkTask }:
{

    # TODO: This assumes execution from the root of the project
    #: Generate a task to run the app which generates scripts in specified paths
    #:-  name: string - Name of the app which generates scripts (usually "gen-scripts")
    gen-scripts = name: mkTask "gen-scripts" { script = "nix run .#${name}"; };

    #: Check that the repository has no uncommitted changes and fail if so.
    #:-  msg: string - Message to display if there are uncommitted changes
    check-no-uncommited = msg: mkTask "check-no-uncommited" { script = ''
        git update-index --refresh > /dev/null
            git diff-index --quiet HEAD -- || {
                echo "${msg}"
                    exit 1
            }
        '';
    };
}
