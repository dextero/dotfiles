import gdb

class StackUsed(gdb.Command):
    def __init__(self):
        super (StackUsed, self).__init__ ('stack-used', gdb.COMMAND_DATA)
        print('stack-used loaded')

    def invoke(self, arg, from_tty):
        argv = gdb.string_to_argv(arg)
        if len(argv) != 1:
            raise gdb.GdbError('stack-used takes exactly 1 argument.')

        func = gdb.lookup_symbol(argv[0])

        if not func or not func.is_function():
            raise gdb.GdbError('stack-used works only on functions or methods')

        for kv in func.__dict__.iteritems(): print('%s: %s\n' % kv)

    def complete(text, word):
        print('complete?')
        return gdb.COMPLETE_SYMBOL

StackUsed()

