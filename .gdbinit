source ~/.gdb/gdb-dashboard/.gdbinit
dashboard source -style context 20
dashboard expressions
dashboard assembly
dashboard threads
dashboard memory

source ~/.gdb/offsets-of.py
source ~/.gdb/stack-used.py

set disassembly-flavor intel

source ~/projects/avs_commons/gdb/print-avs-list.py
source ~/projects/avs_commons/gdb/print-avs-rbtree.py
