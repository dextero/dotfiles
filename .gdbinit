source ~/.gdb/gdb-dashboard/.gdbinit
dashboard source -style context 20
dashboard expressions
dashboard assembly
dashboard threads
dashboard memory

source ~/.gdb/GdbAsciiHexPrint/AsciiPrintCommand.py
source ~/.gdb/offsets-of.py
source ~/.gdb/stack-used.py
source ~/.gdb/print-coap-packet.py

set disassembly-flavor intel

source ~/projects/avs_commons/gdb/print-avs-list.py
source ~/projects/avs_commons/gdb/print-avs-rbtree.py
