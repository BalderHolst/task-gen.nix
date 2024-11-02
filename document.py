#!/usr/bin/env python3

import sys

MODULE_BEGIN   = "#!"
PROPERTY_BEGIN = "#:"

class Module:
    def __init__(self, name, desc, line):
        self.name = name
        self.desc = desc
        self.line = line
        self.symbols = []

    def add_symbol(self, symbol):
        self.symbols.append(symbol)

    def to_markdown(self):
        desc  = f"#### `{self.name}`\n"
        desc += f"{self.desc}\n\n"
        desc += "\n\n".join(map(lambda x: x.to_markdown(), self.symbols))
        return desc

    def __repr__(self) -> str:
        return f"Module({self.name}: {self.desc}, {len(self.symbols)} symbols)"

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

    def parse_property(self):
        desc_lines = []
        line = self.get_line().strip()
        while line.startswith(PROPERTY_BEGIN):
            desc_lines.append(line[len(PROPERTY_BEGIN):].strip())
            self.cursor += 1
            line = self.get_line().strip()

        name = line.split(" = ")[0]
        symbol = Symbol(name, "\n".join(desc_lines), self.cursor)


        if len(self.symbols) > 0 and type(self.symbols[-1]) == Module:
            self.symbols[-1].add_symbol(symbol)
        else:
            self.symbols.append(symbol)

    def parse_module(self):
        desc_lines = []
        line = self.get_line().strip()
        while line.startswith(MODULE_BEGIN):
            desc_lines.append(line[len(MODULE_BEGIN):].strip())
            self.cursor += 1
            line = self.get_line().strip()

        name = line.split(" = ")[0]
        mod = Module(name, "\n".join(desc_lines), self.cursor)

        self.symbols.append(mod)

    def parse(self):
        while self.cursor < len(self.lines):
            line = self.lines[self.cursor].strip()
            if line.startswith(PROPERTY_BEGIN):
                self.parse_property()
            if line.startswith(MODULE_BEGIN):
                self.parse_module()
            self.cursor += 1

    def get_symbols(self):
        return self.symbols

def main():

    # Pull file from argv

    if len(sys.argv) != 2:
        print(f"Usage: python3 {sys.argv[0]} <filename>")
        sys.exit(1)

    filename = sys.argv[1]

    with open(filename) as f:
        lines = f.readlines()

    parser = Parser(lines)
    parser.parse()

    for sym in parser.get_symbols():
        print(sym.to_markdown())


if __name__ == '__main__':
    main()
