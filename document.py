#!/usr/bin/env python3

import sys
from dataclasses import dataclass

MODULE_BEGIN   = "#!"
PROPERTY_BEGIN = "#:"
ARG_BEGIN      = "#:-"
RETURN_BEGIN   = "#:>"

assert ARG_BEGIN.startswith(PROPERTY_BEGIN)
assert RETURN_BEGIN.startswith(PROPERTY_BEGIN)

class Module:
    def __init__(self, name, desc, line, file):
        self.name = name
        self.desc = desc
        self.line = line
        self.file = file
        self.symbols = []

    def add_symbol(self, symbol):
        self.symbols.append(symbol)

    def to_markdown(self):
        desc  = f"### `{self.name}`\n"
        desc += f"{self.desc}\n\n"
        desc += "\n\n".join(map(lambda x: x.to_markdown(), self.symbols))
        return desc

    def __repr__(self) -> str:
        return f"Module({self.name}: {self.desc}, {len(self.symbols)} symbols)"

@dataclass
class Arg:
    name: str
    kind: str
    desc: str

    def to_markdown(self):
        if self.desc is None:
            return f"- `{self.name}`: `{self.kind}`"
        else:
            return f"- `{self.name}`: `{self.kind}` - {self.desc}"

    def __repr__(self):
        return f"Arg({self.name}, {self.kind})"

class Symbol:
    def __init__(self, name, desc, line, file, args, ret, ret_desc):
        self.name = name
        self.desc = desc
        self.line = line
        self.file = file
        self.args = args
        self.ret = ret
        self.ret_desc = ret_desc

    def add_arg(self, arg):
        self.args.append(arg)

    def to_markdown(self):
        s = f"#### **`{self.name}`** {' '.join(map(lambda x: f'*{x.name}*', self.args))}"
        s += "\n\n"
        s += self.desc
        s += "\n\n"

        # Maybe add "Args" section
        if len(self.args) > 0:
            args = "\n".join(map(lambda x: x.to_markdown(), self.args))
            s += f"*Args:*\n{args}\n\n"

        if self.ret is not None:
            s += f"Returns: `{self.ret}`"
            if self.ret_desc:
                s += f" - {self.ret_desc}"
            s += "\n\n"

        # Add source reference
        s += f"Source: [`{self.file}:{self.line}`]({self.file}?plain=1#L{self.line})\n\n"

        return s

    def __repr__(self):
        return f"Symbol({self.name}, {self.desc}, {self.line})"

class Parser:
    def __init__(self, lines, file):
        self.cursor = 0
        self.lines = lines
        self.symbols = []
        self.file = file

    def get_line(self):
        return self.lines[self.cursor]

    def parse_property(self):
        desc_lines = []
        args = []
        ret = None
        ret_desc = None
        line = self.get_line().strip()
        while line.startswith(PROPERTY_BEGIN):
            if line.startswith(ARG_BEGIN):
                line = line[len(ARG_BEGIN):].strip()
                desc = None
                if line.find(" - ") != -1:
                    [line, desc] = line.strip().split(" - ", 1)
                [name, kind] = line.split(": ", 1)
                args.append(Arg(name, kind, desc))
            elif line.startswith(RETURN_BEGIN):
                assert ret is None
                line = line[len(RETURN_BEGIN):].strip()
                if line.find(" - ") != -1:
                    [ret, ret_desc] = line.split(" - ", 1)
                    ret_desc = ret_desc.strip()
                else:
                    ret = line
                ret = ret.strip()

            else:
                desc_lines.append(line[len(PROPERTY_BEGIN):].strip())
            self.cursor += 1
            line = self.get_line().strip()

        name = line.split(" = ")[0]
        symbol = Symbol(name, "\n".join(desc_lines), self.cursor+1, self.file, args, ret, ret_desc)


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
        mod = Module(name, "\n".join(desc_lines), self.cursor, self.file)

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

    parser = Parser(lines, filename)
    parser.parse()

    for sym in parser.get_symbols():
        print(sym.to_markdown())


if __name__ == '__main__':
    main()
