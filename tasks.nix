{ task-lib }:
with task-lib;
rec {

    test = mkTask "test-lib" { script = /* bash */ ''
        TEST_DIR="`${task-lib.snips.git-find-root}`/test/tests"
        for test in $(ls $TEST_DIR); do
            echo "Running test $test... "
            nix eval --quiet --impure --expr "import $TEST_DIR/$test {}" > /dev/null || exit 1
        done

        echo "All tests passed!"
    ''; };

    gen-readme = mkTask "gen-readme" { script = "txtx ./README.mdx > README.md"; };
    update-examples = mkTask "update-examples" { script = /*bash*/ ''
        ls examples | while read example; do
            echo "Updating example: $example";
            nix flake update --flake ./examples/$example
        done
    ''; };
    update-flake = mkTask "update-flake" { script = "nix flake update"; };
    update = mkSeq "update" [update-flake update-examples];
    gen-scripts = gen.gen-scripts "gen-scripts";
    pre-push = mkSeq "pre-push" [
        gen-readme
        gen-scripts
        (task-lib.gen.check-no-uncommited "Please commit all changes before pushing")
    ];
}
