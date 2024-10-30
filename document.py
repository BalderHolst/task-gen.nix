#!/usr/bin/env python3

import sys

DOCSTRING_BEGIN = "#:"

class Symbol:
    def __init__(self, name, desc, line):
        self.name = name
        self.desc = desc
        self.line = line

    def to_markdown(self):
        return f"`{self.name}`\n{self.desc}\n"

    def __repr__(self):
        return f"Symbol({self.name}, {self.desc}, {self.line})"

class Parser:
    def __init__(self, lines):
        self.cursor = 0
        self.lines = lines
        self.symbols = []

    def get_line(self):
        return self.lines[self.cursor]

    def parse_symbol(self):
        desc_lines = []
        line = self.get_line().strip()
        while line.startswith(DOCSTRING_BEGIN):
            desc_lines.append(line[len(DOCSTRING_BEGIN):].strip())
            self.cursor += 1
            line = self.get_line().strip()

        name = line.split(" = ")[0]
        self.symbols.append(Symbol(name, "\n".join(desc_lines), self.cursor))

    def parse(self):
        while self.cursor < len(self.lines):
            line = self.lines[self.cursor].strip()
            if line.startswith(DOCSTRING_BEGIN):
                self.parse_symbol()
            self.cursor += 1

    def get_symbols(self):
        return self.symbols

def main():

    # Pull file from argv

    if len(sys.argv) != 2:
        print(f"Usage: python3 {sys.argv[0]} <filename>")
        sys.exit(1)

    filename = sys.argv[1]

    with open(filename, 'r') as f:
        lines = f.readlines()

    parser = Parser(lines)
    parser.parse()

    for sym in parser.get_symbols():
        print(sym.to_markdown())


if __name__ == '__main__':
    main()
