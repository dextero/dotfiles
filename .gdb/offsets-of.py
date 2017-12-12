import gdb

class Offsets(gdb.Command):
    def __init__(self):
        super (Offsets, self).__init__ ('offsets-of', gdb.COMMAND_DATA)
        print('offsets-of loaded')

    def invoke(self, arg, from_tty):
        argv = gdb.string_to_argv(arg)
        if len(argv) != 1:
            raise gdb.GdbError('offsets-of takes exactly 1 argument.')

        stype = gdb.lookup_type(argv[0])

        print('format: offset (size+padding) field')
        print(argv[0] + ' {')

        fields = [ f for f in stype.fields() ]
        totalPadding = 0

        for i in range(len(fields)):
            currField = fields[i]
            nextField = fields[i + 1] if i + 1 < len(fields) else None

            offset = currField.bitpos // 8
            if nextField:
                padding = nextField.bitpos // 8 - (currField.bitpos // 8 + currField.type.sizeof)
            else:
                padding = stype.sizeof - currField.bitpos // 8 - currField.type.sizeof
            totalPadding += padding

            print('  % 8x (% 8s) %s' % (offset, '%x+%x' % (currField.type.sizeof, padding), currField.name))
        print('}')

        print('%s: %d padding bytes total' % (argv[0], totalPadding))

    def complete(text, word):
        print('complete?')
        return gdb.COMPLETE_SYMBOL

Offsets()
